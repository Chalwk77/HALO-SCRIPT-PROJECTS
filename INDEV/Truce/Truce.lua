--[[
--=====================================================================================================--
Script Name: Truce, for SAPP (PC & CE)
Description: Initiate a truce between two or more players on the opposing team.
             While in a truce, players will not be able to damage each other.

             Cross-compatible with PC & CE.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local Truce = {
    players = {}, ip_table = {},
    dependencies = {
        ['./Truce/'] = { 'settings' },
        ['./Truce/Events/'] = { 'sapp_events' },
        ['./Truce/Misc/'] = { 'misc' },
    }
}

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_TEAM_SWITCH'], 'OnSwitch')
    OnStart()
end

function Truce:LoadDependencies()

    self.cmds = { }

    if (self.expire_on_new_game) then
        self.ip_table, self.players = {}, {}
    end

    local s = self
    for path, t in pairs(self.dependencies) do
        for i = 1, #t do

            local f
            local file = t[i]
            f = loadfile(path .. file .. '.lua')()
            setmetatable(s, { __index = f })
            s = f

            :: next ::
        end
    end

    self:LoadCommands()
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        Truce:LoadDependencies()
    end
end

function OnCommand(P, C)
    return Truce:OnCommand(P, C)
end

function OnJoin(P)
    Truce:OnJoin(P)
end

function OnQuit(P)
    Truce:OnQuit(P)
end

function OnSwitch(P)
    Truce:OnSwitch(P)
end

function OnScriptUnload()
    -- N/A
end