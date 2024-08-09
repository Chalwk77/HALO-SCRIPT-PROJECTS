--[[
--=====================================================================================================--
Script Name: Anti AFK, for SAPP (PC & CE)
Description: If you move your mouse, fire your gun, move forward,
             backward, left, right, throw a grenade, switch weapon,
             switch grenade, reload, zoom, melee, activate flashlight,
             press your action key, crouch or jump it will consider you no longer afk.

             This script is in ALPHA and may have bugs.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
-- Time (in seconds) a player must be afk before the script will kick them:
--
local max_afk_time = 300 -- default 5 minutes

local kick_reason = 'AFK for too long!'
-- config ends --

api_version = '1.12.0.0'

local players = {}
local mt = { __index = {

    timer = 0,

    update_aim = false,

    camera = {

        -- current:
        { 0, 0, 0 },

        -- old:
        { 0, 0, 0 }
    },

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
} }

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
    register_callback(cb['EVENT_CHAT'], 'ChatCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_PRESPAWN'], 'OnPreSpawn')
    register_callback(cb['EVENT_COMMAND'], 'ChatCommand')
    OnStart()
end

local function newPlayer(id)
    players[id] = setmetatable({}, mt)
end

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

function ChatCommand(id)
    if (id > 0) then
        players[id].timer = 0
    end
end

local function updateAim(dyn, Camera)
    if (dyn ~= 0) then
        Camera[1] = read_float(dyn + 0x230)
        Camera[2] = read_float(dyn + 0x234)
        Camera[3] = read_float(dyn + 0x238)
    end
end

local function checkInputs(dyn, player)
    if (dyn ~= 0) then
        for _, input in pairs(player.inputs) do

            local func, address = input[1], input[2]
            local state = func(dyn + address)

            if (state ~= input.state and player.update_aim) then
                player.timer = 0
            end
            input.state = state
        end
    end
end

local function checkAim(x1, y1, z1, x2, y2, z2)
    return (x1 == x2 and y1 == y2 and z1 == z2)
end

function OnTick()

    for i, v in pairs(players) do
        local dyn = get_dynamic_player(i)

        checkInputs(dyn, v)

        -- update current aim:
        updateAim(dyn, v.camera[1])

        -- current Aim:
        local x1 = v.camera[1][1]
        local y1 = v.camera[1][2]
        local z1 = v.camera[1][3]

        -- old Aim:
        local x2 = v.camera[2][1]
        local y2 = v.camera[2][2]
        local z2 = v.camera[2][3]

        -- update old aim:
        updateAim(dyn, v.camera[2])

        local no_aim_change = checkAim(x1, y1, z1, x2, y2, z2)
        local case = (no_aim_change or not v.update_aim)

        v.timer = (case and v.timer + 1 / 30) or 0
        --print(v.timer)

        if (v.timer >= max_afk_time) then
            execute_command('k ' .. i .. ' "' .. kick_reason .. '"')
        end
    end
end

function OnPreSpawn(id)
    players[id].update_aim = false
end

function OnSpawn(id, DelayUpdate)
    id = tonumber(id)
    if (not DelayUpdate) then
        timer(500, 'OnSpawn', id, 1)
    else
        players[id].update_aim = true
    end
end

function OnJoin(id)
    newPlayer(id)
end

function OnQuit(id)
    players[id] = nil
end

function OnScriptUnload()
    -- N/A
end