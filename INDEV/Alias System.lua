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

    -- If true, the .json database will be updated
    -- every time a player joins.
    --
    -- If false, the .json database will only be updated
    -- when the game ends (recommended).
    update_file_on_join = false
}

local date = os.date
local open = io.open
local json = loadfile('./json.lua')()

api_version = "1.12.0.0"

function OnScriptLoad()

    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()

    Alias:CheckFile(true)
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

function OnScriptUnload()
    WriteToFile(Alias, Alias.records)
end