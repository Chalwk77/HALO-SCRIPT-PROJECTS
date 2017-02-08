--[[
------------------------------------
Script Name: Halo CE: Custom Weapons, for SAPP
]]--

api_version = "1.11.0.0"
weapon = { }
weapons = { }

-- Default Weapons
-----------------------------------------------------------------
weapons[1] = "weapons\\pistol\\pistol"
weapons[2] = "weapons\\plasma_cannon\\plasma_cannon"
weapons[3] = "weapons\\rocket launcher\\rocket launcher"
weapons[4] = "weapons\\sniper rifle\\sniper rifle"
weapons[5] = "weapons\\plasma pistol\\plasma pistol"
weapons[6] = "weapons\\plasma rifle\\plasma rifle"
weapons[7] = "weapons\\assault rifle\\assault rifle"
weapons[8] = "weapons\\flamethrower\\flamethrower"
weapons[9] = "weapons\\needler\\mp_needler"
weapons[10] = "weapons\\pistol\\pistol"
weapons[11] = "weapons\\shotgun\\shotgun"
-----------------------------------------------------------------
-- Custom Weapons:
weapons[12] = "weapons\\m16\\m16" -- Dustbeta


function OnScriptLoad()
	register_callback(cb["EVENT_TICK"],"OnTick")
	register_callback(cb['EVENT_SPAWN'],"OnPlayerSpawn")
	register_callback(cb['EVENT_GAME_START'],"OnNewGame")
	register_callback(cb['EVENT_OBJECT_SPAWN'],"OnObjectSpawn")
	if get_var(0, "$gt") ~= "n/a" then
		GetMetaIDs()
        game_mode = get_var(0,"$mode")
        mapname = get_var(0,"$map")
	end	
end

