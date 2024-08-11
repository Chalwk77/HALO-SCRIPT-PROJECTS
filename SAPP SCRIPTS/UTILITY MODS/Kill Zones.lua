--[[
--=====================================================================================================--
Script Name: Kill Zones, for SAPP (PC & CE)
Description: This script creates and manages 'kill zones' in the game, which are configurable areas that
             players must leave within a specified time or face death.

             When a player enters a kill zone, they receive a warning message displaying a countdown timer
             showing how long they have before being killed.

             The script allows customization of the warning message, server prefix, kill delay, and zone positions,
             giving server administrators flexibility in setting up these danger zones.

Copyright (c) 2024, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

local config = {

    -- MESSAGES:
    warningMessage = "Warning: Forbidden zone [%]",
    serverPrefix = "SERVER",


    --[[

        MAP SETTINGS:
        team                 =       Player Team: 'red', 'blue', 'FFA'
                                     Only players on the defined team will trigger the Zone.
        x,y,z radius         =       Zone coordinates.
        seconds until death  =       A player has this many seconds to leave a kill zone otherwise they are killed.
    ]]

    ['bloodgulch'] = {

        -- team, x,y,z, radius, kill delay
        { 'FFA', 82.68, -114.61, 0.67, 5, 15 },


        --{...}
        -- repeat the structure to add more zones for this map
    },

    -- repeat the above structure to add more maps:
    ["map name here"] = {
        --{...}
    }
}

local ffa
local zones = {}
local players = {}

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], "OnStart")
end

local function loadZones()
    local map = get_var(0, '$map')
    zones = config[map]
    return zones and #zones > 0 or nil
end

function OnStart()
    if get_var(0, '$gt') ~= 'n/a' then

        players = {}
        ffa = (get_var(0, '$ffa') == '1')

        local killZones = loadZones()
        if killZones then
            register_callback(cb['EVENT_TICK'], "OnTick")
            register_callback(cb['EVENT_JOIN'], "OnJoin")
            register_callback(cb['EVENT_LEAVE'], "OnQuit")
            register_callback(cb['EVENT_TEAM_SWITCH'], "OnTeamSwitch")
            return
        end

        unregister_callback(cb['EVENT_TICK'])
        unregister_callback(cb['EVENT_JOIN'])
        unregister_callback(cb['EVENT_LEAVE'])
        unregister_callback(cb['EVENT_TEAM_SWITCH'])
    end
end

local function killPlayer(player)
    execute_command("kill " .. player.id)
    say_all(player.name .. " was killed for entering a forbidden zone.")
end

local function warn(player)
    execute_command('msg_prefix ""')

    local elapsed = os.clock() - player.timer.start
    local remaining = math.floor(player.timer.remaining - elapsed)
    local message = config.warningMessage:gsub('%%', remaining)

    for _ = 1, 25 do
        rprint(player.id, " ")
    end

    rprint(player.id, message)
    execute_command('msg_prefix ' .. config.serverPrefix .. '"')
end

local function startTimer(player, killDelay)
    if not player.timer then
        player.timer = {
            start = os.clock();
            remaining = killDelay,
        }
    end
end

local function updateTimer(player)
    if player.timer then
        local elapsed = os.clock() - player.timer.start
        if elapsed < player.timer.remaining then
            warn(player)
        else
            player.timer = nil
            killPlayer(player)
        end
    end
end

function OnJoin(id)
    players[id] = {
        id = id,
        team = ffa and 'FFA' or get_var(id, '$team'),
        name = get_var(id, '$name')
    }
end

function OnQuit(id)
    players[id] = nil
end

function OnTeamSwitch(id)
    local player = players[id]
    if player then
        player.team = get_var(id, '$team')
    end
end

local function getPlayerPosition(dyn)

    local x, y, z
    local crouch = read_float(dyn + 0x50C)
    local vehicle = read_dword(dyn + 0x11C)
    local object = get_object_memory(vehicle)

    x, y, z = read_vector3d(dyn + 0x5C)

    if vehicle == 0xFFFFFFFF then
        z = crouch == 0 and z + 0.65 or z + 0.35 * crouch
    elseif object ~= 0 then
        x, y, z = read_vector3d(object + 0x5C)
    end

    return { x = x, y = y, z = z }
end

local function isPlayerOutsideZone(playerPosition, zonePosition)

    local maxDistance = zonePosition.radius

    local dx = math.abs(playerPosition.x - zonePosition.x)
    local dy = math.abs(playerPosition.y - zonePosition.y)
    local dz = math.abs(playerPosition.z - zonePosition.z)

    return dx > maxDistance or dy > maxDistance or dz > maxDistance
end

local function checkPlayerZoneAndTimer(player)

    local dyn = get_dynamic_player(player.id)
    for zoneIndex = 1, #zones do
        local zonePosition = {
            x = zones[zoneIndex][2],
            y = zones[zoneIndex][3],
            z = zones[zoneIndex][4],
            radius = zones[zoneIndex][5]
        }
        local playerPosition = getPlayerPosition(dyn)

        if (not isPlayerOutsideZone(playerPosition, zonePosition)) then
            startTimer(player, zones[zoneIndex][6])
        elseif (player.timer) then
            player.timer = nil
        end
    end
end

function OnTick()
    for i = 1, 16 do
        local player = players[i]
        if player and player_present(i) and player_alive(i) then
            checkPlayerZoneAndTimer(player)
            updateTimer(player)
        end
    end
end

function OnScriptUnload()
    -- N/A
end