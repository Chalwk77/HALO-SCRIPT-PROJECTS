--[[
--=====================================================================================================--
Script Name: WriteToJSON, for SAPP (PC & CE)
Description:

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local Alias = {

    -- File that contains the json database:
    --
    file = 'aliases.json',


    -- Base command:
    --
    command = "alias",


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
    delete_stale_records = true,
    stale_period = 30,


    -- List of all known pirated hashes:
    -- If someone has a pirated hash, the script will tell you when you hash-alias them:
    --
    known_pirated_hashes = {
        "388e89e69b4cc08b3441f25959f74103",
        "81f9c914b3402c2702a12dc1405247ee",
        "c939c09426f69c4843ff75ae704bf426",
        "13dbf72b3c21c5235c47e405dd6e092d",
        "29a29f3659a221351ed3d6f8355b2200",
        "d72b3f33bfb7266a8d0f13b37c62fddb",
        "76b9b8db9ae6b6cacdd59770a18fc1d5",
        "55d368354b5021e7dd5d3d1525a4ab82",
        "d41d8cd98f00b204e9800998ecf8427e",
        "c702226e783ea7e091c0bb44c2d0ec64",
        "f443106bd82fd6f3c22ba2df7c5e4094",
        "10440b462f6cbc3160c6280c2734f184",
        "3d5cd27b3fa487b040043273fa00f51b",
        "b661a51d4ccf44f5da2869b0055563cb",
        "740da6bafb23c2fbdc5140b5d320edb1",
        "7503dad2a08026fc4b6cfb32a940cfe0",
        "4486253cba68da6786359e7ff2c7b467",
        "f1d7c0018e1648d7d48f257dc35e9660",
        "40da66d41e9c79172a84eef745739521",
        "2863ab7e0e7371f9a6b3f0440c06c560",
        "34146dc35d583f2b34693a83469fac2a",
        "b315d022891afedf2e6bc7e5aaf2d357",
        "63bf3d5a51b292cd0702135f6f566bd1",
        "6891d0a75336a75f9d03bb5e51a53095",
        "325a53c37324e4adb484d7a9c6741314",
        "0e3c41078d06f7f502e4bb5bd886772a",
        "fc65cda372eeb75fc1a2e7d19e91a86f",
        "f35309a653ae6243dab90c203fa50000",
        "50bbef5ebf4e0393016d129a545bd09d",
        "a77ee0be91bd38a0635b65991bc4b686",
        "3126fab3615a94119d5fe9eead1e88c1",
        "2f02b641060da979e2b89abcfa1af3d6",
        "ac73d9785215e196074d418d1cce825b",
        "bf117d42b3db727f441d03786586e249",
        "54f4d0236653a6da6429bfc79015f526"
    }
}

local open = io.open
local floor = math.floor
local date, time, diff = os.date, os.time, os.difftime

local json = loadfile('./json.lua')()

api_version = "1.12.0.0"

function OnScriptLoad()

    register_callback(cb['EVENT_JOIN'], 'OnJoin')
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

function Alias:UpdateRecords(o)

    local day = date('*t').day
    local month = date('*t').month
    local year = date('*t').year

    self.records.hashes[o.hash] = {
        [o.name] = { day = day, month = month, year = year }
    }

    self.records.ip_addresses[o.ip] = {
        [o.name] = { day = day, month = month, year = year }
    }

    WriteToFile(self, self.records)
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
    Alias:UpdateRecords({
        name = get_var(Ply, '$name'),
        hash = get_var(Ply, '$hash'),
        ip = get_var(Ply, '$ip'):match('%d+.%d+.%d+.%d+')
    })
end

-- Delete stale records:
function CheckStale()
    for _, record in pairs(Alias.records) do
        for type, hash_table in pairs(record) do
            for name, log in pairs(hash_table) do
                local day = log.day
                local month = log.month
                local year = log.year
                local reference = time { day = day, month = month, year = year }
                local days_from = diff(time(), reference) / (24 * 60 * 60)
                local whole_days = floor(days_from)
                if (whole_days >= Alias.stale_period) then
                    hash_table[name] = nil
                    cprint("Deleting stale name record for " .. type .. ":" .. name, 12)
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

function Alias:OnQuery(Ply, CMD)
    local args = CMDSplit(CMD)
    if (#args > 0 and args[1] == self.command and HasPermission(Ply)) then

        if (args[2]) then

            local player = (args[2]:match("^%d+$"))
            if (not player_present(player)) then
                Respond(Ply, "Player #" .. player .. " is not online.")
                return false
            elseif (args[2] == "me") then
                player = Ply
            end


            -- name search --

            -- hash search --

            -- hash-name query --

            -- ip-name query --
        end

        return false
    end
end

OnCommand = function(a, b)
    return Alias:OnQuery(a, b)
end

function OnScriptUnload()
    WriteToFile(Alias, Alias.records)
end