function OnTick()
	for i = 1,16 do
		if (player_alive(i)) then
            local player = get_dynamic_player(i)
            if (weapon[i] == 0) then
                execute_command("wdel " .. i)
                local x,y,z = read_vector3d(player + 0x5C)
                -- *** [ SLAYER ] *** --
                if (game_mode == "game_mode_here") then -- Insert Gamemode here, i.e, fig_slayer
                    if (mapname == "dustbeta") then
                        assign_weapon(spawn_object("weap", weapons[1],x,y,z),i) -- Pistol
                        assign_weapon(spawn_object("weap", weapons[12],x,y,z),i) -- M16
                        weapon[i] = 1
                    elseif (mapname == "h2_momentum") then
                        assign_weapon(spawn_object("weap", weapons[1],x,y,z),i) -- Pistol
                        weapon[i] = 1
                    end
                end
                -- *** [ CAPTURE THE FLAG ] *** --
                if (game_mode == "game_mode_here") then -- Insert Gamemode here, i.e, fig_ctf
                    if (mapname == "MAP_NAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1],x,y,z),i) -- Change weapons[#] (number) to the corrosponding table# at the top
                        weapon[i] = 1
                    elseif (mapname == "MAP_NAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1],x,y,z),i) -- Pistol
                        weapon[i] = 1
                        -- repeat the structure to add more maps
                    end
                end
            end
        end
	end
end

function OnScriptUnload() 
    weapons = { }
	hud_item_messages = {}
	setup_hud_item_messages()
end

function OnPlayerSpawn(PlayerIndex)
	weapon[PlayerIndex] = 0
end

function OnNewGame()
    game_mode = get_var(0,"$mode")
    mapname = get_var(0,"$map")
    GetMetaIDs()
end

function get_tag_info(obj_type, obj_name)
	local tag_id = lookup_tag(obj_type, obj_name)
	return tag_id ~= 0 and read_dword(tag_id + 0xC) or nil
end	

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID)
    if MapID == weap_assault_rifle then
        return true, weap_sniper_rifle
    end
    if MapID == weap_plasma_pistol then 
        return true, weap_sniper_rifle
    end
    if MapID == weap_plasma_rifle then 
        return true, weap_sniper_rifle
    end
    if MapID == weap_flamer then 
        return true, weap_sniper_rifle
    end
    if MapID == weap_needler then 
        return true, weap_sniper_rifle
    end
    if MapID == weap_shotgun then 
        return true, weap_sniper_rifle
    end
    if MapID == weap_fuel_rod then
        return true, weap_sniper_rifle
    end
    if m16 == weap_fuel_rod then
        return true, weap_sniper_rifle
    end
end

function GetMetaIDs()
	m16 = read_dword(lookup_tag("weap", "weapons\\m16\\m16") + 12)
	weap_fuel_rod = read_dword(lookup_tag("weap", "weapons\\plasma_cannon\\plasma_cannon") + 12)
	weap_rocket_launcher = read_dword(lookup_tag("weap", "weapons\\rocket launcher\\rocket launcher") + 12)
	weap_sniper_rifle = read_dword(lookup_tag("weap", "weapons\\sniper rifle\\sniper rifle") + 12)
	weap_plasma_pistol = read_dword(lookup_tag("weap", "weapons\\plasma pistol\\plasma pistol") + 12)
	weap_plasma_rifle = read_dword(lookup_tag("weap", "weapons\\plasma rifle\\plasma rifle") + 12)
	weap_assault_rifle = read_dword(lookup_tag("weap", "weapons\\assault rifle\\assault rifle") + 12)
	weap_flamer = read_dword(lookup_tag("weap", "weapons\\flamethrower\\flamethrower") + 12)
	weap_needler = read_dword(lookup_tag("weap", "weapons\\needler\\mp_needler") + 12)
	weap_pistol = read_dword(lookup_tag("weap", "weapons\\pistol\\pistol") + 12)
	weap_shotgun = read_dword(lookup_tag("weap", "weapons\\shotgun\\shotgun") + 12)
end

function remove_from_string(String, Start)
    if(string.sub(String:lower(),1,string.len(Start)) == Start:lower()) then
        return string.sub(String, string.len(Start)+1)
    end
    return String
end

function get_weapon_name(MetaID)
    if (MetaID == 0xFFFFFFFF) then
        return "NULL METAID"
    else
        local weapon_tag = lookup_tag(MetaID)
        local weapon_data = read_dword(weapon_tag + 0x14)
        local message_index = read_short(weapon_data + 0x180)
        if (hud_item_messages[message_index] ~= nil) then
            return hud_item_messages[message_index]
        else
            return "<need a string entry here>"
        end
    end
end

function setup_hud_item_messages()
    local globals_tag = lookup_tag("matg", "globals\\globals")
    local globals_data = read_dword(globals_tag + 0x14)
    local interface_bitmaps_data = read_dword(globals_data + 0x144)
    local hud_globals_metaid = read_dword(interface_bitmaps_data + 0x6C)
    local hud_globals_tag = lookup_tag(hud_globals_metaid)
    local hud_globals_data = read_dword(hud_globals_tag + 0x14)
    local hud_item_messages_metaid = read_dword(hud_globals_data + 0xA0)
    local hud_item_messages_tag = lookup_tag(hud_item_messages_metaid)
    local hud_item_messages_data = read_dword(hud_item_messages_tag + 0x14)
    local string_references_count = read_dword(hud_item_messages_data)
    local string_references_data = read_dword(hud_item_messages_data + 0x4)
    hud_item_messages = {}
    for i=0,string_references_count-1 do
        local bytes = read_dword(string_references_data + i*20)
        local string_data = read_dword(string_references_data + i*20 + 0xC)
        local string = ''
        for j=0,bytes-3,2 do
            if(read_byte(string_data + j + 1) == 0) then
                string = string .. string.char(read_char(string_data + j))
            else
                string = string .. "?"
            end
        end
        string = string:gsub("\n", "")
        string = remove_from_string(string, "Picked up a ")
        string = remove_from_string(string, "Picked up an ")
        string = remove_from_string(string, "Picked up the ")
        string = remove_from_string(string, "Picked up ")
        string = string:gsub("^%l", string.upper)
        hud_item_messages[i] = string
    end
end
