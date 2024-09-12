--[[
--=====================================================================================================--
Script Name: List Players, for SAPP (PC & CE)
Description: An alternative player list mod (Overrides SAPP's built in /pl command.)

             This script provides a custom player list command that displays player names, teams, and IP addresses.
             It includes permission checks to ensure only authorized users can execute the command.

Copyright (c) 2019-2024, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]

api_version = '1.12.0.0'

-- Configuration
local config = {
    command = 'pls', -- Command to show custom player list
    level = 1, -- Minimum level required to execute custom command
    header = 'NAME            TEAM            IP\n', -- Header for the player list
    ffa = false, -- Free-for-all mode
}

local players = {}

-- Register needed event callbacks
function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_TEAM_SWITCH'], 'OnTeamSwitch')
    OnStart()
end

-- Initialize player list on game start
function OnStart()
    if get_var(0, '$gt') ~= 'n/a' then
        players = {}
        config.ffa = (get_var(0, '$ffa') == '1')
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

-- Handle player joining
function OnJoin(id)
    local team = get_var(id, '$team')
    team = (not config.ffa and team or 'FFA')
    local name = get_var(id, '$name')
    local ip = get_var(id, '$ip')
    players[id] = { id = id, ip = ip, team = team, name = name }
end

-- Handle player quitting
function OnQuit(id)
    players[id] = nil
end

-- Handle team switching
function OnTeamSwitch(id)
    local player = players[id]
    if player then
        player.team = get_var(id, '$team')
    end
end

-- Respond to player or server
local function Respond(id, msg)
    if id == 0 then
        cprint(msg)
    else
        rprint(id, msg)
    end
end

-- Check if player has permission to execute command
local function hasPermission(id)
    local lvl = tonumber(get_var(id, '$lvl'))
    if id == 0 or lvl >= config.level then
        return true
    else
        Respond(id, 'You do not have permission to execute that command.')
        return false
    end
end

-- Format player list with proper spacing
local function formatPlayerList()
    local list = {}
    for _, player in pairs(players) do
        local name = player.name
        local team = player.team
        local ip = player.ip
        table.insert(list, string.format('%-16s%-16s%s', name, team, ip))
    end
    return table.concat(list, '\n')
end

-- Handle custom command
function OnCommand(id, cmd)
    if cmd:sub(1, #config.command):lower() == config.command then
        if hasPermission(id) then
            local list = formatPlayerList()
            if #list > 0 then
                Respond(id, config.header .. list)
            else
                Respond(id, 'No players online')
            end
        end
        return false
    end
end

function OnScriptUnload()
    -- No actions needed on script unload
end