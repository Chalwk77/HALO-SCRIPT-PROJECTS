-- Addresses and Offsets
-- Created by Wizard.
--!!!!WARNINGWARNINGWARNING!!!!
--!!!!WARNINGWARNINGWARNING!!!!
--!!!!WARNINGWARNINGWARNING!!!!
--DO NOT DOWNLOAD THIS SCRIPT. YOU SHOULD BE VISITING THIS PAGE WHENEVER YOU NEED AN OFFSET.
--THIS PAGE IS UPDATED FREQUENTLY, SO IF YOU DOWNLOAD THIS YOU WILL HAVE  AN  OUTDATED COPY.
--!!!!WARNINGWARNINGWARNING!!!!
--!!!!WARNINGWARNINGWARNING!!!!
--!!!!WARNINGWARNINGWARNING!!!!

function GetRequiredVersion()
	return 200
end

function OnScriptLoad(process, Game, persistent)

	GetGameAddresses(Game) -- declare addresses and confirm the game (pc or ce)
	game = Game
	-- gametype info

	local gametype_name = readwidestring(gametype_base, 0x2C) -- Confirmed. Real name of gametype.
	local gametype_game = readbyte(gametype_base + 0x30) -- Confirmed. (CTF = 1) (Slayer = 2) (Oddball = 3) (KOTH = 4) (Race = 5)
	local gametype_team_play = readbyte(gametype_base + 0x34) -- Confirmed. (Off = 0) (On = 1)
	--	gametype parameters
		local gametype_other_players_on_radar = readbit(gametype_base + 0x38, 0) -- Confirmed. (On = True, Off = False)
		local gametype_friends_indicator = readbit(gametype_base + 0x38, 1) -- Confirmed. (On = True, Off = False)
		local gametype_infinite_grenades = readbit(gametype_base + 0x38, 2) -- Confirmed. (On = True, Off = False)
		local gametype_shields = readbit(gametype_base + 0x38, 3) -- Confirmed. (Off = True, On = False)
		local gametype_invisible_players = readbit(gametype_base + 0x38, 4) -- Confirmed. (On = True, Off = False)
		local gametype_starting_equipment = readbit(gametype_base + 0x38, 5) -- Confirmed. (Generic = True, Custom = False)
		local gametype_only_friends_on_radar = readbit(gametype_base + 0x38, 6) -- Confirmed.
	--	unkBit[7] 0. - always 0
	local gametype_indicator = readbyte(gametype_base + 0x3C) -- Confirmed. (Motion Tracker = 0) (Nav Points = 1) (None = 2)
	local gametype_odd_man_out = readbyte(gametype_base + 0x40) -- Confirmed. (No = 0) (Yes = 1)
	local gametype_respawn_time_growth = readdword(gametype_base + 0x44) -- Confirmed. (1 sec = 30 ticks)
	local gametype_respawn_time = readdword(gametype_base + 0x48) -- Confirmed. (1 sec = 30 ticks)
	local gametype_suicide_penalty = readdword(gametype_base + 0x4C) -- Confirmed. (1 sec = 30 ticks)
	local gametype_lives = readbyte(gametype_base + 0x50) -- Confirmed. (Unlimited = 0)
	local gametype_maximum_health = readfloat(gametype_base + 0x54) -- Confirmed.
	local gametype_score_limit = readbyte(gametype_base + 0x58) -- Confirmed.
	local gametype_weapons = readbyte(gametype_base + 0x5C) -- Confirmed. (Normal = 0) (Pistols = 1) (Rifles = 2) (Plasma Weapons = 3) (Sniper = 4) (No Sniping = 5) (Rocket Launchers = 6) (Shotguns = 7) (Short Range = 8) (Human = 9) (Convenant = 10) (Classic = 11) (Heavy Weapons = 12)
	local gametype_red_vehicles = readdword(gametype_base + 0x60) -- () Binary
	local gametype_blue_vehicles = readdword(gametype_base + 0x64) -- () Binary
	local gametype_vehicle_respawn_time = readdword(gametype_base + 0x68) -- Confirmed. (1 sec = 30 ticks)
	local gametype_friendly_fire = readbyte(gametype_base + 0x6C) -- Confirmed. (Off = 0) (On = 1)
	local gametype_friendly_fire_penalty = readdword(gametype_base + 0x70) -- Confirmed. (1 sec = 30 ticks)
	local gametype_auto_team_balance = readbyte(gametype_base + 0x74) -- Confirmed. (Off = 0) (On = 1)
	local gametype_time_limit = readdword(gametype_base + 0x78) -- Confirmed. (1 sec = 30 ticks)
	local gametype_ctf_assault = readbyte(gametype_base + 0x7C) -- Confirmed. (No = 0) (Yes = 1)
		local gametype_koth_moving_hill = readbyte(gametype_base + 0x7C) -- Confirmed. (No = 0) (Yes = 1)
		local gametype_oddball_random_start = readbyte(gametype_base + 0x7C) -- Confirmed. (No = 0) (Yes = 1)
		local gametype_race_type = readbyte(gametype_base + 0x7C) -- Confirmed. (Normal = 0) (Any Order = 1) (Rally = 2)
		local gametype_slayer_death_bonus = readbyte(gametype_base + 0x7c) -- Confirmed. (Yes = 0) (No = 1)
	local gametype_slayer_kill_penalty = readbyte(gametype_base + 0x7D) -- Confirmed. (Yes = 0) (No = 1)
	local gametype_ctf_flag_must_reset = readbyte(gametype_base + 0x7E) -- Confirmed. (No = 0) (Yes = 1)
		local gametype_slayer_kill_in_order = readbyte(gametype_base + 0x7E) -- Confirmed. (No = 0) (Yes = 1)
	local gametype_ctf_flag_at_home_to_score = readbyte(gametype_base + 0x7F) -- Confirmed. (No = 0) (Yes = 1)
	local gametype_ctf_single_flag_time = readdword(gametype_base + 0x80) -- Confirmed. (1 sec = 30 ticks)
		local gametype_oddball_speed_with_ball = readbyte(gametype_base + 0x80) -- Confirmed. (Slow = 0) (Normal = 1) (Fast = 2)
		local gametype_race_team_scoring = readbyte(gametype_base + 0x80) -- Confirmed. (Minimum = 0) (Maximum = 1) (Sum = 2)
	local gametype_oddball_trait_with_ball = readbyte(gametype_base + 0x84) -- Confirmed. (None = 0) (Invisible = 1) (Extra Damage = 2) (Damage Resistant = 3)
	local gametype_oddball_trait_without_ball = readbyte(gametype_base + 0x88) -- Confirmed. (None = 0) (Invisible = 1) (Extra Damage = 2) (Damage Resistant = 3)
	local gametype_oddball_ball_type = readbyte(gametype_base + 0x8C) -- Confirmed. (Normal = 0) (Reverse Tag = 1) (Juggernaut = 2)
	local gametype_oddball_ball_spawn_count = readbyte(gametype_base + 0x90) -- Confirmed.
	
	--mapcycle header
	mapcycle_pointer = readdword(mapcycle_header) -- () index  0xA4 + 0xC + this = something.
	mapcycle_total_indicies = readdword(mapcycle_header + 0x4) -- From DZS. Number of options in the mapcycle.
	mapcycle_total_indicies_allocated = readdword(mapcycle_header + 0x8) -- From Phasor.
	mapcycle_current_index = readdword(mapcycle_header + 0xC) -- Confirmed. Current mapcycle index.
	
	--mapcycle struct
	mapcycle_something = readwidestring(mapcycle_pointer + mapcycle_current_index  0xE4 + 0xC) -- () LOTS OF BAADF00D!
	mapcycle_current_map_name = readstring(readdword(mapcycle_pointer)) -- Confirmed. Real name of the map.
	mapcycle_current_gametype_name = readstring(readdword(mapcycle_pointer + 0x4)) -- Confirmed. Real name of the gametype. Case-sensitive.
	mapcycle_current_gametype_name2 = readwidestring(mapcycle_pointer + 0xC) -- Confirmed. Real name of gametype. Case-sensitive.
	
	--Server globals
	server_initialized = readbit(network_server_globals, 0) -- Tested.
	server_last_display_time = readdword(network_server_globals + 0x4) -- From OS.
	server_password = readstring(network_server_globals + 0x8, 8) -- Confirmed.
	server_single_flag_force_reset = readbit(network_server_globals + 0x10, 0) -- Confirmed.
	server_banlist_path = readstring(network_server_globals + 0x1C) -- Confirmed. Path to the banlist file.
	server_friendly_fire_type = readword(network_server_globals + 0x120) -- Tested. Something to do with the friendly fire.
	server_rcon_password = readstring(network_server_globals + 0x128) -- Confirmed.
	if game == CE then
		server_motd_filename = readstring(network_server_globals + 0x13C, 0x100) -- From OS.
		server_motd_contents = readstring(network_server_globals + 0x23C, 0x100) -- From OS.
	end

	--gameinfo header
	gameinfo_base = readdword(gameinfo_header)
	--unkLong[1] 0x4 () Always 0
	--unkFloat[2] 0x8 ()
	--unkLong[9] 0x10 ()
	--unkFloat[2] 0x34 ()
	
	--gameinfo struct (someone should really help me with names lol)
	gameinfo_initialized = readbit(gameinfo_base, 0) -- Confirmed. If the game is started or in standby. (1 if started, 0 if not)
	gameinfo_active = readbit(gameinfo_base, 1) -- Confirmed. If the game is currently running (Active = True, Not Active = False)
	gameinfo_paused = readbit(gameinfo_base, 2) -- From OS.
	--Padding[2]
	--unkWord[3] ()
	gameinfo_time_passed = readdword(gameinfo_base + 0xC) -- Confirmed (1 second = 30 ticks)
	gameinfo_elapsed_time = readdword(gameinfo_base + 0x10) -- From OS.
	gameinfo_server_time = readdword(gameinfo_base + 0x14) -- Confirmed. Same as gameinfo_time_passed, except it lags behind.
	gameinfo_server_speed = readdword(gameinfo_base + 0x18) -- Confirmed. Changing this would be the same as cheatengining the server and messing with speedhack control.
	gameinfo_leftover_time = readdword(gameinfo_base + 0x1C) -- From OS. Not sure what this is. Changes frequently.
	--unkLong[39] 0x20 don't care enough to continue.
	
	--banlist header
	banlist_size = readdword(banlist_header)
	banlist_base = readdword(banlist_header + 0x4)
	
	--banlist struct
	banlist_struct_size = 0x44
	for j = 1,banlist_size do
		ban_name = readwidestring(banlist_base + j  0x44, 13) -- Confirmed. Name of banned player.
		ban_hash = readstring(banlist_base + j  0x44 + 0x1A, 32) -- Confirmed. Hash of banned player.
		ban_some_bool = readbit(banlist_base + j  0x44 + 0x3A, 0) -- ()
		ban_count = readword(banlist_base + j  0x44 + 0x3C) -- Confirmed. How many times the specified player has been banned.
		ban_indefinitely = readbit(banlist_base + j  0x44 + 0x3E, 0) -- Confirmed. 1 if permanently banned, 0 if not.
		ban_time = readdword(banlist_base + j  0x44 + 0x40) -- Confirmed. Ban end date.
	end
	
	--Stringdata addresses that aren't in a structheader (to my knowledge).
	server_broadcast_version = readstring(broadcast_version_address) -- Confirmed. Version that the server is broadcasting on.
	version_info = readstring(version_info_address, 0x2A) -- Confirmed. Some version info for halo
	halo_broadcast_game = readstring(broadcast_game_address, 5) -- Confirmed. Basically determines whether the server will broadcast on PCCETrial (halor = PC, halom = CE, halo = Trial).
	server_port = readdword(server_port_address) -- Confirmed. Port that the server is broadcasting on.
	server_path = readstring(server_path_address) -- Confirmed. Path to the server's haloded.exe
	server_computer_name = readstring(computer_name_address) -- Confirmed. Server Computer (domain) name.
	profile_path = readstring(profile_path_address) -- Confirmed. Path to the profile path.
	map_name = readwidestring(map_name_address) -- Confirmed. Halo's map name (e.g. Blood Gulch)
	computer_specs = readstring(computer_specs_address) -- Confirmed. Some address I found that stores information about the server (processor speed, brand)
	map_name2 = readstring(map_name_address2) -- Confirmed. Map file name. (e.g. bloodgulch)
	server_password = readstring(server_password_address, 8) -- Confirmed. Current server password for the server (will be nullstring if there is no password)
	banlist_path = readstring(banlist_path_address) -- Confirmed. Path to the banlist file.
	rcon_password = readstring(rcon_password_address, 8) -- Confirmed. Current rcon password for the server.
	
	-- random unuseful crap (string stuff) don't care enough to do CE
	-- don't know why I even cared enough to write these down.
	if game == PC then
		halo_profilepath_cmdline = readstring(0x5D45B0, 5) -- Confirmed. The -path cmdline string.
		halo_cpu_cmdline = readstring(0x5E4760, 4) -- Confirmed. The -cpu cmdline string.
		halo_broadcast_game = readstring(0x5E4768, 5) -- Confirmed. Basically determines whether the server will broadcast on PCCETrial (halor = PC, halom = CE, halo = Trial).
		halo_ip_cmdline = readstring(0x5E4770, 3) -- Confirmed. The -ip cmdline string.
		halo_port_cmdline = readstring(0x5E4774, 5) -- Confirmed. The -port cmdline string.
		halo_checkfpu_cmdline = readstring(0x5E477C, 9) -- Confirmed. The -checkfpu cmdline string.
		halo_windowname = readstring(0x5E4788, 4) -- The console windowname and classname (basically windowtitle, always 'Halo Console (#)').
		--0x5E4790 - 0x5E473C is registry key stuff
		halo_dw15_exe_path = readstring(0x5E4940, 26) --Confirmed. Path to dw15.exe (.Watsondw15.exe -x -s %u) probably from client code.
		--other random crapstrings here
	end

end

-- All of these are confirmed, unless said otherwise.
function GetGameAddresses(game)

	if game == PC then
		-- StructsHeaders.
		stats_header = 0x639720
		stats_globals = 0x639898
		ctf_globals = 0x639B98
		slayer_globals = 0x63A0E8
		oddball_globals = 0x639E58
		koth_globals = 0x639BD0
		race_globals = 0x639FA0
		race_locs = 0x670F40
		map_pointer = 0x63525C
		gametype_base = 0x671340
		network_struct = 0x745BA0
		camera_base = 0x69C2F8
		player_header_pointer = 0x75ECE4
		obj_header_pointer = 0x744C18
		collideable_objects_pointer = 0x744C34
		map_header_base = 0x630E74
		banlist_header = 0x641280
		game_globals =  -- () Why do I not have this for PC
		gameinfo_header = 0x671420
		mapcycle_header = 0x614B4C
		network_server_globals = 0x69B934
		flags_pointer = 0x6A590C
		hash_table_base = 0x6A2AE4
		
		-- StringData Addresses.
		broadcast_version_address = 0x5DF840
		version_info_address = 0x5E02C0
		broadcast_game_address = 0x5E4768
		server_port_address = 0x625230
		server_path_address = 0x62C390
		computer_name_address = 0x62CD60
		profile_path_address = 0x635610
		map_name_address = 0x63BC78
		computer_specs_address = 0x662D04
		map_name_address2 = 0x698F21
		server_password_address = 0x69B93C
		banlist_path_address = 0x69B950
		rcon_password_address = 0x69BA5C

		--Patches
		gametype_patch = 0x481F3C -- I 'thought' this worked but haven't tested in ages.
		hashcheck_patch = 0x59c280
		servername_patch = 0x517D6B
		versioncheck_patch = 0x5152E7
	else
		-- Structsheaders.
		stats_header = 0x5BD740
		stats_globals = 0x5BD8B8
		ctf_globals = 0x5BDBB8
		slayer_globals = 0x5BE108
		oddball_globals = 0x5BDE78
		koth_globals = 0x5BDBF0
		race_globals = 0x5BDFC0
		race_locs = 0x5F5098
		map_pointer = 0x5B927C
		gametype_base = 0x5F5498
		network_struct = 0x6C7980
		camera_base = 0x62075C
		player_globals = 0x6E1478 -- From OS.
		player_header_pointer = 0x6E1480
		obj_header_pointer = 0x6C69F0
		collideable_objects_pointer = 0x6C6A14
		map_header_base = 0x6E2CA4
		banlist_header = 0x5C52A0
		game_globals = 0x61CFE0 -- ()
		gameinfo_header = 0x5F55BC
		mapcycle_header = 0x598A8C
		network_server_globals = 0x61FB64
		hash_table_base = 0x5AFB34
		
		-- StringData Addresses.
		broadcast_version_address = 0x564B34
		version_info_address = 0x565104
		broadcast_game_address = 0x569EAC
		server_port_address = 0x5A91A0
		server_path_address = 0x5B0670
		computer_name_address = 0x5B0D40
		profile_path_address = 0x5B9630
		map_name_address = 0x5BFC98
		computer_specs_address = 0x5E6E5C
		map_name_address2 = 0x61D151
		server_password_address = 0x61FB6C
		banlist_path_address = 0x61FB80
		rcon_password_address = 0x61FC8C
		

		--Patches
		hashcheck_patch = 0x530130
		servername_patch = 0x4CE0CD
		versioncheck_patch = 0x4CB587
	end
end

function OnScriptUnload()

end

function OnNewGame(map)
	Map = map
	--Patches
	writeword(servername_patch, 0x9090) -- Allows special characters in server name. Pretty useless now that Phasor does this automatically.
	writebyte(hashcheck_patch, 0xEB) -- Disables Halo's hash check (0x74 to reenable) COMPLETELY USELESS NOW THAT GAMESPY IS DOWN.
	writebyte(versioncheck_patch, 0xEB) -- Disables Halo's version check (0x7D to reenable) COMPLETELY USELESS NOW THAT GAMESPY IS DOWN.
end

function OnDamageApplication(receiving_obj, causing_obj, mapId, hitdata, backtap)

end

