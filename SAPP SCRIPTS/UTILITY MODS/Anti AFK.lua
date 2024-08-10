--[[
--=====================================================================================================--
Script Name: Anti AFK, for SAPP (PC & CE)
Description: This script effectively detects and manages AFK players in your server.

It monitors various in-game activities such as mouse movement, weapon firing,
player movement (forward, backward, left, right), grenade throwing, weapon switching,
grenade switching, reloading, zooming, melee attacks, flashlight activation, action key presses,
crouching, and jumping. If any of these actions are performed, the player is no longer considered AFK.

Copyright (c) 2022-2024, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- Script settings
local max_afk_time = 10 -- default 5 minutes
local kick_reason = 'AFK for too long!'
local threshold = 0.001 -- Adjust this value as needed
api_version = '1.12.0.0'

-- Player list
local players = {}

local abs = math.abs
local clock = os.clock
local pairs = pairs
local ipairs = ipairs

-- Events
local events = {
    ['EVENT_TICK'] = 'OnTick',
    ['EVENT_JOIN'] = 'OnJoin',
    ['EVENT_LEAVE'] = 'OnQuit',
    ['EVENT_CHAT'] = 'ChatCommand',
    ['EVENT_COMMAND'] = 'ChatCommand',
    ['EVENT_GAME_START'] = 'OnStart'
}

-- Create a new player object
local function newPlayer(id)
    players[id] = {
        last_active = clock(),
        camera_old = { 0, 0, 0 },
        inputs = {
            -- shooting:
            { read_float, 0x490, state = 0 },
            -- forward, backward, left, right, grenade throw:
            { read_byte, 0x2A3, state = 0 },
            -- weapon switch:
            { read_byte, 0x47C, state = 0 },
            -- grenade switch:
            { read_byte, 0x47E, state = 0 },
            -- weapon reload:
            { read_byte, 0x2A4, state = 0 },
            -- zoom:
            { read_word, 0x480, state = 0 },
            -- melee, flashlight, action, crouch, jump:
            { read_word, 0x208, state = 0 }
        }
    }
end

-- Check if a player is AFK
local function isPlayerAfk(player)
    return clock() - player.last_active >= max_afk_time
end

-- Check if the player's aim has changed
local function checkAim(x1, y1, z1, x2, y2, z2)
    local delta_x = abs(x1 - x2)
    local delta_y = abs(y1 - y2)
    local delta_z = abs(z1 - z2)
    return delta_x <= threshold and delta_y <= threshold and delta_z <= threshold
end

-- Get the current camera position
local function getCameraCurrent(dyn)
    return {
        read_float(dyn + 0x230),
        read_float(dyn + 0x234),
        read_float(dyn + 0x238)
    }
end

-- Check player inputs and update last_active timestamp
local function checkInputs(dyn, player)
    for _, input in ipairs(player.inputs) do
        local func, address = input[1], input[2]
        if func(dyn + address) ~= input.state then
            player.last_active = clock()
            input.state = func(dyn + address)
        end
    end
end

-- Update player's last_active timestamp and camera_old values
local function updatePlayerData(player, camera_current)
    player.last_active = clock()
    player.camera_old = { camera_current[1], camera_current[2], camera_current[3] }
end

-- Checks if a player is present, alive, and has a valid dyn value
local function isValidPlayer(id, dyn)
    return player_present(id) and dyn ~= 0 and player_alive(id)
end

-- Check and update player's aim:
local function checkAndUpdateAim(player, dyn)
    local current_aim = getCameraCurrent(dyn)
    local old_aim = player.camera_old

    if not checkAim(old_aim[1], old_aim[2], old_aim[3], current_aim[1], current_aim[2], current_aim[3]) then
        updatePlayerData(player, current_aim)
    end
end

-- Callbacks
function OnScriptLoad()
    for event, callback in pairs(events) do
        register_callback(cb[event], callback)
    end
end

-- Initialize the players' data when a game starts
function OnStart()
    players = { }
    if (get_var(0, '$gt') ~= 'n/a') then
        for i = 1, 16 do
            if player_present(i) then
                newPlayer(i)
            end
        end
    end
end

-- Update player inputs and last_active timestamp, kick AFK players
function OnTick()
    for id, player in pairs(players) do
        local dyn = get_dynamic_player(id)

        if not isValidPlayer(id, dyn) then
            goto continue -- Skips the rest of the loop if the player is not present, alive, or has invalid dyn
        elseif isPlayerAfk(player) then
            execute_command('k ' .. id .. ' "' .. kick_reason .. '"')
            players[id] = nil
            goto continue -- Skips the rest of the loop if the player is AFK
        end

        -- Update player inputs and last_active timestamp:
        checkInputs(dyn, player)

        -- Check and update player's aim:
        checkAndUpdateAim(player, dyn)

        :: continue ::
    end
end

-- Create a new player object when a player joins the game
function OnJoin(id)
    newPlayer(id)
end

-- Remove a player object when a player leaves the game
function OnQuit(id)
    players[id] = nil
end

-- Update last_active timestamp on chat messages (includes chat commands)
function ChatCommand(id)
    if (id > 0) then -- Ensures the player is not the server
        players[id].last_active = clock()
    end
end