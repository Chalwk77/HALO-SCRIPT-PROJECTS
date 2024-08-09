--[[
--=====================================================================================================--
Script Name: List Players, for SAPP (PC & CE)
Description: An alternative player list mod (Overrides SAPP's built in /pl command.)

Copyright (c) 2019-2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]

api_version = '1.12.0.0'

-- config starts --
-- Command to show custom player list:
local command = 'pls'

-- Minimum level required to execute custom command:
local level = 1
-- config ends --

local ffa
local players = {}

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_TEAM_SWITCH'], 'OnTeamSwitch')

    OnStart()
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        players = { }
        ffa = (get_var(0, '$ffa') == '1')

        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

-- Called when a player joins the server and creates an iterable player cache:
-- @param Ply (player index)
--
function OnJoin(Ply)

    local team = get_var(Ply, '$team')
    team = (not ffa and team or 'FFA')

    local name = get_var(Ply, '$name')
    local ip = get_var(Ply, '$ip'):match('%d+.%d+.%d+.%d+')

    players[Ply] = {
        id = Ply,
        ip = ip,
        team = team,
        name = name
    }
end

-- Called when a player quits the server.
-- @param Ply (player index)
-- Nullifies the player cache for this player.
--
function OnQuit(Ply)
    players[Ply] = nil
end

-- Called when a player switches team:
--
function OnTeamSwitch(Ply)
    local p = players[Ply]
    if (p) then
        p.team = get_var(Ply, '$team')
    end
end

-- Custom response function:
-- Player 0 = SERVER (terminal)
--
local function Respond(Ply, Msg)
    return (Ply == 0 and cprint(Msg) or rprint(Ply, Msg))
end

local function noPerm(Ply)
    Respond(Ply, 'You do not have permission to execute that command.')
    return false
end

-- Checks if a player can execute the custom command:
--
-- @return (boolean), true if player has permission.
--
local function hasPermission(Ply)
    local lvl = tonumber(get_var(Ply, '$lvl'))
    return (Ply == 0 or lvl >= level or noPerm(Ply))
end

local function spaces(str, pos)
    local s = ''
    for _ = 1, pos - str:len() do
        s = s .. ' '
    end
    return s
end


-- Custom command listener:
--
function OnCommand(Ply, CMD)

    if (CMD:sub(1, command:len()):lower() == command) then
        if hasPermission(Ply) then

            local t = {}
            for i, v in pairs(players) do
                local ip = v.ip
                local name = v.name
                local team = v.team
                t[i] = name .. spaces(name, 16) .. team .. spaces(team, 16) .. ip
            end

            local list = (#t > 0 and table.concat(t, '\n') or 'No players online')
            Respond(Ply, 'NAME            TEAM            IP\n')
            Respond(Ply, list)

        end
        return false
    end
end

function OnScriptUnload()
    -- N/A
end