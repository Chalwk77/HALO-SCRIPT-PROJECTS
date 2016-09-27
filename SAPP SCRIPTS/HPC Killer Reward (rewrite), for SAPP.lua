--[[
Script Name: HPC Killer Reward (rewrite), for SAPP
- Implementing API version: 1.11.0.0

    Description: This script will drop 1-20 (configurable) random items at your victims death location.
    TO DO LIST: https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues/4
            
MODES:
    [!] Kills Not Required:
        * Weapons and Equipment:
            ->  GlobalNoKills = "true"
            ->  GlobalSettings = "true"
            ->  WeaponsAndEquipment = "true"
            ->  JustEquipment = false
            ->  JustWeapons = false
        * Just Weapons:
            ->  GlobalNoKills = "true"
            ->  GlobalSettings = "true"
            ->  WeaponsAndEquipment = false
            ->  JustEquipment = false
            ->  JustWeapons = "true"
        * Just Equipment:
            ->  GlobalNoKills = "true"
            ->  GlobalSettings = "true"
            ->  WeaponsAndEquipment = false
            ->  JustEquipment = "true"
            ->  JustWeapons = false
            
    [!] Kills Required:
        * Weapons and Equipment:
            ->  GlobalKillsRequired = "true"
            ->  WeaponsAndEquipment = "true"
            ->  JustEquipment = false
            ->  JustWeapons = false
        * Just Weapons:
            ->  GlobalKillsRequired = "true"
            ->  WeaponsAndEquipment = false
            ->  JustEquipment = false
            ->  JustWeapons = "true"
        * Just Equipment:
            ->  GlobalKillsRequired = "true"
            ->  WeaponsAndEquipment = false
            ->  JustEquipment = "true"
            ->  JustWeapons = false
            
            Kill-Threshold: Increments of 10.
            For every 10 kills you get, your victim will drop an item.
            
Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
]]

api_version = "1.11.0.0"
--==============================================--
-- >> Configuration << --
-- Notice: "BasedOnMap" and "BasedOnGameType" are for a future update.
gamesettings = {
    ["BasedOnMap"]          = false,
    ["BasedOnGameType"]     = false,
    ["GlobalSettings"]      = true,
    ["GlobalNoKills"]       = true,
    ["GlobalKillsRequired"] = false,
    ["WeaponsAndEquipment"] = true,
    ["JustEquipment"]       = false,
    ["JustWeapons"]         = false,
}

weapons = {
    ["AssaultRifle"]    = true,
    ["FlameThrower"]    = true,
    ["Needler"]         = true,
    ["Pistol"]          = true,
    ["PlasmaPistol"]    = true,
    ["PlasmaRifle"]     = true,
    ["PlasmaCannon"]    = true,
    ["RocketLauncher"]  = true,
    ["Shotgun"]         = true,
    ["SniperRifle"]     = true,
}

equipment = {
    ["Camouflage"]          = true,
    ["HealthPack"]          = true,
    ["OverShield"]          = true,
    ["AssaultRifleAmmo"]    = true,
    ["NeedlerAmmo"]         = true,
    ["PistolAmmo"]          = true,
    ["RocketLauncherAmmo"]  = true,
    ["ShotgunAmmo"]         = true,
    ["SniperRifleAmmo"]     = true,
    ["FlameThrowerAmmo"]    = true,
}

-- Notice: "mapsettings" are for a future update.
mapsettings = {
    ["bloodgulch"]      = true,
    ["dangercanyon"]    = true,
    ["deathisland"]     = true,
    ["gephyrophobia"]   = true,
    ["icefields"]       = true,
    ["infinity"]        = true,
    ["sidewinder"]      = true,
    ["timberland"]      = true,
    ["hangemhigh"]      = true,
    ["ratrace"]         = true,
    ["beavercreek"]     = true,
    ["damnation"]       = true,
    ["boardingaction"]  = true,
    ["carousel"]        = true,
    ["putput"]          = true,
    ["prisoner"]        = true,
    ["wizard"]          = true
}
-- >> Configuration Ends << --
--==============================================--


-- Do Not Touch --
weap = "weap"
eqip = "eqip"
GameHasStarted = false
VICTIM_LOCATION = { }
for i = 1, 16 do VICTIM_LOCATION[i] = { } end

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
    gamesettings = {}
    equipment = {}
    weapons = {}
    mapsettings = {}
    EQUIPMENT_TABLE = { }
    WEAPON_TABLE = { }
end

function OnGameEnd()
    gamesettings = {}
    equipment = {}
    weapons = {}
    mapsettings = {}
    EQUIPMENT_TABLE = { }
    WEAPON_TABLE = { }
    GameHasStarted = false
