--[[
    Script Name: HPC Killer Reward (rewrite), for SAPP
    - Implementing API version: 1.11.0.0


    [!]   **BETA**

    Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
    * Notice: You can use this document subject to the following conditions:
    https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

    * IGN: Chalwk
    * Written by Jericho Crosby
]]

api_version = "1.11.0.0"

-- Configuration --
-- Set 'true' to enable item drop 
Camouflage = true
HealthPack = false
OverShield = false
AssaultRifleAmmo = false
NeedlerAmmo = true
PistolAmmo = false
RocketLauncherAmmo = false
ShotgunAmmo = false
SniperRifleAmmo = false
FlameThrowerAmmo = false

AssaultRifle = false
FlameThrower = true
Needler = false
Pistol = false
PlasmaPistol = true
PlasmaRifle = false
PlasmaCannon = false
RocketLauncher = false
Shotgun = false
SniperRifle = false
-- Configuration Ends --

weap = "weap"
eqip = "eqip"
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
end

function OnScriptUnload() end

function OnNewGame()

    if not Camouflage then
        local index = 1
        local ValueOf = EQUIPMENT_TABLE[index]
        if (ValueOf == "powerups\\active camouflage") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            indexid = 1
            cprint("Camouflage was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not HealthPack then
        local index = 2
        local ValueOf = EQUIPMENT_TABLE[index]
        if (ValueOf == "powerups\\health pack") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            indexid = 2
            cprint("HealthPack was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not OverShield then
        local index = 3
        local ValueOf = EQUIPMENT_TABLE[index]
        if (ValueOf == "powerups\\over shield") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            indexid = 3
            cprint("OverShield was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not AssaultRifleAmmo then
        local index = 4
        local ValueOf = EQUIPMENT_TABLE[index]
        if (ValueOf == "powerups\\assault rifle ammo\\assault rifle ammo") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            indexid = 4
            cprint("AssaultRifleAmmo was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not NeedlerAmmo then
        local index = 5
        local ValueOf = EQUIPMENT_TABLE[index]
        if (ValueOf == "powerups\\needler ammo\\needler ammo") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            indexid = 5
            cprint("NeedlerAmmo was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not PistolAmmo then
        local index = 6
        local ValueOf = EQUIPMENT_TABLE[index]
        if (ValueOf == "powerups\\pistol ammo\\pistol ammo") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            indexid = 6
            cprint("PistolAmmo was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not RocketLauncherAmmo then
        local index = 7
        local ValueOf = EQUIPMENT_TABLE[index]
        if (ValueOf == "powerups\\rocket launcher ammo\\rocket launcher ammo") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            indexid = 7
            cprint("RocketLauncherAmmo was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not ShotgunAmmo then
        local index = 8
        local ValueOf = EQUIPMENT_TABLE[index]
        if (ValueOf == "powerups\\shotgun ammo\\shotgun ammo") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            indexid = 8
            cprint("ShotgunAmmo was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not SniperRifleAmmo then
        local index = 9
        local ValueOf = EQUIPMENT_TABLE[index]
        if (ValueOf == "powerups\\sniper rifle ammo\\sniper rifle ammo") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            indexid = 9
            cprint("SniperRifleAmmo was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not FlameThrowerAmmo then
        local index = 10
        local ValueOf = EQUIPMENT_TABLE[index]
        if (ValueOf == "powerups\\flamethrower ammo\\flamethrower ammo") then
            EQUIPMENT_TABLE[index] = EQUIPMENT_TABLE[index]
            EQUIPMENT_TABLE[index] = nil
            index = index - 1
            indexid = 10
            cprint("FlameThrowerAmmo was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not AssaultRifle then
        local index = 1
        local ValueOf = WEAPON_TABLE[index]
        if (ValueOf == "weapons\\assault rifle\\assault rifle") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            indexid = 1
            cprint("AssaultRifle was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not FlameThrower then
        local index = 2
        local ValueOf = WEAPON_TABLE[index]
        if (ValueOf == "weapons\\flamethrower\\flamethrower") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            indexid = 2
            cprint("FlameThrower was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not Needler then
        local index = 3
        local ValueOf = WEAPON_TABLE[index]
        if (ValueOf == "weapons\\needler\\mp_needler") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            indexid = 3
            cprint("Needler was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not Pistol then
        local index = 4
        local ValueOf = WEAPON_TABLE[index]
        if (ValueOf == "weapons\\pistol\\pistol") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            indexid = 4
            cprint("Pistol was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not PlasmaPistol then
        local index = 5
        local ValueOf = WEAPON_TABLE[index]
        if (ValueOf == "weapons\\plasma pistol\\plasma pistol") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            indexid = 5
            cprint("PlasmaPistol was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not PlasmaRifle then
        local index = 6
        local ValueOf = WEAPON_TABLE[index]
        if (ValueOf == "weapons\\plasma rifle\\plasma rifle") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            indexid = 6
            cprint("PlasmaRifle was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not PlasmaCannon then
        local index = 7
        local ValueOf = WEAPON_TABLE[index]
        if (ValueOf == "weapons\\plasma_cannon\\plasma_cannon") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            indexid = 7
            cprint("PlasmaCannon was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not RocketLauncher then
        local index = 8
        local ValueOf = WEAPON_TABLE[index]
        if (ValueOf == "weapons\\rocket launcher\\rocket launcher") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            indexid = 8
            cprint("RocketLauncher was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not Shotgun then
        local index = 9
        local ValueOf = WEAPON_TABLE[index]
        if (ValueOf == "weapons\\shotgun\\shotgun") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            indexid = 9
            cprint("Shotgun was removed!", 4 + 8)
        else
            index = index + 1
        end
    end

    if not SniperRifle then
        local index = 10
        local ValueOf = WEAPON_TABLE[index]
        if (ValueOf == "weapons\\sniper rifle\\sniper rifle") then
            WEAPON_TABLE[index] = WEAPON_TABLE[index]
            WEAPON_TABLE[index] = nil
            index = index - 1
            indexid = 10
            cprint("SniperRifle was removed!", 4 + 8)
        else
            index = index + 1
        end
    end
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    local victim = tonumber(VictimIndex)
    local killer = tonumber(KillerIndex)
    local player_object = get_dynamic_player(victim)
    if (killer == -1) then
        local x, y, z = read_vector3d(player_object + 0x5C)
        VICTIM_LOCATION[victim][1] = x
        VICTIM_LOCATION[victim][2] = y
        VICTIM_LOCATION[victim][3] = z
        math.randomseed(os.time())
        local itemtoDrop1 = EQUIPMENT_TABLE[math.random(1, #EQUIPMENT_TABLE - 1)]
        local itemtoDrop2 = WEAPON_TABLE[math.random(1, #WEAPON_TABLE - 1)]
        local player = get_player(victim)
        local rotation = read_float(player + 0x138)
        local eqTable = math.random(1, 2)
        if (tonumber(eqTable) == 1) then
            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
        elseif (tonumber(eqTable) == 2) then
            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
        end
    end
end

function OnError(Message)
    print(debug.traceback())
end
