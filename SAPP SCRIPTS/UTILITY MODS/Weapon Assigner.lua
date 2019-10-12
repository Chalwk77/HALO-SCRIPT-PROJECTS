--[[
--=====================================================================================================--
Script Name: Weapon Assigner (v1.0), for SAPP (PC & CE)

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local mod = {}
function mod:init()
    
    local weapon = mod:GetTag()
    
    mod.weapons = { 
    
        -- Set the weapon index to the corresponding tag number (see function mod:GetTag() on line 65)
        -- You can spawn with up to 4 weapons.
        -- Warning: The 4th slot is reserved for the objective (flag & oddball)
        -- If this slot is taken up, you wont be able to pick up the flag or oddball but you'll still spawn with 4 weapons.
        
        -- To disable a slot, set it to nil:
        -- Example: ["mymap"] = {weapon[1], nil, nil, nil},
        -- In the above example, you will only spawn with the pistol on the map "mymap"
        
        -- =========== [ STOCK MAPS ] =========== --
        -- PRIMARY | SECONDARY | TERTIARY | QUATERNARY
        ["beavercreek"] = { weapon[1], weapon[2], nil, nil},
        ["bloodgulch"] = { weapon[2], weapon[1], weapon[9], weapon[5]},
        ["boardingaction"] = { weapon[10], weapon[1], nil, nil},
        ["carousel"] = { weapon[2], weapon[1], weapon[10], nil},
        ["dangercanyon"] = { weapon[1], weapon[4], weapon[7], nil},
        ["deathisland"] = { weapon[2], weapon[1], weapon[7], nil},
        ["gephyrophobia"] = { weapon[2], weapon[1], weapon[4], nil},
        ["icefields"] = { weapon[1], weapon[7], nil, nil},
        ["infinity"] = { weapon[1], weapon[2], weapon[4], nil},
        ["sidewinder"] = { weapon[1], weapon[4], weapon[3], weapon[2]},
        ["timberland"] = { weapon[1], weapon[7], weapon[9], nil},
        ["hangemhigh"] = { weapon[1], weapon[10], nil, nil},
        ["ratrace"] = { weapon[7], weapon[1], nil, nil},
        ["damnation"] = { weapon[7], weapon[1], nil, nil},
        ["putput"] = { weapon[5], weapon[6], weapon[3], weapon[8]},
        ["prisoner"] = { weapon[1], weapon[4], nil, nil},
        ["wizard"] = { weapon[1], weapon[2], nil, nil},
       
        -- =========== [ CUSTOM MAPS ] =========== --
        ["bigassv2,104"] = {weapon[16], weapon[20], weapon[18], weapon[19]}, -- slot 1, dmr
        -- Repeat the structure to add more entries
        ["mapname"] = {weapon[0], weapon[0], weapon[0], weapon[0]},
    }
    
    

    --# Do Not Touch #--
    mod.players = { }
    mod.map = get_var(0, "$map")
    ----------------------------
end

function mod:GetTag()
    return {
    
        -- ============= [ STOCK WEAPONS ] ============= --
        [1] = "weapons\\pistol\\pistol",
        [2] = "weapons\\sniper rifle\\sniper rifle",
        [3] = "weapons\\plasma_cannon\\plasma_cannon",
        [4] = "weapons\\rocket launcher\\rocket launcher",
        [5] = "weapons\\plasma pistol\\plasma pistol",
        [6] = "weapons\\plasma rifle\\plasma rifle",
        [7] = "weapons\\assault rifle\\assault rifle",
        [8] = "weapons\\flamethrower\\flamethrower",
        [9] = "weapons\\needler\\mp_needler",
        [10] = "weapons\\shotgun\\shotgun",
        
        -- ============= [ CUSTOM WEAPONS ] ============= --
        
        -- Weapon indexes 11-30 belong to bigassv2,104
        [11] = "altis\\weapons\\binoculars\\binoculars",
        [12] = "altis\\weapons\\binoculars\\gauss spawner\\create gauss",
        [13] = "altis\\weapons\\smoke\\smoke",
        [14] = "bourrin\\halo reach\\vehicles\\warthog\\gauss\\gauss gun",
        [15] = "bourrin\\halo reach\\vehicles\\warthog\\rocket\\rocket",
        [16] = "bourrin\\weapons\\dmr\\dmr",
        [17] = "bourrin\\weapons\\ma5k\\cmt's ma5k reloaded",
        [18] = "bourrin\\weapons\\masternoob's assault rifle\\assault rifle",
        [19] = "cmt\\weapons\\human\\shotgun\\shotgun",
        [20] = "cmt\\weapons\\human\\stealth_sniper\\sniper rifle",
        [21] = "halo reach\\objects\\weapons\\support_high\\spartan_laser\\spartan laser",
        [22] = "halo3\\weapons\\odst pistol\\odst pistol",
        [23] = "my_weapons\\trip-mine\\trip-mine",
        [24] = "reach\\objects\\weapons\\pistol\\magnum\\magnum",
        [25] = "vehicles\\le_falcon\\weapon",
        [26] = "vehicles\\scorpion\\scorpion cannon_heat",
        [27] = "weapons\\ball\\ball",
        [28] = "weapons\\flag\\flag",
        [29] = "weapons\\gauss sniper\\gauss sniper",
        [30] = "weapons\\rocket launcher\\rocket launcher test",
        
        -- repeat the structure to add more weapon tags:
        [31] = "tag_goes_here",
    }
end

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    if (get_var(0, "$gt") ~= "n/a") then
        mod:init()
        for i = 1, 16 do
            if player_present(i) then
                mod:initPlayer(i, true)
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        mod:init()
    end
end

function OnGameEnd()
    for i = 1, 16 do
        if player_present(i) then
            mod:initPlayer(i, false)
        end
    end
end

function OnTick()
    for _,player in pairs(mod.players) do
        if (player.id) and player_alive(player.id) then
            if (player.assign) then
            
                local player_object = get_dynamic_player(player.id)
                local coords = mod:getXYZ(player.id, player_object)
                
                if (not coords.invehicle) then
                    player.assign = false
                    execute_command("wdel " .. player.id)
                    for Slot, Weapon in pairs(mod.weapons[mod.map]) do
                        if (Slot == 1 or Slot == 2) then
                            assign_weapon(spawn_object("weap", Weapon, coords.x, coords.y, coords.z), player.id)
                        elseif (Slot == 3 or Slot == 4) then
                            timer(250, "DelaySecQuat", player.id, Weapon, coords.x, coords.y, coords.z)
                        end
                    end
                end
            end
        end
    end
end

function OnPlayerSpawn(PlayerIndex)
    for _,player in pairs(mod.players) do
        if (player.id == PlayerIndex) then 
            player.assign = true 
        end
    end
end

function OnPlayerConnect(PlayerIndex)
    mod:initPlayer(PlayerIndex, true)
end

function OnPlayerDisconnect(PlayerIndex)
    mod:initPlayer(PlayerIndex, false)
end

function OnScriptUnload()
    --
end

function mod:initPlayer(PlayerIndex, Init)
    local players = mod.players
    if (Init) then
        players[#players + 1] = {
            id = tonumber(PlayerIndex),
            assign = false,
        }
    else
        for index,player in pairs(players) do
            if (player.id == PlayerIndex) then
                players[index] = nil
            end
        end
    end
end

function DelaySecQuat(PlayerIndex, Weapon, x, y, z)
    assign_weapon(spawn_object("weap", Weapon, x, y, z), PlayerIndex)
end

function mod:getXYZ(PlayerIndex, PlayerObject)
    local coords, x,y,z = { }
    
    local VehicleID = read_dword(PlayerObject + 0x11C)
    if (VehicleID == 0xFFFFFFFF) then
        coords.invehicle = false
        x, y, z = read_vector3d(PlayerObject + 0x5c)
    else
        coords.invehicle = true
        x, y, z  = read_vector3d(get_object_memory(VehicleID) + 0x5c)
    end
    
    if (coords.invehicle) then z = z + 1 end
    
    coords.x, coords.y, coords.z = x, y, z
    return coords
end
