--[[
--=====================================================================================================--
Script Name: Killer Reward, for SAPP (PC & CE)
Implementing API version: 1.11.0.0
Description:    This script will drop 1 of 20 (configurable) random items at your victims death location.
    
                MODES:
                Kills Not Required:
                    Your victim will drop 1 random "weapon" or "equipment" item (indefinitely), by default.

                Kills Required:
                    Your victim will drop 1 random "weapon" or "equipment" item when you reach a specific kill threashold.
                    For every 5 (non-consecutive) kills, your victim will drop an item.

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
-- ==============================================--
-- >> Configuration << --
gamesettings = {
    --  You can toggle these settings ON|OFF. (true/false).
    --  Only one option can be "true" at a time.
    ["WeaponsAndEquipment"] = true,
    ["JustEquipment"] = false,
    ["JustWeapons"] = false,

    -- Toggle these modes ON|OFF (true/false)
    --  Only one option can be "true" at a time.
    -- No Kills Kequired
    ["NO_KILLS_REQUIRED"] = true,
    -- Kills Are Required
    ["KILLS_REQUIRED"] = false
}

-- To disable a specific item, change the 'true' value to "false".
weapons = {
    { "weap", "weapons\\assault rifle\\assault rifle", true },
    { "weap", "weapons\\flamethrower\\flamethrower", true },
    { "weap", "weapons\\needler\\mp_needler", true },
    { "weap", "weapons\\pistol\\pistol", true },
    { "weap", "weapons\\plasma pistol\\plasma pistol", true },
    { "weap", "weapons\\plasma rifle\\plasma rifle", true },
    { "weap", "weapons\\plasma_cannon\\plasma_cannon", true },
    { "weap", "weapons\\rocket launcher\\rocket launcher", true },
    { "weap", "weapons\\shotgun\\shotgun", true },
    { "weap", "weapons\\sniper rifle\\sniper rifle", true }
}

equipment = {
    { "eqip", "powerups\\active camouflage", true },
    { "eqip", "powerups\\health pack", true },
    { "eqip", "powerups\\over shield", true },
    { "eqip", "powerups\\assault rifle ammo\\assault rifle ammo", true },
    { "eqip", "powerups\\needler ammo\\needler ammo", true },
    { "eqip", "powerups\\pistol ammo\\pistol ammo", true },
    { "eqip", "powerups\\rocket launcher ammo\\rocket launcher ammo", true },
    { "eqip", "powerups\\shotgun ammo\\shotgun ammo", true },
    { "eqip", "powerups\\sniper rifle ammo\\sniper rifle ammo", true },
    { "eqip", "powerups\\flamethrower ammo\\flamethrower ammo", true }
}
-- >> Configuration Ends << --
-- ==============================================--

-- Do Not Touch --
weap = "weap"
eqip = "eqip"
GameHasStarted = false
VICTIM_LOCATION = { }
for i = 1, 16 do
    VICTIM_LOCATION[i] = { }
end

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    if get_var(0, "$gt") ~= "n/a" then
        GameHasStarted = true
        map_name = get_var(1, "$map")
        game_type = get_var(0, "$gt")
    end
end

function OnScriptUnload()
    gamesettings = { }
    equipment = { }
    weapons = { }
    EQUIPMENT_TABLE = { }
    WEAPON_TABLE = { }
end

function OnGameEnd()
    gamesettings = { }
    equipment = { }
    weapons = { }
    EQUIPMENT_TABLE = { }
    WEAPON_TABLE = { }
    GameHasStarted = false
end

function OnNewGame()
    for k, v in pairs(equipment) do
        local tag = lookup_tag(v[1], v[2])
        if tag ~= 0 then
            local index = k
            if (v[3] == false) then
                EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
                EQUIPMENT_TABLE[index] = nil
                index = index - k
                -- cprint("[EQUIPMENT] Removing index #" ..k.. " from the EQUIPMENT_TABLE", 2+8)
            else
                index = index + k
            end
        end
    end
    for k, v in pairs(weapons) do
        local tag = lookup_tag(v[1], v[2])
        if tag ~= 0 then
            local index = k
            if (v[3] == false) then
                WEAPON_TABLE[index] = WEAPON_TABLE[index]
                WEAPON_TABLE[index] = nil
                index = index - k
                -- cprint("[WEAPONS] Removing index #" ..k.. " from the WEAPON_TABLE", 2+8)
            else
                index = index + k
            end
        end
    end
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    local victim = tonumber(VictimIndex)
    local killer = tonumber(KillerIndex)
    local kills = tonumber(get_var(killer, "$kills"))
    local player_object = get_dynamic_player(victim)
    local xAxis, yAxis, zAxis = read_vector3d(player_object + 0x5C)
    VICTIM_LOCATION[victim][1] = xAxis
    VICTIM_LOCATION[victim][2] = yAxis
    VICTIM_LOCATION[victim][3] = zAxis
    if (killer > 0) then

        -- NO KILLS REQUIRED -- 
        -- Weapons and Equipment
        if (gamesettings["NO_KILLS_REQUIRED"] == true) and (gamesettings["WeaponsAndEquipment"] == true) then
            WeaponsAndEquipment(victim, xAxis, yAxis, zAxis)

            -- Global (no kills required): JustEquipment (indefinitely spawn an item)
        elseif (gamesettings["NO_KILLS_REQUIRED"] == true) and (gamesettings["JustEquipment"] == true) then
            JustEquipment(victim, xAxis, yAxis, zAxis)

            -- Global (no kills required): JustWeapons (indefinitely spawn an item)
        elseif (gamesettings["NO_KILLS_REQUIRED"] == true) and (gamesettings["JustWeapons"] == true) then
            JustWeapons(victim, xAxis, yAxis, zAxis)

            -- KILLS REQUIRED --
            -- Weapons and Equipment
        elseif (gamesettings["KILLS_REQUIRED"] == true) and (gamesettings["NO_KILLS_REQUIRED"] == false) and (gamesettings["WeaponsAndEquipment"] == true) then
            if (kills == 5) then
                WeaponsAndEquipment(victim, xAxis, yAxis, zAxis)
            elseif (kills == 10) then
                WeaponsAndEquipment(victim, xAxis, yAxis, zAxis)
            elseif (kills == 15) then
                WeaponsAndEquipment(victim, xAxis, yAxis, zAxis)
            elseif (kills == 20) then
                WeaponsAndEquipment(victim, xAxis, yAxis, zAxis)
            elseif (kills == 25) then
                WeaponsAndEquipment(victim, xAxis, yAxis, zAxis)
            elseif (kills == 30) then
                WeaponsAndEquipment(victim, xAxis, yAxis, zAxis)
            elseif (kills == 35) then
                WeaponsAndEquipment(victim, xAxis, yAxis, zAxis)
            elseif (kills == 40) then
                WeaponsAndEquipment(victim, xAxis, yAxis, zAxis)
            elseif (kills == 45) then
                WeaponsAndEquipment(victim, xAxis, yAxis, zAxis)
            elseif (kills >= 50) then
                WeaponsAndEquipment(victim, xAxis, yAxis, zAxis)
            end
            -- JustEquipment --
        elseif (gamesettings["KILLS_REQUIRED"] == true) and (gamesettings["NO_KILLS_REQUIRED"] == false) and (gamesettings["JustEquipment"] == true) then
            if (kills == 5) then
                JustEquipment(victim, xAxis, yAxis, zAxis)
            elseif (kills == 10) then
                JustEquipment(victim, xAxis, yAxis, zAxis)
            elseif (kills == 15) then
                JustEquipment(victim, xAxis, yAxis, zAxis)
            elseif (kills == 20) then
                JustEquipment(victim, xAxis, yAxis, zAxis)
            elseif (kills == 25) then
                JustEquipment(victim, xAxis, yAxis, zAxis)
            elseif (kills == 30) then
                JustEquipment(victim, xAxis, yAxis, zAxis)
            elseif (kills == 35) then
                JustEquipment(victim, xAxis, yAxis, zAxis)
            elseif (kills == 40) then
                JustEquipment(victim, xAxis, yAxis, zAxis)
            elseif (kills == 45) then
                JustEquipment(victim, xAxis, yAxis, zAxis)
            elseif (kills >= 50) then
                JustEquipment(victim, xAxis, yAxis, zAxis)
            end
            -- JustWeapons --
        elseif (gamesettings["KILLS_REQUIRED"] == true) and (gamesettings["NO_KILLS_REQUIRED"] == false) and (gamesettings["JustWeapons"] == true) then
            if (kills == 5) then
                JustWeapons(victim, xAxis, yAxis, zAxis)
            elseif (kills == 10) then
                JustWeapons(victim, xAxis, yAxis, zAxis)
            elseif (kills == 15) then
                JustWeapons(victim, xAxis, yAxis, zAxis)
            elseif (kills == 20) then
                JustWeapons(victim, xAxis, yAxis, zAxis)
            elseif (kills == 25) then
                JustWeapons(victim, xAxis, yAxis, zAxis)
            elseif (kills == 30) then
                JustWeapons(victim, xAxis, yAxis, zAxis)
            elseif (kills == 35) then
                JustWeapons(victim, xAxis, yAxis, zAxis)
            elseif (kills == 40) then
                JustWeapons(victim, xAxis, yAxis, zAxis)
            elseif (kills == 45) then
                JustWeapons(victim, xAxis, yAxis, zAxis)
            elseif (kills >= 50) then
                JustWeapons(victim, xAxis, yAxis, zAxis)
            end
        end
    end
end

EQUIPMENT_TABLE = { }
EQUIPMENT_TABLE[1] = "powerups\\active camouflage"
EQUIPMENT_TABLE[2] = "powerups\\health pack"
EQUIPMENT_TABLE[3] = "powerups\\over shield"
EQUIPMENT_TABLE[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
EQUIPMENT_TABLE[5] = "powerups\\needler ammo\\needler ammo"
EQUIPMENT_TABLE[6] = "powerups\\pistol ammo\\pistol ammo"
EQUIPMENT_TABLE[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
EQUIPMENT_TABLE[8] = "powerups\\shotgun ammo\\shotgun ammo"
EQUIPMENT_TABLE[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
EQUIPMENT_TABLE[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

WEAPON_TABLE = { }
WEAPON_TABLE[1] = "weapons\\assault rifle\\assault rifle"
WEAPON_TABLE[2] = "weapons\\flamethrower\\flamethrower"
WEAPON_TABLE[3] = "weapons\\needler\\mp_needler"
WEAPON_TABLE[4] = "weapons\\pistol\\pistol"
WEAPON_TABLE[5] = "weapons\\plasma pistol\\plasma pistol"
WEAPON_TABLE[6] = "weapons\\plasma rifle\\plasma rifle"
WEAPON_TABLE[7] = "weapons\\plasma_cannon\\plasma_cannon"
WEAPON_TABLE[8] = "weapons\\rocket launcher\\rocket launcher"
WEAPON_TABLE[9] = "weapons\\shotgun\\shotgun"
WEAPON_TABLE[10] = "weapons\\sniper rifle\\sniper rifle"

function WeaponsAndEquipment(victim, xAxis, yAxis, zAxis)
    math.randomseed(os.time())
    local e = EQUIPMENT_TABLE[math.random(1, #EQUIPMENT_TABLE - 1)]
    local w = WEAPON_TABLE[math.random(1, #WEAPON_TABLE - 1)]
    local player = get_player(victim)
    local rotation = read_float(player + 0x138)
    local GetRandomNumber = math.random(1, 2)
    if (tonumber(GetRandomNumber) == 1) then
        spawn_object(tostring(eqip), e, xAxis, yAxis, zAxis + 0.5, rotation)
    elseif (tonumber(GetRandomNumber) == 2) then
        spawn_object(tostring(weap), w, xAxis, yAxis, zAxis + 0.5, rotation)
    end
end

function JustEquipment(victim, xAxis, yAxis, zAxis)
    math.randomseed(os.time())
    local e = EQUIPMENT_TABLE[math.random(0, #EQUIPMENT_TABLE - 1)]
    local player = get_player(victim)
    local rotation = read_float(player + 0x138)
    spawn_object(tostring(eqip), e, xAxis, yAxis, zAxis + 0.5, rotation)
end

function JustWeapons(victim, xAxis, yAxis, zAxis)
    math.randomseed(os.time())
    local w = WEAPON_TABLE[math.random(0, #WEAPON_TABLE - 1)]
    local player = get_player(victim)
    local rotation = read_float(player + 0x138)
    spawn_object(tostring(weap), w, xAxis, yAxis, zAxis + 0.5, rotation)
end

function OnError(Message)
    print(debug.traceback())
end
