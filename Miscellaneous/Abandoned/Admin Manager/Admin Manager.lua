--[[
--=====================================================================================================--
Script Name: Admin Manager, for SAPP (PC & CE)
Description:

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

local AdminManager = {
    commands_dir = './Admin Manager/commands/', -- management commands path
    json = loadfile('./Admin Manager/util/json.lua')(),
    dependencies = {
        ['./Admin Manager/'] = { 'settings' },
        ['./Admin Manager/events/'] = {
            'on_command',
            'on_join',
            'on_start'
        },
        ['./Admin Manager/util/'] = {
            'FileIO',
            'LoadDatabase',
            'Misc'
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
end

function OnScriptLoad()

    local am = AdminManager

    -- load file dependencies:
    am:loadDependencies()

    -- load management commands:
    am:loadManagementCMDS()

    -- create default commands:
    am:WriteDefaultCommands()

    -- create default admins:
    --am:WriteDefaultAdmins()

    -- Load server admins and management commands:
    am.admins = am:loadAdmins()
    am.commands = am:loadCommands()
    am.management = am:loadManagementCMDS()
    am:onStart()
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