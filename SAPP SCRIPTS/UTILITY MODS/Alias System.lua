--[[
--=====================================================================================================--
Script Name: Alias System (remake), for SAPP (PC & CE)
Description: Look up names linked to an IP address or hash.

Alias results are displayed in columns of 5 and rows of 10 per page.
To view a specific page of results, simply define the page id as shown in the command syntax examples below.

* /alias [pid] -ip [opt page]"
> Check IP aliases for specific player id.

* /alias [pid] -hash [opt page]"
> Check HASH aliases for specific player id.

* /alias [IP] [opt page]"
> Check aliases for specific IP address.

* /alias [hash] [opt page]"
> Check aliases for a specific hash.

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration Starts --

local Alias = {


    -- This is name of the alias database (saved to servers root directory).
    dir = "alias.json",

    command = "alias",

    -- Minimum permission required to execute /command:
    permission = 1,

    --------------------------------------------------------------------------
    -- Advanced users only:
    --
    --

    -- Aliases are printed in columns of 5
    max_columns = 5,

    -- Max results to load per page:
    results_per_page = 25,

    -- Spacing between names per column;
    spaces = 2,

    -- Client data is saved as a json array.
    -- The array index for each client will either be "IP", or "IP:PORT".
    -- Set to 1 for IP-only indexing.
    ClientIndexType = 1,

    -- List of all known pirated copies of halo.
    -- If someone has a pirated copy of halo, it will tell you when you hash-alias them.
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
    }
}

-- Configuration Ends --

local json = (loadfile "json.lua")()
local lower, upper = string.lower, string.upper
local concat, gmatch = table.concat, string.gmatch

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    if (get_var(0, "$gt") ~= "n/a") then
        Alias:CheckFile()
    end
end

function OnScriptUnload()

end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        Alias:CheckFile(true)
    end
end

function OnPlayerConnect(Ply)
    Alias:UpdateRecords(Ply)
end

function Alias:GetIP(Ply)
    local IP = get_var(Ply, "$ip")
    if (self.ClientIndexType == 1) then
        IP = IP:match("%d+.%d+.%d+.%d+")
    end
    return IP
end

local function spacing(n)
    local str, sep = "", ","
    for i = 1, n do
        if (i % n == 2) then
            str = str .. ""
        end
        str = str .. " "
    end
    return sep .. str
end

local function FormatTable(table, rowlen, space)

    local longest = 0
    for _, v in pairs(table) do
        local len = string.len(v)
        if (len > longest) then
            longest = len
        end
    end

    local rows = {}
    local row = 1
    local count = 1

    for k, v in pairs(table) do
        if (count % rowlen == 0) or (k == #table) then
            rows[row] = (rows[row] or "") .. v
        else
            rows[row] = (rows[row] or "") .. v .. spacing(longest - string.len(v) + space)
        end
        if (count % rowlen == 0) then
            row = row + 1
        end
        count = count + 1
    end
    return concat(rows)
end

function Alias:getPage(params)
    local max_results = self.results_per_page
    local start = (max_results) * params.page
    local startpage = (start - max_results + 1)
    local endpage = start
    return startpage, endpage
end

function Alias:getPageCount(total)
    local pages = (total / self.results_per_page)
    if (pages) ~= math.floor(pages) then
        pages = math.floor(pages) + 1
    end
    return pages
end

function Alias:ShowResults(params)
    local records = self:CheckFile()
    local tab = records[params.type][params.artifact]
    local page = tonumber(params.page)

    if (tab) and (#tab > 0) then

        local total_pages = Alias:getPageCount(#tab)
        if (page > 0 and page <= total_pages) then

            local count = 0
            local table, row = { }
            local START, FINISH = self:getPage(params)
            for i = START, FINISH do
                for k, v in pairs(tab) do
                    if (k == i) then
                        count = count + 1
                        table[i] = v
                        row = FormatTable(table, self.max_columns, self.spaces)
                    end
                end
            end

            if (row) then
                self:Respond(params.executor, row, 10)
            end

            self:Respond(params.executor, '[Page ' .. page .. '/' .. total_pages .. '] Showing ' .. count .. '/' .. #tab .. ' aliases for: "' .. params.artifact .. '"', 2 + 8)
            if (params.pirated) then
                if (params.name) then
                    self:Respond(params.executor, params.name .. ' is using a pirated copy of Halo.', 2 + 8)
                else
                    self:Respond(params.executor, params.artifact .. ' is a pirated copy of Halo.', 2 + 8)
                end
            end
        else
            self:Respond(params.executor, 'Invalid Page ID. Please type a page between 1-' .. total_pages)
        end
    else
        self:Respond(params.executor, 'No results for "' .. params.artifact .. '"')
    end
end

function StrSplit(CMD)
    local Args, index = { }, 1
    for Params in gmatch(CMD, "([^%s]+)") do
        Args[index] = Params
        index = index + 1
    end
    return Args
end

function Alias:IsPirated(hash)
    for i = 1, #self.known_pirated_hashes do
        if (hash == self.known_pirated_hashes[i]) then
            return true
        end
    end
    return false
end

function Alias:CmdHelp(Executor)
    self:Respond(Executor, "Invalid Command Syntax.")
    self:Respond(Executor, "Usage:")
    self:Respond(Executor, "/" .. self.command .. " <pid> -ip <opt page>")
    self:Respond(Executor, "/" .. self.command .. " <pid> -hash <opt page>")
    self:Respond(Executor, "/" .. self.command .. " <ip> <opt page>")
    self:Respond(Executor, "/" .. self.command .. " <hash> <opt page>")
end

function Alias:OnServerCommand(Executor, Command)
    local Args = StrSplit(Command)
    if (Args[1] == nil) then
        return
    else

        Args[1] = lower(Args[1]) or upper(Args[1])
        local lvl = tonumber(get_var(Executor, "$lvl"))

        if (Args[1] == self.command) then
            if (lvl >= self.permission) or (Executor == 0) then

                if (Args[2] ~= nil) then

                    local error
                    local params = { }

                    local player_id = Args[2]:match("^%d+$")
                    local ip_pattern = Args[2]:match("^%d+.%d+.%d+.%d+$")
                    local hash_pattern = Args[2]:match("^%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x$")

                    -- /alias <ip> <opt page>
                    local ip_lookup = (ip_pattern)

                    -- /alias <32x char hash> <opt page>
                    local hash_lookup = (hash_pattern)

                    -- /alias <pid> <-ip> <opt page>
                    local player_ip_lookup = (player_id and Args[3] == "-ip")

                    -- /alias <pid> <-hash> <opt page>
                    local player_hash_lookup = (player_id and Args[3] == "-hash")

                    if (ip_lookup) then
                        params.page = (Args[3] ~= nil and Args[3]:match("^%d+$") or 1)
                        params.type = "ip_addresses"
                        params.artifact = ip_pattern

                    elseif (hash_lookup) then
                        params.page = (Args[3] ~= nil and Args[3]:match("^%d+$") or 1)
                        params.type = "hashes"
                        params.artifact = hash_pattern
                        params.pirated = self:IsPirated(hash_pattern)

                    elseif (player_ip_lookup) then
                        params.page = (Args[4] ~= nil and Args[4]:match("^%d+$") or 1)
                        params.type = "ip_addresses"
                        params.name = get_var(player_id, "$name")
                        params.artifact = self:GetIP(player_id)

                    elseif (player_hash_lookup) then
                        params.type = "hashes"
                        params.page = (Args[4] ~= nil and Args[4]:match("^%d+$") or 1)
                        params.name = get_var(player_id, "$name")
                        params.artifact = get_var(player_id, "$hash")
                        params.pirated = self:IsPirated(hash_pattern)
                    else
                        error = true
                        self:CmdHelp(Executor)
                    end

                    if (not error) then
                        params.executor = Executor
                        self:ShowResults(params)
                    end

                else
                    self:CmdHelp(Executor)
                end
            else
                self:Respond(Executor, "You do not have permission to execute that command!")
            end
            return false
        end
    end
end

function Alias:Respond(Ply, Message, Color)
    Color = Color or 10
    if (Ply == 0) then
        cprint(Message, Color)
    else
        rprint(Ply, Message)
    end
end

function Alias:NameOnRecord(Records, Name)
    for _, NameRecord in pairs(Records) do
        if (NameRecord == Name) then
            return true
        end
    end
    return false
end

function Alias:UpdateRecords(Ply)

    local update
    local ip = self:GetIP(Ply)
    local name = get_var(Ply, "$name")
    local hash = get_var(Ply, "$hash")

    local records = self:CheckFile()

    -- Check if name on file for this hash:
    if (records.hashes[hash] == nil) then
        records.hashes[hash] = {}
        table.insert(records.hashes[hash], name)
        update = true
        -- Add it:
    elseif not self:NameOnRecord(records.hashes[hash], name) then
        table.insert(records.hashes[hash], name)
        update = true
    end

    -- Check if name on record for this ip:
    if (records.ip_addresses[ip] == nil) then
        records.ip_addresses[ip] = {}
        table.insert(records.ip_addresses[ip], name)
        update = true
        -- Add it:
    elseif not self:NameOnRecord(records.ip_addresses[ip], name) then
        table.insert(records.ip_addresses[ip], name)
        update = true
    end

    -- If hash or ip record needs updating, do it:
    if (update) then
        local file = assert(io.open(self.dir, "w"))
        if (file) then
            file:write(json:encode_pretty(records))
        end
        io.close(file)
    end
end

function Alias:CheckFile(OnGameStart)
    if (get_var(0, "$gt") ~= "n/a") then

        local content = ""
        local file = io.open(self.dir, "r")
        if (file) then
            content = file:read("*all")
        end
        io.close(file)

        local records = json:decode(content)
        if (not records) then
            file = assert(io.open(self.dir, "w"))
            if (file) then
                records = { hashes = {}, ip_addresses = {} }
                file:write(json:encode_pretty(records))
            end
            io.close(file)
        end

        if (OnGameStart) then

            local hash_name_total, ip_address_name_total = 0, 0
            local hash_total, ip_address_total = 0, 0

            for _, hash in pairs(records.hashes) do
                hash_total = hash_total + 1
                for _, _ in pairs(hash) do
                    hash_name_total = hash_name_total + 1
                end
            end

            for _, ip in pairs(records.ip_addresses) do
                ip_address_total = ip_address_total + 1
                for _, _ in pairs(ip) do
                    ip_address_name_total = ip_address_name_total + 1
                end
            end

            cprint("----------------- ALIAS SYSTEM -----------------", 10)
            cprint(hash_total .. " hashes and " .. hash_name_total .. " linked names are on record", 10)
            cprint(ip_address_total .. " ip addresses and " .. ip_address_name_total .. " linked names are on record", 10)
            cprint("------------------------------------------------", 10)
        end

        return records
    end
end

function OnServerCommand(P, C)
    return Alias:OnServerCommand(P, C)
end