function OnDamageLookup(receiving_obj, causing_obj, mapId, tagdata)
	-- REMEMBER. ANYTHING WRITTEN TO TAGDATA IS PERMANANT UNTIL THE MAP RESETS.
	-- MAKE SURE IF YOU'RE WRITING TO TAGDATA YOU REMEMBER TO RESET IT AFTERWARDS (like with a timer) UNLESS YOU WANT IT TO BE PERMANENT
	-- If you do want the change to be permanent, you most likely don't want to do it here. Do it OnNewGame.
	
	-- In reality, a majority of these should be for reading only.
	-- jpt! tagdata struct.
	dmg_radius_from = readfloat(tagdata + 0x0) -- From Sparky's Plugins. In world units.
	dmg_radius_to = readfloat(tagdata + 0x4) -- From Sparky's Plugins. In world units.
	dmg_cutoff_scale = readfloat(tagdata + 0x8) -- From Sparky's Plugins. 0 - 1 only
	--	bitmask16
	--	bitPadding[15] 0-14
		dmg_dont_scale_damage_by_distance = readbit(tagdata + 0x0C, 15) -- From Sparky's Plugins
	--jpt! Screen Flash.png
	dmg_screen_flash_type = readword(tagdata + 0x24) -- From Sparky's Plugins. Probably doesn't sync. (None = 0, Lighten = 1, Darken = 2, Maximum = 3, Minimum = 4, Invert = 5, Tint = 6)
	dmg_screen_flash_priority = readword(tagdata + 0x26) -- From Sparky's Plugins. (Low = 0, Medium = 1, High = 2)
	dmg_screen_flash_duration = readfloat(tagdata + 0x34) -- From Sparky's Plugins.
	--Padding[2] 0x36
	dmg_screen_flash_fade_function = readword(tagdata + 0x38) -- From Sparky's Plugins. (Linear = 0, Early = 1, Very Early = 2, Late = 3, Very Late = 4, Cosine = 5)
	--Padding[10] 0x3A
	dmg_screen_flash_maximum_intensity = readfloat(tagdata + 0x44) -- From Sparky's Plugins. 0 - 1 only.
	dmg_screen_flash_colors = readColorARGB(tagdata + 0x48) -- From Sparky's Plugins.
	dmg_low_frequency_vibrate_frequency = readfloat(tagdata + 0x5C) -- From Sparky's Plugins. 0 - 1 only.
	dmg_low_frequency_vibrate_duration = readfloat(tagdata + 0x60) -- From Sparky's Plugins. In seconds.
	dmg_low_frequency_fade_function = readword(tagdata + 0x64) -- From Sparky's Plugins. (Linear = 0, Early = 1, Very Early = 2, Late = 3, Very Late = 4, Cosine = 5)
	--Padding[2] 0x66
	dmg_high_frequency_vibrate_frequency = readfloat(tagdata + 0x68) -- From Sparky's Plugins. 0 - 1 only.
	dmg_high_frequency_vibrate_duration = readfloat(tagdata + 0x6C) -- From Sparky's Plugins. In seconds.
	dmg_high_frequency_fade_function = readword(tagdata + 0x70) -- From Sparky's Plugins. (Linear = 0, Early = 1, Very Early = 2, Late = 3, Very Late = 4, Cosine = 5)
	--Padding[0x26] 0x72
	dmg_temporary_camera_impulse_duration = readfloat(tagdata + 0x98) -- From Sparky's Plugins. Wait... impulsive cameras
	dmg_temporary_camera_impulse_fadefunction = readword(tagdata + 0x9C) -- From Sparky's Plugins. (Linear = 0, Early = 1, Very Early = 2, Late = 3, Very Late = 4, Cosine = 5)
	dmg_temporary_camera_impulse_rotation = readfloat(tagdata + 0xA0) -- From Sparky's Plugins. In radians.
	dmg_temporary_camera_impulse_pushback = readfloat(tagdata + 0xA4) -- From Sparky's Plugins. In world units.
	dmg_temporary_camera_impulse_jitter_from = readfloat(tagdata + 0xA8) -- From Sparky's Plugins. In world units.
	dmg_temporary_camera_impulse_jitter_to = readfloat(tagdata + 0xAC) -- From Sparky's Plugins. In world units.
	--Padding[8]
	dmg_permanent_camera_impulse_angle = readfloat(tagdata + 0xB8) -- From Sparky's Plugins. In radians.
	--Padding[16]
	dmg_camera_shaking_duration = readfloat(tagdata + 0xCC)
	dmg_camera_shaking_falloff_function = readword(tagdata + 0xD0) -- From Sparky's Plugins. (Linear = 0, Early = 1, Very Early = 2, Late = 3, Very Late = 4, Cosine = 5)
	--Padding[2]
	dmg_camera_shaking_random_translation = readfloat(tagdata + 0xD4) -- From Sparky's Plugins. In world units, in all directions
	dmg_camera_shaking_random_rotation = readfloat(tagdata + 0xD8) -- From Sparky's Plugins. In radians, in all directions.
	--Padding[12] 0xDC-0xE8
	dmg_camera_shaking_wobble_function = readword(tagdata + 0xE8) -- From Sparky's Plugins. Perturbs the effect's behavior over time. (One = 0, Zero = 1, Cosine = 2, Cosine (variable period) = 3, Diagonal Wave = 4, Diagonal Wave (variable period) = 5, Slide = 6, , Slide (variable period) = 7, Noise = 8, Jitter = 9, Wander = 10, Spark = 11)
	--Padding[2] 0xEA-0xEC
	dmg_camera_shaking_wobble_function_period = readfloat(tagdata + 0xEC) -- From Sparky's Plugins. (1 sec = 30 ticks)
	dmg_camera_shaking_wobble_weight = readfloat(tagdata + 0xF0) -- From Sparky's Plugins. 0.0 = wobble function has no effect; 1.0 = effect will not be felt when the wobble function's value is zero
	--Padding[32] 0xF4-0x114
	dmg_sound_tagtype = readstring(tagdata + 0x114, 4) -- From Sparky's Plugins. (changing this does nothing)
	dmg_sound_tagname_address = readdword(tagdata + 0x118) -- From Sparky's Plugins. (changing this does nothing)
		dmg_sound_tagname = readstring(dmg_sound_tagname_address) -- (DO NOT CHANGE)
	--Padding[4]
	dmg_sound_mapId = readdword(tagdata + 0x11C) -- From Sparky's Plugins.
	--Padding[116] 0x120-0x194
	dmg_breaking_effect_forward_velocity = readfloat(tagdata + 0x194) -- From Sparky's Plugins. In world units per second.
	dmg_breaking_effect_forward_radius = readfloat(tagdata + 0x198) -- From Sparky's Plugins. In world units.
	dmg_breaking_effect_forward_exponent = readfloat(tagdata + 0x19C) -- From Sparky's Plugins.
	dmg_breaking_effect_outward_velocity = readfloat(tagdata + 0x1A0) -- From Sparky's Plugins. In world units per second.
	dmg_breaking_effect_outward_radius = readfloat(tagdata + 0x1A4) -- From Sparky's Plugins. In world units.
	dmg_breaking_effect_outward_exponent = readfloat(tagdata + 0x1A8) -- From Sparky's Plugins.
	--Padding[18] 0x1AC-0x1C4
	dmg_side_effect = readword(tagdata + 0x1C4) -- From Sparky's Plugins. (None = 0, Harmless = 1, Lethal to the Unsuspecting = 2, EMP = 3)
	dmg_damage_category = readword(tagdata + 0x1C6) -- From Sparky's Plugins. (None = 0, Falling = 1, Bullet = 2, Grenade = 3, High Explosive = 4, Sniper = 5, Melee = 6, Flame = 7, Mounted Weapon = 8, Vehicle = 9)
	--	damage flags bitmask16
		dmg_does_not_hurt_owner = readbit(tagdata + 0x1C8, 0) -- From Sparky's Plugins.
		dmg_can_cause_headshots = readbit(tagdata + 0x1C8, 1) -- From Sparky's Plugins.
		dmg_pings_resistent_units = readbit(tagdata + 0x1C8, 2) -- From Sparky's Plugins.
		dmg_does_not_hurt_friends = readbit(tagdata + 0x1C8, 3) -- From Sparky's Plugins.
		dmg_does_not_ping_units = readbit(tagdata + 0x1C8, 4) -- From Sparky's Plugins.
		dmg_detonates_explosives = readbit(tagdata + 0x1C8, 5) -- From Sparky's Plugins.
		dmg_only_hurts_shields = readbit(tagdata + 0x1C8, 6) -- From Sparky's Plugins.
		dmg_causes_flaming_death = readbit(tagdata + 0x1C8, 7) -- From Sparky's Plugins.
		dmg_damage_indicators_always_point_down = readbit(tagdata + 0x1C8, 8) -- From Sparky's Plugins.
		dmg_skips_shields = readbit(tagdata + 0x1C8, 9) -- From Sparky's Plugins.
		dmg_only_hurts_one_infection_form = readbit(tagdata + 0x1C8, 10) -- From Sparky's Plugins.
		dmg_can_cause_multiplayer_headshots = readbit(tagdata + 0x1C8, 11) -- From Sparky's Plugins.
		dmg_infection_form_pop = readbit(tagdata + 0x1C8, 12) -- From Sparky's Plugins.
	--Padding[2] 0x1CA-0x1CC
	dmg_aoe_core_radius = readfloat(tagdata + 0x1CC) -- From Sparky's Plugins. if this is an area of effect damage type; (AOE = area of effect, not Age of Empires P)
	dmg_min_dmg = readfloat(tagdata + 0x1D0) -- Confirmed. The minimum amount of damage that can be done.
	dmg_max_min = readfloat(tagdata + 0x1D4) -- Confirmed. The minimum amount of damage that can be done at the maximum damage.
	dmg_max_max = readfloat(tagdata + 0x1D8) -- Confirmed. The maximum amount of damage causer can damage.
	dmg_vehicle_passthrough_penalty = readfloat(tagdata + 0x1DC) -- From Sparky's Plugins. (0-1 only). 0 damages passengers in vehicles; 1 does not.
	dmg_active_camouflage_damage = readfloat(tagdata + 0x1E0) -- From Sparky's Plugins. (0-1 only). how much more visible this makes a player who is active camouflaged.
	dmg_stun = readfloat(tagdata + 0x1E4) -- From Sparky's Plugins. (0-1 only). amount of stun added to damaged object.
	dmg_maximum_stun = readfloat(tagdata + 0x1E8) -- From Sparky's Plugins. (0-1 only). damaged object's stun will never exceed this amount; also check the matg Globals tag value!
	dmg_stun_time = readfloat(tagdata + 0x1EC) -- From Sparky's Plugins. (0-1 only). duration of stun due to this damage.
	--Padding[4] 0x1F0-0x1F4
	dmg_force_amount = readfloat(tagdata + 0x1F4) -- From Sparky's Plugins. (0 through infinity).
	
	--TONS OF DAMAGE MODIFIERS RELATING TO MATERIALS HERE. SCREW IT FOR NOW. OTHERWISE THIS IS COMPLETE.
end

function readColorARGB(address, offset)
	address = address + (offset or 0x0)
	local colors = {}
	colors.alpha = readfloat(address + 0x0) --Also known as transparency.
	colors.red = readfloat(address + 0x4)
	colors.green = readfloat(address + 0x8)
	colors.blue = readfloat(address + 0xC)
	return colors
end

function readcolorrgb(address, offset)
	address = address + (offset or 0x0)
	red = readfloat(address + 0x0)
	green = readfloat(address + 0x4)
	blue = readfloat(address + 0x8)
	return red, blue, green
end

