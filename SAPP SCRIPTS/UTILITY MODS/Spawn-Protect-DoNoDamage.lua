--[[
--=====================================================================================================--
Script Name: Spawn-Protect-DoNoDamage, for SAPP (PC & CE)
Description: Prevent newly spawned players from inflicting damage 
			 on others until the timer has expired.

			 This mod is intended to be used in conjuction with SAPP's Spawn Protection feature.
			 SAPP's Spawn Protection Feature prevents others from harming you for X seconds, 
			 but you can still inflict damage on them.
			 
			 * This mod is a work-around for the above issue.

~ Credits: This scipt utilizes modified parts of 002's equipment loading/saving script.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

api_version = "1.12.0.0"

-- Configuration [starts]
-- Players will not be able to inflict damage for this many seconds after they spawn:
local duration = 5 -- (in seconds)

-- Enable|Disable on-screen timer
local show_countdown = false
-- Configuration [ends]

local init_timer, time_remaining, provisions = { }, { }, { }
local _debug_, floor = false, math.floor

local function ResetAll()
    for i = 1, 16 do
        if player_present(i) then
            init_timer[i], time_remaining[i] = { }, { }
        end
    end
end

function OnScriptLoad()
    duration = duration + 1
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")

    register_callback(cb['EVENT_TICK'], "OnTick")
    ResetAll()
end

function OnGameEnd()
    ResetAll()
end

local function stopTimer(p)
    init_timer[p], time_remaining[p] = false, duration
    if (_debug_) then
        cprint("Spawn-Protect-DoNoDamage: Stopping Timer for " .. get_var(p, "$name"))
    end
    if player_alive(p) then
        for _ = 1, 4 do execute_command("wdel " .. p) end
        local x, y, z = read_vector3d(get_dynamic_player(p) + 0x5C)
        local inventory = provisions[p]
        for _, weapon in ipairs(inventory) do
            local saved_weapons = spawn_object("null", "null", x, y, z + 0.3, 90, weapon.identifier)
            local weapon_object = get_object_memory(saved_weapons)
            write_word(weapon_object + 0x2B8, weapon.pa)
            write_word(weapon_object + 0x2B6, weapon.pra)
            write_word(weapon_object + 0x2C6, weapon.sla)
            write_word(weapon_object + 0x2C8, weapon.sra)
            write_float(weapon_object + 0x240, weapon.b)
            sync_ammo(saved_weapons)
            assign_weapon(saved_weapons, p)
            write_byte(get_dynamic_player(p) + 0x31E, inventory.frags)
            write_byte(get_dynamic_player(p) + 0x31F, inventory.plasmas)
        end
    end
end

function OnScriptUnload()
    --
end

function OnPlayerConnect(p)
    init_timer[p], time_remaining[p] = { }, { }
end

function OnPlayerDisconnect(p)
    init_timer[p], time_remaining[p] = nil, duration
end

function OnPlayerSpawn(p)
    init_timer[p], time_remaining[p] = true, duration
    if (_debug_) then
        cprint(get_var(p, "$name") .. " just spawned. Starting Timer.", 5 + 8)
        cprint("Spawn-Protect-DoNoDamage: " .. get_var(p, "$name") .. " just spawned. Starting Timer."
    end
    local player_object = get_dynamic_player(p)
    if (player_object ~= 0) then
        provisions[p] = provisions[p] or { }
        provisions[p] = nil
        local inventory, weapon = {}
        for w = 0, 3 do
            weapon = get_object_memory(read_dword(player_object + 0x2F8 + w * 4))
            if (weapon ~= 0) then
                inventory[w + 1] = {
                    ["identifier"] = read_dword(weapon),
                    ["pa"] = read_word(weapon + 0x2B8),
                    ["pra"] = read_word(weapon + 0x2B6),
                    ["sla"] = read_word(weapon + 0x2C6),
                    ["sra"] = read_word(weapon + 0x2C8),
                    ["b"] = read_float(weapon + 0x240)
                }
            end
        end
        inventory.frags = read_byte(player_object + 0x31E)
        inventory.plasmas = read_byte(player_object + 0x31F)
        provisions[p] = inventory
    end
end

local function cls(p)
    if (p) then
        for _ = 1, 25 do
            rprint(p, " ")
        end
    end
end

local function CountdownLoop(p)
    time_remaining[p] = time_remaining[p] - 0.030

    local char = ""
    if (floor(time_remaining[p]) > 1) then
        char = 's'
    elseif (time_remaining[p] <= 1) then
        char = ''
    end

    if (show_countdown) then
        cls(p)
        rprint(p, 'Spawn Protection ends in (' .. floor(time_remaining[p]) .. ") second" .. char, 5 + 8)
    end

    if (time_remaining[p] ~= nil) and (time_remaining[p] <= 1) then
        cls(p)
        stopTimer(p)
    elseif (_debug_) then
        cprint('Player can deal damage in (' .. floor(time_remaining[p]) .. ") second" .. char, 5 + 8)
    end
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) and player_alive(i) then
            if (init_timer[i]) then
                CountdownLoop(i)
            end
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
        if (init_timer[CauserIndex]) then
            return false
        end
    end
end
