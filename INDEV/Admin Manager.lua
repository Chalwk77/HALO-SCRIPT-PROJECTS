--[[
--=====================================================================================================--
Script Name: Admin Manager, for SAPP (PC & CE)
Description: See link below for full description.

INTRO: https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/releases/tag/AdminManager

Copyright (c) 2023, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

local AdminManager = {
    commands_dir = './Admin Manager/commands/',
    dependencies = {
        ['./Admin Manager/'] = { 'settings' },
        ['./Admin Manager/events/'] = {
            'on_chat',
            'on_command',
            'on_join',
            'on_quit',
            'on_start',
            'on_tick'
        },
        ['./Admin Manager/util/'] = {
            'ban',
            'file_io',
            'misc'
        }
    }
}

function AdminManager:loadDependencies()

    local s = self
    for path, t in pairs(self.dependencies) do
        for _, file in pairs(t) do
            local f = loadfile(path .. file .. '.lua')()
            setmetatable(s, { __index = f })
            s = f
        end
    end

    self:loadBans()
    self:setDefaultCommands()
    self:setManagementCMDS()
    self:setAdmins()
    self:onStart()
end

function OnScriptLoad()
    AdminManager:loadDependencies()
end

function OnStart()
    AdminManager:onStart()
end

function OnTick()
    AdminManager:onTick()
end

function OnJoin(...)
    AdminManager:onJoin(...)
end

function OnQuit(...)
    AdminManager:onQuit(...)
end

function OnCommand(...)
    return AdminManager:onCommand(...)
end

function OnChat(...)
    return AdminManager:onChat(...)
end

function OnScriptUnload()
    -- N/A
end