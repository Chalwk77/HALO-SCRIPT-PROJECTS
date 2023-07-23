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
            'on_end',
            'on_join',
            'on_quit',
            'on_start',
            'on_tick'
        },
        ['./Admin Manager/util/'] = {
            'ban',
            'custom_variables',
            'file_io',
            'misc'
        }
    }
}

function AdminManager:loadDependencies()

    local dir = read_string(read_dword(sig_scan('68??????008D54245468') + 0x1))
    self.root_directory = dir .. '\\sapp\\'

    local s = self
    for path, t in pairs(self.dependencies) do
        for _, file in pairs(t) do

            local success, error = pcall(function()
                local f = loadfile(path .. file .. '.lua')()
                setmetatable(s, { __index = f })
                s = f
            end)

            if (not success) then
                print('Error loading ' .. path .. file .. '.lua')
                print(error)
            end
        end
    end

    self:registerLevelVariable()
    self:loadBans()
    self:loadAliases()
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

function OnEnd()
    AdminManager:onEnd()
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
    AdminManager:unregisterLevelVariable()
end