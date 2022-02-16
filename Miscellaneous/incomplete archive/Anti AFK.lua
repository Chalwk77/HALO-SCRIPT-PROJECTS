--[[
--=====================================================================================================--
Script Name: Anti AFK (ALPHA), for SAPP (PC & CE)
Description: An unreleased beta version of my new Anti AFK kick script.

If you move your mouse, fire your gun, move forward,
backward, left, right, throw a grenade, switch weapon,
switch grenade, reload, zoom, melee, activate flashlight,
press your action key, crouch or jump it will consider you no longer afk.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
-- Time (in seconds) a player must be afk before the script will kick them:
--
local max_afk_time = 300 -- default 5 minutes

-- Self explanatory?
local kick_reason = "AFK for too long!"
-- config ends --

api_version = "1.12.0.0"

local players = {}

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_JOIN"], "OnJoin")
    register_callback(cb["EVENT_LEAVE"], "OnQuit")
    register_callback(cb["EVENT_SPAWN"], "OnSpawn")
    register_callback(cb["EVENT_CHAT"], "ChatCommand")
    register_callback(cb["EVENT_GAME_START"], "OnStart")
    register_callback(cb["EVENT_PRESPAWN"], "OnPreSpawn")
    register_callback(cb["EVENT_COMMAND"], "ChatCommand")
end

local function InitPlayer(Ply, Reset)
    if (not Reset) then
        players[Ply] = {
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
        }
        return
    end

    players[Ply] = nil
end

function OnStart()
    if (get_var(0, '$gt') ~= "n/a") then

        players = { }

        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i)
            end
        end

    end
end

function ChatCommand(Ply)
    if (Ply > 0) then
        players[Ply].timer = 0
    end
end

local function UpdateAim(DyN, Camera)
    if (DyN ~= 0) then
        Camera[1] = read_float(DyN + 0x230)
        Camera[2] = read_float(DyN + 0x234)
        Camera[3] = read_float(DyN + 0x238)
    end
end

local function CheckInputs(DyN, Player)
    if (DyN ~= 0) then
        for _, input in pairs(Player.inputs) do

            local func, address = input[1], input[2]
            local state = func(DyN + address)

            if (state ~= input.state and Player.update_aim) then
                Player.timer = 0
            end
            input.state = state
        end
    end
end

local function NoAimChange(x1, y1, z1, x2, y2, z2)
    return (x1 == x2 and y1 == y2 and z1 == z2)
end

function OnTick()

    for i, v in pairs(players) do

        local DyN = get_dynamic_player(i)

        CheckInputs(DyN, v)

        -- update current aim:
        UpdateAim(DyN, v.camera[1])

        -- current Aim:
        local x1 = v.camera[1][1]
        local y1 = v.camera[1][2]
        local z1 = v.camera[1][3]

        -- old Aim:
        local x2 = v.camera[2][1]
        local y2 = v.camera[2][2]
        local z2 = v.camera[2][3]

        -- update old aim:
        UpdateAim(DyN, v.camera[2])

        local no_aim_change = NoAimChange(x1, y1, z1, x2, y2, z2)
        local case = (no_aim_change or not v.update_aim)

        v.timer = (case and v.timer + 1 / 30) or 0
        --print(v.timer)

        if (v.timer >= max_afk_time) then
            execute_command('k ' .. i .. ' "' .. kick_reason .. '"')
        end
    end
end

function OnPreSpawn(Ply)
    players[Ply].update_aim = false
end

function OnSpawn(Ply, DelayUpdate)
    Ply = tonumber(Ply)
    if (not DelayUpdate) then
        timer(500, "OnSpawn", Ply, 1)
    else
        players[Ply].update_aim = true
    end
end

function OnJoin(Ply)
    InitPlayer(Ply)
end

function OnQuit(Ply)
    InitPlayer(Ply, true)
end

function OnScriptUnload()
    -- N/A
end