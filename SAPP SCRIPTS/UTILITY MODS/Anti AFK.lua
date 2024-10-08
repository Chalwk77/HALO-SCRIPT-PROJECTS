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

-- Configuration settings:
local max_afk_time = 300                    -- Maximum allowed AFK time in seconds
local kick_reason = 'AFK for too long!'     -- Reason displayed when kicking an AFK player
local threshold = 0.001                     -- Threshold for checking aim differences (only change if necessary)
api_version = '1.12.0.0'                    -- API version used by the script
-- Configuration ends here.
--
--
--
-- Empty table for storing AFK status of players
local players = {}

-- Importing necessary functions and variables from external libraries
local abs, clock, pairs, ipairs = math.abs, os.clock, pairs, ipairs

-- Function called when a new player joins the server
-- Initializes a new entry in the players table for the given player.
local function newPlayer(id)
    players[id] = {
        last_active = clock(),
        camera_old = { 0, 0, 0 },
        inputs = {
            { read_float, 0x490, state = 0 }, -- shooting
            { read_byte, 0x2A3, state = 0 }, -- forward, backward, left, right, grenade throw
            { read_byte, 0x47C, state = 0 }, -- weapon switch
            { read_byte, 0x47E, state = 0 }, -- grenade switch
            { read_byte, 0x2A4, state = 0 }, -- weapon reload
            { read_word, 0x480, state = 0 }, -- zoom
            { read_word, 0x208, state = 0 }  -- melee, flashlight, action, crouch, jump
        }
    }
end

-- Function to get the current x,y,z camera position of a player at the given memory address
local function getCameraCurrent(dyn)
    return {
        read_float(dyn + 0x230),
        read_float(dyn + 0x234),
        read_float(dyn + 0x238)
    }
end

-- Function to check if a player is AFK:
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

-- Update player's last_active timestamp and camera_old values:
local function updatePlayerData(player, camera_current)
    player.last_active = clock()
    player.camera_old = { camera_current[1], camera_current[2], camera_current[3] }
end

-- Function to check and update aim for a player:
local function checkAndUpdateAim(player, dyn)
    local current_aim = getCameraCurrent(dyn)
    local old_aim = player.camera_old
    if not checkAim(old_aim[1], old_aim[2], old_aim[3], current_aim[1], current_aim[2], current_aim[3]) then
        updatePlayerData(player, current_aim)
    end
end

-- Function to check player inputs and update their last_active timestamp
local function checkInputs(dyn, player)
    for _, input in ipairs(player.inputs) do
        local func, address = input[1], input[2]
        if func(dyn + address) ~= input.state then
            player.last_active = clock()  -- Update the player's last_active timestamp
            input.state = func(dyn + address)  -- Update the input state
        end
    end
end

-- Function to check if a player is valid:
local function isValidPlayer(id, dyn)
    return player_present(id) and dyn ~= 0 and player_alive(id)
end

-- Kick the player with the given ID and display the kick reason:
local function kickPlayer(id, reason)
    execute_command('k ' .. id .. ' "' .. reason .. '"')
    players[id] = nil
end

--================--
-- SAPP functions:
--================--

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
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
            kickPlayer(id, kick_reason)
            goto continue -- Skips the rest of the loop if the player is AFK
        end

        -- Update player inputs and last_active timestamp:
        checkInputs(dyn, player)

        -- Check and update player's aim:
        checkAndUpdateAim(player, dyn)
        :: continue ::
    end
end

-- Create a new player object when a player joins the game:
function OnJoin(id)
    newPlayer(id)
end

-- Remove a player object when a player leaves the game:
function OnQuit(id)
    players[id] = nil
end

-- Update the player's last_active timestamp when they send a chat message/command:
function ChatCommand(id)
    if (id > 0) then
        players[id].last_active = clock()
    end
end