function OnClientUpdate(player, m_objectId)

	local thisHash = gethash(player)
	local team = getteam(player)

	if thisHash ~= nil then

		-- Confirmedtested addresses and offsets
		-- teams red = 0, blue = 1
		
		--stats header (size = 0x178 = 376 bytes)
		--This header is seriously unfinished.
		stats_header_recorded_animations_data = readdword(stats_header + 0x0) -- Confirmed. Pointer to Recorded Animations data table.
		--unkByte[4] 0x4-0x8 (Zero's)
		stats_header_last_decal_location_x = readfloat(stats_header + 0x8) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_y = readfloat(stats_header + 0xC) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_x2 = readfloat(stats_header + 0x10) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_y2 = readfloat(stats_header + 0x14) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_x3 = readfloat(stats_header + 0x18) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_y3 = readfloat(stats_header + 0x1C) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_x4 = readfloat(stats_header + 0x20) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_y4 = readfloat(stats_header + 0x24) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_x5 = readfloat(stats_header + 0x28) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_y5 = readfloat(stats_header + 0x2C) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_x6 = readfloat(stats_header + 0x30) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_y6 = readfloat(stats_header + 0x34) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		--unkByte[48] 0x38-0x68 (Zero's)
		stats_header_last_decal_location2_x = readfloat(stats_header + 0x68) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_y = readfloat(stats_header + 0x6C) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_x2 = readfloat(stats_header + 0x70) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_y2 = readfloat(stats_header + 0x74) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_x3 = readfloat(stats_header + 0x78) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_y3 = readfloat(stats_header + 0x7C) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_x4 = readfloat(stats_header + 0x80) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_y4 = readfloat(stats_header + 0x84) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_x5 = readfloat(stats_header + 0x88) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_y5 = readfloat(stats_header + 0x8C) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_x6 = readfloat(stats_header + 0x90) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_y6 = readfloat(stats_header + 0x94) -- From Silentk. World coordinates of the last bulletnade hit anywhere on map x,y, applies to BSP only, not objects
		--unkFloat[2] 0x98-0xA0 ()
		--unkByte[40] 0xA0-0xC8 (Zero's)
		stats_header_decalID_table = readdword(stats_header + 0xC8) -- From Silentk. Pointer to an array of Decal ID's (correlates with LastDecalLocation)
		--unkPointer[1] 0xCC-0xD0 ()
		--unkByte[20] 0xD0-0xE4 ()
		stats_header_locationID = readdword(stats_header + 0xE4) -- From Silentk
		stats_header_locationID2 = readdword(stats_header + 0xE8) -- From Silentk
		--unkLong[1] 0xEC-0xF0 ()
		--unkByte[130] 0xF0-0x172 (Zero's)
		--unkPointer[2] 0x172-0x17A
		
		--stats struct (size = 0x30 = 48 bytes)
		stats_base = stats_globals + player0x30
		stats_player_ingame = readbyte(stats_base + 0x0) -- From Silentk (1 = Ingame, 0 if not)
		--unkByte[3] 0x1-0x4 ()
		stats_player_id = readident(stats_base, 0x4) --Confirmed. Full DWORD ID of player.
		stats_player_kills = readword(stats_base + 0x8) -- Confirmed.
		--unkByte[6] 0xA-0x10 ()
		stats_player_assists = readword(stats_base + 0x10) -- From Silentk
		--unkByte[6] 0x12-0x18 ()
		stats_player_betrays = readword(stats_base + 0x18) -- From Silentk. Actually betrays + suicides.
		stats_player_deaths = readword(stats_base + 0x1A) -- From Silentk Everytime you die, no matter what..
		stats_player_suicides = readword(stats_base + 0x1C) -- Confirmed.
		stats_player_flag_steals = readword(stats_base + 0x1E) -- From Silentk. Flag steals for CTF.
			stats_player_hill_time = readword(stats_base + 0x1E) -- Confirmed. Time for KOTH. (1 sec = 30 ticks)
			stats_player_race_time = readword(stats_base + 0x1E) -- Guess. Time for Race. (1 sec = 30 ticks)
		stats_player_flag_returns = readword(stats_base + 0x20) -- From Silentk. Flag returns for CTF.
			stats_player_oddball_target_kills = readword(stats_base + 0x20) -- Guess. Number of times you killed the Juggernaut or It.
			stats_player_race_laps = readword(stats_base + 0x20) -- Guess. Laps for Race.
		stats_player_flag_scores = readword(stats_base + 0x22) -- From Silentk. Flag scores for CTF.
			stats_player_oddball_kills = readword(stats_base + 0x22) -- Guess. Number of kills you have as Juggernaut or It.
			stats_player_race_best_time = readword(stats_base + 0x22) -- Guess. Best time for Race. (1 sec = 30 ticks)
		--unkByte[12] 0x24-0x30 ()

		-- ctf globals (size = 0x34 = 52 bytes)
		ctf_flag_coords_pointer = readdword(ctf_globals + team4) -- Confirmed. Pointer to the coords where the flag respawns.
			ctf_flag_x_coord = readfloat(ctf_flag_coords_pointer) -- Confirmed.
			ctf_flag_y_coord = readfloat(ctf_flag_coords_pointer + 0x4) -- Confirmed.
			ctf_flag_z_coord = readfloat(ctf_flag_coords_pointer + 0x8) -- Confirmed.
		ctf_flag_object_id = readident(ctf_globals + team4 + 0x8) -- Confirmed.
		ctf_team_score = readdword(ctf_globals + team4 + 0x10) -- Confirmed.
		ctf_score_limit = readdword(ctf_globals + 0x18) -- Confirmed.
		ctf_team_missing_flag_bool = readbit(ctf_globals + 0x1C+team, 0) -- Confirmed. (True if team doesn't have flag, False if their flag is at home)
		ctf_flag_istaken_red_soundtimer = readdword(ctf_globals + 0x20) -- Confirmed. (Announcer repeats 'Red team, has the flag' after this number gets to 600 ticks = 20 seconds)
		ctf_flag_istaken_blue_soundtimer = readdword(ctf_globals + 0x24) -- Confirmed. (Announcer repeats 'Blue team, has the flag' after this number gets to 600 ticks = 20 seconds)
		ctf_flag_swap_timer = readdword(ctf_globals + 0x28) -- Confirmed. Single flag only. Counts down until 0, then offense team swaps with defense team. (1 second = 30 ticks)
		ctf_failure_timer = readdword(ctf_globals + 0x2C)-- From OS. Sound timer for failure. Counts down until 0. (1 second = 30 ticks)
		ctf_team_on_defense = readbyte(ctf_globals + 0x30) -- Confirmed. Team on defense (single flag gametypes) (Red = 0, Blue = 1)

		--koth globals (size = 0x200 = 512 bytes)
		--Reminder There are 16 teams in FFA, one for each person.
		koth_team_score = readdword(koth_globals + team4) -- Confirmed. (1 second = 30 ticks)
		koth_team_last_time_in_hill = readdword(koth_globals + player4 + 0x40) -- Confirmed. gameinfo_current_time - this = time since team was last in the hill. (1 sec = 30 ticks)
		koth_player_in_hill = readbyte(koth_globals + player + 0x80) -- Confirmed. (1 if in hill, 0 if not)
		koth_hill_marker_count = readdword(koth_globals + 0x90) -- Confirmed. Number of hill markers.
		--These are coordinates for each hill marker
		for i = 0,koth_hill_marker_count-1 do
			koth_hill_marker_x_coord = readfloat(koth_globals + i4 + 0x94) -- X coordinate for hill marker
			koth_hill_marker_y_coord = readfloat(koth_globals + i4 + 0x98) -- Y coordinate for hill marker
			koth_hill_marker_z_coord = readfloat(koth_globals + i4 + 0x9C) -- Z coordinate for hill marker
		end
		--wth... these are coordinates but they're 2 dimensional, no z axis. Probably just the area that determines if you are in a hill
		for i = 0,koth_hill_marker_count-1 do
			koth_hill_marker_x_coord2 = readfloat(koth_globals + i4 + 0x124) -- Tested. X coordinate for 2d hill.
			koth_hill_marker_y_coord2 = readfloat(koth_globals + i4 + 0x128) -- Tested. Y coordinate for 2d hill.
		end
		koth_center_of_hill_x_coord = readfloat(koth_globals + 0x184) -- Confirmed. Center of hill X.
		koth_center_of_hill_y_coord = readfloat(koth_globals + 0x188) -- Confirmed. Center of hill Y.
		koth_center_of_hill_z_coord = readfloat(koth_globals + 0x18C) -- Confirmed. Center of hill Z.
		--unkLong[4] 0x190 ()
		koth_move_timer = readdword(koth_globals + 0x200) -- Confirmed. (1 second = 30 ticks)

		-- oddball globals
		oddball_score_to_win = readdword(oddball_globals) -- Confirmed.
		oddball_team_score = readdword(oddball_globals + team4 + 0x4) -- Confirmed. There's actually 16 teams if the gametype is FFA.
		oddball_player_score = readdword(oddball_globals + player4 + 0x44) -- Confirmed.
		--oddball_something = readdword(oddball_globals + player4 + 0x64) -- ()
		oddball_ball_indexes = readdword(oddball_globals + 0x84) -- Tested. Idk what this is for but it holds oddball indexes that are differentiated by 0x1C2.
			oddball_it_people = readdword(oddball_globals + 0x84) -- Tested. It's filled with stuff depending on the amount of 'it' people in juggtag
		oddball_player_holding_ball = readident(oddball_globals + player4 + 0xC4) -- Confirmed.
		oddball_player_time_with_ball = readdword(oddball_globals + player4 + 0x104) -- Confirmed. (1 second = 30 ticks)

		--race globals
		race_checkpoint_count = readdword(race_globals) -- Confirmed. Total number of checkpoints required for a lap. Stored very awkwardly. (0x1 = 1, 0x3 = 2, 0x7 = 3, 0xF = 4, 0x1F = 5 etc)
		race_player_current_checkpoint = readdword(race_globals + player4 + 0x44) -- Confirmed. Current checkpoint the player needs to go to. Stored very awkwardly. (0x1 = first checkpoint, 0x3 = second checkpoint, 0x7 = 3rd checkpoint, 0xF = 4th checkpoint, 0x1F = 5th checkpoint etc)
		race_team_score = readdword(race_globals + team4 + 0x88) -- Confirmed.

		--race checkpoint locations
		for i = 0,race_checkpoint_count do
			race_checkpoint_x_coord = readfloat(race_locs + i0x20) -- Confirmed.
			race_checkpoint_y_coord = readfloat(race_locs + i0x20 + 0x4) -- Confirmed.
			race_checkpoint_z_coord = readfloat(race_locs + i0x20 + 0x8) -- Confirmed.
		end

		--slayer globals
		slayer_team_score = readdword(slayer_globals + team4) -- Confirmed.
		slayer_player_score = readdword(slayer_globals + player4 + 0x40) -- Confirmed.
		slayer_game = readbyte(slayer_globals + 0x20) -- Tested. I think its always 1. I guess 1 if slayer, 0 if not Something like that.

		-- camera struct
		camera_size = 0x30
		camera_xy = readfloat(camera_base + playercamera_size)
		camera_z = readfloat(camera_base + playercamera_size + 0x4)
		camera_x_aim = readfloat(camera_base + playercamera_size + 0x1C)
		camera_y_aim = readfloat(camera_base + playercamera_size + 0x20)
		camera_z_aim = readfloat(camera_base + playercamera_size + 0x24)

		-- mp flags table (race checkpoints, hill markers, vehicle spawns, etc)
		-- REM figure out wth this is since I now know where flags really are...
		flags_table_base = readdword(flags_pointer) -- Tested.
		flags_count = readdword(flags_table_base + 0x378) -- Tested.
		flags_table_address = readdword(flags_table_base + 0x37C) -- Tested.
		for i = 0,flags_count do -- i is each individual flag index
			flag_address = flags_table_address + i  148
			flag_x_coord = readfloat(flag_address) -- Confirmed.
			flag_y_coord = readfloat(flag_address + 0x4) -- Confirmed.
			flag_z_coord = readfloat(flag_address + 0x8) -- Confirmed.
			flag_type = readword(flag_address + 0x10) -- Tested. (3 if race checkpoint, 6 if spawnpoint, sometimes 0 meaning something else)
			--flag_something = readword(flag_address + 0x12) -- () Always 1
			flag_tagtype = readstring(flag_address + 0x14, 4) -- Tested. It's usually ITMC or WPCL, which makes no sense...
		end

		-- player struct setup
		m_player = getplayer(player)

		-- player struct
		player_id = readword(m_player, 0x0) -- Confirmed. WORD ID of this player. (0xEC70 etc)
		player_host = readword(m_player + 0x2) -- Confirmed. (Host = 0) (Not host = 0xFFFFFFFF)
		player_name = readwidestring(m_player + 0x4, 12) -- Confirmed.
		--unkIdent[1] 0x1C-0x20 ()
		player_team = readbyte(m_player + 0x20) -- Confirmed. (Red = 0) (Blue = 1)
		--Padding[3] 0x21-0x24
		player_interaction_obj_id = readident(m_player + 0x24) -- Confirmed. Returns vehiweap id on interaction. (does not apply to weapons you're already holding)
		player_interaction_object_type = readword(m_player + 0x28) -- Confirmed. (Vehicle = 8, Weapon = 7)
		player_interaction_vehi_seat = readword(m_player + 0x2A) -- Confirmed. Takes seat number from vehi tag starting with 0. Warthog Seats (0 = Driver, 1 = Gunner, 2 = Passenger)
		player_respawn_time = readdword(m_player + 0x2C) -- Confirmed. Counts down when dead. When 0 you respawn. (1 sec = 30 ticks)
		player_respawn_time_growth = readdword(m_player + 0x30) -- Confirmed. Current respawn time growth for player. (1 second = 30 ticks)
		player_obj_id = readident(m_player + 0x34) -- Confirmed.
		player_last_obj_id = readident(m_player + 0x38) -- Confirmed. 0xFFFFFFFF if player hasn't diedhasn't had their object destroyed yet. sv_kill or kill(player) DOES NOT AFFECT THIS AT ALL.
		player_cluster_index = readword(m_player + 0x3C) -- Tested. Not sure what this is, but it's definitely something.
		--	bitmask16
			player_weapon_pickup = readbit(m_player + 0x3E, 0) -- Confirmed. (True if picking up weapon, False if not.)
		--	bitPadding[15] 1-15
		--player_auto_aim_target_objId = readident(m_player + 0x40)	-- () Always 0xFFFFFFFF
		player_last_bullet_time = readdword(m_player + 0x44) -- Confirmed. gameinfo_current_time - this = time since last shot fired. (1 second = 30 ticks). Auto_aim_update_time in OS.
		
		--This stuff comes directly from the client struct
		player_name2 = readwidestring(m_player + 0x48, 12) -- Confirmed.
		player_color = readword(m_player + 0x60) -- Confirmed. Color of the player (FFA Gametypes Only.) (0 = white) (1 = black) (2 = red) (3 = blue) (4 = gray) (5 = yellow) (6 = green) (7 = pink) (8 = purple) (9 = cyan) (10 = cobalt) (11 = orange) (12 = teal) (13 = sage) (14 = brown) (15 = tan) (16 = maroon) (17 = salmon)
		--player_icon_index = readword(m_player + 0x62) -- () Always 0xFFFF
		player_machine_index = readbyte(m_player + 0x64) -- Confirmed with resolveplayer(player). Player Machine Index (rconId - 1).
		--player_controller_index = readbyte(m_player + 0x65) -- () Always 0
		player_team2 = readbyte(m_player + 0x66) -- Confirmed. (Red = 0) (Blue = 1)
		player_index = readbyte(m_player + 0x67) -- Confirmed. Player memory idindex (0 - 15) (To clarify this IS the 'player' argument passed to phasor functions)
		--End of client struct stuff.
		
		player_invis_time = readword(m_player + 0x68) -- Confirmed. Time until player is no longer camouflaged. (1 sec = 30 ticks)
		--unkWord[1] 0x6A-0x6C () Has something to do with player_invis_time.
		player_speed = readfloat(m_player + 0x6C) -- Confirmed.
		player_teleporter_flag_id = readident(m_player + 0x70) -- Tested. Index to a netgame flag in the scenario, or -1 (Always 0xFFFFFFFF)
		player_objective_mode = readdword(m_player + 0x74) -- From Smiley. (Hill = 0x22 = 34) (Juggernaut = It = 0x23 = 35) (Race = 0x16 = 22) (Ball = 0x29 = 41) (Others = -1)
		player_objective_player_id = readident(m_player + 0x78) -- Confirmed. Becomes the full DWORD ID of this player once they interact with the objective. (DOES NOT APPLY TO CTF) (0xFFFFFFFF  -1 if not interacting)
		player_target_player = readdword(m_player + 0x7C) -- From OS. Values (this and below) used for rendering a target player's name. (Always 0xFFFFFFFF)
		player_target_time = readdword(m_player + 0x80) -- From OS. Timer used to fade in the target player name.
		player_last_death_time = readdword(m_player + 0x84) -- Confirmed. gameinfo_current_time - this = time since last death time. (1 sec = 30 ticks)
		player_slayer_target = readident(m_player + 0x88) -- Confirmed. Slayer Target Player
		--	bitmask32
			player_oddman_out = readbit(m_player + 0x8C, 0) -- Confirmed. (1 if oddman out, 0 if not)
		--	bitPadding[31]
		--Padding[6] 0x90-0x96
		player_killstreak = readword(m_player + 0x96) -- Confirmed. How many kills the player has gotten in their lifetime.
		player_multikill = readword(m_player + 0x98) -- () 0 on spawn, 1 when player gets a kill, then stays 1 until death.
		player_last_kill_time = readword(m_player + 0x9A) -- Confirmed. gameinfo_current_time - this = time since last kill time. (1 sec = 30 ticks)
		player_kills = readword(m_player + 0x9C) -- Confirmed.
		--unkByte[6] 0x9E-0xA4 (Padding Maybe)
		player_assists = readword(m_player + 0xA4) -- Confirmed.
		--unkByte[6] 0xA6-0xAC (Padding Maybe)
		player_betrays = readword(m_player + 0xAC) -- Confirmed. Actually betrays + suicides.
		player_deaths = readword(m_player + 0xAE) -- Confirmed.
		player_suicides = readword(m_player + 0xB0) -- Confirmed.
		--Padding[14] 0xB2-0xC0
		player_teamkills = readword(m_player + 0xC0) -- From OS.
		--Padding[2] 0xC2-0xC4
		
		--This is all copied from the stat struct
		player_flag_steals = readword(m_player + 0xC4) -- Confirmed. Flag steals for CTF.
			player_hill_time = readword(m_player + 0xC4) -- Confirmed. Time for KOTH. (1 sec = 30 ticks)
			player_race_time = readword(m_player + 0xC4) -- Confirmed. Time for Race. (1 sec = 30 ticks)
		player_flag_returns = readword(m_player + 0xC6) -- Confirmed. Flag returns for CTF.
			player_oddball_target_kills = readword(m_player + 0xC6) -- Confirmed. Number of times you killed the Juggernaut or It.
			player_race_laps = readword(m_player + 0xC6) -- Confirmed. Laps for Race.
		player_flag_scores = readword(m_player + 0xC8) -- Confirmed. Flag scores for CTF.
			player_oddball_kills = readword(m_player + 0xC8) -- Confirmed. Number of kills you have as Juggernaut or It.
			player_race_best_time = readword(m_player + 0xC8) -- Confirmed. Best time for Race. (1 sec = 30 ticks)
		
		--unkByte[2] 0xCA-0xCC (Padding Maybe)
		player_telefrag_timer = readdword(m_player + 0xCC) -- Confirmed. Time spent blocking a tele. Counts down after other player stops trying to teleport. (1 sec = 30 ticks)
		player_quit_time = readdword(m_player + 0xD0) -- Confirmed. gameinfo_current_time - this = time since player quit. 0xFFFFFFFF if player not quitting. (1 sec = 30 ticks)
		--	bitmask16
		--	player_telefrag_enabled = readbit(m_player + 0xD4, 0) -- () Always False
		--	bitPadding[7] 1-7
		--	player_quit = readbit(m_player + 0xD4, 8) -- () Always False
		--	bitPadding[7] 9-15
		--Padding[6] 0xD6-0xDC
		player_ping = readdword(m_player + 0xDC) -- Confirmed.
		player_teamkill_number = readdword(m_player + 0xE0) -- Confirmed.
		player_teamkill_timer = readdword(m_player + 0xE4) -- Confirmed. Time since last betrayal. (1 sec = 30 ticks)
		player_some_timer = readword(m_player + 0xE8) -- Tested. It increases once every half second until it hits 36, then repeats.
		--unkByte[14] 0xEA-0xF8 ()
		player_x_coord = readfloat(m_player + 0xF8) -- Confirmed.
		player_y_coord = readfloat(m_player + 0xFC) -- Confirmed.
		player_z_coord = readfloat(m_player + 0x100) -- Confirmed.
		--unkIdent[1] 0x104-0x108 ()
		
		
		--unkByte[8] 0x108-0x110 ()
		--unkLong[1] 0x110-0x114 (Some timer)
		--unkByte[8] 0x114-0x11C ()
		--	Player Action Keypresses.
			player_melee_key = readbit(m_player + 0x11C, 0) -- Confirmed.
			player_action_key = readbit(m_player + 0x11C, 1) -- Confirmed.
		--	unkBit[1] 2
			player_flashlight_key = readbit(m_player + 0x11C, 3) -- Confirmed.
		--	unkBit[9] 4-12
			player_reload_key = readbit(m_player + 0x11C, 13) -- Confirmed.
		--	unkBit[2] 14-15
		
		--unkByte[30] 0x11E-0x134 ()
		player_xy_aim = readfloat(m_player + 0x138) -- Confirmed. Lags. (0 to 2pi) In radians.
		player_z_aim = readfloat(m_player + 0x13C) -- Confirmed. Lags. (-pi2 to pi2) In radians.
		player_forward = readfloat(m_player + 0x140) -- Confirmed. Negative means backward. Lags. (-1, -sqrt(2)2, 0, sqrt(2)2, 1)
		player_left = readfloat(m_player + 0x144) -- Confirmed. Negative means right. Lags. (-1, -sqrt(2)2, 0, sqrt(2)2, 1)
		player_rateoffire_speed = readfloat(m_player + 0x148) -- Confirmed. As player is shooting, this will gradually increase until it hits the max (0 to 1 only)
		player_weap_type = readword(m_player + 0x14C) -- Confirmed. Lags. (Primary = 0) (Secondary = 1) (Tertiary = 2) (Quaternary = 3)
		player_nade_type = readword(m_player + 0x14E) -- Confirmed. Lags. (Frag = 0) (Plasma = 1)
		--unkByte[4] 0x150-0x154 (Padding Maybe)
		player_x_aim2 = readfloat(m_player + 0x154) -- Confirmed. Lags.
		player_y_aim2 = readfloat(m_player + 0x158) -- Confirmed. Lags.
		player_z_aim2 = readfloat(m_player + 0x15C) -- Confirmed. Lags.
		--unkByte[16] 0x160-0x170 (Padding Maybe)
		player_x_coord2 = readfloat(m_player + 0x170) -- Confirmed. Lags. (Possibly what the client reports is _its_ world coord)
		player_y_coord2 = readfloat(m_player + 0x174) -- Confirmed. Lags. (Possibly what the client reports is _its_ world coord)
		player_z_coord2 = readfloat(m_player + 0x178) -- Confirmed. Lags. (Possibly what the client reports is _its_ world coord)
		--unkByte[132] 0x17C-0x200

		-- objweap struct setup
		m_object = getobject(player_obj_id) -- obj struct setup
		m_vehicle = getobject(readdword(m_object + 0x11C)) -- vehi check setup

		-- vehi check
		if m_vehicle then
			m_object = m_vehicle
		end

		-- obj struct. This struct applies to ALL OBJECTS. 0x0 - 0x1F4
		obj_tag_id = readdword(m_object) -- Confirmed with HMT. Tag Meta ID  MapID  TagID.
		--obj_object_role = readdword(m_object + 0x4) -- From OS. (0 = Master, 1 = Puppet, 2 = Puppet controlled by local player, 3 = ) Always 0
		--	bitmask32
		--	unkBits[8] 0-7 ()
			obj_should_force_baseline_update = readbit(m_object + 0x8, 8) -- From OS.
		--	unkBits[23] 9-32 ()
		obj_existance_time = readdword(m_object + 0xC) -- Confirmed. (1 second = 30 ticks)
		--	Physics bitmask32
			obj_noCollision = readbit(m_object + 0x10, 0) -- Confirmed. (Ghost mode = True)
			obj_is_on_ground = readbit(m_object + 0x10, 1) -- Confirmed. (Object is on the ground = True, otherwise False) 
			obj_ignoreGravity = readbit(m_object + 0x10, 2) -- From Phasor
		--	obj_is_in_water = readbit(m_object + 0x10, 3) -- () Always 0
		--	unkBits[1] 0x10 4
			obj_stationary = readbit(m_object + 0x10, 5) -- Confirmed. This bit is set (true) when the object is stationary.
		--	unkBits[1] 0x10 6
			obj_noCollision2 = readbit(m_object + 0x10, 7) -- From Phasor.
		--	unkBits[3] 0x10 8-10
		--	obj_connected_to_map = readbit(m_object + 0x10, 11) -- () Always True
		--	unkBits[4] 0x10 12-15
			obj_garbage_bit = readbit(m_object + 0x10, 16) -- From OS.
		--	unkBits[1] 0x10 17
			obj_does_not_cast_shadow = readbit(m_object + 0x10, 18) -- From OS.
		--	unkBits[2] 0x10 19-20
			obj_is_outside_of_map = readbit(m_object + 0x10, 21) -- Confirmed. (True if outside of map, False if not)
		--	obj_beautify_bit = readbit(m_object + 0x10, 22) -- () Always False
		--	unkBits[1] 0x10 23
			obj_is_collideable = readbit(m_object + 0x10, 24) -- Confirmed. Set this to true to allow other objects to pass through you. (doesn't apply to vehicles).
		--	unkBits[7] 0x10 25-31
		obj_marker_id = readdword(m_object + 0x14) -- Tested. Continually counts up from like 89000...
		--Padding[0x38] 0x18-0x50
		--obj_owner_player_id = readident(m_object + 0x50) -- () Always 0
		--obj_owner_id = readident(m_object + 0x54) -- () Always 0
		--obj_timestamp = readdword(m_object + 0x58) -- () Always 0
		obj_x_coord = readfloat(m_object + 0x5C) -- Confirmed.
		obj_y_coord = readfloat(m_object + 0x60) -- Confirmed.
		obj_z_coord = readfloat(m_object + 0x64) -- Confirmed.
		obj_x_vel = readfloat(m_object + 0x68) -- Confirmed.
		obj_y_vel = readfloat(m_object + 0x6C) -- Confirmed.
		obj_z_vel = readfloat(m_object + 0x70) -- Confirmed.
		obj_pitch = readfloat(m_object + 0x74) -- Confirmed. In Radians. (-1 to 1)
		obj_yaw = readfloat(m_object + 0x78) -- Confirmed. In Radians. (-1 to 1)
		obj_roll = readfloat(m_object + 0x7C) -- Confirmed. In Radians. (-1 to 1)
		obj_x_scale = readfloat(m_object + 0x80) -- Tested. 0 for bipd. Changes when in vehi. Known as 'up' in OS.
		obj_y_scale = readfloat(m_object + 0x84) -- Tested. 0 for bipd. Changes when in vehi. Known as 'up' in OS.
		obj_z_scale = readfloat(m_object + 0x88) -- Tested. 1 for bipd. Changes when in vehi. Known as 'up' in OS.
		obj_pitch_vel = readfloat(m_object + 0x8C) -- Confirmed for vehicles. Current velocity for pitch.
		obj_yaw_vel = readfloat(m_object + 0x90) -- Confirmed for vehicles. Current velocity for yaw.
		obj_roll_vel = readfloat(m_object + 0x94) -- Confirmed for vehicles. Current velocity for roll.
		obj_locId = readdword(m_object + 0x98) -- Confirmed. Each map has dozens of location IDs, used for general location checking.
		--unkLong[1] 0x9C (Padding Maybe)
		-- Apparently these are coordinates, used for the game code's trigger volume point testing
		obj_center_x_coord = readfloat(m_object + 0xA0) -- Tested. Very close to obj_x_coord, but not quite
		obj_center_y_coord = readfloat(m_object + 0xA4) -- Tested. Very close to obj_y_coord, but not quite
		obj_center_z_coord = readfloat(m_object + 0xA8) -- Tested. Very close to obj_z_coord, but not quite
		obj_radius = readfloat(m_object + 0xAC) -- Confirmed. Radius of object. In Radians. (-1 to 1)
		obj_scale = readfloat(m_object + 0xB0) -- Tested. Seems to be some random float for all objects (all same objects have same value)
		obj_type = readword(m_object + 0xB4) -- Confirmed. (0 = Biped) (1 = Vehicle) (2 = Weapon) (3 = Equipment) (4 = Garbage) (5 = Projectile) (6 = Scenery) (7 = Machine) (8 = Control) (9 = Light Fixture) (10 = Placeholder) (11 = Sound Scenery)
		--Padding[2] 0xB6-0xB8
		obj_game_objective = readword(m_object + 0xB8) -- Confirmed. If objective then this = 0, -1 = is NOT game object. Otherwise (Red = 0) (Blue = 1)
		obj_namelist_index = readword(m_object + 0xBA) -- From OS.
		--obj_moving_time = readword(m_object + 0xBC) -- () Always 0
		--obj_region_permutation_variant_id = readword(m_object + 0xBE) -- () Always 0
		obj_player_id = readident(m_object + 0xC0) -- Confirmed. Full DWORD ID of player.
		obj_owner_obj_id = readident(m_object + 0xC4) -- Confirmed. Parent object ID of this object (DOES NOT APPLY TO BIPEDSPLAYER OBJECTS)
		--Padding[4] 0xC8-0xCC
		--REM figure out what this animation stuffz is.
		obj_antr_meta_id = readident(m_object + 0xCC) -- From DZS. Remind me to look at eschaton to see what this actually is (Possible Struct)
		obj_animation_state = readword(m_object + 0xD0) -- Confirmed. (0 = Idle, 1 = Gesture, Turn Left = 2, Turn Right = 3, Move Front = 4, Move Back = 5, Move Left = 6, Move Right = 7, Stunned Front = 8, Stunned Back = 9, Stunned Left = 10, Stunned Right = 11, Slide Front = 12, Slide Back = 13, Slide Left = 14, Slide Right = 15, Ready = 16, Put Away = 17, Aim Still = 18, Aim Move = 19, Airborne = 20, Land Soft = 21, Land Hard = 22,  = 23, Airborne Dead = 24, Landing Dead = 25, Seat Enter = 26, Seat Exit = 27, Custom Animation = 28, Impulse = 29, Melee = 30, Melee Airborne = 31, Melee Continuous = 32, Grenade Toss = 33, Resurrect Front = 34, Ressurect Back = 35, Feeding = 36, Surprise Front = 37, Surprise Back = 38, Leap Start = 39, Leap Airborne = 40, Leap Melee = 41, Unused AFAICT = 42, Berserk = 43)
		obj_time_since_animation_state_change = readword(m_object + 0xD2) -- Confirmed (0 to 60) Time since last animation_state change. Restarts at 0 when animation_state changes (1 sec = 30 ticks)
		--unkWord[2] 0xD4-0xD8 ()
		obj_max_health = readfloat(m_object + 0xD8) -- Confirmed. Takes value from coll tag.
		obj_max_shields = readfloat(m_object + 0xDC) -- Confirmed. Takes value from coll tag.
		obj_health = readfloat(m_object + 0xE0) -- Confirmed. (0 to 1)
		obj_shields = readfloat(m_object + 0xE4) -- Confirmed. (0 to 3) (Normal = 1) (Full overshield = 3)
		obj_current_shield_damage = readfloat(m_object + 0xE8) -- Confirmed. CURRENT INSTANTANEOUS amount of shield being damaged.
		obj_current_body_damage = readfloat(m_object + 0xEC) -- Confirmed. CURRENT INSTANTANEOUS amount of health being damaged.
		--obj_some_obj_id = readident(m_object + 0xF0) -- () Always 0xFFFFFFFF
		obj_last_shield_damage_amount = readfloat(m_object + 0xF4) -- Tested. Total shield damage taken (counts back down to 0 after 2 seconds)
		obj_last_body_damage_amount = readfloat(m_object + 0xF8) -- Tested. Total health damage taken (counts back down to 0 after 2 seconds)
		obj_last_shield_damage_time = readdword(m_object + 0xFC) -- Tested. Counts up to 75 after shield is damaged, then becomes 0xFFFFFFFF.
		obj_last_body_damage_time = readdword(m_object + 0x100) -- Tested. Counts up to 75 after health is damaged, then becomes 0xFFFFFFFF.
		obj_shields_recharge_time = readword(m_object + 0x104) -- Tested. Counts down when shield is damaged. When 0 your shields recharge. (1 sec = 30 ticks). based on ftol(s_shield_damage_resistance-stun_time  30f)
		-- damageFlags bitmask16
			--obj_body_damage_effect_applied = readbit(m_object + 0x106, 0) -- () Always False
			--obj_shield_damage_effect_applied = readbit(m_object + 0x106, 1) -- () Always False
			--obj_body_health_empty = readbit(m_object + 0x106, 2) -- () Always False
			--obj_shield_empty = readbit(m_object + 0x106, 3) -- () Always False
			--obj_kill = readbit(m_object + 0x106, 4) -- () Always False
			--obj_silent_kill_bit = readbit(m_object + 0x106, 5) -- () Always False
			--obj_damage_berserk = readbit(m_object + 0x106, 6) -- () Always False (actor berserk related)
		--	unkBits[4] 0x106 7-10
			obj_cannot_take_damage = readbit(m_object + 0x106, 11) -- Confirmed. Set this to true to make object undamageable (even from backtaps!)
			obj_shield_recharging = readbit(m_object + 0x106, 12) -- Confirmed. (True = shield recharging, False = not recharging)
			--obj_killed_no_statistics = readbit(m_object + 0x106, 13) -- () Always False
		--	unkBits[2] 0x106 14-15
		--Padding[4] 0x108
		obj_cluster_partition_index = readident(m_object + 0x10C) -- Tested. This number continually counts up, and resumes even after object is destroyed and recreated (killed)
		--obj_some_obj_id2 = readident(m_object + 0x110) -- object_index, garbage collection related
		--obj_next_obj_id = readident(m_object + 0x114) -- () Always 0xFFFFFFFF
		obj_weap_obj_id = readident(m_object + 0x118) -- Confirmed. Current weapon  id.
		obj_vehi_obj_id = readident(m_object + 0x11C) -- Confirmed. Current vehicle id. (Could also be known as the object's parent ID.)
		obj_vehi_seat = readword(m_object + 0x120) -- Confirmed. Current seat index (actually same as player_interaction_vehi_seat once inside a vehicle)
		--	bitmask8
			obj_force_shield_update = readbit(m_object + 0x122, 0) -- From OS.
		--	unkBits[15] 1-15 ()
		
		--Functions.
		obj_shields_hit = readfloat(m_object + 0x124) -- Tested. Counts down from 1 after shields are hit (0 to 1)
		obj_shields_target = readfloat(m_object + 0x128) -- Tested. When you have an overshield it stays at 1 which is why I think the overshield drains. (0 to 1) [2nd function]
		obj_flashlight_scale = readfloat(m_object + 0x12C) -- Confirmed. Intensity of flashlight as it turns on and off. (0 to 1) (On  0) (Off = 0) [3rd function]
		obj_assaultrifle_function = readfloat(m_object + 0x130) -- The Assault rifle is the only one that uses this function.
		obj_export_function1 = readfloat(m_object + 0x134) -- Tested. (Assault rifle = 1)
		obj_flashlight_scale2 = readfloat(m_object + 0x138) -- Confirmed. Intensity of flashlight as it turns on and off. (0 to 1) (On  0) (Off = 0) [2nd function]
		obj_shields_hit2 = readfloat(m_object + 0x13C) -- Tested. Something to do with shields getting hit. [3rd function]
		obj_export_function4 = readfloat(m_object + 0x140) -- Tested. (1 = Assault Rifle)
		--End of functions.
		
		--RegionsAttachments.
		obj_attachment_type = readbyte(m_object + 0x144) -- From OS. (0 = light, 1 = looping sound, 2 = effect, 3 = contrail, 4 = particle, 5 = , 0xFF = invalid)
		obj_attachment_type2 = readbyte(m_object + 0x145) -- From OS. (0 = light, 1 = looping sound, 2 = effect, 3 = contrail, 4 = particle, 5 = , 0xFF = invalid)
		obj_attachment_type3 = readbyte(m_object + 0x146) -- From OS. (0 = light, 1 = looping sound, 2 = effect, 3 = contrail, 4 = particle, 5 = , 0xFF = invalid)
		obj_attachment_type4 = readbyte(m_object + 0x147) -- From OS. (0 = light, 1 = looping sound, 2 = effect, 3 = contrail, 4 = particle, 5 = , 0xFF = invalid)
		obj_attachment_type5 = readbyte(m_object + 0x148) -- From OS. (0 = light, 1 = looping sound, 2 = effect, 3 = contrail, 4 = particle, 5 = , 0xFF = invalid)
		obj_attachment_type6 = readbyte(m_object + 0x149) -- From OS. (0 = light, 1 = looping sound, 2 = effect, 3 = contrail, 4 = particle, 5 = , 0xFF = invalid)
		obj_attachment_type7 = readbyte(m_object + 0x14A) -- From OS. (0 = light, 1 = looping sound, 2 = effect, 3 = contrail, 4 = particle, 5 = , 0xFF = invalid)
		obj_attachment_type8 = readbyte(m_object + 0x14B) -- From OS. (0 = light, 1 = looping sound, 2 = effect, 3 = contrail, 4 = particle, 5 = , 0xFF = invalid)
		
		-- game state identity
		-- ie, if Attachments[x]'s definition (object_attachment_block[x]) says it is a 'cont'
		-- then the identity is a contrail_data handle
		obj_attachment_id = readident(m_object + 0x14C) -- From OS.
		obj_attachment2_id = readident(m_object + 0x150) -- From OS.
		obj_attachment3_id = readident(m_object + 0x154) -- From OS.
		obj_attachment4_id = readident(m_object + 0x158) -- From OS.
		obj_attachment5_id = readident(m_object + 0x15C) -- From OS.
		obj_attachment6_id = readident(m_object + 0x160) -- From OS.
		obj_attachment7_id = readident(m_object + 0x164) -- From OS.
		obj_attachment8_id = readident(m_object + 0x168) -- From OS.
		obj_first_widget_id = readident(m_object + 0x16C) -- () Always 0xFFFFFFFF
		obj_cached_render_state_index = readident(m_object + 0x170) -- () Always 0xFFFFFFFF
		--unkByte[2] 0x174-0x176 (Padding Maybe)
		obj_shader_permutation = readword(m_object + 0x176) -- From OS. shader's bitmap block index
		obj_health_region = readbyte(m_object + 0x178) -- From OS.
		obj_health_region2 = readbyte(m_object + 0x179) -- From OS.
		obj_health_region3 = readbyte(m_object + 0x17A) -- From OS.
		obj_health_region4 = readbyte(m_object + 0x17B) -- From OS.
		obj_health_region5 = readbyte(m_object + 0x17C) -- From OS.
		obj_health_region6 = readbyte(m_object + 0x17D) -- From OS.
		obj_health_region7 = readbyte(m_object + 0x17E) -- From OS.
		obj_health_region8 = readbyte(m_object + 0x17F) -- From OS.
		obj_region_permutation_index = readchar(m_object + 0x180) -- From OS.
		obj_region_permutation2_index = readchar(m_object + 0x181) -- From OS.
		obj_region_permutation3_index = readchar(m_object + 0x182) -- From OS.
		obj_region_permutation4_index = readchar(m_object + 0x183) -- From OS.
		obj_region_permutation5_index = readchar(m_object + 0x184) -- From OS.
		obj_region_permutation6_index = readchar(m_object + 0x185) -- From OS.
		obj_region_permutation7_index = readchar(m_object + 0x186) -- From OS.
		obj_region_permutation8_index = readchar(m_object + 0x187) -- From OS.
		--End of regionsattachments
		
		obj_color_change_red = readfloat(m_object + 0x188) -- From OS.
		obj_color_change_green = readfloat(m_object + 0x18C) -- From OS.
		obj_color_change_blue = readfloat(m_object + 0x190) -- From OS.
		obj_color_change2_red = readfloat(m_object + 0x194) -- From OS.
		obj_color_change2_green = readfloat(m_object + 0x198) -- From OS.
		obj_color_change2_blue = readfloat(m_object + 0x19C) -- From OS.
		obj_color_change3_red = readfloat(m_object + 0x1A0) -- From OS.
		obj_color_change3_green = readfloat(m_object + 0x1A4) -- From OS.
		obj_color_change3_blue = readfloat(m_object + 0x1A8) -- From OS.
		obj_color_change4_red = readfloat(m_object + 0x1AC) -- From OS.
		obj_color_change4_green = readfloat(m_object + 0x1B0) -- From OS.
		obj_color_change4_blue = readfloat(m_object + 0x1B4) -- From OS.
		obj_color2_change_red = readfloat(m_object + 0x1B8) -- From OS.
		obj_color2_change_green = readfloat(m_object + 0x1BC) -- From OS.
		obj_color2_change_blue = readfloat(m_object + 0x1C0) -- From OS.
		obj_color2_change2_red = readfloat(m_object + 0x1C4) -- From OS.
		obj_color2_change2_green = readfloat(m_object + 0x1C8) -- From OS.
		obj_color2_change2_blue = readfloat(m_object + 0x1CC) -- From OS.
		obj_color2_change3_red = readfloat(m_object + 0x1D0) -- From OS.
		obj_color2_change3_green = readfloat(m_object + 0x1D4) -- From OS.
		obj_color2_change3_blue = readfloat(m_object + 0x1D8) -- From OS.
		obj_color2_change4_red = readfloat(m_object + 0x1DC) -- From OS.
		obj_color2_change4_green = readfloat(m_object + 0x1E0) -- From OS.
		obj_color2_change4_blue = readfloat(m_object + 0x1E4) -- From OS.
		
		--one of these are for interpolating
		obj_header_block_ref_node_orientation_size = readword(m_object + 0x1E8) -- From OS.
		obj_header_block_ref_node_orientation_offset = readword(m_object + 0x1EA) -- From OS.
		obj_header_block_ref_node_orientation2_size = readword(m_object + 0x1EC) -- From OS.
		obj_header_block_ref_node_orientation2_offset = readword(m_object + 0x1EE) -- From OS.
		obj_header_block_ref_node_matrix_block_size = readword(m_object + 0x1F0) -- From OS.
		obj_header_block_ref_node_matrix_block_offset = readword(m_object + 0x1F2) -- From OS.
		
		--unkLong[2] 0x1E8-0x1F0 () Some sort of ID
		--obj_node_matrix_block = readdword(m_object + 0x1F0) -- From OS. ()
		
		if obj_type == 0 or obj_type == 1 then -- check if object is biped or vehicle
			
			--unit struct (applies to bipeds (players and AI) and vehicles)
			m_unit = m_object
			
			unit_actor_index = readident(m_unit + 0x1F4) -- From OS.
			unit_swarm_actor_index = readident(m_unit + 0x1F8) -- From OS.
			unit_swarm_next_actor_index = readident(m_unit + 0x1FC) -- Guess.
			unit_swarm_prev_obj_id = readident(m_unit + 0x200) -- From OS.
			
			--	Client Non-Instantaneous bitmask32
			--	unkBit[4] 0-3 ()
				unit_is_invisible = readbit(m_unit + 0x204, 4) -- Confirmed. (True if currently invisible, False if not)
				unit_powerup_additional = readbit(m_unit + 0x204, 5) -- From OS. Guessing this is set if you have multiple powerups at the same time.
				unit_is_currently_controllable_bit = readbit(m_unit + 0x204, 6) -- From OS. I'm just going to assume this works.
			--	unkBit[9] 7-15 ()
			--	unit_doesNotAllowPlayerEntry = readbit(m_unit + 0x204, 16) -- From DZS. For vehicles. (True if vehicle is allowing players to enter, False if not)
			--	unkBit[2] 17-18 ()
				unit_flashlight = readbit(m_unit + 0x204, 19) -- Confirmed. (True = flashlight on, False = flashlight off)
				unit_doesnt_drop_items = readbit(m_unit + 0x204, 20) -- Confirmed. (True if object doesn't drop items on death, otherwise False). (Clients will see player drop items, then immediately despawn)
			--	unkBit[1] 21 ()
			--	unit_can_blink = readbit(m_unit + 0x204, 22) -- () Always False
			--	unkBit[1] 23 ()
				unit_is_suspended = readbit(m_unit + 0x204, 24) -- Confirmed. (True if frozensuspended, False if not)
			--	unkBit[2] 25-26 ()
			--	unit_is_possessed = readbit(m_unit + 0x204, 27) -- () Always False
			--	unit_flashlight_currently_on = readbit(m_unit + 0x204, 28) -- () Always False
			--	unit_flashlight_currently_off = readbit(m_unit + 0x204, 29) -- () Always False
			--	unkBit[2] 30-31 ()

			--	Client Action Keypress bitmask32 (Instantaneous actions).
				unit_crouch_presshold = readbit(m_unit + 0x208, 0) -- Confirmed. (True when holding crouch, False when not)
				unit_jump_presshold = readbit(m_unit + 0x208, 1)	-- Confirmed. (True when holding jump key, False when not)
			--	unit_user1 = readbit(m_unit + 0x208, 3) -- () Always False
			--	unit_user2 = readbit(m_unit + 0x208, 4) -- () Always False
				unit_flashlightkey = readbit(m_unit + 0x208, 4)-- Confirmed. (True when pressing flashlight key, False when not)
			--	unit_exact_facing = readbit(m_unit + 0x208, 5) -- () Always False
				unit_actionkey = readbit(m_unit + 0x208, 6)	-- Confirmed. (True when pressing action key, False when not)
				unit_meleekey = readbit(m_unit + 0x208, 7)		-- Confirmed. (True when pressing melee key, False when not)
			--	unit_look_without_turn = readbit(m_unit + 0x208, 8) -- () Always False
			--	unit_force_alert = readbit(m_unit + 0x208, 9) -- () Always False
				unit_reload_key = readbit(m_unit + 0x208, 10)	-- Confirmed. (True when pressing actionreload key, False when not)
				unit_primaryWeaponFire_presshold = readbit(m_unit + 0x208, 11)		-- Confirmed. (True when holding left click, False when not)
				unit_secondaryWeaponFire_presshold = readbit(m_unit + 0x208, 12)	-- Confirmed. (True when holding right click, False when not)
				unit_grenade_presshold = readbit(m_unit + 0x208, 13)	-- Confirmed. (True when holding right click, False when not)
				unit_actionkey_presshold = readbit(m_unit + 0x208, 14)	-- Confirmed. (True when holding action key,  False when not)
			--	emptyBit[1] 15
			
			--unkWord[2] 0x20A-0x20E related to first two words in unit_global_data
			--unit_shield_sapping = readchar(m_unit + 0x20E) -- () Always 0
			unit_base_seat_index = readchar(m_unit + 0x20F) -- From OS.
			--unit_time_remaining = readdword(m_unit + 0x210) -- () Always 0
			unit_flags = readdword(m_unit + 0x214) -- From OS. Bitmask32 (breakdown of this coming soon)
			unit_player_id = readident(m_unit + 0x218) -- Confirmed. Full DWORD ID of the Player.
			unit_ai_effect_type = readword(m_unit + 0x21C) -- From OS. ai_unit_effect
			unit_emotion_animation_index = readword(m_unit + 0x21E) -- From OS.
			unit_last_bullet_time = readdword(m_unit + 0x220) -- Confirmed. gameinfo_current_time - this = time since last shot fired. (1 second = 30 ticks) Related to unit_ai_effect_type. Lags immensely behind player_last_bullet_time.
			unit_x_facing = readfloat(m_unit + 0x224) -- Confirmed. Same as unit_x_aim.
			unit_y_facing = readfloat(m_unit + 0x228) -- Confirmed. Same as unit_y_aim.
			unit_z_facing = readfloat(m_unit + 0x22C) -- Confirmed. Same as unit_z_aim.
			unit_desired_x_aim = readfloat(m_unit + 0x230)	-- Confirmed. This is where the unit WANTS to aim.
			unit_desired_y_aim = readfloat(m_unit + 0x234)	-- Confirmed. This is where the unit WANTS to aim.
			unit_desired_z_aim = readfloat(m_unit + 0x238)	-- Confirmed. This is where the unit WANTS to aim.
			unit_x_aim = readfloat(m_unit + 0x23C) -- Confirmed.
			unit_y_aim = readfloat(m_unit + 0x240) -- Confirmed.
			unit_z_aim = readfloat(m_unit + 0x244) -- Confirmed.
			unit_x_aim_vel = readfloat(m_unit + 0x248) -- Confirmed. Does not apply to multiplayer bipeds
			unit_y_aim_vel = readfloat(m_unit + 0x24C) -- Confirmed. Does not apply to multiplayer bipeds
			unit_z_aim_vel = readfloat(m_unit + 0x250) -- Confirmed. Does not apply to multiplayer bipeds
			unit_x_aim2 = readfloat(m_unit + 0x254) -- Confirmed.
			unit_y_aim2 = readfloat(m_unit + 0x258) -- Confirmed.
			unit_z_aim2 = readfloat(m_unit + 0x25C) -- Confirmed.
			unit_x_aim3 = readfloat(m_unit + 0x260) -- Confirmed.
			unit_y_aim3 = readfloat(m_unit + 0x264) -- Confirmed.
			unit_z_aim3 = readfloat(m_unit + 0x268) -- Confirmed.
			--unit_x_aim_vel2 = readfloat(m_unit + 0x26C) -- () Always 0
			--unit_y_aim_vel2 = readfloat(m_unit + 0x26C) -- () Always 0
			--unit_z_aim_vel2 = readfloat(m_unit + 0x26C) -- () Always 0

			unit_forward = readfloat(m_unit + 0x278) -- Confirmed. Negative means backward. (-1, -sqrt(2)2, 0, sqrt(2)2, 1)
			unit_left = readfloat(m_unit + 0x27C) -- Confirmed. Negative means right. (-1, -sqrt(2)2, 0, sqrt(2)2, 1)
			unit_up = readfloat(m_unit + 0x280) -- Confirmed. Negative means down. (-1, -sqrt(2)2, 0, sqrt(2)2, 1) (JUMPINGFALLING DOESNT COUNT)
			unit_shooting = readfloat(m_unit + 0x284) -- Confirmed. (Shooting = 1, Not Shooting = 0)
			--unkByte[2] 0x288-0x28A melee related (state enum and counter)
			unit_time_until_flaming_death = readchar(m_unit + 0x28A) -- From OS (1 second = 30 ticks)
			--unkByte[2] 0x28B-0x28D looks like the amount of frames left for the ping animation. Also set to the same PersistentControlTicks value when an actor dies and they fire-wildly
			unit_throwing_grenade_state = readbyte(m_unit + 0x28D) -- Confirmed. (0 = not throwing) (1 = Arm leaning back) (2 = Grenade leaving hand) (3 = Grenade Thrown, going back to normal state)
			--unkWord[2] 0x28E-0x292 ()
			--Padding[2] 0x292-0x294
			unit_thrown_grenade_obj_id = readident(m_unit + 0x294) -- Confirmed. 0xFFFFFFFF when grenade leaves hand.
			--unkBit[16] -- () 0x298-0x29A -- From OS.
			--unit_action = readword(m_unit + 0x29A) -- Tested. Something to do with actions. (Crouching, throwing nade, walking) (animation index, weapon type)
			--unkWord[1] 0x29C-0x29E animation index
			--unkWord[1] 0x29E-0x2A0 appears unused except for getting initialized
			unit_crouch = readbyte(m_unit + 0x2A0) -- Confirmed. (Standing = 4) (Crouching = 3) (Vehicle = 0)
			unit_weap_slot = readbyte(m_unit + 0x2A1) -- Confirmed. Current weapon slot. (Primary = 0) (Secondary = 1) (Ternary = 2) (Quaternary = 3)
			unit_weap_index_type = readbyte(m_unit + 0x2A2) -- Tested. (0 = Rocket Launcher) (1 = Plasma Pistol) (2 = Shotgun) (3 = Plasma Rifle) don't care to continue
			unit_animation_state = readbyte(m_unit + 0x2A3) -- Confirmed. (0 = Idle, 1 = Gesture, Turn Left = 2, Turn Right = 3, Move Front = 4, Move Back = 5, Move Left = 6, Move Right = 7, Stunned Front = 8, Stunned Back = 9, Stunned Left = 10, Stunned Right = 11, Slide Front = 12, Slide Back = 13, Slide Left = 14, Slide Right = 15, Ready = 16, Put Away = 17, Aim Still = 18, Aim Move = 19, Airborne = 20, Land Soft = 21, Land Hard = 22,  = 23, Airborne Dead = 24, Landing Dead = 25, Seat Enter = 26, Seat Exit = 27, Custom Animation = 28, Impulse = 29, Melee = 30, Melee Airborne = 31, Melee Continuous = 32, Grenade Toss = 33, Resurrect Front = 34, Ressurect Back = 35, Feeding = 36, Surprise Front = 37, Surprise Back = 38, Leap Start = 39, Leap Airborne = 40, Leap Melee = 41, Unused AFAICT = 42, Berserk = 43)
			unit_reloadmelee = readbyte(m_unit + 0x2A4) -- Confirmed. (Reloading = 5) (Meleeing = 7)
			unit_shooting2 = readbyte(m_unit + 0x2A5) -- Confirmed. (Shooting = 1) (No = 0)
			unit_animation_state2 = readbyte(m_unit + 0x2A6) -- Confirmed. (0 = Idle, 1 = Gesture, Turn Left = 2, Turn Right = 3, Move Front = 4, Move Back = 5, Move Left = 6, Move Right = 7, Stunned Front = 8, Stunned Back = 9, Stunned Left = 10, Stunned Right = 11, Slide Front = 12, Slide Back = 13, Slide Left = 14, Slide Right = 15, Ready = 16, Put Away = 17, Aim Still = 18, Aim Move = 19, Airborne = 20, Land Soft = 21, Land Hard = 22,  = 23, Airborne Dead = 24, Landing Dead = 25, Seat Enter = 26, Seat Exit = 27, Custom Animation = 28, Impulse = 29, Melee = 30, Melee Airborne = 31, Melee Continuous = 32, Grenade Toss = 33, Resurrect Front = 34, Ressurect Back = 35, Feeding = 36, Surprise Front = 37, Surprise Back = 38, Leap Start = 39, Leap Airborne = 40, Leap Melee = 41, Unused AFAICT = 42, Berserk = 43)
			unit_crouch2 = readbyte(m_unit + 0x2A7) -- Confirmed. (Standing = 2) (Crouching = 3)
			--unkByte[2] 0x2A8-0x2AA ()
			--unit_ping_state_animation_index = readword(m_unit + 0x2AA) -- () Always 0xFFFF
			unit_ping_state_frame_index = readword(m_unit + 0x2AC) -- Tested. Counts up from 0 after you perform an action (reload, melee, etc) until it hits a random final number depending on action.
			--don't care enough to test these 4, if I don't know what above 2 are then there's no point.
			unit_unknown_state_animation_index = readword(m_unit + 0x2AE) -- From OS.
			unit_unknown_state_frame_index = readword(m_unit + 0x2B0) -- From OS.
			unit_fpweapon_state_animation_index = readword(m_unit + 0x2B2) -- From OS.
			unit_fpweapon_state_frame_index = readword(m_unit + 0x2B4) -- From OS.
			--unkByte[1] 0x2B6-0x2B7 () look related.
			--unkByte[1] 0x2B7-0x2B8 () aim related.
			unit_aim_rectangle_top_x = readfloat(m_unit + 0x2B8) -- Confirmed. Top-most aim possible.
			unit_aim_rectangle_bottom_x = readfloat(m_unit + 0x2BC) -- Confirmed. Bottom-most aim possible.
			unit_aim_rectangle_left_y = readfloat(m_unit + 0x2C0) -- Confirmed. Left-most aim possible.
			unit_aim_rectangle_right_y = readfloat(m_unit + 0x2C4) -- Confirmed. Right-most aim possible.
			unit_look_rectangle_top_x = readfloat(m_unit + 0x2C8) -- Confirmed. Top-most aim possible. Same as unit_aim_rectangle_top_x.
			unit_look_rectangle_bottom_x = readfloat(m_unit + 0x2CC) -- Confirmed. Bottom-most aim possible. Same as unit_aim_rectangle_bottom_x.
			unit_look_rectangle_left_y = readfloat(m_unit + 0x2D0) -- Confirmed. Left-most aim possible. Same as unit_aim_rectangle_left_y.
			unit_look_rectangle_right_y = readfloat(m_unit + 0x2D4) -- Confirmed. Right-most aim possible. Same as unit_aim_rectangle_right_y.
			--Padding[8] 0x2D8-0x2E0
			--unit_ambient = readfloat(m_unit + 0x2E0) -- () Always 0
			--unit_illumination = readfloat(m_unit + 0x2E4) -- ()
			unit_mouth_aperture = readfloat(m_unit + 0x2E8) -- From OS.
			--Padding[4] 0x2EC-0x2F0
			unit_vehi_seat = readword(m_unit + 0x2F0) -- Confirmed. (Warthog seats Driver = 0, Passenger = 1, Gunner = 2 Not in vehicle = 0xFFFF)
			unit_weap_slot2 = readword(m_unit + 0x2F2) -- Confirmed. Current weapon slot. (Primary = 0) (Secondary = 1) (Ternary = 2) (Quaternary = 3)
			unit_next_weap_slot = readword(m_unit + 0x2F4) -- Confirmed. Weapon slot the player is trying to change to. (Primary = 0) (Secondary = 1) (Ternary = 2) (Quaternary = 3)
			--unkByte[2] 0x2F6-0x2F8 (Padding Maybe)
				unit_next_weap_obj_id = readident(m_unit + 0x2F8 + unit_next_weap_slot4) -- Confirmed. Object ID of the weapon that the player is trying to change to.
			unit_primary_weap_obj_id = readident(m_unit + 0x2F8) -- Confirmed.
			unit_secondary_weap_obj_id = readident(m_unit + 0x2FC) -- Confirmed.
			unit_tertiary_weap_obj_id = readident(m_unit + 0x300) -- Confirmed.
			unit_quaternary_weap_obj_id = readident(m_unit + 0x304) -- Confirmed.
			unit_primaryWeaponLastUse = readdword(m_unit + 0x308) -- From DZS. gameinfo_current_time - this = time since this weapon was last swapped topicked up. (1 second = 30 ticks)
			unit_secondaryWeaponLastUse = readdword(m_unit + 0x30C) -- From DZS. gameinfo_current_time - this = time since this weapon was last swapped topicked up. (1 second = 30 ticks)
			unit_tertiaryWeaponLastUse = readdword(m_unit + 0x310) -- From DZS. gameinfo_current_time - this = time since this weapon was last swapped topicked up. (1 second = 30 ticks)
			unit_quaternaryWeaponLastUse = readdword(m_unit + 0x314) -- From DZS. gameinfo_current_time - this = time since this weapon was last swapped topicked up. (1 second = 30 ticks)
			unit_objective = readdword(m_unit + 0x318) -- Tested. Increases every time you interact with the objective.
			unit_current_nade_type = readchar(m_unit + 0x31C) -- Confirmed. (Frag = 0) (Plasma = 1)
			unit_next_nade_type = readbyte(m_unit + 0x31D) -- Confirmed. Grenade type the player is trying to change to. (Frag = 0) (Plasma = 1)
			unit_primary_nades = readbyte(m_unit + 0x31E) -- Confirmed. Amount of frag grenades you have.
			unit_secondary_nades = readbyte(m_unit + 0x31F) -- Confirmed. Amount of plasma grenades you have.
			unit_zoom_level = readbyte(m_unit + 0x320) -- Confirmed. The level of zoom the player is at. (0xFF = not zoomed, 0 = first zoom lvl, 1 = second zoom lvl, etc...)
			unit_desired_zoom_level = readbyte(m_unit + 0x321) -- Confirmed. Where the player wants to zoom. (0xFF = not zoomed, 0 = first zoom lvl, 1 = second zoom lvl, etc...)
			unit_vehicle_speech_timer = readchar(m_unit + 0x322) -- Tested. Counts up from 0 after reloading, shooting, or throwing nade.
			unit_aiming_change = readbyte(m_unit + 0x323) -- Tested. This is 'confirmed' except I don't know what units. Does not apply to multiplayer bipeds.
			unit_master_obj_id = readident(m_unit + 0x324) -- Confirmed. Object ID controlling this unit (driver)
			unit_masterofweapons_obj_id = readident(m_unit + 0x328) -- Confirmed. Object ID controlling the weapons of this unit (gunner)
			unit_passenger_obj_id = readident(m_unit + 0x32C) -- Confirmed for vehicles. 0xFFFFFFFF for bipeds
			unit_time_abandoned_parent = readdword(m_unit + 0x330) -- Confirmed. gameinfo_current_time - this = time since player ejected from vehicle.
			unit_some_obj_id = readident(m_unit + 0x334) -- From OS.
			unit_vehicleentry_scale = readfloat(m_unit + 0x338) -- Tested. Intensity of vehicle entry as you enter a vehicle (0 to 1)
			--unit_power_of_masterofweapons = readfloat(m_unit + 0x33C) -- () Always 0
			unit_flashlight_scale = readfloat(m_unit + 0x340) -- Confirmed. Intensity of flashlight as it turns on and off. (0 to 1) (On  0) (Off = 0)
			unit_flashlight_energy = readfloat(m_unit + 0x344) -- Confirmed. Amount of flashlight energy left. (0 to ~1)
			unit_nightvision_scale = readfloat(m_unit + 0x348) -- Confirmed. Intensity of nightvision as it turns on and off. (0 to 1) (On = 1) (Off = 0)
			--unkFloat[12] 0x34C-0x37C Seat-related
			unit_invis_scale = readfloat(m_unit + 0x37C) -- Confirmed. How invisible you are. (0 to 1) (Completely = 1) (None = 0)
			--unit_fullspectrumvision_scale = readfloat(m_unit + 0x380) -- () Always 0, even when picking up a fullspectrum vision.
			unit_dialogue_definition = readident(m_unit + 0x384) -- From OS.
			
			--SPEECH--
			--AI Current Speech
			unit_speech_priority = readword(m_unit + 0x388) -- From OS. (0 = None) (1 = Idle) (2 = Pain) (3 = Talk) (4 = Communicate) (5 = Shout) (6 = Script) (7 = Involuntary) (8 = Exclaim) (9 = Scream) (10 = Death)
			unit_speech_scream_type = readword(m_unit + 0x38A) -- From OS. (0 = Fear) (1 = Enemy Grenade) (2 = Pain) (3 = Maimed Limb) (4 = Maimed Head) (5 = Resurrection)
			unit_sound_definition = readident(m_unit + 0x38C) -- From OS.
			--unkWord[1] 0x390-0x392 time-related.
			--Padding[2] 0x392-0x394
			--unkLong[2] 0x394-0x39C ()
			--unkWord[1] 0x39C-0x39E ()
			unit_ai_current_communication_type = readword(m_unit + 0x39E) -- From OS. (0 = Death) (1 = Killing Spree) (2 = Hurt) (3 = Damage) (4 = Sighted Enemy) (5 = Found Enemy) (6 = Unexpected Enemy) (7 = Found dead friend) (8 = Allegiance Changed) (9 = Grenade Throwing) (10 = Grenade Startle) (11 = Grenade Sighted) (12 = Grenade Danger) (13 = Lost Contact) (14 = Blocked) (15 = Alert Noncombat) (16 = Search Start) (17 = Search Query) (18 = Search Report) (19 = Search Abandon) (20 = Search Group Abandon) (21 = Uncover Start) (22 = Advance) (23 = Retreat) (24 = Cover) (25 = Sighted Friend Player) (26 = Shooting) (27 = Shooting Vehicle) (28 = Shooting Berserk) (29 = Shooting Group) (30 = Shooting Traitor) (31 = Flee) (32 = Flee Leader Died) (33 = Flee Idle) (34 = Attempted Flee) (35 = Hiding Finished) (36 = Vehicle Entry) (37 = Vehicle Exit) (38 = Vehicle Woohoo) (39 = Vehicle Scared) (40 = Vehicle Falling) (41 = Surprise) (42 = Berserk) (43 = Melee) (44 = Dive) (45 = Uncover Exclamation) (46 = Falling) (47 = Leap) (48 = Postcombat Alone) (49 = Postcombat Unscathed) (50 = Postcombat Wounded) (51 = Postcombat Massacre) (52 = Postcombat Triumph) (53 = Postcombat Check Enemy) (54 = Postcombat Check Friend) (55 = Postcombat Shoot Corpse) (56 = Postcombat Celebrate)
			--unkWord[1] 0x3A0-0x3A2 ()
			--Padding[2] 0x3A2-0x3A4
			--unkWord[1] 0x3A4-0x3A6 ()
			--Padding[6] 0x3A6-0x3AC
			--unkWord[1] 0x3AC-0x3AE ()
			--Padding[2] 0x3AE-0x3B0
			--unkWord[2] 0x3B0-0x3B4 ()
			--	bitmask8
				unit_ai_current_communication_broken = readbit(m_unit + 0x3B4, 0) -- From OS. 1C false = reformed
			--	unkBit[7] 1-7 ()
			--Padding[3] 0x3B5-0x3B8
			
			--AI Next Speech (I think)
			unit_speech_priority2 = readword(m_unit + 0x3B8) -- From OS. (0 = None) (1 = Idle) (2 = Pain) (3 = Talk) (4 = Communicate) (5 = Shout) (6 = Script) (7 = Involuntary) (8 = Exclaim) (9 = Scream) (10 = Death)
			unit_speech_scream_type2 = readword(m_unit + 0x3BA) -- From OS. (0 = Fear) (1 = Enemy Grenade) (2 = Pain) (3 = Maimed Limb) (4 = Maimed Head) (5 = Resurrection)
			unit_sound_definition2 = readident(m_unit + 0x3BC) -- From OS.
			--unkWord[1] 0x3C0-0x3C2 time-related.
			--Padding[2] 0x3C2-0x3C4
			--unkLong[2] 0x3C4-0x3CC ()
			--unkWord[1] 0x3CC-0x3CE ()
			unit_ai_current_communication_type2 = readword(m_unit + 0x3CE) -- From OS. (0 = Death) (1 = Killing Spree) (2 = Hurt) (3 = Damage) (4 = Sighted Enemy) (5 = Found Enemy) (6 = Unexpected Enemy) (7 = Found dead friend) (8 = Allegiance Changed) (9 = Grenade Throwing) (10 = Grenade Startle) (11 = Grenade Sighted) (12 = Grenade Danger) (13 = Lost Contact) (14 = Blocked) (15 = Alert Noncombat) (16 = Search Start) (17 = Search Query) (18 = Search Report) (19 = Search Abandon) (20 = Search Group Abandon) (21 = Uncover Start) (22 = Advance) (23 = Retreat) (24 = Cover) (25 = Sighted Friend Player) (26 = Shooting) (27 = Shooting Vehicle) (28 = Shooting Berserk) (29 = Shooting Group) (30 = Shooting Traitor) (31 = Flee) (32 = Flee Leader Died) (33 = Flee Idle) (34 = Attempted Flee) (35 = Hiding Finished) (36 = Vehicle Entry) (37 = Vehicle Exit) (38 = Vehicle Woohoo) (39 = Vehicle Scared) (40 = Vehicle Falling) (41 = Surprise) (42 = Berserk) (43 = Melee) (44 = Dive) (45 = Uncover Exclamation) (46 = Falling) (47 = Leap) (48 = Postcombat Alone) (49 = Postcombat Unscathed) (50 = Postcombat Wounded) (51 = Postcombat Massacre) (52 = Postcombat Triumph) (53 = Postcombat Check Enemy) (54 = Postcombat Check Friend) (55 = Postcombat Shoot Corpse) (56 = Postcombat Celebrate)
			--unkWord[1] 0x3D0-0x3D2 ()
			--Padding[2] 0x3D2-0x3D4
			--unkWord[1] 0x3D4-0x3D6 ()
			--Padding[6] 0x3D6-0x3DC
			--unkWord[1] 0x3DC-0x3DE ()
			--Padding[2] 0x3DE-0x3E0
			--unkWord[2] 0x3E0-0x3E4 ()
			--	bitmask8
				unit_ai_current_communication_broken2 = readbit(m_unit + 0x3E4, 0) -- From OS. 1C false = reformed
			--	unkBit[7] 1-7 ()
			--Padding[3] 0x3E5-0x3E8
			
			--unkWord[4] 0x3E8-0x3F0
			--unkLong[1] 0x3F0 time related
			--unkBit[32] 0x3F4-0x3F8 0-31 ()
			--unkWord[4] 0x3F8-0x400 ()
			--unkLong[1] 0x400-0x404 ()
			--END OF SPEECH--
			
			unit_damage_type = readword(m_unit + 0x404) -- Tested. (Not being damaged = 0) (Being damaged = 2) (Enum here)
			--unit_damage2 = readword(m_unit + 0x406) -- Tested. Changes when damaged. Changes back.
			--unit_damage3 = readfloat(m_unit + 0x408) -- Tested. Changes when damaged. Changes back.
			unit_causing_objId = readident(m_unit + 0x40C) -- Confirmed. ObjId causing damage to this object.
			--unit_flamer_causer_objId = readident(m_unit + 0x410) -- () Always 0xFFFFFFFF
			--Padding[8] 0x414-0x41C
			--unit_death_time = readdword(m_unit + 0x41C) -- () Always 0xFFFFFFFF
			--unit_feign_death_timer = readword(m_unit + 0x420) -- () Always 0xFFFFFFFF
			unit_camo_regrowth = readword(m_unit + 0x422) -- Confirmed. (1 = Camo Failing due to damageshooting)
			--unit_stun_amount = readfloat(m_unit + 0x424) -- () Always 0
			--unit_stun_timer = readword(m_unit + 0x428) -- () Always 0
			unit_killstreak = readword(m_unit + 0x42A) -- Tested. Same as player_killstreak.
			unit_last_kill_time = readdword(m_unit + 0x42C) -- Confirmed. gameinfo_current_time - this = time since last kill time. (1 sec = 30 ticks)
			
			--I realize the below are confusing, and if you really don't understand them after looking at it, I will explain it if you contact me about them
			--I have no idea why halo stores these, only thing I can think of is because of betrayals or something.. but still..
			unit_last_damage_time_by_mostrecent_objId = readdword(m_unit + 0x430) -- Confirmed. gameinfo_current_time - this = Time since last taken damage by MOST RECENT object. (1 second = 30 ticks)
			unit_total_damage_by_mostrecent_objId = readfloat(m_unit + 0x434) -- Confirmed. Total damage done by the MOST RECENT PLAYER (NOT TOTAL DAMAGE TO EVERYONE)
			unit_damage_mostrecent_causer_objId = readident(m_unit + 0x438) -- Confirmed. the MOST RECENT object ID to do damage to this object (or 0xFFFFFFFF)
			unit_damage_mostrecent_causer_playerId = readident(m_unit + 0x43C) -- Confirmed. Full DWORD ID of the MOST RECENT PLAYER to do damage to this object.. (AI = 0xFFFFFFFF)
			unit_last_damage_time_by_secondtomostrecent_obj = readdword(m_unit + 0x440) -- Confirmed. gameinfo_current_time - this = Time since last taken damage by the SECOND TO MOST RECENT object. (1 second = 30 ticks)
			unit_total_damage_by_secondtomostrecent_obj = readfloat(m_unit + 0x444) -- Confirmed. Total damage done by the SECOND TO MOST RECENT PLAYER (NOT TOTAL DAMAGE TO EVERYONE)
			unit_damage_secondtomostrecent_causing_objId = readident(m_unit + 0x448) -- Confirmed. the SECOND TO MOST RECENT object ID to do damage to this object (or 0xFFFFFFFF)
			unit_damage_secondtomostrecent_causing_playerId = readident(m_unit + 0x44C) -- Confirmed. Full DWORD ID of the SECOND TO MOST RECENT PLAYER to do damage to this object.. (AI = 0xFFFFFFFF)
			unit_last_damage_time_by_thirdtomostrecent_obj = readdword(m_unit + 0x450) -- Confirmed. gameinfo_current_time - this = Time since last taken damage by the THIRD TO MOST RECENT object. (1 second = 30 ticks)
			unit_total_damage_by_thirdtomostrecent_obj = readfloat(m_unit + 0x454) -- Confirmed. Total damage done by the THIRD TO MOST RECENT PLAYER (NOT TOTAL DAMAGE TO EVERYONE)
			unit_damage_thirdtomostrecent_causing_objId = readident(m_unit + 0x458) -- Confirmed. the THIRD TO MOST RECENT object ID to do damage to this object (or 0xFFFFFFFF)
			unit_damage_thirdtomostrecent_causing_playerId = readident(m_unit + 0x45C) -- Confirmed. Full DWORD ID of the THIRD TO MOST RECENT PLAYER to do damage to this object.. (AI = 0xFFFFFFFF)
			unit_last_damage_time_by_fourthtomostrecent_obj = readdword(m_unit + 0x460) -- Confirmed. gameinfo_current_time - this = Time since last taken damage by the FOURTH TO MOST RECENT object. (1 second = 30 ticks)
			unit_total_damage_by_fourthtomostrecent_obj = readfloat(m_unit + 0x464) -- Confirmed. Total damage done by the FOURTH TO MOST RECENT PLAYER (NOT TOTAL DAMAGE TO EVERYONE)
			unit_damage_fourthtomostrecent_causing_objId = readident(m_unit + 0x468) -- Confirmed. the FOURTH TO MOST RECENT object ID to do damage to this object (or 0xFFFFFFFF)
			unit_damage_fourthtomostrecent_causing_playerId = readident(m_unit + 0x46C) -- Confirmed. Full DWORD ID of the FOURTH TO MOST RECENT PLAYER to do damage to this object.. (AI = 0xFFFFFFFF)
			--Padding[4] 0x470-0x474
			unit_shooting3 = readbyte(m_unit + 0x474) -- Confirmed. (Shooting = 1) (No = 0) 'unused'
			--unkByte[1] 0x475-0x476 () 'unused'
			--Padding[2] 0x476-0x478
			--unit_animation_state3 = readbyte(m_unit + 0x478) -- () Always 3
			--unit_aiming_speed2 = readbyte(m_unit + 0x479) -- () Always 0
			--	Client Action Keypress bitmask32 (Instantaneous actions).
				unit_crouch2_presshold = readbit(m_unit + 0x47A, 0) -- Confirmed. (True when holding crouch, False when not)
				unit_jump2_presshold = readbit(m_unit + 0x47A, 1)	-- Confirmed. (True when holding jump key, False when not)
			--	unit_user1_2 = readbit(m_unit + 0x47A, 3) -- () Always false
			--	unit_user2_2 = readbit(m_unit + 0x47A, 4) -- () Always false
				unit_flashlightkey2 = readbit(m_unit + 0x47A, 4)-- Confirmed. (True when pressing flashlight key, False when not)
			--	unit_exact_facing2 = readbit(m_unit + 0x47A, 5) -- () Always false
				unit_actionkey2 = readbit(m_unit + 0x47A, 6)	-- Confirmed. (True when pressing action key, False when not)
				unit_meleekey2 = readbit(m_unit + 0x47A, 7)		-- Confirmed. (True when pressing melee key, False when not)
			--	unit_look_without_turn2 = readbit(m_unit + 0x47A, 8) -- () Always false
			--	unit_force_alert2 = readbit(m_unit + 0x47A, 9) -- () Always false
				unit_reload_key2 = readbit(m_unit + 0x47A, 10)	-- Confirmed. (True when pressing actionreload key, False when not)
				unit_primaryWeaponFire_presshold2 = readbit(m_unit + 0x47A, 11)	-- Confirmed. (True when holding left click, False when not)
				unit_secondaryWeaponFire_presshold2 = readbit(m_unit + 0x47A, 12)	-- Confirmed. (True when holding right click, False when not)
				unit_grenade_presshold2 = readbit(m_unit + 0x47A, 13)	-- Confirmed. (True when holding right click, False when not)
				unit_actionkey_presshold2 = readbit(m_unit + 0x47A, 14)	-- Confirmed. (True when holding action key,  False when not)
			--	emptyBit[1] 15
			unit_weap_slot3 = readbyte(m_unit + 0x47C) -- Confirmed. (Primary = 0) (Secondary = 1) (Ternary = 2) (Quaternary = 3)
			unit_nade_type = readbyte(m_unit + 0x47E) -- Confirmed. (Frag = 0) (Plasma = 1)
			unit_zoom_level2 = readword(m_unit + 0x480) -- Confirmed. The level of zoom the player is at. (0xFFFF = not zoomed, 0 = first zoom lvl, 1 = next zoom lvl, etc...)
			--Padding[2] 0x482-0x484
			unit_x_vel2 = readfloat(m_unit + 0x484) -- Confirmed.
			unit_y_vel2 = readfloat(m_unit + 0x488) -- Confirmed.
			unit_z_vel2 = readfloat(m_unit + 0x48C) -- Confirmed.
			unit_primary_trigger = readfloat(m_unit + 0x490) -- Confirmed. (1 = Holding down primaryFire button) (0 = not firing) Doesn't necessarily mean unit is shooting.
			unit_x_aim4 = readfloat(m_unit + 0x494) -- Confirmed.
			unit_y_aim4 = readfloat(m_unit + 0x498) -- Confirmed.
			unit_z_aim4 = readfloat(m_unit + 0x49C) -- Confirmed.
			unit_x_aim5 = readfloat(m_unit + 0x4A0) -- Confirmed.
			unit_y_aim5 = readfloat(m_unit + 0x4A4) -- Confirmed.
			unit_z_aim5 = readfloat(m_unit + 0x4A8) -- Confirmed.
			unit_x_aim6 = readfloat(m_unit + 0x4AC) -- Confirmed.
			unit_y_aim6 = readfloat(m_unit + 0x4B0) -- Confirmed.
			unit_z_aim6 = readfloat(m_unit + 0x4B4) -- Confirmed.
			--	bitmask32
				unit_last_completed_client_update_id_valid = readbit(m_unit + 0x4B8, 0) -- From OS.
			--	unkBit[31] 1-31 ()
			unit_last_completed_client_update_id = readdword(m_unit + 0x4BC) -- From OS.
			--Padding[12] 0x4C0-0x4CC unused.
		end
		
		if obj_type == 0 then -- check if object is a biped.
		
			-- Biped Struct. Definition is a two legged creature, but applies to ALL AI and all players.
			m_biped = m_object
			
			--	bitmask32
				bipd_is_airborne = readbit(m_biped + 0x4CC, 0) -- Confirmed. (Airborne = True, No = False)
			--	bipd_is_slipping = readbit(m_biped + 0x4CC, 1) -- () Always False
			--	unkBit[30] 2-31
			--unkByte[1] 0x4D0 () 1
			--unkByte[2] 0x4D1 ()
			bipd_movement_state = readbyte(m_biped + 0x4D2) -- Confirmed. (Standing = 0) (Walking = 1) (IdleTurning = 2) (Gesturing = 3)
			--unkByte[5] 0x4D3-0x4D8 (Padding Maybe)
			bipd_action = readbyte(m_biped + 0x4D8) -- Tested. Something to do with walking and jumping.
			--unkByte[1] 0x4D9-0x4DA (Padding Maybe)
			bipd_action2 = readbyte(m_biped + 0x4DA) -- Tested. Something to do with walking and jumping.
			--unkByte[5] 0x4DB ()
			bipd_x_coord = readfloat(m_biped + 0x4E0) -- Confirmed.
			bipd_y_coord = readfloat(m_biped + 0x4E4) -- Confirmed.
			bipd_z_coord = readfloat(m_biped + 0x4E8) -- Confirmed.
			--unkLong[4] 0x4EC-0x4FC ()
			bipd_bumped_obj_id = readident(m_biped + 0x4FC) -- Confirmed. Object ID of any object you bump into (rocks, weapons, players, vehicles, ANY object)
			bipd_time_since_last_bump = readchar(m_biped + 0x500) -- Tested. Counts backwards from 0 to -15 when bumped. Glitchy. Don't rely on this.
			bipd_airborne_time = readchar(m_biped + 0x501) -- Confirmed. (1 sec = 30 ticks)
			--bipd_slipping_time = readchar(m_biped + 0x502) -- () Always 0
			--unkChar[1] 0x503-0x504 ()
			bipd_jump_time = readchar(m_biped + 0x504) -- Tested. Counts up from 0 after landing from a jump, and returns to 0 after you hit the ground (1 sec = 30 ticks).
			--unkChar[2] 0x505-0x507 sbyte timer, melee related.
			--Padding[1] 0x507-0x508
			--unkWord[1] 0x508-0x50A ()
			--Padding[2] 0x50A-0x50C
			bipd_crouch_scale = readfloat(m_biped + 0x50C) -- Confirmed. How crouched you are. (0 to 1) (Crouching = 1) (Standing = 0)
			--unkFloat[1] 0x510-0x514 ()
			--unk_realPlane3d[1] 0x514-0x524 physics related (xyzd)
			--unkChar[2] 0x524-0x526 ()
			--	bitmask8
				bipd_baseline_valid = readbit(m_biped + 0x526, 0) -- From OS.
			--	unkBit[7] 1-7 ()
			bipd_baseline_index = readchar(m_biped + 0x527) -- From OS.
			bipd_message_index = readchar(m_biped + 0x528) -- From OS.
			--Padding[3] 0x529-0x52C
			
			--	baseline update
			bipd_primary_nades = readbyte(m_biped + 0x52C) -- Confirmed. Number of frag grenades.
			bipd_secondary_nades = readbyte(m_biped + 0x52D) -- Confirmed. Number of plasma grenades.
			--Padding[2] 0x52E-0x530
			bipd_health = readfloat(m_biped + 0x530) -- Confirmed. (0 to 1). Lags behind obj_health.
			bipd_shield = readfloat(m_biped + 0x534) -- Confirmed. (0 to 1). Lags behind obj_health.
			--	bitmask8
				bipd_shield_stun_time_greater_than_zero = readbit(m_biped + 0x538, 0) -- From OS.
			--	unkBit[7] 1-7 ()
			--Padding[3] 0x539-0x53C
			--	bitmask8
			--	unkBit[8] 0x53C 0-7 ()
			--Padding[3] 0x53D-0x540
			
			--	delta update
			--bipd_primary_nades2 = readbyte(m_biped + 0x540) -- () Always 0
			--bipd_secondary_nades2 = readbyte(m_biped + 0x541) -- () Always 0
			--Padding[2] 0x542-0x544
			--bipd_health2 = readfloat(m_biped + 0x544) -- () Always 0 (0 to 1)
			--bipd_shield2 = readfloat(m_biped + 0x548) -- () Always 0 (0 to 1)
			--	bitmask8
				bipd_shield_stun_time_greater_than_zero2 = readbit(m_biped + 0x54C, 0) -- From OS.
			--	unkBit[7] 1-7 ()
			--Padding[3] 0x54D-0x550
			
			--these are all just friggin rediculous...
			function getBodyPart(address, offset)
				address = address + (offset or 0x0)
				local bodypart = {}
				--this puts unknown floats in the table.
				--accessed by hprintf(bodypart.unkfloat1) hprintf(bodypart.unkfloat2) etc...
				for i = 0,9 do
					bodypart[unkfloat..i+1] = readfloat(address + i4) -- () Probably rotations.
				end
				--accessed by hprintf(bodypart.x) hprintf(bodypart.y) etc...
				bodypart.x = readfloat(address + 0x28) -- Confirmed.
				bodypart.y = readfloat(address + 0x2C) -- Confirmed.
				bodypart.z = readfloat(address + 0x30) -- Confirmed.
				return bodypart
			end
			
			function getBodyPartLocation(address, offset)
				address = address + (offset or 0x0)
				--unkFloats[10] () Probably rotations.
				bipd_bodypart_x = readfloat(m_biped + 0x28)
				bipd_bodypart_y = readfloat(m_biped + 0x2C)
				bipd_bodypart_z = readfloat(m_biped + 0x30)
				return bipd_bodypart_x,bipd_bodypart_y,bipd_bodypart_z
			end

			--All of these are from SuperAbyll.
			--getBodyPart returns a table full of x,y,z coords + unknown floats
			--getBodyPartLocation returns 3 values (x, y, and z coordinates)
			bipd_left_thigh = getBodyPart(m_biped + 0x550)
				--if you just want the coordinates, you can do this instead for each bodypart
				x,y,z = getBodyPartLocation(m_biped + 0x550) -- XYZ coordinates for the left thigh.
			bipd_right_thigh = getBodyPart(m_biped + 0x584)
			bipd_pelvis = getBodyPart(m_biped + 0x5B8)
			bipd_left_calf = getBodyPart(m_biped + 0x5EC)
			bipd_right_calf = getBodyPart(m_biped + 0x620)
			bipd_spine = getBodyPart(m_biped + 0x654)
			bipd_left_clavicle = getBodyPart(m_biped + 0x688)
			bipd_left_foot = getBodyPart(m_biped + 0x6BC)
			bipd_neck = getBodyPart(m_biped + 0x6F0)
			bipd_right_clavicle = getBodyPart(m_biped + 0x724)
			bipd_right_foot = getBodyPart(m_biped + 0x758)
			bipd_head = getBodyPart(m_biped + 0x78C)
			bipd_left_upper_arm = getBodyPart(m_biped + 0x7C0)
			bipd_right_upper_arm = getBodyPart(m_biped + 0x7F4)
			bipd_left_lower_arm = getBodyPart(m_biped + 0x828)
			bipd_right_lower_arm = getBodyPart(m_biped + 0x85C)
			bipd_left_hand = getBodyPart(m_biped + 0x890)
			bipd_right_hand = getBodyPart(m_biped + 0x8C4)
			
			--The coordinates from these can be accessed doing the following
			--let's say I want to tell the whole server the y coordinate of this object's right foot. I would do say(bipd_right_foot.y)
			say(bipd_right_foot.y) -- SERVER 52.7130341548629
		
		elseif obj_type == 1 then -- check if object is a vehicle
		
			-- vehi struct
			-- Thank you 002 and shaft for figuring out that there's a struct here
			--	bitmask16
			--	unkBit[2] 0x4CC 0-1
			vehi_crouch = readbit(m_vehicle + 0x4CC, 2)
			vehi_jump = readbit(m_vehicle + 0x4CC, 3)
			--	unkBit[4] 0x4CC 4-7
			--unkWord[1] 0x4CE
			--unkByte[4] 0x4D0-0x4D4
			vehi_speed = readfloat(m_vehicle + 0x4D4)
			vehi_slide = readfloat(m_vehicle + 0x4D8)
			vehi_turn = readfloat(m_vehicle + 0x4DC)
			vehi_tireposition = readfloat(m_vehicle + 0x4E0)
			vehi_treadpositionleft = readfloat(m_vehicle + 0x4E4)
			vehi_treadpositionright = readfloat(m_vehicle + 0x4E8)
			vehi_hover = readfloat(m_vehicle + 0x4EC)
			vehi_thrust = readfloat(m_vehicle + 0x4F0)
			--unkByte[4] 0x4F4-0x4F8 something to do with suspension states... enum
			vehi_hoveringposition_x = readfloat(m_vehicle + 0x4FC)
			vehi_hoveringposition_y = readfloat(m_vehicle + 0x500)
			vehi_hoveringposition_z = readfloat(m_vehicle + 0x504)
			--unkLong[7] 0x508-0x524
			--	bitmask16
				vehi_networkTimeValid = readbit(m_vehicle + 0x524, 0)
			--	unkBit[7] 1-7
				vehi_baselineValid = readbit(m_vehicle + 0x524, 8)
			--	unkBit[7] 9-15
			vehi_baselineIndex = readbyte(m_vehicle + 0x526)
			vehi_messageIndex = readbyte(m_vehicle + 0x527)
			--	bitmask32
				vehi_at_rest = readbit(m_vehicle + 0x528, 0)
			--	unkBit[30] 1-31
			vehi_x_coord = readfloat(m_vehicle + 0x52C)
			vehi_y_coord = readfloat(m_vehicle + 0x530)
			vehi_z_coord = readfloat(m_vehicle + 0x534)
			vehi_x_vel = readfloat(m_vehicle + 0x538)
			vehi_y_vel = readfloat(m_vehicle + 0x53C)
			vehi_z_vel = readfloat(m_vehicle + 0x540)
			vehi_x_aim_vel = readfloat(m_vehicle + 0x544)
			vehi_y_aim_vel = readfloat(m_vehicle + 0x548)
			vehi_z_aim_vel = readfloat(m_vehicle + 0x54C)
			vehi_pitch = readfloat(m_vehicle + 0x550)
			vehi_yaw = readfloat(m_vehicle + 0x554)
			vehi_roll = readfloat(m_vehicle + 0x558)
			vehi_x_scale = readfloat(m_vehicle + 0x55C)
			vehi_y_scale = readfloat(m_vehicle + 0x560)
			vehi_z_scale = readfloat(m_vehicle + 0x564)
			--Padding[4] 0x568-0x56C
			vehi_x_coord2 = readfloat(m_vehicle + 0x56C)
			vehi_y_coord2 = readfloat(m_vehicle + 0x570)
			vehi_z_coord2 = readfloat(m_vehicle + 0x574)
			vehi_x_vel2 = readfloat(m_vehicle + 0x578)
			vehi_y_vel2 = readfloat(m_vehicle + 0x57C)
			vehi_z_vel2 = readfloat(m_vehicle + 0x580)
			vehi_x_aim_vel2 = readfloat(m_vehicle + 0x584)
			vehi_y_aim_vel2 = readfloat(m_vehicle + 0x588)
			vehi_z_aim_vel2 = readfloat(m_vehicle + 0x58C)
			vehi_pitch2 = readfloat(m_vehicle + 0x590)
			vehi_yaw2 = readfloat(m_vehicle + 0x594)
			vehi_roll2 = readfloat(m_vehicle + 0x598)
			vehi_x_scale2 = readfloat(m_vehicle + 0x59C)
			vehi_y_scale2 = readfloat(m_vehicle + 0x5A0)
			vehi_z_scale2 = readfloat(m_vehicle + 0x5A4)
			--Padding[4] 0x5A8-0x5AC
			vehi_some_timer = readdword(m_vehicle + 0x5AC) -- Untested. 0xFFFFFFFF if vehicle not active.

			--block index of the scenario datum used for respawning
			--For all game engines besides race, this will be a scenario vehicle datum
			--For race, it's a scenario_netpoint, aka scenario_netgame_flags_block
			vehi_respawn_timer = readword(m_vehicle + 0x5B0) -- Confirmed. (1 sec = 30 ticks)
			--Padding[2] 0x5B2-0x5B4
			vehi_some_x_coord = readfloat(m_vehicle + 0x5B4) -- ()
			vehi_some_y_coord = readfloat(m_vehicle + 0x5B8) -- ()
			vehi_some_z_coord = readfloat(m_vehicle + 0x5BC) -- ()
		end

	--server network struct
	network_machine_pointer = readdword(network_struct) -- Confirmed.
	network_state = readword(network_struct + 0x4) -- Confirmed. (Inactive = 0, Game = 1, Results = 2)
	--unkWord[1] 0x6 ()
	network_name = readwidestring(network_struct + 0x8, 0x42) -- Confirmed. Current server name.
	--unkWord[3] 0x86 (Padding Maybe)
	network_current_map = readstring(network_struct + 0x8C, 0x80) -- Confirmed. Current map the server is currently running.
	network_current_gametype = readwidestring(network_struct + 0x10C, 0x18) -- Confirmed. Current gametype that the server is currently running.
	--	partial of Gametype need to break them down.
	--	unkByte[39] ()
	--	unkFloat[1] 0x160 () Always 1.
	network_score_limit = readbyte(network_struct + 0x164) -- Confirmed. Current score limit for gametype. (1 second = 30 ticks)
	--Padding[3] 0x165
	local ce = 0x0
	if game == CE then
		--This exists in CE but not PC, therefore making the struct size larger in CE.
		--unkByte[64] 0x168 ()
		ce = 0x40
	end
	--unkFloat[1] 0x1A0+ce () --0xBAADF00D (lol)
	network_max_players = readbyte(network_struct + (0x1A5+ce)) -- Confirmed. The maximum amount of players allowed to join the server (sv_maxplayers)
	network_difficulty_level = readword(network_struct + (0x1A6+ce)) -- Tested. For SP only. Always 1 for server.
	network_player_count = readword(network_struct + (0x1A8+ce)) -- Confirmed. Total number of players currently in the server.
	--	client network struct
		client_struct_size = 0x20 -- Confirmed.
		client_network_struct = network_struct + 0x1AA+ce + player  client_struct_size -- Strange. It starts in the middle of the dword.
		client_name = readwidestring(client_network_struct, 12) -- Confirmed. Name of player.
		client_color = readword(client_network_struct + 0x18) -- Confirmed. Color of the player (ffa gametypes only.) (0 = white) (1 = black) (2 = red) (3 = blue) (4 = gray) (5 = yellow) (6 = green) (7 = pink) (8 = purple) (9 = cyan) (10 = cobalt) (11 = orange) (12 = teal) (13 = sage) (14 = brown) (15 = tan) (16 = maroon) (17 = salmon)
		client_icon_index = readword(client_network_struct + 0x1A) -- From OS.
		client_machine_index = readbyte(client_network_struct + 0x1C) -- Confirmed. Player machine index (or rconId - 1)
		client_status = readbyte(client_network_struct + 0x1D) -- From Phasor. (1 = Genuine, 2 = Invalid hash (or auth, or we))
		client_team = readbyte(client_network_struct + 0x1E) -- Confirmed. (0 = red) (1 = blue)
		client_player_id = readbyte(client_network_struct + 0x1F) -- Confirmed. Player memory idindex (0 - 15) (To clarify this IS the 'player' argument passed to phasor functions)
	--Padding[2] 0x3AA+ce
	network_game_random_seed = readdword(network_struct + (0x3AC+ce)) -- Tested.
	network_games_played = readdword(network_struct + (0x3B0+ce)) -- Confirmed. Total number of games played. (First game = 1, Second game = 2, etc..)
	network_local_data = readdword(network_struct + (0x3B4+ce)) -- From OS.
	--	client_machine_info struct
		client_machineinfo_size = 0x60
		if game == CE then
			client_machineinfo_size = 0xEC
		end
		client_machineinfo_struct = network_struct + 0x3B8+ce + player  client_machineinfo_size
		client_connectioninfo_pointer = readdword(client_machineinfo_struct) -- From Phasor.
	--	Padding[8] 0x4
		client_machine_index = readword(client_machineinfo_struct + 0xC) -- Confirmed. Player machine index (or rconId - 1)
	--	unkWord[1] 0xE (Padding Maybe)
		client_machine_unknown = readword(client_machineinfo_struct + 0x10) -- From DZS. First is 1, then 3, then 7 and back to 0 if not in used (1 is found during the CD Hash Check, 7 if currently playing the game)
	--	unkWord[1] 0x12 (Padding Maybe)
	--	unkLong[2] 0x14 ()
	--	unkLong[1] 0x1C () most of the time 1, but sometimes changes to 2 for a moment.
	--	unkLong[1] 0x20 ()
	--		action bitmask 16
			client_crouch = readbit(client_machineinfo_struct + 0x24, 0) -- From DZS.
			client_jump = readbit(client_machineinfo_struct + 0x24, 1) -- From DZS.
			client_flashlight = readbit(client_machineinfo_struct + 0x24, 2) -- From DZS.
	--		unkBit[5] 3-7
			client_reload = readbit(client_machineinfo_struct + 0x24, 8) -- From DZS.
			client_fire = readbit(client_machineinfo_struct + 0x24, 9) -- From DZS.
			client_actionkey = readbit(client_machineinfo_struct + 0x24, 10) -- From DZS.
			client_grenade = readbit(client_machineinfo_struct + 0x24, 11) -- From DZS.
	--		unkBit[4] 12-15
	--	unkWord[1] 0x26 (Padding Maybe)
		client_yaw = readfloat(client_machineinfo_struct + 0x28) -- From DZS.
		client_pitch = readfloat(client_machineinfo_struct + 0x2C) -- From DZS.
		client_roll = readfloat(client_machineinfo_struct + 0x30) -- From DZS.
	--	unkByte[8] 0x34 ()
		client_forwardVelocityMultiplier = readfloat(client_machineinfo_struct + 0x3C) -- From DZS.
		client_horizontalVelocityMultiplier = readfloat(client_machineinfo_struct + 0x40) -- From DZS.
		client_ROFVelocityMultiplier = readfloat(client_machineinfo_struct + 0x44) -- From DZS.
		client_weap_type = readword(client_machineinfo_struct + 0x48) -- Confirmed. (Primary = 0, Secondary = 1, Tertiary = 2, Quaternary = 3)
		client_nade_type = readword(client_machineinfo_struct + 0x4A) -- Confirmed. (Frag Grenades = 0, Plasma Grenades = 1)
		--unkWord[1] 0x4C The index is -1 if no choices are even available.
		--unkWord[2] 0x4E
		client_machine_encryption_key = readstring(client_machineinfo_struct + 0x52, 0xA) -- From Phasor. Used for encrypting packets.
		client_machineNum = readdword(client_machineinfo_struct + 0x5C) -- From Phasor. 0 - 0xFFFFFFFF Increased for each connection in server's life.
		if game == CE then
			client_last_player_name = readstring(client_machineinfo_struct + 0x60) -- Confirmed. Changes to the player name when they quit. (Could be useful for BOS if PC had this too )
			client_machine_ip_address = readstring(client_machineinfo_struct + 0x80, 32) -- From Phasor.
			client_machine_player_cdhash = readstring(client_machineinfo_struct + 0xA0, 32) -- From Phasor.
			--unkByte[76] 0xC0 () Maybe Padding Nothing here. Possibly was going to be used for something else
		end
		
	-- machine struct
	--I've found two methods of getting this struct D
	local method = 1
	if method == 1 then
		machine_base = readdword(network_machine_pointer) -- Confirmed.
		machine_table = machine_base + 0xAA0 -- Confirmed. Player machine table
		machine_struct = readdword(machine_table + player_machine_index4) -- Confirmed. Player machine struct
	elseif method == 2 then
		--This is the way most server apps do it (including Phasor) since it's less lines of code.
		machine_table = readdword(client_connectioninfo_pointer)
		machine_struct = readdword(machine_table)
		machine_network = readdword(machine_network)
	end
	machine_player_first_ip_byte = readbyte(machine_struct) -- Confirmed. 127 if host.
	machine_player_second_ip_byte = readbyte(machine_struct + 0x1) -- Confirmed. 0 if host.
	machine_player_third_ip_byte = readbyte(machine_struct + 0x2) -- Confirmed. 0 if host.
	machine_player_fourth_ip_byte = readbyte(machine_struct + 0x3) -- Confirmed. 1 if host.
	machine_player_ip_address = string.format(%i.%i.%i.%i, machine_player_first_ip_byte, machine_player_second_ip_byte, machine_player_third_ip_byte, machine_player_fourth_ip_byte) -- Player's IP Address (127.0.0.1 if host)
	machine_player_port = readword(machine_struct + 0x4) -- Confirmed. Usually 2303.
		
		-- addressoffset checker
		--hprintf(---)

		--[[local offset = 0x0

		while offset  camera_size do

			if readbyte(camera_base, offset) ~= nil then
				hprintf(string.format(%X, offset) ..  -  .. readbyte(camera_base, offset))
			end

			offset = offset + 0x1

		end]]--
	end
end

function OnObjectCreation(m_objectId)
	local m_object = getobject(m_objectId)
	if m_object then
		local obj_type = readword(m_object + 0xB4)
		if obj_type == 2 or obj_type == 3 or obj_type == 4 then
			-- item struct
			-- This applies to equipment, weapons, and garbage only.
			item_struct = m_object
			
			--	bitmask32
				item_in_inventory = readbit(item_struct + 0x1F4, 0) -- From OS.
			--	unkBit[31] 1-31 (Padding Maybe)
			item_detonation_countdown = readword(item_struct + 0x1F8) -- Confirmed. (1 sec = 30 ticks)
			item_collision_surface_index = readword(item_struct + 0x1FA) -- From OS.
			item_structure_bsp_index = readword(item_struct + 0x1FC) -- From OS.
			--Padding[2] 0x1FE-0x200
			item_unknown_obj_id = readident(item_struct + 0x200)
			item_last_update_time = readdword(item_struct + 0x204) -- From OS.
			item_unknown_obj_id2 = readident(item_struct + 0x208)
			item_unknown_x_coord = readfloat(item_struct + 0x20C)
			item_unknown_y_coord = readfloat(item_struct + 0x210)
			item_unknown_z_coord = readfloat(item_struct + 0x214)
			item_unknown_x_vel = readfloat(item_struct + 0x218)
			item_unknown_y_vel = readfloat(item_struct + 0x21C)
			item_unknown_z_vel = readfloat(item_struct + 0x220)
			item_unknown_xy_angle = readfloat(item_struct + 0x224)
			item_unknown_z_angle = readfloat(item_struct + 0x228)
			
			if obj_type == 2 then -- weapons
			
				-- weap struct
				weap_struct = m_object
				
				weap_meta_id = readdword(weap_struct) -- Confirmed with HMT. Tag Meta ID.
				weap_fuel = readfloat(weap_struct + 0x124) -- Confirmed. Only for Flamethrower. (0 to 1)
				weap_charge = readfloat(weap_struct + 0x140) -- Confirmed. Only for Plasma Pistol. (0 to 1)
				--	weapon flags bitmask32
				--	unkBit[3] 0-2 ()
					weap_must_be_readied = readbit(weap_struct + 0x22C, 3) -- From OS.
				--	unkBit[28] 4-31 ()
				--	ownerObjFlags bitmask16
				--	unkBit[16] 0x230 0-15 ()
				--Padding[2] 0x232-0x234
				weap_primary_trigger = readfloat(weap_struct + 0x234) -- From OS.
				weap_state = readbyte(weap_struct + 0x238) -- From OS. (0 = Idle) (1 = PrimaryFire) (2 = SecondaryFire) (3 = Chamber1) (4 = Chamber2) (5 = Reload1) (6 = Reload2) (7 = Charged1) (8 = Charged2) (9 = Ready) (10 = Put Away)
				--Padding[1] 0x239-0x23A
				weap_readyWaitTime = readword(weap_struct + 0x23A) -- From DZS.
				weap_heat = readfloat(weap_struct + 0x23C) -- Confirmed. (0 to 1)
				weap_age = readfloat(weap_struct + 0x240) -- Confirmed. Equal to 1 - batteries. (0 to 1)
				weap_illumination_fraction = readfloat(weap_struct + 0x244) -- From OS.
				weap_light_power = readfloat(weap_struct + 0x248) -- From OS.
				--Padding[4] 0x24C-0x250 Unused.
				weap_tracked_objId = readident(weap_struct + 0x250) -- From OS.
				--Padding[8] 0x254-0x25C Unused.
				weap_alt_shots_loaded = readword(weap_struct + 0x25C) -- From OS.
				--Padding[2] 0x25E-0x260
		
				--Trigger State
				--Padding[1] 0x260-0x261
				weap_trigger_state = readbyte(weap_struct + 0x261) -- From OS. Some counter.
				weap_trigger_time = readword(weap_struct + 0x262) -- From OS.
				--	trigger_flags bitmask32
				weap_trigger_currently_not_firing = readbit(weap_struct + 0x264, 0) -- From DZS.
				--	unkBit[31] 0x264-0x268 1-31 ()
				weap_trigger_autoReloadCounter = readdword(weap_struct + 0x268) -- From DZS.
				--unkWord[2] 0x26C-0x26E firing effect related.
				weap_trigger_rounds_since_last_tracer = readword(weap_struct + 0x26E) -- From OS.
				weap_trigger_rate_of_fire = readfloat(weap_struct + 0x270) -- From OS.
				weap_trigger_ejection_port_recovery_time = readfloat(weap_struct + 0x274) -- From OS.
				weap_trigger_illumination_recovery_time = readfloat(weap_struct + 0x278) -- From OS.
				--unkFloat[1] 0x27C-0x280 used in the calculation of projectile error angle
				weap_trigger_charging_effect_id = readident(weap_struct + 0x280) -- From OS.
				--unkByte[4] 0x284-0x288 ()
				--Padding[1] 0x288-0x289
				weap_trigger2_state = readbyte(weap_struct + 0x289) -- From OS. Some counter.
				weap_trigger2_time = readword(weap_struct + 0x28A) -- From OS.
				--	trigger_flags bitmask32
					weap_trigger2_currently_not_firing = readbit(weap_struct + 0x28C, 0) -- From DZS.
				--	unkBit[31] 0x28C-0x290 1-31 ()
				weap_trigger2_autoReloadCounter = readdword(weap_struct + 0x290) -- From DZS.
				--unkWord[2] 0x294-0x296 firing effect related.
				weap_trigger2_rounds_since_last_tracer = readword(weap_struct + 0x296) -- From OS.
				weap_trigger2_rate_of_fire = readfloat(weap_struct + 0x298) -- From OS.
				weap_trigger2_ejection_port_recovery_time = readfloat(weap_struct + 0x29C) -- From OS.
				weap_trigger2_illumination_recovery_time = readfloat(weap_struct + 0x2A0) -- From OS.
				--unkFloat[1] 0x2A4-0x2A8 used in the calculation of projectile error angle
				weap_trigger2_charging_effect_id = readident(weap_struct + 0x2A8) -- From OS.
				--unkByte[4] 0x2AC-0x2B0 ()
		
				--Primary Magazine State
				weap_mag1_state = readword(weap_struct + 0x2B0) -- From OS. (0 = Idle) (1 = Chambering Start) (2 = Chambering Finish) (3 = Chambering)
				weap_mag1_chambering_time = readword(weap_struct + 0x2B2) -- From OS. Can set to 0 to finish reloading. (1 sec = 30 ticks)
				--unkWord[1] 0x2B4-0x2B6 game tick based value (animations)
				weap_primary_ammo = readword(weap_struct + 0x2B6) -- Confirmed. Unloaded ammo for magazine 1.
				weap_primary_clip = readword(weap_struct + 0x2B8) -- Confirmed. Loaded clip for magazine 1.
				--unkWord[3] 0x2BA-0x2C0 game tick value,unkWord,possible enum
		
				--Secondary Magazine State
				weap_mag2_state = readword(weap_struct + 0x2C0) -- From OS. (0 = Idle) (1 = Chambering Start) (2 = Chambering Finish) (3 = Chambering)
				weap_mag2_chambering_time = readword(weap_struct + 0x2C2) -- From OS. Can set to 0 to finish reloading. (1 sec = 30 ticks)
				--unkWord[1] 0x2C4-0x2C6 game tick based value (animations)
				weap_secondary_ammo = readword(weap_struct + 0x2C6) -- Confirmed. Unloaded ammo for magazine 1.
				weap_secondary_clip = readword(weap_struct + 0x2C8) -- Confirmed. Loaded clip for magazine 1.
				--unkWord[3] 0x2CA-0x2D0 game tick value,unkWord,possible enum
				weap_last_fired_time = readdword(weap_struct + 0x2D0) -- From DZS. gameinfo_current_time - this = time since this weapon was fired. (1 second = 30 ticks)
				weap_mag1_starting_total_rounds = readword(weap_struct + 0x2D4) -- From OS. The total unloaded primary ammo the weapon has by default.
				weap_mag1_starting_loaded_rounds = readword(weap_struct + 0x2D6) -- From OS. The total loaded primary clip the weapon has by default.
				weap_mag2_starting_total_rounds = readword(weap_struct + 0x2D8) -- From OS. The total unloaded secondary ammo the weapon has by default.
				weap_mag2_starting_loaded_rounds = readword(weap_struct + 0x2DA) -- From OS. The total loaded secondary clip the weapon has by default.
				--unkByte[4] 0x2DC-0x2E0 (Padding Maybe)
				weap_baseline_valid = readbyte(weap_struct + 0x2E0) -- From OS.
				weap_baseline_index = readbyte(weap_struct + 0x2E1) -- From OS.
				weap_message_index = readbyte(weap_struct + 0x2E2) -- From OS.
				--Padding[1] 0x2E3-0x2E4
				weap_x_coord = readfloat(weap_struct + 0x2E4) -- From OS.
				weap_y_coord = readfloat(weap_struct + 0x2E8) -- From OS.
				weap_z_coord = readfloat(weap_struct + 0x2EC) -- From OS.
				weap_x_vel = readfloat(weap_struct + 0x2F0) -- From OS.
				weap_y_vel = readfloat(weap_struct + 0x2F2) -- From OS.
				weap_z_vel = readfloat(weap_struct + 0x2F4) -- From OS.
				--Padding[12] 0x2F8-0x300
				weap_primary_ammo2 = readword(weap_struct + 0x300) -- From OS. Unloaded ammo for magazine 1.
				weap_secondary_ammo2 = readword(weap_struct + 0x302) -- From OS. Unloaded ammo for magazine 2.
				weap_age2 = readfloat(weap_struct + 0x304) -- From OS. Equal to 1 - batteries. (0 to 1)
				--Duplicates of above below this point, will add later.
			elseif obj_type == 3 then -- equipment
				
				-- eqip struct
				eqip_struct = item_struct
				
				--unkByte[16] 0x22C-0x23C () possibly unused
				--unkByte[8] 0x23C-0x244 () possibly unused
				--	bitmask8
					eqip_baseline_valid = readbit(eqip_struct + 0x244, 0) -- From OS.
				--	unkBit[7] 1-7 (Padding Maybe)
				eqip_baseline_index = readchar(eqip_struct + 0x245) -- From OS.
				eqip_message_index = readchar(eqip_struct + 0x246) -- From OS.
				--Padding[1] 0x247-0x248
				-- baseline update
				eqip_x_coord = readfloat(eqip_struct + 0x248) -- From OS.
				eqip_y_coord = readfloat(eqip_struct + 0x24C) -- From OS.
				eqip_z_coord = readfloat(eqip_struct + 0x250) -- From OS.
				eqip_x_vel = readfloat(eqip_struct + 0x254) -- From OS.
				eqip_y_vel = readfloat(eqip_struct + 0x258) -- From OS.
				eqip_z_vel = readfloat(eqip_struct + 0x25C) -- From OS.
				eqip_pitch_vel = readfloat(eqip_struct + 0x260) -- From OS.
				eqip_yaw_vel = readfloat(eqip_struct + 0x264) -- From OS.
				eqip_roll_vel = readfloat(eqip_struct + 0x268) -- From OS.
				
				--	delta update
				--	bitmask8
					eqip_delta_valid = readbit(eqip_struct + 0x26C, 0) -- Guess.
				--	unkBit[7] 1-7 (Padding Maybe)
				--Padding[3] 0x26D-0x270
				eqip_x_coord2 = readfloat(eqip_struct + 0x270) -- From OS.
				eqip_y_coord2 = readfloat(eqip_struct + 0x274) -- From OS.
				eqip_z_coord2 = readfloat(eqip_struct + 0x278) -- From OS.
				eqip_x_vel2 = readfloat(eqip_struct + 0x27C) -- From OS.
				eqip_y_vel2 = readfloat(eqip_struct + 0x280) -- From OS.
				eqip_z_vel2 = readfloat(eqip_struct + 0x284) -- From OS.
				eqip_pitch_vel2 = readfloat(eqip_struct + 0x288) -- From OS.
				eqip_yaw_vel2 = readfloat(eqip_struct + 0x28C) -- From OS.
				eqip_roll_vel2 = readfloat(eqip_struct + 0x290) -- From OS.
				
			elseif obj_type == 4 then -- garbage object
				
				-- garbage struct
				garb_struct = item_struct
				
				garb_time_until_garbage = readword(garb_struct + 0x22C) -- From OS.
				--Padding[2] 0x22E-0x230
				--Padding[20] 0x230-0x244 unused
				
			elseif obj_type == 5 then -- projectile
				
				-- proj struct
				proj_struct = m_object
				
				--It appears Smiley didn't know how to read Open-Sauce very effectively, which explains the previous failure in this projectile structure's documentation
				
				proj_mapId = readident(proj_struct + 0x0) -- Confirmed.
				--INSERT REST OF OBJECT STRUCT FROM 0x4 TO 0x1F4 HERE
				--Padding[52] 0x1F4-0x22C -- Item data struct not used in projectile.
				--unkBit[32] 0x22C-0x230 ()
				proj_action = readword(proj_struct + 0x230) -- From OS. (enum)
				--unkWord[1] 0x232-0x234 looks like some kind of index.
				proj_source_obj_id = readident(proj_struct + 0x234) -- From OS.
				proj_target_obj_id = readident(proj_struct + 0x238) -- From OS.
				proj_contrail_attachment_index = readdword(proj_struct + 0x23C) -- From OS. index for the proj's definition's object_attachment_block, index is relative to object.attachments.attachment_indices or -1
				proj_time_remaining = readfloat(proj_struct + 0x240) -- From OS. Time remaining to target.
				--unkFloat[1] 0x244-0x248 () related to detonation countdown timer
				--unkFloat[1] 0x248-0x24C ()
				--unkFloat[1] 0x24C-0x250 () related to arming_time
				proj_range_traveled = readword(proj_struct + 0x250) -- From OS. If the proj definition's maximum range is  0, divide this value by maximum range to get range remaining.
				proj_x_vel = readfloat(proj_struct + 0x254) -- From OS.
				proj_y_vel = readfloat(proj_struct + 0x258) -- From OS.
				proj_z_vel = readfloat(proj_struct + 0x25C) -- From OS.
				--unkFloat[1] 0x260-0x264 set to water_damage_range's maximum.
				proj_pitch = readfloat(proj_struct + 0x264) -- From OS.
				proj_yaw = readfloat(proj_struct + 0x268) -- From OS.
				proj_roll = readfloat(proj_struct + 0x26C) -- From OS.
				--unkFloat[2] 0x270-0x278 real_euler_angles2d
				--unkBit[8] 0x278-0x279 ()
				--	bitmask8
					proj_baseline_valid = readbit(proj_struct + 0x279, 0) -- From OS.
				--	unkBit[7] 1-7
				proj_baseline_index = readchar(proj_struct + 0x27A) -- From OS.
				proj_message_index = readchar(proj_struct + 0x27B) -- From OS.
				
				--	baseline update
				proj_x_coord = readfloat(proj_struct + 0x27C) -- From OS.
				proj_y_coord = readfloat(proj_struct + 0x280) -- From OS.
				proj_z_coord = readfloat(proj_struct + 0x284) -- From OS.
				proj_x_vel2 = readfloat(proj_struct + 0x288) -- From OS.
				proj_y_vel2 = readfloat(proj_struct + 0x28C) -- From OS.
				proj_z_vel2 = readfloat(proj_struct + 0x290) -- From OS.
				--unkBit[8] 0x294-0x295 delta_valid
				--Padding[3] 0x295-0x298
				
				--	delta update
				proj_x_coord2 = readfloat(proj_struct + 0x298) -- From OS.
				proj_y_coord2 = readfloat(proj_struct + 0x29C) -- From OS.
				proj_z_coord2 = readfloat(proj_struct + 0x2A0) -- From OS.
				proj_x_vel3 = readfloat(proj_struct + 0x2A4) -- From OS.
				proj_y_vel3 = readfloat(proj_struct + 0x2A8) -- From OS.
				proj_z_vel3 = readfloat(proj_struct + 0x2AC) -- From OS.
				
			elseif obj_type = 6 and obj_type = 9 then -- device
				
				-- device struct
				device_struct = m_object
				
				device_flags = readdword(device_struct + 0x1F4) -- breakdown coming soon!
				device_power_group_index = readword(device_struct + 0x1F8) -- From OS.
				--Padding[2] 0x1FA-0x1FC
				device_power_amount = readfloat(device_struct + 0x1FC) -- From OS.
				device_power_change = readfloat(device_struct + 0x200) -- From OS.
				device_position_group_index = readword(device_struct + 0x204) -- From OS.
				--Padding[2] 0x206-0x208
				device_position_amount = readfloat(device_struct + 0x208) -- From OS.
				device_position_change = readfloat(device_struct + 0x20C) -- From OS.
				--	user interaction bitmask32
					device_one_sided = readbit(device_struct + 0x210, 0) -- From OS.
					device_operates_automatically = readbit(device_struct + 0x210, 1) -- From OS.
				--	unkBit[30] 2-31 (Padding Maybe)
				
				if obj_type == 7 then -- machine
					
					-- mach struct
					mach_struct = device_struct
					
					mach_flags = readdword(mach_struct + 0x214) -- breakdown coming soon!
					mach_door_timer = readdword(mach_struct + 0x218) -- Tested. looks like a timer used for door-type machines.
					mach_elevator_x_coord = readdword(mach_struct + 0x21C) -- From OS.
					mach_elevator_y_coord = readdword(mach_struct + 0x220) -- From OS.
					mach_elevator_z_coord = readdword(mach_struct + 0x224) -- From OS.
					
				elseif obj_type == 8 then -- control
					
					-- ctrl struct
					ctrl_struct = device_struct
					
					ctrl_flags = readdword(mach_struct + 0x214) -- breakdown coming soon!
					ctrl_custom_name_index = readword(mach_struct + 0x218) -- From OS.
					--Padding[2] 0x21A-0x21C
				
				elseif obj_type == 9 then -- lightfixture
					
					--lightfixture struct
					lifi_struct = device_struct
					
					lifi_red_color = readfloat(lifi_struct + 0x214) -- From OS.
					lifi_green_color = readfloat(lifi_struct + 0x218) -- From OS.
					lifi_blue_color = readfloat(lifi_struct + 0x21C) -- From OS.
					lifi_intensity = readfloat(lifi_struct + 0x220) -- From OS.
					lifi_falloff_angle = readfloat(lifi_struct + 0x224) -- From OS.
					lifi_cutoff_angle = readfloat(lifi_struct + 0x228) -- From OS.
					
				end
			end
		end
	end
end

--I will rewrite this function to work less retardedly.
function objIsProjectile(objId)
	local m_object = getobject(objId)
	if m_object then
		local mapId = readident(m_object + 0x0)
		local tag_type = gettaginfo(mapId)
		if tagtype == proj then
			return true
		end
	end
end

function readident(address, offset)
	address = address + (offset or 0)
	identity = readdword(address) -- DWORD ID.
	--	Thank you WaeV for helping me wrap my head around this.
		ident_table_index = readword(address) -- Confirmed. This is what most functions use. (player number, object index, etc)
		ident_table_flags = readbyte(address + 0x2) -- Tested. From Phasor. 0x44 by default, dunno what they're for.
		ident_type = readbyte(address + 0x3) -- Confirmed. [Object values (Weapon = 6) (Vehicle = 8) (Others = -1) (Probably more)]
	return identity
end

function getplayermachinenum(player_number)
	player_number = tonumber(player_number) or raiseerror(bad argument #1 to getplayermachinenum (valid player required, got  .. tostring(type(player_number)) .. ))
	local client_machineinfo_size = 0x60
	local ce = 0x0
	if game == CE then
		client_machineinfo_size = 0xEC
		ce = 0x40
	end
	local client_machineinfo_struct = network_struct + 0x3B8+ce + player_numberclient_machineinfo_size
	local machineNum = readdword(client_machineinfo_struct + 0x5C) -- From Phasor. 0 - 0xFFFFFFFF Increased for each connection in server's life.
	return machineNum
end

--Thank you Kennan for helping me test this function
function gethash(player_number)
	player_number = tonumber(player_number) or raiseerror(bad argument #1 to gethash (valid player required, got  .. tostring(type(player_number)) .. ))
	
	--need to get player machineNum.
	local machineNum = getplayermachinenum(player_number)
	
	--hash table
	local hash_table = readdword(hash_table_base + 0x0) -- Confirmed.
	local hash_table_data_size = 0x50 -- Confirmed.
	local hash_table_data = readdword(hash_table_base + 0x0) -- Confirmed. Pointer to the hash table data.
	local hash_next_hash_table = readdword(hash_table_base + 0x4) -- Confirmed. Next hash table in the list
	local hash_prev_hash_table = readdword(hash_table_base + 0x8) -- Confirmed. Previous hash table in the list.
	
	--hash table data
	hash_table = hash_next_hash_table -- There's nothing in the first table except for the next table.
	hash_table_data = readdword(hash_table) -- There's no data in the first table data.
	local hash_table_data_id = readdword(hash_table_data) -- Confirmed. Machine num index for hash table data.
	local hash = readstring(hash_table_data + 0x4, 32) -- Confirmed. Hash of the player.
	--unkByte[44] 0x8 ()

	while hash_table ~= 0 and hash_table_data ~= 0 do
		if hash_table_data_id == machineNum then
			hash = readstring(hash_table_data + 0x4, 32)
			return hash
		end
		hash_table = readdword(hash_table + 0x4)
		if hash_table ~= 0 then
			hash_table_data = readdword(hash_table)
			hash_table_data_id = readdword(hash_table_data)
		end
	end
end

function getplayer(player_number)
	player_number = tonumber(player_number) or raiseerror(bad argument #1 to getplayer (valid player required, got  .. tostring(type(player_number)) .. ))
	-- player header setup
	local player_header = readdword(player_header_pointer) - 0x8 -- Confirmed. (0x4029CE88)
	local player_header_size = 0x40 -- Confirmed.
	
	-- player header
	--Padding[8] 0x0-0x8
	local player_header_name = readstring(player_header + 0x8, 0xE) -- Confirmed. Always players.
	--Padding[24] 0x10-0x20
	local player_header_maxplayers = readword(player_header + 0x28) -- Confirmed. (0 - 16)
	local player_struct_size = readword(player_header + 0x2A) -- Confirmed. (0x200 = 512)
	local player_header_data = readstring(player_header + 0x30, 0x4) -- Confirmed. Always @t@d. Translates to data
	local player_header_ingame = readword(player_header + 0x34) -- Tested. Always seems to be 0 though... (In game = 0) (Not in game = 1)
	local player_header_current_players = readword(player_header + 0x36) -- Confirmed.
	local player_header_next_player_id = readident(player_header + 0x38) -- Confirmed. Full DWORD ID of the next player to join.
	local player_header_first_player_struct = readident(player_header + 0x3C) -- Confirmed with getplayer(0). Player struct of the first player. (0x4029CEC8 for PCCE)

	-- player struct setup
	local player_base = player_header + player_header_size -- Confirmed. (0x4029CEC8)
	local player_struct = player_base + (player_number  player_struct_size) -- Confirmed with getplayer(player).

	return player_struct

end

function getLowerWord16(x)
    local highervals = math.floor(x  2 ^ 16)
    highervals = highervals  2 ^ 16
    local lowervals = x - highervals
    return lowervals
end

function rshift(x, by)
	return math.floor(x  2 ^ by)
end

function getobject(m_objectId)

	-- obj header setup
	local obj_header = readdword(obj_header_pointer) -- Confirmed. (0x4005062C)
	local obj_header_size = 0x38 -- Confirmed.

	-- obj header
	local obj_header_name = readstring(obj_header, 0x6) -- Confirmed. Always object.
	local obj_header_maxobjs = readword(obj_header + 0x20) -- Confirmed. (0x800 = 2048 objects)
	local obj_table_size = readword(obj_header + 0x22) -- Confirmed. (0xC = 12)
	local obj_header_data = readstring(obj_header + 0x28, 0x3) -- Confirmed. Always @t@d. Translates to data
	local obj_header_objs = readword(obj_header + 0x2C) -- Needs to be tested.
	local obj_header_current_maxobjs = readword(obj_header + 0x2E) -- Tested.
	local obj_header_current_objs = readword(obj_header + 0x30) -- Tested.
	local obj_header_next_obj_index = readword(obj_header + 0x32) -- Tested. Corresponds with obj_struct_obj_index.
	local obj_table_base_pointer = readdword(obj_header + 0x34) -- Confirmed. (0x40050664)
	--local obj_header_next_obj_id = readident(obj_header + 0x34) -- Incorrect
	--local obj_header_first_obj = readident(obj_header + 0x36) -- Incorrect

	-- obj table setup
	local obj_table_index = getLowerWord16(m_objectId) -- grab last two bytes of objId
	local obj_table_flags = rshift(m_objectId, 44) - rshift(m_objectId, 64)  0x100 -- part of the objId salt
	local obj_table_type = rshift(m_objectId, 64) -- part of the objId salt
	local obj_table_base = obj_header + obj_header_size -- Confirmed. (0x40050664)
	local obj_table_address = obj_table_base + (obj_table_index  obj_table_size) + 0x8 -- Confirmed.

	-- obj_table (needs testing)
	local obj_struct = readdword(obj_table_address + 0x0) -- Confirmed with getobject().
	local obj_struct_obj_id = readword(obj_table_address + 0x2) -- ()
	local obj_struct_obj_index = readword(obj_table_address + 0x4) -- Tested. Corresponds with obj_header_next_obj_index.
	local obj_struct_size = readword(obj_table_address + 0x6) -- Wrong offset

	return obj_struct

end

function gettagaddress(tagtype, tagname)

	-- map header
	local map_header_size = 0x800 -- Confirmed. (2048 bytes)
	local map_header_head = readstring(map_header_base, 4, true) -- Confirmed. head (head = daeh)
	local map_header_version = readbyte(map_header_base + 0x4) -- Confirmed. (Xbox = 5) (Trial = 6) (PC = 7) (CE = 0x261 = 609)
	local map_header_map_size = readdword(map_header_base + 0x8, 0x3) -- Confirmed. (Bytes)
	local map_header_index_offset = readdword(map_header_base + 0x10, 0x2) -- Confirmed. (Hex)
	local map_header_meta_data_size = readdword(map_header_base + 0x14, 0x2) -- Confirmed. (Hex)
	local map_header_map_name = readstring(map_header_base + 0x20, 0x9) -- Confirmed.
	local map_header_build = readstring(map_header_base + 0x40, 12) -- Confirmed.
	local map_header_map_type = readbyte(map_header_base + 0x60) -- Confirmed. (SP = 0) (MP = 1) (UI = 2)
	-- Something from 0x64 to 0x67.
	local map_header_foot = readstring(map_header_base + 0x7FC, 4, true) -- Confirmed. foot (foot = toof)

	--tag table setup
	local map_base = readdword(map_pointer) -- Confirmed. (0x40440000)
	local tag_table_base_pointer = readdword(map_base)
	local tag_table_first_tag_id = readdword(map_base + 0x4) -- Confirmed. Also known as the scenario tagId.
	local tag_table_tag_id = readdword(map_base + 0x8) -- Confirmed. MapIdTagId for specified tag
	local tag_table_count = readdword(map_base + 0xC) -- Confirmed. Number of tags in the tag table.
	local map_verticie_count = readdword(map_base + 0x10)
	local map_verticie_offset = readdword(map_base + 0x14)
	local map_indicie_count = readdword(map_base + 0x18)
	local map_indicie_offset = readdword(map_base + 0x1C)
	local map_model_data_size = readdword(map_base + 0x20)
	local tag_table_tags = readstring(map_base + 0x24, 4, true) -- Confirmed. tags (tags = sgat)
	local tag_table_base = readdword(map_base) -- Confirmed. (0x40440028)
	local tag_table_size = 0x20 -- Confirmed.
	local tag_allocation_size = 0x01700000 -- From OS.
	local tag_max_address = map_base + tag_allocation_size -- From OS. (0x41B40000)
	
	-- tag table
	-- the scenario is always the first tag located in the table.
	local scnr_tag_class1 = readstring(tag_table_base, 4, true) -- Confirmed. weap, obje, etc. (weap = paew). Never 0xFFFF.
	local scnr_tag_class2 = readstring(tag_table_base + 0x4, 4, true) -- Confirmed. weap, obje, etc. (weap = paew) 0xFFFF if not existing.
	local scnr_tag_class3 = readstring(tag_table_base + 0x8, 4, true) -- Confirmed. weap, obje, etc. (weap = paew) 0xFFFF if not existing.
	local scnr_tag_id = readident(tag_table_base + 0xC) -- Confirmed. TagIDMapIDMetaID
	local scnr_tag_name_address = readdword(tag_table_base + 0x10) -- Confirmed. Pointer to the tag name.
		local scnr_tag_name = readstring(scnr_tag_name_address) -- Confirmed. Name of the tag (weaponspistolpistol)
	local scnr_tag_data_address = readdword(tag_table_base + 0x14) -- Confirmed. This is where map mods made with EschatonHMTHHT are stored.
	--unkByte[8]
	
	local tag_address = 0
	for i=0,(tag_table_count - 1) do
	
		local tag_class = readstring(tag_table_base, (tag_table_size  i), 4)
		local tag_id = readdword(tag_table_base + 0xC + (tag_table_size  i))
		local tag_name_address = readdword(tag_table_base + 0x10 + tag_table_size  i)
		local tag_name = readstring(tag_name_address)
		
		--this function can accept mapId or tagtype, tagname
		if tag_id == tagtype or (tag_class == tagtype and tag_name == tagname) then
			tag_address = todec(readdword(tag_table_base + 0x14 + (tag_table_size  i)))
			break
		end
		
	end

	return tag_address

end

function gettagdata(tag_address)
	--All of these are thanks to Sparky's plugin pack for Eschaton.
	--There's no way I'm going to list them all, I'm only listing some to show you 
	--how you need to read from the tagdata to get the mapmod you want to read fromwrite to.
	--Download Sparky's plugin pack (google it) and open up the '.ent' files to get started.
	--The offset should be right next to the value.
	
	-- tag table
	local tag_class1 = readstring(tag_address, 4, true) -- Confirmed. weap, obje, etc. (weap = paew). Never 0xFFFF.
	local tag_class2 = readstring(tag_address + 0x4, 4, true) -- Confirmed. weap, obje, etc. (weap = paew) 0xFFFF if not existing.
	local tag_class3 = readstring(tag_address + 0x8, 4, true) -- Confirmed. weap, obje, etc. (weap = paew) 0xFFFF if not existing.
	local tag_id = readdword(tag_address + 0xC) -- Confirmed. TagIDMapIDMetaID
	local tag_name_address = readdword(tag_address + 0x10) -- Confirmed. Pointer to the tag name.
		local tag_name = readstring(tag_name_address) -- Confirmed. Name of the tag (weaponspistolpistol)
	local tag_data_address = readdword(tag_address + 0x14) -- Confirmed. This is where map mods made with EschatonHMTHHT are stored.
	--unkByte[0x8]
	if tag_class1 == weap then
		--	Flags
			local does_not_cast_shadow = readbit(tag_data_address + 0x2, 0)
			local transparent_self_occlusion = readbit(tag_data_address + 0x2, 1)
			local brighter_than_should_be = readbit(tag_data_address + 0x2, 2)
			local not_pathfinding_obstacle = readbit(tag_data_address + 0x2, 3)
			
		local bounding_radius = readfloat(tag_data_address + 0x4) -- In world units.
		local bounding_offset_x = readfloat(tag_data_address + 0x8)
		local bounding_offset_y = readfloat(tag_data_address + 0xC)
		local bounding_offset_z = readfloat(tag_data_address + 0x10)
		local origin_offset_x = readfloat(tag_data_address + 0x14)
		local origin_offset_y = readfloat(tag_data_address + 0x18)
		local origin_offset_z = readfloat(tag_data_address + 0x1C)
		local acceleration_scale = readfloat(tag_data_address + 0x20)
		local render_bounding_radius = readfloat(tag_data_address + 0x104) -- In world units.
		
		--	magazines.
			local address_magazines = readdword(tag_data_address + 0x4F0 + 0x4)
			local magazine_count = readdword(tag_data_address + 0x4F0)
			local address_magazines_size = 0x70 -- Confirmed.
			--	Flags
				local wastes_rounds_when_reloading = readbit(address_magazines + 0x0, 1)
				local every_round_must_be_chambered = readbit(address_magazines + 0x0, 2)
			--	emptyBits[30]
			local rounds_recharged = readshort(address_magazines + 0x4) -- per second.
			local rounds_total_initial = readshort(address_magazines + 0x6)
			local rounds_total_maximum = readshort(address_magazines + 0x8)
			local rounds_loaded_maximum = readshort(address_magazines + 0xA)
			local reload_time = readfloat(address_magazines + 0x14) -- the length of time it takes to load a single magazine into the weapon.
			local rounds_reloaded = readshort(address_magazines + 0x18)
			local chamber_time = readfloat(address_magazines + 0x1C) -- the length of time it takes to chamber the next round
		--	some dependencies from 0x38 to 0x64
			
			--	Equipment Magazines.
			--	Seriously another struct
				local address_equipment_magazines = readdword(address_magazines + 0x64)
				local address_equipment_magazines_size = 0x1C -- Confirmed.
				local equipment_rounds = readshort(address_equipment_magazines + 0x0)
			--	some dependency here at 0xC.
		--	end of magazine struct.
		
		--	triggers
			local address_triggers = readdword(tag_data_address + 0x4FC + 0x4)
			local trigger_count = readdword(tag_data_address + 0x4FC)
			local address_triggers_size = 0x114 -- Confirmed.
		--		bitmask32 flags
				local tracks_fired_projectile = readbit(address_triggers, 0)
				local random_firing_effects = readbit(address_triggers, 1) -- Rather than being chosen sequentially, firing effects are chosen randomly.
				local can_fire_with_partial_ammo = readbit(address_triggers, 2)
				local does_not_repeat_automatically = readbit(address_triggers, 3)
				local locks_in_on_off_state = readbit(address_triggers, 4)
				local projectiles_use_weapon_origin = readbit(address_triggers, 5)
				local sticks_when_dropped = readbit(address_triggers, 6)
				local ejects_during_chamber = readbit(address_triggers, 7)
				local discharging_spews = readbit(address_triggers, 8)
				local analog_rate_of_fire = readbit(address_triggers, 9) -- May help with lag.
				local error_when_unzoom = readbit(address_triggers, 10)
				local projectile_vector_not_adjustable = readbit(address_triggers, 11)
				local projectile_identical_error = readbit(address_triggers, 12)
				local projectile_client_side_only = readbit(address_triggers, 13)
		--		emptyBits[18] 14-31.
			local rateOfFireFrom = readfloat(address_triggers + 0x4)
			local rateOfFireTo = readfloat(address_triggers + 0x8)
			local firingAccelerationTime = readfloat(address_triggers + 0xC)
			local firingDecelerationTime = readfloat(address_triggers + 0x10)
			local firingBlurredRateOfFire = readfloat(address_triggers + 0x14)
			local magazine = readword(address_triggers + 0x20)
			local roundsPerShot = readword(address_triggers + 0x22)
			local minimumRounds = readword(address_triggers + 0x24)
			local roundsBetweenTracers = readword(address_triggers + 0x26)
			local weaponFiringNoise = readword(address_triggers + 0x2E)
			local errorFrom = readfloat(address_triggers + 0x30)
			local errorTo = readfloat(address_triggers + 0x34)
			local errorAccelerationTime = readfloat(address_triggers + 0x38)
			local errorDecelerationTime = readfloat(address_triggers + 0x3C)
			local chargingTime = readfloat(address_triggers + 0x48)
			local chargedTime = readfloat(address_triggers + 0x4C)
			local weaponFiringOverchargeAction = readword(overchargeAction + 0x50)
			local chargedIllumination = readfloat(address_triggers + 0x54)
			local overchargeSpewTime = readfloat(address_triggers + 0x58)
			local chargingEffect = readdword(address_triggers + 0x5C)
		--	enum weaponFiringDistributionFunction projectileDistributionFunction; 0x6C
			local projectilesPerShot = readdword(address_triggers + 0x6E)
			local projectileDistributionAngle = readfloat(address_triggers + 0x70)
		--	emptyBytes[0x4] 0x74
			local projectileMinimumError = readfloat(address_triggers + 0x78)
			local projectileErrorAngleFrom = readfloat(address_triggers + 0x7C)
			local projectileErrorAngleTo = readfloat(address_triggers + 0x80)
			local firstPersonOffset_x = readfloat(address_triggers + 0x84)
			local firstPersonOffset_y = readfloat(address_triggers + 0x88)
			local firstPersonOffset_z = readfloat(address_triggers + 0x8C)
		--	emptyBytes[0x4] 0x90
		--	TagDependency projectile; 0x94
			local ejectionPortRecoveryTime = readfloat(address_triggers + 0xA4)
			local illuminationRecoveryTime = readfloat(address_triggers + 0xA8)
		--	emptyBytes[0xC] 0xAC
			local heatGeneratedPerRound = readfloat(address_triggers + 0xB8)
			local ageGeneratedPerRound = readfloat(address_triggers + 0xBC)
		--	emptyBytes[0x4] 0xC0
			local overloadTime = readfloat(address_triggers + 0xC4)
		--	emptyBytes[0x40] 0xC8
		--	Reflexive firingEffects; 0x108
	end
	return tag_data_address
end

function endian(address, offset, length)
	if offset and not length then
		length = offset
		offset = nil
	end
	local data_table = {}
	local data = 

	for i=0,length do

		local hex = string.format(%X, readbyte(address, offset + i))

		if tonumber(hex, 16)  16 then
			hex = 0 .. hex
		end

		table.insert(data_table, hex)

	end

	for k,v in pairs(data_table) do
		data = v .. data
	end

	return data

end

function tohex(number)
	return string.format(%X, number)
end

function todec(number)
	return tonumber(number, 16)
end

function setgametypeparameters(friendsonlyradar, startingequipment, invisibleplayers, shields, infinitegrenades, friendindicators, radar)

	local binary = tonumber(0 .. friendsonlyradar .. startingequipment .. invisibleplayers .. shields .. infinitegrenades .. friendindicators .. radar)
	writebyte(gametype_base + 0x38, convertbase(2, 10, binary))

end

function setvehicleparameters(team, vehicleset, warthog, ghost, scorpion, rocketwarthog, banshee, gunturret)

	if vehicleset == default then
		vehicleset = convertbase(10, 2, 0)
	elseif vehicleset == none then
		vehicleset = convertbase(10, 2, 1)
	elseif vehicleset == warthogs then
		vehicleset = convertbase(10, 2, 2)
	elseif vehicleset == ghosts then
		vehicleset = convertbase(10, 2, 3)
	elseif vehicleset == scorpions then
		vehicleset = convertbase(10, 2, 4)
	elseif vehicleset == rocket warthogs then
		vehicleset = convertbase(10, 2, 5)
	elseif vehicleset == banshees then
		vehicleset = convertbase(10, 2, 6)
	elseif vehicleset == gun turrets then
		vehicleset = convertbase(10, 2, 7)
	elseif vehicleset == custom then
		vehicleset = convertbase(10, 2, 8)
	end

	warthog = warthog or 0

	ghost = ghost or 0

	scorpion = scorpion or 0

	rocketwarthog = rocketwarthog or 0

	banshee = banshee or 0

	gunturret = gunturret or 0

	warthog = convertbase(10, 2, warthog)
	ghost = convertbase(10, 2, ghost)
	scorpion = convertbase(10, 2, scorpion)
	rocketwarthog = convertbase(10, 2, rocketwarthog)
	banshee = convertbase(10, 2, banshee)
	gunturret = convertbase(10, 2, gunturret)

	if vehicleset10  1 then
		vehicleset = 0 .. vehicleset
	end

	if vehicleset100  1 then
		vehicleset = 0 ..vehicleset
	end

	if vehicleset1000  1 then
		vehicleset = 0 .. vehicleset
	end

	if warthog10  1 then
		warthog = 0 .. warthog
	end

	if warthog100  1 then
		warthog = 0 ..warthog
	end

	if ghost10  1 then
		ghost = 0 .. ghost
	end

	if ghost100  1 then
		ghost = 0 ..ghost
	end

	if scorpion10  1 then
		scorpion = 0 .. scorpion
	end

	if scorpion100  1 then
		scorpion = 0 ..scorpion
	end

	if rocketwarthog10  1 then
		rocketwarthog = 0 .. rocketwarthog
	end

	if rocketwarthog100  1 then
		rocketwarthog = 0 ..rocketwarthog
	end

	if banshee10  1 then
		banshee = 0 .. banshee
	end

	if banshee100  1 then
		banshee = 0 ..banshee
	end

	if gunturret10  1 then
		gunturret = 0 .. gunturret
	end

	if gunturret100  1 then
		gunturret = 0 ..gunturret
	end

	local binary = 0 .. 0 .. 0 .. 0 .. 0 .. 0 .. 0 .. 0 .. 0 .. 0 .. gunturret .. banshee .. rocketwarthog .. scorpion .. ghost .. warthog .. vehicleset
	local set1 = tonumber(string.sub(binary, 1, 8))
	local set2 = tonumber(string.sub(binary, 9, 16))
	local set3 = tonumber(string.sub(binary, 17, 24))
	local set4 = tonumber(string.sub(binary, 25, 32))
	writebyte(gametype_base + 0x60 + (0x4  team), convertbase(2, 10, set4))
	writebyte(gametype_base + 0x61 + (0x4  team), convertbase(2, 10, set3))
	writebyte(gametype_base + 0x62 + (0x4  team), convertbase(2, 10, set2))
	writebyte(gametype_base + 0x63 + (0x4  team), convertbase(2, 10, set1))

end

function convertbase(inputbase, outputbase, input)

	local power = 0
	local answer = 0
	local number = math.floor(input  (outputbase^power))
	local check = true

	for word in string.gmatch(tostring(input), %d) do
		if tonumber(word) = inputbase then
			check = false
			break
		end
	end

	if check == false then
		answer = 0
	else
		if input == 0 then
			answer = 0
		else

			while number ~= 1 do
				power = power + 1
				number = math.floor(input  (outputbase^power))
			end

			while power = 0 do
				number = math.floor(input  (outputbase^power))
				input = input - (number  (outputbase^power))
				answer = answer + (number  (inputbase^power))
				power = power - 1
			end

		end
	end

	return answer

end
