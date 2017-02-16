	--	client network struct
		client_struct_size = 0x20 -- Confirmed.
		client_network_struct = network_struct + 0x1AA+ce + player * client_struct_size -- Strange. It starts in the middle of the dword.
		client_name = readwidestring(client_network_struct, 12) -- Confirmed. Name of player.
		client_color = readword(client_network_struct + 0x18) -- Confirmed. Color of the player (ffa gametypes only.) (0 = white) (1 = black) (2 = red) (3 = blue) (4 = gray) (5 = yellow) (6 = green) (7 = pink) (8 = purple) (9 = cyan) (10 = cobalt) (11 = orange) (12 = teal) (13 = sage) (14 = brown) (15 = tan) (16 = maroon) (17 = salmon)
		client_icon_index = readword(client_network_struct + 0x1A) -- From OS.
		client_machine_index = readbyte(client_network_struct + 0x1C) -- Confirmed. Player machine index (or rconId - 1)
		client_status = readbyte(client_network_struct + 0x1D) -- From Phasor. (1 = Genuine, 2 = Invalid hash (or auth, or w/e))
		client_team = readbyte(client_network_struct + 0x1E) -- Confirmed. (0 = red) (1 = blue)
		client_player_id = readbyte(client_network_struct + 0x1F) -- Confirmed. Player memory id/index (0 - 15) (To clarify: this IS the 'player' argument passed to phasor functions)
