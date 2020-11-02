--[[
--=====================================================================================================--
Script Name: Alias System (remake), for SAPP (PC & CE)
Description: Look up names linked to an IP address or hash.

Alias results are displayed in columns of 5 and rows of 10 per page.
To view a specific page of results, simply define the page id as shown in the command syntax examples below.

* /alias [pid] -ip [opt page]
> Check IP aliases for specific player id.

* /alias [pid] -hash [opt page]
> Check HASH aliases for specific player id.

* /alias [IP] [opt page]
> Check aliases for specific IP address.

* /alias [hash] [opt page]
> Check aliases for a specific hash.

* /alias [pid]
> When executing /alias [pid] without specifying the look-up type,
> the search will automatically look up names associated with their IP Address.
> This can be edited in the config section among other settings.

* /alias [name] -search
> Lookup names and retrieve the hashes/IP addresses they are linked to.

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

    -- The custom command;
    command = "alias",

    -- Minimum permission required to execute /command:
    permission = 1,

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

    -- Client data is saved as a json array.
    -- The array index for each client will either be "IP", or "IP:PORT".
    -- Set to 1 for IP-only indexing.
    ClientIndexType = 1,

    -- When executing /alias <pid> without specifying the look up type, what
    -- should we look up? Names associated with their IP Address or Names associated with their Hash?
    default_table = "ip_addresses", -- Valid Tables: "ip_addresses" or "hashes"

    -- List of all known pirated copies of halo.
    -- If someone has a pirated copy of halo, it will tell you when you hash-alias them:
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

local len, sub = string.len, string.sub
local json, floor = (loadfile "json.lua")(), math.floor
local concat, gmatch, gsub = table.concat, string.gmatch, string.gsub

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

function Alias:GetNames(Ply, t, name, CheckPirated)
    local count = 0
    for Artifact, TAB in pairs(t) do
        for _, NameRecord in pairs(TAB) do
            if (NameRecord == name) then
                count = count + 1
                if (CheckPirated) then
                    local pirated = Alias:IsPirated(Artifact)
                    self:Respond(Ply, "MATCH FOUND: [" .. Artifact .. "]: " .. NameRecord .. " [PIRATED: " .. tostring(pirated) .. "]")
                else
                    self:Respond(Ply, "MATCH FOUND: [" .. Artifact .. "]: " .. NameRecord)
                end
            end
        end
    end
    return count
end

function Alias:GetPage(page)
    local max = self.max_results
    local start = (max) * page
    local startpage = (start - max + 1)
    local endpage = start
    return startpage, endpage
end

function Alias:getPageCount(total_names)
    local pages = total_names / (self.max_results)
    if ((pages) ~= floor(pages)) then
        pages = floor(pages) + 1
    end
    return pages
end

local function spacing(n)
    local String, Seperator = "", ","
    for i = 1, n do
        if i == math.floor(n / 2) then
            String = String .. ""
        end
        String = String .. " "
    end
    return Seperator .. String
end

function Alias:FormatTable(table)

    local longest = 0
    for _, v in pairs(table) do
        if (len(v) > longest) then
            longest = len(v)
        end
    end

    local rows, row, count = {}, 1, 1
    for k, v in pairs(table) do
        if (count % self.max_results == 0) or (k == #table) then
            rows[row] = (rows[row] or "") .. v
        else
            rows[row] = (rows[row] or "") .. v .. spacing(longest - len(v) + self.spaces)
        end
        if (count % self.max_results == 0) then
            row = row + 1
        end
        count = count + 1
    end
    return concat(rows)
end

function Alias:ShowResults(params)
    local records = self:CheckFile()
    local tab = records[params.type][params.artifact]
    local page = tonumber(params.page)

    if (tab) and (#tab > 0) then

        local total_pages = self:getPageCount(#tab)
        if (page > 0 and page <= total_pages) then

            local startIndex, endIndex = 1, self.max_columns
            local startpage, endpage = self:GetPage(page)

            local results = { }
            for page_num = startpage, endpage do
                if tab[page_num] then
                    results[#results + 1] = tab[page_num]
                end
            end

            local function formatResults()
                local tmp, row = { }

                for i = startIndex, endIndex do
                    tmp[i] = results[i]
                    row = self:FormatTable(tmp)
                end

                if (row ~= nil and row ~= "" and row ~= " ") then
                    self:Respond(params.executor, row, 10)
                end

                startIndex = (endIndex + 1)
                endIndex = (endIndex + (self.max_columns))
            end

            while (endIndex < #tab + self.max_columns) do
                formatResults()
            end

            self:Respond(params.executor, '[Page ' .. page .. '/' .. total_pages .. '] Showing ' .. #results .. '/' .. #tab .. ' aliases for: "' .. params.artifact .. '"', 2 + 8)
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

function StrSplit(CMD, Delimiter)
    local Args, index = { }, 1
    for Params in gmatch(CMD, "([^" .. Delimiter .. "]+)") do
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
    self:Respond(Executor, "Invalid Command Syntax or Lookup Parameter.")
    self:Respond(Executor, "Usage:")
    self:Respond(Executor, "/" .. self.command .. " <pid> -ip <opt page>")
    self:Respond(Executor, "/" .. self.command .. " <pid> -hash <opt page>")
    self:Respond(Executor, "/" .. self.command .. " <ip> <opt page>")
    self:Respond(Executor, "/" .. self.command .. " <32 char hash> <opt page>")
    self:Respond(Executor, ".....................................................")
end

function Alias:OnServerCommand(Executor, Command)
    local Args = StrSplit(Command, "%s")

    if (Args[1] == nil) then
        return
    else

        Command = Command:lower()
        local lvl = tonumber(get_var(Executor, "$lvl"))
        if (Args[1] == self.command) then
            if (lvl >= self.permission) or (Executor == 0) then

                if (Args[2] ~= nil) then

                    local params, error = { }
                    local player_id = (Args[2] ~= nil and Args[2]:match("^%d+$")) or 0

                    local name_search = Command:match("--search")

                    if (not player_present(player_id) and player_id ~= 0) then
                        self:Respond(Executor, "Player #" .. player_id .. " is not online.")
                        return false
                    elseif (Args[2] == "me") then
                        player_id = Executor
                    end

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

                    -- /alias <pid>
                    local player_lookup = (player_id and Args[3] == nil) and (not hash_pattern)

                    if (ip_lookup) then
                        params.page = (Args[3] ~= nil and Args[3]:match("^%d+$") or 1)
                        params.type = "ip_addresses"
                        params.artifact = ip_pattern

                    elseif (player_lookup) then
                        params.page = 1
                        params.type = self.default_table
                        params.name = get_var(player_id, "$name")
                        if (self.default_table == "ip_addresses") then
                            params.artifact = self:GetIP(player_id)
                        elseif (self.default_table == "hashes") then
                            params.artifact = get_var(player_id, "$hash")
                            params.pirated = self:IsPirated(get_var(player_id, "$hash"))
                        end

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
                        params.pirated = self:IsPirated(get_var(player_id, "$hash"))

                    elseif (name_search) then

                        local cmd_len = len(self.command)
                        local cmd_to_replace = sub(Command, 1, cmd_len + 1)
                        local name = gsub(gsub(Command, cmd_to_replace, ""), " --search", "")

                        local records = self:CheckFile()
                        local ip_count = Alias:GetNames(Executor, records.ip_addresses, name, false)
                        local hash_count = Alias:GetNames(Executor, records.hashes, name, true)
                        ip_count = ip_count + hash_count
                        if (ip_count == 0) then
                            self:Respond(Executor, "No records found for [ " .. name .. " ]")
                        end
                    else
                        error = true
                        self:CmdHelp(Executor)
                    end

                    function T()
                        return self:ShowResults(params)
                    end

                    if (not error) and (not name_search) then
                        params.executor = Executor
                        timer(0, "T")
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
            io.close(file)
        end
    end
end

function Alias:CheckFile(OnGameStart)
    if (get_var(0, "$gt") ~= "n/a") then

        local content = ""
        local file = io.open(self.dir, "r")
        if (file) then
            content = file:read("*all")
            io.close(file)
        end

        local records = json:decode(content)
        if (not records) then
            file = assert(io.open(self.dir, "w"))
            if (file) then
                records = { hashes = {}, ip_addresses = {} }
                file:write(json:encode_pretty(records))
                io.close(file)
            end
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