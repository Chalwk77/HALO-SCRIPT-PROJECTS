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
}

local open = io.open
local json = loadfile('./json.lua')()

api_version = "1.12.0.0"

function OnScriptLoad()

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

function Alias:CheckFile(ScriptLoad)

    local dir = read_string(read_dword(sig_scan('68??????008D54245468') + 0x1))
    self.dir = dir .. '\\sapp\\' .. self.file

    self.database = (ScriptLoad and nil or self.database)

    if (get_var(0, '$gt') ~= 'n/a' and self.database == nil) then
        local content = ''
        local file = open(self.dir, 'r')
        if (file) then
            content = file:read('*all')
            file:close()
        end
        local data = json:decode(content)
        if (not data) then
            WriteToFile(self, {})
        end
        self.database = data or {}
    end
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        Alias:CheckFile(false)
    end
end

function OnScriptUnload()
    -- N/A
end