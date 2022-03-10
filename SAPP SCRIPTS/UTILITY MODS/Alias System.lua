--[[
--=====================================================================================================--
Script Name: Alias System, for SAPP (PC & CE)
Description: Look up names linked to an IP address or hash.

--------------------------------------------------------------------------
IMPORTANT:
This script requires that you install a JSON library on your server.
Place json.lua in the same location as strings.dll.
See this page for the download:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/releases/tag/AliasSystem
--------------------------------------------------------------------------

Alias results are split into in rows & columns on a per-page basis.
To view a specific page of results, simply define the page id as shown in the command syntax examples below.

* /alias [pid]
> Check aliases for the defined player (defaults to ip-aliases).

* /alias [pid] -ip [opt page]
> Check IP aliases.

* /alias [pid] -hash [opt page]
> Check Hash aliases.

* /alias [IP] [opt page]
> Check aliases for specific IP

* /alias [hash] [opt page]
> Check aliases for a specific hash.

Additional Features:
This system will know whether someone has a pirated hash or not.
This is important for determining whether you can hash-ban someone or not.

Furthermore, hash or ip tables that have not been modified for 30 days will be considered stale and will be deleted.

Example of the Alias Database:
The 'last_activity' table keeps a track record (day, month, year) of when a named was linked to its parent table.
If no names were saved within 30 days, the parent table will be deleted.

Individual names also have a timestamp of the last login time.

{
  "hashes": {
    "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx": {
      "Chalwk": "Last Login: Thursday, 03 March 2022",
      "last_activity": {
        "day": 10,
        "month": 3,
        "year": 2022
      }
    }
  },
  "ip_addresses": {
    "127.0.0.1": {
      "FIG-Chalwk": "Last Login: Thursday, 03 March 2022",
      "last_activity": {
        "day": 10,
        "month": 3,
        "year": 2022
      }
    }
  }
}

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local Alias = {

    -- File that contains the json database of aliases:
    -- This file will be created in 'cg/sapp/'
    --
    file = 'aliases.json',


    -- Base command:
    --
    command = 'alias',


    -- Minimum permission required to execute /command:
    --
    permission = 1,


    -- If true, the .json database will be updated
    -- every time a player joins.
    --
    -- If false, the .json database will only be updated
    -- when the game ends (recommended).
    --
    update_file_on_join = false,


    -- If a player hasn't connected with a specific hash or ip
    -- after this many days, it's considered stale and will be deleted:
    --
    delete_stale_records = true,
    stale_period = 30,


    -- When executing /alias <pid>, what should the default look up table be?
    -- Valid Tables: 'ip_addresses' or 'hashes'
    --
    default_table = 'ip_addresses',


    --------------------------------------------------------------------------
    -- Advanced users only:
    --
    --
    -- Max results to load per page:
    max_results = 50,


    -- Aliases are printed in columns of 5:
    max_columns = 5,


    -- Spacing between names per column:
    spaces = 2,


    -- List of all known pirated hashes:
    -- If someone has a pirated hash, the script will tell you upon querying the hash:
    --
    known_pirated_hashes = {
        ['388e89e69b4cc08b3441f25959f74103'] = true,
        ['81f9c914b3402c2702a12dc1405247ee'] = true,
        ['c939c09426f69c4843ff75ae704bf426'] = true,
        ['13dbf72b3c21c5235c47e405dd6e092d'] = true,
        ['29a29f3659a221351ed3d6f8355b2200'] = true,
        ['d72b3f33bfb7266a8d0f13b37c62fddb'] = true,
        ['76b9b8db9ae6b6cacdd59770a18fc1d5'] = true,
        ['55d368354b5021e7dd5d3d1525a4ab82'] = true,
        ['d41d8cd98f00b204e9800998ecf8427e'] = true,
        ['c702226e783ea7e091c0bb44c2d0ec64'] = true,
        ['f443106bd82fd6f3c22ba2df7c5e4094'] = true,
        ['10440b462f6cbc3160c6280c2734f184'] = true,
        ['3d5cd27b3fa487b040043273fa00f51b'] = true,
        ['b661a51d4ccf44f5da2869b0055563cb'] = true,
        ['740da6bafb23c2fbdc5140b5d320edb1'] = true,
        ['7503dad2a08026fc4b6cfb32a940cfe0'] = true,
        ['4486253cba68da6786359e7ff2c7b467'] = true,
        ['f1d7c0018e1648d7d48f257dc35e9660'] = true,
        ['40da66d41e9c79172a84eef745739521'] = true,
        ['2863ab7e0e7371f9a6b3f0440c06c560'] = true,
        ['34146dc35d583f2b34693a83469fac2a'] = true,
        ['b315d022891afedf2e6bc7e5aaf2d357'] = true,
        ['63bf3d5a51b292cd0702135f6f566bd1'] = true,
        ['6891d0a75336a75f9d03bb5e51a53095'] = true,
        ['325a53c37324e4adb484d7a9c6741314'] = true,
        ['0e3c41078d06f7f502e4bb5bd886772a'] = true,
        ['fc65cda372eeb75fc1a2e7d19e91a86f'] = true,
        ['f35309a653ae6243dab90c203fa50000'] = true,
        ['50bbef5ebf4e0393016d129a545bd09d'] = true,
        ['a77ee0be91bd38a0635b65991bc4b686'] = true,
        ['3126fab3615a94119d5fe9eead1e88c1'] = true,
    }
}

local players = {}

local open = io.open
local floor = math.floor
local concat = table.concat
local date, time, diff = os.date, os.time, os.difftime

local json = loadfile('./json.lua')()

api_version = '1.12.0.0'

function OnScriptLoad()

    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')

    if (Alias.delete_stale_records) then
        register_callback(cb['EVENT_TICK'], 'CheckStale')
    end

    OnStart()
end

local function WriteToFile(self, t)
    local file = open(self.dir, 'w')
    if (file) then
        file:write(json:encode_pretty(t))
        file:close()
    end
end

function Alias:AddRecord(o)

    local day = date('*t').day
    local month = date('*t').month
    local year = date('*t').year

    local hashes = self.records.hashes
    local ip_addresses = self.records.ip_addresses
    local last_activity = { day = day, month = month, year = year }

    hashes[o.hash] = hashes[o.hash] or {}
    hashes[o.hash].last_activity = last_activity
    hashes[o.hash][o.name] = date("Last Login: %A, %m %B %Y")

    ip_addresses[o.ip] = ip_addresses[o.ip] or {}
    ip_addresses[o.ip].last_activity = last_activity
    ip_addresses[o.ip][o.name] = date("Last Login: %A, %m %B %Y")

    if (self.update_file_on_join) then
        WriteToFile(self, self.records)
    end
    return o
end

function Alias:CheckFile(ScriptLoad)

    local dir = read_string(read_dword(sig_scan('68??????008D54245468') + 0x1))
    self.dir = dir .. '\\sapp\\' .. self.file

    self.records = (ScriptLoad and nil or self.records)

    if (get_var(0, '$gt') ~= 'n/a' and self.records == nil) then
        local content = ''
        local file = open(self.dir, 'r')
        if (file) then
            content = file:read('*all')
            file:close()
        end
        local data = json:decode(content)
        if (not data) then
            data = { hashes = {}, ip_addresses = {} }
            WriteToFile(self, data)
        end
        self.records = data

        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnStart()
    Alias:CheckFile(true)
    if (get_var(0, '$gt') ~= 'n/a') then
        Alias:CheckFile(false)
    end
end

function OnEnd()
    WriteToFile(Alias, Alias.records)
end

function OnJoin(Ply)
    players[Ply] = Alias:AddRecord({
        pid = Ply,
        name = get_var(Ply, '$name'),
        hash = get_var(Ply, '$hash'),
        ip = get_var(Ply, '$ip'):match('%d+.%d+.%d+.%d+')
    })
end

function OnQuit(Ply)
    players[Ply] = nil
end

-- Delete stale records:
function CheckStale()
    for _, record in pairs(Alias.records) do
        for artifact, hash_table in pairs(record) do
            for _, log in pairs(hash_table) do
                if (type(log) == 'table') then
                    local day = log.day
                    local month = log.month
                    local year = log.year
                    local reference = time { day = day, month = month, year = year }
                    local days_from = diff(time(), reference) / (24 * 60 * 60)
                    local whole_days = floor(days_from)
                    if (whole_days >= Alias.stale_period) then
                        record[artifact] = nil
                        cprint('Deleting stale record for ' .. artifact, 12)
                    end
                end
            end
        end
    end
end

local function HasPermission(Ply)
    local lvl = tonumber(get_var(Ply, '$lvl'))
    return (Ply == 0 or lvl >= Alias.permission or false)
end

local function CMDSplit(CMD)
    local args = { }
    for arg in CMD:gmatch('([^%s]+)') do
        args[#args + 1] = arg:lower()
    end
    return args
end

local function Respond(Ply, Msg)
    return (Ply == 0 and cprint(Msg) or rprint(Ply, Msg))
end

local function GetPage(page)
    local start = (Alias.max_results) * page
    local start_page = (start - Alias.max_results + 1)
    local end_page = start
    return start_page, end_page
end

local function GetPageCount(total)
    local pages = total / (Alias.max_results)
    if (pages ~= floor(pages)) then
        pages = floor(pages) + 1
    end
    return pages
end

local function spacing(n)
    local Str = ''
    for i = 1, n do
        if i == floor(n / 2) then
            Str = Str .. ''
        end
        Str = Str .. ' '
    end
    return ',' .. Str
end

local function FormatTable(table)

    local longest = 0
    for i = 1, #table do
        if (table[i]:len() > longest) then
            longest = table[i]:len()
        end
    end

    local rows, row, count = {}, 1, 1
    for k, v in pairs(table) do
        if (count % Alias.max_results == 0) or (k == #table) then
            rows[row] = (rows[row] or '') .. v
        else
            rows[row] = (rows[row] or '') .. v .. spacing(longest - v:len() + Alias.spaces)
        end
        if (count % Alias.max_results == 0) then
            row = row + 1
        end
        count = count + 1
    end

    return concat(rows)
end

local function GetNames(t)
    local results = {}
    for name, _ in pairs(t) do
        if (name ~= 'last_activity') then
            results[#results + 1] = name
        end
    end
    return results
end

function Alias:ShowResults(Ply, Table, Page, Artifact)

    Table = GetNames(self.records[Table][Artifact])
    local total_pages = GetPageCount(#Table)

    if (Page > 0 and Page <= total_pages) then

        local start_index, end_index = 1, self.max_columns
        local start_page, end_page = GetPage(Page)

        local results = { }
        for page_num = start_page, end_page do
            if Table[page_num] then
                results[#results + 1] = Table[page_num]
            end
        end

        while (end_index < #Table + self.max_columns) do

            local t, row = { }
            for i = start_index, end_index do
                t[i] = results[i]
                row = FormatTable(t)
            end

            if (row ~= nil and row ~= '' and row ~= ' ') then
                Respond(Ply, row, 10)
            end

            start_index = (end_index + 1)
            end_index = (end_index + (self.max_columns))
        end
        Respond(Ply, '[Page ' .. Page .. '/' .. total_pages .. '] Showing ' .. #results .. '/' .. #Table .. ' aliases for: ' .. Artifact)
        if (self.known_pirated_hashes[Artifact]) then
            Respond(Ply, 'This hash is pirated.')
        end
    else
        Respond(Ply, 'Invalid Page ID. Please type a page between 1-' .. total_pages)
    end
end

function Alias:OnQuery(Ply, CMD)
    local args = CMDSplit(CMD)
    if (#args > 0 and args[1] == self.command and HasPermission(Ply)) then

        if (args[2]) then

            local ip_pattern = args[2]:match("^%d+.%d+.%d+.%d+$")
            local hash_pattern = args[2]:match("^%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x$")

            local player = tonumber((args[2]:match('^%d+$')))
            if (not ip_pattern and not hash_pattern and not player_present(player)) then
                Respond(Ply, 'Player #' .. player .. ' is not online.')
                return false
            elseif (args[2] == 'me') then
                player = Ply
            end

            -- /alias <pid>
            local player_lookup = (player and not args[3])

            -- /alias <pid> <-ip> <opt page>
            local player_ip_lookup = (player and args[3] == '-ip')

            -- /alias <pid> <-hash> <opt page>
            local player_hash_lookup = (player and args[3] == '-hash')

            -- /alias <ip> <opt page>
            local ip_lookup = (ip_pattern)

            -- /alias <32x char hash> <opt page>
            local hash_lookup = (hash_pattern)

            local t = players[player]
            local page = (args[4] and args[4]:match('^%d+$') or 1)

            if (player_lookup) then
                if (self.default_table == 'ip_addresses') then
                    self:ShowResults(Ply, 'ip_addresses', 1, t.ip)
                else
                    self:ShowResults(Ply, 'hashes', 1, t.hash)
                end
            elseif (player_ip_lookup) then
                self:ShowResults(Ply, 'ip_addresses', page, t.ip)
            elseif (player_hash_lookup) then
                self:ShowResults(Ply, 'hashes', page, t.hash)
            elseif (ip_lookup) then
                page = (args[3] and args[3]:match('^%d+$') or 1)
                self:ShowResults(Ply, 'ip_addresses', page, ip_pattern)
            elseif (hash_lookup) then
                page = (args[3] and args[3]:match('^%d+$') or 1)
                self:ShowResults(Ply, 'hashes', page, hash_pattern)
            else
                self:CmdHelp(Ply)
            end
        else
            self:CmdHelp(Ply)
        end

        return false
    end
end

function Alias:CmdHelp(Ply)
    Respond(Ply, "Invalid Command Syntax or Lookup Parameter.")
    Respond(Ply, "Usage:")
    Respond(Ply, "/" .. self.command .. " <pid>")
    Respond(Ply, "/" .. self.command .. " <pid> -ip <opt page>")
    Respond(Ply, "/" .. self.command .. " <pid> -hash <opt page>")
    Respond(Ply, "/" .. self.command .. " <32 char hash> <opt page>")
    Respond(Ply, "/" .. self.command .. " <ip address> <opt page>")
    Respond(Ply, ".....................................................")
end

function OnCommand(a, b)
    return Alias:OnQuery(a, b)
end

function OnScriptUnload()
    WriteToFile(Alias, Alias.records)
end