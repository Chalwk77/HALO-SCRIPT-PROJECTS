--[[
------------------------------------
Script Name: HPC WeaponSettings, for SAPP
    - Implementing API version: 1.11.0.0

OZ-4 SDTM (Weapon Settings)

Copyright ©2016 Jericho Crosby <jericho.crosby227@gmail.com>

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

api_version = "1.11.0.0"
weapons = { }
weapons[1] = "weapons\\pistol\\pistol"
weapons[2] = "weapons\\sniper rifle\\sniper rifle"
weapons[3] = "weapons\\rocket launcher\\rocket launcher"
-- For a future update.
weapons[4] = "weapons\\plasma_cannon\\plasma_cannon"

weapon = { }
KILLS = { }
DEATHS = { }
dropped = { }

-- Game Settings.
ConsecutiveKills = 15
delay = 1000*15
plasma_count = 4
frag_count = 4

-- Kills in order of 10
_10_kills = 10
_20_kills = 20
_30_kills = 40
_40_kills = 30

function OnScriptLoad()
	register_callback(cb["EVENT_TICK"],"OnTick")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
	register_callback(cb['EVENT_SPAWN'],"OnPlayerSpawn")
	register_callback(cb['EVENT_GAME_START'],"OnNewGame")
	register_callback(cb['EVENT_GAME_END'],"OnGameEnd")
	register_callback(cb['EVENT_OBJECT_SPAWN'],"OnObjectSpawn")
    register_callback(cb['EVENT_DIE'], "OnPlayerKill")
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_COMMAND'],"OnServerCommand")
	if get_var(0, "$gt") ~= "n/a" then
		GetMetaIDs()
	end	
	--register_callback(cb['EVENT_WEAPON_PICKUP'], "OnWeaponPickup")
	--register_callback(cb['EVENT_WEAPON_DROP'], "OnWeaponDrop")
	--hud_item_messages = {}
	--setup_hud_item_messages()
	--flag_id = nil	
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
                        -- Assign Pistol and Sniper Rifle
                        assign_weapon(spawn_object("weap", weapons[1],x,y,z),i)
                        assign_weapon(spawn_object("weap", weapons[2],x,y,z),i)
                        weapon[i] = 1
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

function OnPlayerJoin(PlayerIndex)
    KILLS[PlayerIndex] = { 0 }
    DEATHS[PlayerIndex] = { 0 }
end

function OnPlayerSpawn(PlayerIndex)
	weapon[PlayerIndex] = 0
    KILLS[PlayerIndex][1] = 0
end
    
function OnPlayerLeave(PlayerIndex)
    KILLS[PlayerIndex] = { 0 }
    DEATHS[PlayerIndex] = { 0 }
end

function OnNewGame()
    game_mode = get_var(0,"$mode")
    mapname = get_var(0,"$map")
    GetMetaIDs()
end

function OnGameEnd(PlayerIndex)
    KILLS[PlayerIndex] = { 0 }
    DEATHS[PlayerIndex] = { 0 }
end

function OnServerCommand(PlayerIndex, Command)
    Command = string.lower(Command)
    -- >>
    -- Temporary Command
    if (Command == "!move") then
        local player_object = get_dynamic_player(PlayerIndex)
        if(player_object ~= 0) then
            write_vector3d(player_object + 0x5C, 23.010, -65.879, 1.693)
        end
        return false
    end
    -- <<
    if (Command == "stats") then
        rprint(PlayerIndex, "|cYou have "..KILLS[PlayerIndex][1].. "/"..ConsecutiveKills.." consecutive kills required to receive NUKE LAUNCHER.")
        rprint(PlayerIndex, "|cThe counter will reset when you die or when the timer runs out.")
        rprint(PlayerIndex, "|c")
        rprint(PlayerIndex, "|c")
        rprint(PlayerIndex, "|c")
        rprint(PlayerIndex, "|c")
        return false
    end
end
    
function OnPlayerChat(PlayerIndex, Message, type)
    local Message = string.lower(Message)
    if (Message == "/cancel ") or (Message == "\\cancel") then
        if player_alive(PlayerIndex) then
            local player = get_dynamic_player(PlayerIndex)
            execute_command("wdel " .. PlayerIndex)
            local x,y,z = read_vector3d(player + 0x5C)
            assign_weapon(spawn_object("weap", weapons[1],x,y,z+1,0.0),PlayerIndex)
            assign_weapon(spawn_object("weap", weapons[2],x,y,z+1,0.0),PlayerIndex)
            -- Setup grenades, (x of each).
            write_word(player + 0x31E, frag_count)
            write_word(player + 0x31F, plasma_count)
            rprint(PlayerIndex, "|cRETURNING TO NORMAL MODE")
        else
            rprint(PlayerIndex, "|cYou are dead, silly! Unable to complete request.")
        end
        return false
    end  
end

function AnnounceMessage(Message, P1, P2)
	for i=1,16 do
		if player_present(i) and (Message ~= nil) then
			if (P1 ~= i) and (P2 ~= i) then
				rprint(i, "|c " .. Message)
				break
			end
		end	
	end
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
end

function OnWeaponPickup(PlayerIndex, WeaponIndex, Type)
	if tonumber(Type) == 1 then
		if get_var(0, "$gt") ~= "n/a" then
			gametype = get_var(0, "$gt")
			flag_id = read_dword(read_dword(read_dword(lookup_tag("matg","globals\\globals") + 0x14) + 0x164 + 4) + 0x0 + 0xC)		
			local player_object = get_dynamic_player(PlayerIndex)
			local weapon_object = get_object_memory(read_dword(player_object + 0x2F8 + (tonumber(WeaponIndex) - 1) * 4))
			local MetaID = read_dword(weapon_object)
			local Objective
			if (gametype == "ctf") then
				Objective = flag_id
			end
			if (MetaID ~= nil) then
				local string_name = get_weapon_name(MetaID)
				if (MetaID == Objective) then
                    pickedup = true
				end
			end
		end
	end
end

flag = true
function OnWeaponDrop(PlayerIndex, WeaponSlot)
	local m_object = get_dynamic_player(PlayerIndex)
	if m_object then
		local weapon_address = get_object_memory(read_dword(m_object + 0x118))
		if weapon_address ~= 0 then
			local weapon_tag = lookup_tag(read_dword(weapon_address))
			if weapon_tag then
				local tag = read_string(read_dword(weapon_tag + 0x10))
				if tag == "weapons\\flag\\flag" then
					cprint("Working", 2+8)
                end
			end
		end
	end
    -- if get_var(0, "$gt") ~= "n/a" then
        -- gametype = get_var(0, "$gt")
        -- flag_id = read_dword(read_dword(read_dword(lookup_tag("matg","globals\\globals") + 0x14) + 0x164 + 4) + 0x0 + 0xC)		
        -- local player_object = get_dynamic_player(PlayerIndex)
        -- local weapon_object = get_object_memory(read_dword(player_object + 0x2F8 + (tonumber(WeaponSlot) - 1) * 4))
        -- local MetaID = read_dword(weapon_object)
        -- local Objective
        -- if (gametype == "ctf") then
            -- Objective = flag_id
        -- end
        -- if (MetaID == flag_id) then
            -- cprint("MetaID ~= nil", 4+8)
            -- --local string_name = get_weapon_name(MetaID)
            -- if (MetaID == Objective) then
                -- cprint("Dropped the flag!")
                -- pickedup = false
            -- end
        -- end
    -- end
    -- pickedup = false
end

function OnPlayerKill(VictimIndex, KillerIndex)
    victim = tonumber(VictimIndex)
    killer = tonumber(KillerIndex)
    kills = tonumber(get_var(KillerIndex,"$kills"))
    if (VictimIndex == killer) then
        -- Suicide - [reset kill-counter]
        KILLS[killer][1] = 0
        return false
    end
    if (killer == -1) then
        -- Killed by Server - [reset kill-counter]
        KILLS[victim][1] = 0
    end
    if (killer == 0) then
        -- Killed by vehicle - [reset kill-counter]
        KILLS[victim][1] = 0
    end
    if (killer > 0) then -- Killed by a player.
        KILLS[killer][1] = KILLS[killer][1] + 1
        
        DEATHS[victim][1] = DEATHS[victim][1] + 1
        
        rprint(victim, "|cNuke Launcher Kill-Counter Reset!")
        rprint(victim, "|cYou need " ..ConsecutiveKills.. " consecutive kills without dying.")
        -- >> Don't show Kill-Counter when they receive N-Launcher.
        -- Redundent, but necessary.
        if (KILLS[killer][1] == ConsecutiveKills) then -- do nothing 
        else
            rprint(killer, "|cNuke Launcher: "..KILLS[killer][1].. "/"..ConsecutiveKills)
        end
        -- <<
        
        if (KILLS[killer][1] == nil) then KILLS[PlayerIndex][1] = 0 
            elseif (KILLS[killer][1] == ConsecutiveKills) then
            GiveReward(killer)
            -- Reset kill-counter after being rewarded. Requires another 15 kills to receive reward.
            KILLS[killer][1] = 0
        end
    -- Consecutive kill threashold, in acending order of 10.
    -- For every 10 kills they have, award Plasma Cannon (Body Rocker). 
        -- if (kills == _10_kills) then
            -- GivePlasmaCannon(killer, victim)
        -- elseif (kills == _20_kills) then
            -- GivePlasmaCannon(killer, victim)
        -- elseif (kills == _30_kills) then
            -- GivePlasmaCannon(killer, victim)
        -- elseif (kills == _40_kills) then
            -- GivePlasmaCannon(killer, victim)
        -- end
    end
end

function GiveReward(killer, victim)
    if player_alive(killer) then
        local player = get_dynamic_player(killer)
        execute_command("wdel " .. killer)
        local x,y,z = read_vector3d(player + 0x5C)
        -- Rocket launcher
        assign_weapon(spawn_object("weap", weapons[3],x,y,z),killer)
        -- Remove grenades.
        write_word(player + 0x31E, 0)
        write_word(player + 0x31F, 0)
        rprint(killer, "|cYOU HAVE THE NUKE LAUNCHER")
        rprint(killer, "|cTIME TO WREAK HAVOC !!")
        rprint(killer, "|cType /cancel to return to normal mode")
        rprint(killer, "|cYou have the Nuke Launcher for 15 seconds")
        AnnounceMessage(get_var(killer, "$name") .. " HAS THE NUKE LAUNCHER", killer)
        AnnounceMessage("RUN FOR YOUR LIVES!", killer)
        timer(delay, "ResetWeapons", killer)
   else
        return false
   end
end

function GivePlasmaCannon(killer)
    if player_alive(killer) then
        local player = get_dynamic_player(killer)
        execute_command("wdel " .. killer)
        local x,y,z = read_vector3d(player + 0x5C)
        assign_weapon(spawn_object("weap", weapons[4],x,y,z),killer)
        write_word(player + 0x31E, 0)
        write_word(player + 0x31F, 0)
        rprint(killer, "|cYOU HAVE THE BODY ROCKER!")
        rprint(killer, "|cDESTROY THESE SON'S-OF-BITCHES.")
        rprint(killer, "|cType /cancel to return to normal mode")
        AnnounceMessage(get_var(killer, "$name") .. " HAS THE BODY ROCKER", killer)
        AnnounceMessage("SPILT, OR YOU'LL GET DESIMATED!", killer)
        timer(delay, "ResetWeapons", killer)
   else
        return false
   end
end

function ResetWeapons(killer)
    if player_alive(killer) then
        local player = get_dynamic_player(killer)
        execute_command("wdel " .. killer)
        local x,y,z = read_vector3d(player + 0x5C)
        assign_weapon(spawn_object("weap", weapons[1],x,y,z+1,0.0),killer)
        assign_weapon(spawn_object("weap", weapons[2],x,y,z+1,0.0),killer)
        write_word(player + 0x31E, plasma_count)
        write_word(player + 0x31F, frag_count)
        rprint(killer, "|cYOU NO LONGER HAVE THE NUKE LAUNCHER")
        rprint(killer, "|cRETURNING TO NORMAL MODE")
    end
end

function GetMetaIDs()
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
