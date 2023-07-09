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
    cmds = {},
    commands_path = './Admin Manager/Commands/', -- management commands path
    json = loadfile('./Admin Manager/Utils/Json.lua')(),
    dependencies = {
        ['./Admin Manager/'] = { 'settings' },
        ['./Admin Manager/Events/'] = {
            'Join',
            'OnCommand'
        },
        ['./Admin Manager/Utils/'] = {
            'FileIO',
            'LoadDatabase',
            'Misc',
            'PermissionHandler'
        }
    }
}

function AdminManager:LoadDependencies()
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
    am:LoadDependencies()

    -- load management commands:
    am:LoadManagementCMDS()

    -- create default commands:
    --am:WriteDefaultCommands()

    -- create default admins:
    --am:WriteDefaultAdmins()

    -- Load admins and player commands:
    am.admins = am:LoadAdmins()
    am.commands = am:LoadCommands()

    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        local am = AdminManager
        am.players = {}
        am.players[0] = am:NewPlayer({
            id = 0,
            level = #am.commands,
            name = 'Server',
            hash = 'N/A',
            ip = '127.0.0.1'
        })
    end
end

function OnJoin(Ply)
    return AdminManager:OnJoin(Ply)
end

function OnCommand(Ply, CMD)
    return AdminManager:OnCommand(Ply, CMD)
end

function OnScriptUnload()
    -- N/A
end