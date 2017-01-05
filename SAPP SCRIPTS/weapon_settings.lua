api_version = "1.11.0.0"

weapons = { }
weapons[1] = "weapons\\pistol\\pistol"
weapons[2] = "weapons\\sniper rifle\\sniper rifle"
weapons[3] = "weapons\\assault rifle\\assault rifle"
weapons[4] = "revolution\\weapons\\pistol\\rev pistol"
weapons[5] = "revolution\\weapons\\sniper\\revolution sniper"
weapons[6] = "revolution\\weapons\\assault rifle\\revolution assault rifle"
weapons[7] = "revolution\\weapons\\battle rifle\\battle_rifle"

RewardTable = { }
RewardTable[1] = "weapons\\plasma_cannon\\plasma_cannon"
RewardTable[2] = "weapons\\rocket launcher\\rocket launcher"

weapon = {}
reward = {}
KILLS = { }

game_started = false
ConsecutiveDeaths = 10

function OnPlayerJoin(PlayerIndex)
    KILLS[PlayerIndex] = { 0 }
end
    
function OnPlayerLeave(PlayerIndex)
    KILLS[PlayerIndex] = { 0 }
end

function OnScriptLoad()
	register_callback(cb["EVENT_TICK"],"OnTick")
    -- register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    -- register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
	register_callback(cb['EVENT_SPAWN'],"OnPlayerSpawn")
	register_callback(cb['EVENT_GAME_START'],"OnNewGame")
	register_callback(cb['EVENT_GAME_END'],"OnGameEnd")
	register_callback(cb['EVENT_OBJECT_SPAWN'],"OnObjectSpawn")
    -- register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
	-- register_callback(cb['EVENT_WEAPON_PICKUP'], "OnWeaponPickup")
	if get_var(0, "$gt") ~= "n/a" then
		GetMetaIDs()
	end	
end

function OnScriptUnload() 
    weapons = { }
    RewardTable = { }
end

function OnNewGame()
    weapons = { }
    RewardTable = { }
    game_mode = get_var(0,"$mode")
	game_started = true
    if (game_mode == "c-elimination") then
        execute_command_sequence("w8 6; say * '1 Life, no shields, no grenades. Good luck!'")
    end
    GetMetaIDs()
end	

function OnNewGame()
    game_mode = get_var(0,"$mode")
    mapname = get_var(0,"$map")
	game_started = true
    GetMetaIDs()
end	

function OnGameEnd()
	game_started = false
    KILLS[PlayerIndex] = { 0 }
end

function OnPlayerSpawn(PlayerIndex)
	weapon[PlayerIndex] = 0
end

function get_tag_info(obj_type, obj_name)
	local tag_id = lookup_tag(obj_type, obj_name)
	return tag_id ~= 0 and read_dword(tag_id + 0xC) or nil
end	

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID) 
	if game_started then
        if (game_mode == "jc-c")then
            if MapID == weap_assault_rifle_metaid then
                return true, weap_sniper_rifle_metaid
            end
            if MapID == weap_plasma_pistol_metaid then 
                return true, weap_sniper_rifle_metaid
            end
            if MapID == weap_plasma_rifle_metaid then 
                return true, weap_sniper_rifle_metaid
            end
            if MapID == weap_flamer_metaid then 
                return true, weap_sniper_rifle_metaid
            end
            if MapID == weap_needler_metaid then 
                return true, weap_sniper_rifle_metaid
            end
            if MapID == weap_shotgun_metaid then 
                return true, weap_sniper_rifle_metaid
            end
        end
    end
end

function OnWeaponPickup(PlayerIndex, WeaponIndex, Type)
	if tonumber(Type) == 1 then
		local PlayerObj = get_dynamic_player(PlayerIndex)
		local WeaponObj = get_object_memory(read_dword(PlayerObj + 0x2F8 + (tonumber(WeaponIndex) - 1) * 4))
		local name = read_string(read_dword(read_word(WeaponObj) * 32 + 0x40440038))
		local MetaIndex = read_dword(WeaponObj)
        if MetaIndex == 0xE712059E or MetaIndex == 0xE63B04C7 then
            return false
        end
    end
    return true
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    local victim = tonumber(VictimIndex)
    local kills = tonumber(get_var(KillerIndex,"$kills"))
    local killer = tonumber(KillerIndex)
    if (killer > 0) then
        KILLS[killer][1] = KILLS[killer][1] + 1
        if (KILLS[killer][1] == nil) then KILLS[killer][1] = 0 
            elseif (KILLS[killer][1] == ConsecutiveDeaths) then
            KILLS[killer][1] = 0
            local player = get_dynamic_player(killer)
            local x,y,z = read_vector3d(player + 0x5C)
            assign_weapon(spawn_object("weap", RewardTable[1],x,y,z),killer)
            rprint(killer, "|cYou have reached: " ..kills.. " kills.")
            rprint(killer, "|cRewarded with Plasma Cannon")
            rprint(killer, "|c ")
            rprint(killer, "|c ")
            rprint(killer, "|c ")
        end
        -- if (kills == 2) then
            -- local player = get_dynamic_player(killer)
            -- local x,y,z = read_vector3d(player + 0x5C)
            -- assign_weapon(spawn_object("weap", RewardTable[2],x,y,z),killer)
            -- rprint(killer, "|cYou have reached: " ..kills.. " kills.")
            -- rprint(killer, "|cRewarded with Rocket Launcher")
            -- rprint(killer, "|c ")
            -- rprint(killer, "|c ")
            -- rprint(killer, "|c ")
        -- end
    end
end

function OnTick()
	for i = 1,16 do
		if(player_alive(i)) then
            if (game_mode == "jc-c") then
                local player = get_dynamic_player(i)
                if(weapon[i] == 0) then
                    execute_command("wdel " .. i)
                    local x,y,z = read_vector3d(player + 0x5C)
                    if (mapname == "bloodgulch") then
                        assign_weapon(spawn_object("weap", weapons[1],x,y,z),i)
                        assign_weapon(spawn_object("weap", weapons[2],x,y,z),i)
                        weapon[i] = 1
                    end
                end
            end
        end
	end
end

function GetMetaIDs()
	weap_fuel_rod_gun_metaid = read_dword(lookup_tag("weap", "weapons\\plasma_cannon\\plasma_cannon") + 12)
	weap_rocket_launcher_metaid = read_dword(lookup_tag("weap", "weapons\\rocket launcher\\rocket launcher") + 12)
	weap_sniper_rifle_metaid = read_dword(lookup_tag("weap", "weapons\\sniper rifle\\sniper rifle") + 12)
	weap_plasma_pistol_metaid = read_dword(lookup_tag("weap", "weapons\\plasma pistol\\plasma pistol") + 12)
	weap_plasma_rifle_metaid = read_dword(lookup_tag("weap", "weapons\\plasma rifle\\plasma rifle") + 12)
	weap_assault_rifle_metaid = read_dword(lookup_tag("weap", "weapons\\assault rifle\\assault rifle") + 12)
	weap_flamer_metaid = read_dword(lookup_tag("weap", "weapons\\flamethrower\\flamethrower") + 12)
	weap_needler_metaid = read_dword(lookup_tag("weap", "weapons\\needler\\mp_needler") + 12)
	weap_pistol_metaid = read_dword(lookup_tag("weap", "weapons\\pistol\\pistol") + 12)
	weap_shotgun_metaid = read_dword(lookup_tag("weap", "weapons\\shotgun\\shotgun") + 12)	
end