end

function OnNewGame()
    GameHasStarted = true
    if gamesettings["BasedOnMap"] == false and gamesettings["BasedOnGameType"] == false
        and gamesettings["GlobalSettings"] == false and gamesettings["GlobalNoKills"] == false
        and gamesettings["WeaponsAndEquipment"] == false and gamesettings["JustEquipment"] == false 
        and gamesettings["JustWeapons"] == false then
        cprint("[SCRIPT] Warning! All Game Settings are false! One or more must be \"true\".", 4+8)
    end
    
    if equipment["Camouflage"] == false then
        local index = 1
        local ValueOfIndex = EQUIPMENT_TABLE[index]
        if (ValueOfIndex == "powerups\\active camouflage") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"Camouflage[1]\" was removed from the equipment table", 4 + 8)
        else
            index = index + 1
        end
    end

    if equipment["HealthPack"] == false then
        local index = 2
        local ValueOfIndex = EQUIPMENT_TABLE[index]
        if (ValueOfIndex == "powerups\\health pack") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"HealthPack[2]\" was removed from the equipment table", 4 + 8)
        else
            index = index + 1
        end
    end

    if equipment["OverShield"] == false then
        local index = 3
        local ValueOfIndex = EQUIPMENT_TABLE[index]
        if (ValueOfIndex == "powerups\\over shield") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"OverShield[3]\" was removed from the equipment table", 4 + 8)
        else
            index = index + 1
        end
    end

    if equipment["AssaultRifleAmmo"] == false then
        local index = 4
        local ValueOfIndex = EQUIPMENT_TABLE[index]
        if (ValueOfIndex == "powerups\\assault rifle ammo\\assault rifle ammo") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"AssaultRifleAmmo[4]\" was removed from the equipment table", 4 + 8)
        else
            index = index + 1
        end
    end

    if equipment["NeedlerAmmo"] == false then
        local index = 5
        local ValueOfIndex = EQUIPMENT_TABLE[index]
        if (ValueOfIndex == "powerups\\needler ammo\\needler ammo") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"NeedlerAmmo[5]\" was removed from the equipment table", 4 + 8)
        else
            index = index + 1
        end
    end

    if equipment["PistolAmmo"] == false then
        local index = 6
        local ValueOfIndex = EQUIPMENT_TABLE[index]
        if (ValueOfIndex == "powerups\\pistol ammo\\pistol ammo") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"PistolAmmo[6]\" was removed from the equipment table", 4 + 8)
        else
            index = index + 1
        end
    end

    if equipment["RocketLauncherAmmo"] == false then
        local index = 7
        local ValueOfIndex = EQUIPMENT_TABLE[index]
        if (ValueOfIndex == "powerups\\rocket launcher ammo\\rocket launcher ammo") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"RocketLauncherAmmo[7]\" was removed from the equipment table", 4 + 8)
        else
            index = index + 1
        end
    end

    if equipment["ShotgunAmmo"] == false then
        local index = 8
        local ValueOfIndex = EQUIPMENT_TABLE[index]
        if (ValueOfIndex == "powerups\\shotgun ammo\\shotgun ammo") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"ShotgunAmmo[8]\" was removed from the equipment table", 4 + 8)
        else
            index = index + 1
        end
    end

    if equipment["SniperRifleAmmo"] == false then
        local index = 9
        local ValueOfIndex = EQUIPMENT_TABLE[index]
        if (ValueOfIndex == "powerups\\sniper rifle ammo\\sniper rifle ammo") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"SniperRifleAmmo[9]\" was removed from the equipment table", 4 + 8)
        else
            index = index + 1
        end
    end

    if equipment["FlameThrowerAmmo"] == false then
        local index = 10
        local ValueOfIndex = EQUIPMENT_TABLE[index]
        if (ValueOfIndex == "powerups\\flamethrower ammo\\flamethrower ammo") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"FlameThrowerAmmo[10]\" was removed from the equipment table", 4 + 8)
        else
            index = index + 1
        end
    end

    if weapons["AssaultRifle"] == false then
        local index = 1
        local ValueOfIndex = WEAPON_TABLE[index]
        if (ValueOfIndex == "weapons\\assault rifle\\assault rifle") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"AssaultRifle[1]\" was removed from the weapon table", 4 + 8)
        else
            index = index + 1
        end
    end

    if weapons["FlameThrower"] == false then
        local index = 2
        local ValueOfIndex = WEAPON_TABLE[index]
        if (ValueOfIndex == "weapons\\flamethrower\\flamethrower") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"FlameThrower[2]\" was removed from the weapon table", 4 + 8)
        else
            index = index + 1
        end
    end

    if weapons["Needler"] == false then
        local index = 3
        local ValueOfIndex = WEAPON_TABLE[index]
        if (ValueOfIndex == "weapons\\needler\\mp_needler") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"Needler[3]\" was removed from the weapon table", 4 + 8)
        else
            index = index + 1
        end
    end

    if weapons["Pistol"] == false then
        local index = 4
        local ValueOfIndex = WEAPON_TABLE[index]
        if (ValueOfIndex == "weapons\\pistol\\pistol") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"Pistol[4]\" was removed from the weapon table", 4 + 8)
        else
            index = index + 1
        end
    end

    if weapons["PlasmaPistol"] == false then
        local index = 5
        local ValueOfIndex = WEAPON_TABLE[index]
        if (ValueOfIndex == "weapons\\plasma pistol\\plasma pistol") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"PlasmaPistol[5]\" was removed from the weapon table", 4 + 8)
        else
            index = index + 1
        end
    end

    if weapons["PlasmaRifle"] == false then
        local index = 6
        local ValueOfIndex = WEAPON_TABLE[index]
        if (ValueOfIndex == "weapons\\plasma rifle\\plasma rifle") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"PlasmaRifle[6]\" was removed from the weapon table", 4 + 8)
        else
            index = index + 1
        end
    end

    if weapons["PlasmaCannon"] == false then
        local index = 7
        local ValueOfIndex = WEAPON_TABLE[index]
        if (ValueOfIndex == "weapons\\plasma_cannon\\plasma_cannon") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"PlasmaCannon[7]\" was removed from the weapon table", 4 + 8)
        else
            index = index + 1
        end
    end

    if weapons["RocketLauncher"] == false then
        local index = 8
        local ValueOfIndex = WEAPON_TABLE[index]
        if (ValueOfIndex == "weapons\\rocket launcher\\rocket launcher") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"RocketLauncher[8]\" was removed from the weapon table", 4 + 8)
        else
            index = index + 1
        end
    end

    if weapons["Shotgun"] == false then
        local index = 9
        local ValueOfIndex = WEAPON_TABLE[index]
        if (ValueOfIndex == "weapons\\shotgun\\shotgun") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"Shotgun[9]\" was removed from the weapon table", 4 + 8)
        else
            index = index + 1
        end
    end

    if weapons["SniperRifle"] == false then
        local index = 10
        local ValueOfIndex = WEAPON_TABLE[index]
        if (ValueOfIndex == "weapons\\sniper rifle\\sniper rifle") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            cprint("[SCRIPT] \"SniperRifle[10]\" was removed from the weapon table", 4 + 8)
        else
            index = index + 1
        end
    end
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    local victim = tonumber(VictimIndex)
    local killer = tonumber(KillerIndex)
    local victimName = tostring(get_var(victim, "$name"))
    local player_object = get_dynamic_player(victim)
    local xAxis, yAxis, zAxis = read_vector3d(player_object + 0x5C)
    VICTIM_LOCATION[victim][1] = xAxis
    VICTIM_LOCATION[victim][2] = yAxis
    VICTIM_LOCATION[victim][3] = zAxis
    if (killer == -1) then
        -- Global (no kills required): Weapons and Equipment
        if gamesettings["GlobalSettings"] and gamesettings["GlobalNoKills"] and gamesettings["WeaponsAndEquipment"] then
            WeaponsAndEquipment(victim, xAxis, yAxis, zAxis)
        end
        -- Global (no kills required): JustEquipment
        if gamesettings["GlobalSettings"] and gamesettings["GlobalNoKills"] and gamesettings["JustEquipment"] then
            JustEquipment(victim, xAxis, yAxis, zAxis)
        end
        -- Global (no kills required): JustWeapons
        if gamesettings["GlobalSettings"] and gamesettings["GlobalNoKills"] and gamesettings["JustWeapons"] then
            JustWeapons(victim, xAxis, yAxis, zAxis)
        end
    -- Global (kills required): Weapons and Equipment
    elseif gamesettings["GlobalSettings"] and gamesettings["GlobalKillsRequired"] and gamesettings["WeaponsAndEquipment"] then
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
    -- Global (kills required): JustEquipment
    elseif gamesettings["GlobalSettings"] and gamesettings["GlobalKillsRequired"] and gamesettings["JustEquipment"] then
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
    -- Global (kills required): JustWeapons
    elseif gamesettings["GlobalSettings"] and gamesettings["GlobalKillsRequired"] and gamesettings["JustWeapons"] then
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