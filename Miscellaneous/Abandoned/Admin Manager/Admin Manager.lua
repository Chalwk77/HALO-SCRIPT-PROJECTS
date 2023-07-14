--[[
--=====================================================================================================--
Script Name: Admin Manager, for SAPP (PC & CE)
Description: This plugin adds custom admin levels to SAPP.

Copyright (c) 2023, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

local AdminManager = {
    commands_dir = './Admin Manager/commands/',
    json = loadfile('./Admin Manager/util/json.lua')(),
    dependencies = {
        ['./Admin Manager/'] = { 'settings' },
        ['./Admin Manager/events/'] = {
            'on_command',
            'on_join',
            'on_start'
        },
        ['./Admin Manager/util/'] = {
            'file_io',
            'load_database',
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

    self:loadManagementCMDS()
    self:setDefaultCommands()
    self:setDefaultAdmins()

    self.admins = self:loadAdmins()
    self.commands = self:loadCommands()
    self.management = self:loadManagementCMDS()
    self:onStart()
end

function OnScriptLoad()
    AdminManager:loadDependencies()
end

function OnStart()
    AdminManager:onStart()
end

function OnJoin(...)
    AdminManager:onJoin(...)
end

function OnCommand(...)
    return AdminManager:onCommand(...)
end

function OnScriptUnload()
    -- N/A
end