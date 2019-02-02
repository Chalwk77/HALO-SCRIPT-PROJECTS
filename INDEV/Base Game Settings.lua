--[[
--=====================================================================================================--
Script Name: Base Game Settings

Copyright (c) 2016-2019 Jericho Crosby <jericho.crosby227@gmail.com>
You do not have permission to use this document.

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local function GameSettings()
    settings = {
        -- Enabled = true, Disabled = false
        mod = {
            ["Admin Chat"] = {
                enabled = true,
                base_command = "achat",
                permission_level = 1,
                prefix = "[ADMIN CHAT]",
                restore_previous_state = true,
                environment = "rcon",
                message_format = {"%prefix% %sender_name% [%index%] %message%"}
            },
            ["Chat IDs"] = {
                enabled = true,
                global_format = { "%sender_name% [%index%]: %message%" },
                team_format = { "[%sender_name%] [%index%]: %message%" },
                -- For a future update
                trial_moderator = { "[T-MOD] [%sender_name%] [%index%]: %message%" },
                moderator = { "[MOD] [%sender_name%] [%index%]: %message%" },
                admin = { "[ADMIN] [%sender_name%] [%index%]: %message%" },
                senior_admin = { "[S-ADMIN] [%sender_name%] [%index%]: %message%" },
                ignore_list = {
                    "skip",
                    "rtv"
                },
            },
            ["Message Board"] = {
                enabled = true,
                duration = 3,
                alignment = "l",
                messages = {
                    "Welcome to $SERVER_NAME",
                    "Bug reports and suggestions:",
                    "https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS",
                    "This is a development & test server only!",
                }
            },
            ["Chat Logging"] = {
                enabled = true,
                dir = "sapp\\Server Chat.txt",
            },
            ["Command Spy"] = {
                enabled = true,
                permission_level = 1,
                prefix = "[SPY]",
                hide_commands = false,
                commands_to_hide = {
                    "/afk",
                    "/lead",
                }
            },
            ["Custom Weapons"] = {
                enabled = true,
                assign_weapons = true,
                assign_custom_frags = true,
                assign_custom_plasmas = true,
                weapons = {
                    -- Weap 1,Weap 2,Weap 3,Weap 4, , frags, plasmas
                    ["beavercreek"] = {sniper, pistol, rocket_launcher, shotgun, 4, 2},
                    ["bloodgulch"] = {sniper, pistol, nil, nil, 2, 2},
                    ["boardingaction"] = {plasma_cannon, rocket_launcher, flamethrower, nil, 1, 3},
                    ["carousel"] = {nil, nil, pistol, needler, 3, 3},
                    ["dangercanyon"] = {nil, plasma_rifle, nil, pistol, 4, 4},
                    ["deathisland"] = {assault_rifle, nil, plasma_cannon, sniper, 1, 1},
                    ["gephyrophobia"] = {nil, nil, nil, shotgun, 3, 3},
                    ["icefields"] = {plasma_rifle, nil, plasma_rifle, nil, 2, 3},
                    ["infinity"] = {assault_rifle, nil, nil, nil, 2, 4},
                    ["sidewinder"] = {nil, rocket_launcher, nil, assault_rifle, 3, 2},
                    ["timberland"] = {nil, nil, nil, pistol, 2, 4},
                    ["hangemhigh"] = {flamethrower, nil, flamethrower, nil, 3, 3},
                    ["ratrace"] = {nil, nil, nil, nil, 3, 2},
                    ["damnation"] = {plasma_rifle, nil, nil, plasma_rifle, 1, 3},
                    ["putput"] = {nil, rocket_launcher, assault_rifle, pistol, 4, 1},
                    ["prisoner"] = {nil, nil, pistol, plasma_rifle, 2, 1},
                    ["wizard"] = {rocket_launcher, nil, shotgun, nil, 1, 2}
                    
                }
            },
            ["Anti Impersonator"] = {
                enabled = true,
                action = "kick",
                reason = "impersonating",
                bantime = 10,
                namelist = { "Chalwk" },
                hashlist = { "6c8f0bc306e0108b4904812110185edd" },
            },
            ["Console Logo"] = {
                enabled = true,
            },
            ["List Players"] = {
                enabled = true,
                permission_level = 1,
                alignment = "l",
                command_aliases = {
                    "pl",
                    "players",
                    "playerlist",
                    "playerslist"
                }
            },
            ["Alias System"] = {
                enabled = true,
                base_command = "alias",
                dir = "sapp\\alias.lua",
                permission_level = 1,
                alignment = "l",
                duration = 10,
            }
        },
        global = {
            server_prefix = "**SERVER**",
            player_data = {
                "Player: %name%",
                "CD Hash: %hash%",
                "IP Address: %ip_address%",
                "Index ID: %index_id%",
            },
        }
    }
end

-- Tables used Globally
players = { }
player_data = { }
quit_data = { }
mapname = ""

-- #Message Board
welcome_timer = { }
message_board_timer = { }

-- #Admin Chat
data = { }
adminchat = { }
stored_data = { }
boolean = { }
game_over = nil

-- #Custom Weapons
weapon = { }
frags = { }
plasmas = { }

-- #Alias System
trigger = { }
alias_timer = { }
index = nil
alias_bool = {}

function OnScriptLoad()
    loadWeaponTags()
    GameSettings()
    printEnabled()
    register_callback(cb['EVENT_TICK'], "OnTick")

    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")

    register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")

    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")

    -- #Message Board
    if (settings.mod["Message Board"].enabled == true) then
        for i = 1, 16 do
            if player_present(i) then
                local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")
                players[p_table].message_board_timer = 0
            end
        end
    end
    
    -- #Alias System
    if (settings.mod["Alias System"].enabled == true) then
        for i = 1, 16 do
            if player_present(i) then
                local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")
                players[p_table].alias_timer = 0
            end
        end
    end

    -- Used OnPlayerJoin()
    if halo_type == "PC" then
        ce = 0x0
    else
        ce = 0x40
    end

    -- #Admin Chat
    if (settings.mod["Admin Chat"].enabled == true) then
        if not (game_over) then
            for i = 1, 16 do
                if player_present(i) then
                    if tonumber(get_var(i, "$lvl")) >= getPermLevel("Admin Chat") then
                        local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")
                        players[p_table].adminchat = nil
                        players[p_table].boolean = nil
                    end
                end
            end
        end
    end
    
    -- #Custom Weapons
    if (settings.mod["Custom Weapons"].enabled == true) then
        if not (game_over) then
            if get_var(0, "$gt") ~= "n/a" then
                mapname = get_var(0, "$map")
            end
        end
    end
end

function OnScriptUnload()
    -- #Admin Chat
    if (settings.mod["Admin Chat"].enabled == true) then
        for i = 1, 16 do
            if player_present(i) then
                if tonumber(get_var(i, "$lvl")) >= getPermLevel("Admin Chat") then
                    local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")
                    players[p_table].adminchat = false
                    players[p_table].boolean = false
                end
            end
        end
    end
end

function OnNewGame()
    -- Used Globally
    game_over = false
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    servername = read_widestring(network_struct + 0x8, 0x42)
    mapname = get_var(0, "$map")
    
    -- #Message Board
    if (settings.mod["Message Board"].enabled == true) then
        for i = 1, 16 do
            if player_present(i) then
                local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")
                players[p_table].message_board_timer = 0
            end
        end
    end

    -- #Alias System
    if (settings.mod["Alias System"].enabled == true) then
        for i = 1, 16 do
            if player_present(i) then
                alias_bool[i] = false
                trigger[i] = false
                local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")
                players[p_table].alias_timer = 0
            end
        end
    end
    
    -- #Console Logo
    if (settings.mod["Console Logo"].enabled == true) then
        local function consoleLogo()
            local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
            local servername = read_widestring(network_struct + 0x8, 0x42)
            -- Logo: ascii: 'kban'
            cprint("================================================================================", 2 + 8)
            cprint(os.date("%A, %d %B %Y - %X"), 6)
            cprint("")
            cprint("          ..|'''.| '||'  '||'     |     '||'      '|| '||'  '|' '||'  |'    ", 4 + 8)
            cprint("          .|'     '   ||    ||     |||     ||        '|. '|.  .'   || .'    ", 4 + 8)
            cprint("          ||          ||''''||    |  ||    ||         ||  ||  |    ||'|.    ", 4 + 8)
            cprint("          '|.      .  ||    ||   .''''|.   ||          ||| |||     ||  ||   ", 4 + 8)
            cprint("          ''|....'  .||.  .||. .|.  .||. .||.....|     |   |     .||.  ||.  ", 4 + 8)
            cprint("                  ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
            cprint("                         " .. servername)
            cprint("                  ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
            cprint("")
            cprint("================================================================================", 2 + 8)
        end
        consoleLogo()
    end

    -- #Chat Logging
    if (settings.mod["Chat Logging"].enabled == true) then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local map = get_var(0, "$map")
            local gt = get_var(0, "$mode")
            local n1 = "\n"
            local t1 = os.date("[%A %d %B %Y] - %X - A new game has started on " .. tostring(map) .. ", Mode: " .. tostring(gt))
            local n2 = "\n---------------------------------------------------------------------------------------------\n"
            file:write(n1, t1, n2)
            file:close()
        end
    end

    -- #Admin Chat
    if (settings.mod["Admin Chat"].enabled == true) then
        for i = 1, 16 do
            if player_present(i) then
                if tonumber(get_var(i, "$lvl")) >= getPermLevel("Admin Chat") then
                    local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")
                    players[p_table].adminchat = false
                    players[p_table].boolean = false
                end
            end
        end
    end
end

function OnGameEnd()
    -- Used Globally
    game_over = true
    
    -- #Weapon Settings
    for i = 1,16 do
        if player_present(i) then
            weapon[i] = false
        end
    end
    
    -- #Alias System
    if (settings.mod["Alias System"].enabled == true) then
        for i = 1, 16 do
            if player_present(i) then
                alias_bool[i] = false
                trigger[i] = false
                local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")
                players[p_table].alias_timer = 0
            end
        end
    end
    
    -- #Message Board
    if (settings.mod["Message Board"].enabled == true) then
        for i = 1, 16 do
            if player_present(i) then
                welcome_timer[i] = false
                local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")
                players[p_table].message_board_timer = 0
            end
        end
    end
    
    -- #Chat Logging
    if (settings.mod["Chat Logging"].enabled == true) then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local data = os.date("[%A %d %B %Y] - %X - The game is ending - ")
            file:write(data)
            file:close()
        end
    end

    -- #Admin Chat
    if (settings.mod["Admin Chat"].enabled == true) then
        for i = 1, 16 do
            if player_present(i) then
                if tonumber(get_var(i, "$lvl")) >= getPermLevel("Admin Chat") then
                    local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")
                    if (Restore_Previous_State == true) then
                        if players[p_table].adminchat == true then
                            bool = "true"
                        else
                            bool = "false"
                        end
                        data[i] = get_var(i, "$name") .. ":" .. bool
                        stored_data[data] = stored_data[data] or { }
                        table.insert(stored_data[data], tostring(data[i]))
                    else
                        players[p_table].adminchat = false
                        players[p_table].boolean = false
                    end
                end
            end
        end
    end
end

function OnTick()
    -- #Message Board
    if (settings.mod["Message Board"].enabled == true) then
        for i = 1, 16 do
            if player_present(i) then
                if (welcome_timer[i] == true) then
                    local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")
                    players[p_table].message_board_timer = players[p_table].message_board_timer + 0.030
                    cls(i)
                    local message_board = settings.mod["Message Board"].messages
                    for k, v in pairs(message_board) do
                        for j = 1, #message_board do
                            if string.find(message_board[j], "$SERVER_NAME") then
                                message_board[j] = string.gsub(message_board[j], "$SERVER_NAME", servername)
                            elseif string.find(message_board[j], "$PLAYER_NAME") then
                                message_board[j] = string.gsub(message_board[j], "$PLAYER_NAME", get_var(i, "$name"))
                            end
                        end
                        rprint(i, "|" .. settings.mod["Message Board"].alignment .. " " .. v)
                    end
                    if players[p_table].message_board_timer >= math.floor(settings.mod["Message Board"].duration) then
                        welcome_timer[i] = false
                        players[p_table].message_board_timer = 0
                    end
                end
            end
        end
    end
    -- Custom Weapons
    if (settings.mod["Custom Weapons"].enabled == true and settings.mod["Custom Weapons"].assign_weapons == true) then
        for i = 1, 16 do
            if (player_alive(i)) then
                local player = get_dynamic_player(i)
                if (weapon[i] == true) then
                    execute_command("wdel " .. i)
                    local x, y, z = read_vector3d(player + 0x5C)
                    if settings.mod["Custom Weapons"].weapons[mapname] ~= nil then
                    
                        local primary, secondary, tertiary, quaternary, Slot = select(1,determineWeapon())

                        if (secondary) then
                            assign_weapon(spawn_object("weap", secondary, x, y, z), i)
                        end
                        
                        if (primary) then
                            assign_weapon(spawn_object("weap", primary, x, y, z), i)
                        end
                        
                        if (Slot == 3 or Slot == 4) then
                            timer(100, "delayAssign", player, x, y, z)
                        end
                        
                        function delayAssign()
                            if (quaternary) then
                                assign_weapon(spawn_object("weap", quaternary, x, y, z), i)
                            end
                            
                            if (tertiary) then
                                assign_weapon(spawn_object("weap", tertiary, x, y, z), i)
                            end
                        end
                        
                    end
                    weapon[i] = false
                end
            end
        end
    end
    -- #Alias System
    if (settings.mod["Alias System"].enabled == true) then
        for i = 1, 16 do
            if player_present(i) then
                if (trigger[i] == true) then
                    local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")
                    players[p_table].alias_timer = players[p_table].alias_timer + 0.030
                    cls(i)
                    concatValues(i, 1, 6)
                    concatValues(i, 7, 12)
                    concatValues(i, 13, 18)
                    concatValues(i, 19, 24)
                    concatValues(i, 25, 30)
                    concatValues(i, 31, 36)
                    concatValues(i, 37, 42)
                    concatValues(i, 43, 48)
                    concatValues(i, 49, 55)
                    concatValues(i, 56, 61)
                    concatValues(i, 62, 67)
                    concatValues(i, 68, 73)
                    concatValues(i, 74, 79)
                    concatValues(i, 80, 85)
                    concatValues(i, 86, 91)
                    concatValues(i, 92, 97)
                    concatValues(i, 98, 100)
                    if (alias_bool[i] == true) then
                        local alignment = settings.mod["Alias System"].alignment
                        rprint(i, "|" .. alignment .. " " .. 'Showing aliases for: "' .. target_hash .. '"')
                    end
                    local duration = settings.mod["Alias System"].duration
                    if players[p_table].alias_timer >= math.floor(duration) then
                        trigger[i] = false
                        alias_bool[i] = false
                        players[p_table].alias_timer = 0
                    end
                end
            end
        end
    end
end

function determineWeapon()
    local primary, secondary, tertiary, quaternary, Slot
    for i = 1,4 do
        local weapon = settings.mod["Custom Weapons"].weapons[mapname][i]
        if (weapon ~= nil) then
            if (i == 1 and settings.mod["Custom Weapons"].weapons[mapname][1] ~= nil) then 
                primary = settings.mod["Custom Weapons"].weapons[mapname][1] 
                Slot = 1
            end
            if (i == 2 and settings.mod["Custom Weapons"].weapons[mapname][2] ~= nil) then 
                secondary = settings.mod["Custom Weapons"].weapons[mapname][2]
                Slot = 2
            end
            if (i == 3 and settings.mod["Custom Weapons"].weapons[mapname][3] ~= nil) then 
                tertiary = settings.mod["Custom Weapons"].weapons[mapname][3] 
                Slot = 3
            end
            if (i == 4 and settings.mod["Custom Weapons"].weapons[mapname][4] ~= nil) then 
                quaternary = settings.mod["Custom Weapons"].weapons[mapname][4] 
                Slot = 4
            end
        end
    end
    return primary, secondary, tertiary, quaternary, Slot
end

function OnPlayerPrejoin(PlayerIndex)
    -- #CONSOLE OUTPUT
    os.execute("echo \7")
    local ns = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local cns = ns + 0x1AA + ce + to_real_index(PlayerIndex) * 0x20
    local name, hash, ip, id = read_widestring(cns, 12), get_var(PlayerIndex, "$hash"), get_var(PlayerIndex, "$ip"), get_var(PlayerIndex, "$n")
    savePlayerData(name, hash, ip, id)
    for k, v in ipairs(player_data) do
        if (string.match(v, name) and string.match(v, hash) and string.match(v, id)) then
            cprint("--------------------------------------------------------------------------------")
            cprint("Player attempting to connect to the server...", 5+8)
            cprint(v, 2 + 8)
            break
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = get_var(PlayerIndex, "$n")
    local ip = get_var(PlayerIndex, "$ip")
    
    -- #CONSOLE OUTPUT
    for k, v in ipairs(player_data) do
        if (v:match(name) and v:match(hash) and v:match(id)) then
            cprint("Join Time: " .. os.date("%A %d %B %Y - %X"), 2+8)
            cprint("Status: " .. name .. " connected successfully.", 5 + 8)
            cprint("--------------------------------------------------------------------------------")
        end
    end

    -- Used Globally
    local p_table = name .. ", " .. hash
    players[p_table] = { }
   
    -- #Message Board
    if (settings.mod["Message Board"].enabled == true) then
        players[p_table].message_board_timer = 0
        welcome_timer[PlayerIndex] = true
    end
    
        -- #Alias System
    if (settings.mod["Alias System"].enabled == true) then
        addAlias(name, hash)
        players[p_table].alias_timer = 0
        welcome_timer[PlayerIndex] = true
    end

    -- #Anti Impersonator
    if (settings.mod["Anti Impersonator"].enabled == true) then

        local name_list = settings.mod["Anti Impersonator"].namelist
        local hash_list = settings.mod["Anti Impersonator"].hashlist

        for i = 1, #name_list do
            for j = 1, #hash_list do
                if (name_list[i]:match(name)) and not (hash_list[i]:match(hash)) then
                    local action = settings.mod["Anti Impersonator"].action
                    local reason = settings.mod["Anti Impersonator"].reason
                    if (action == "kick") then
                        execute_command("k" .. " " .. id .. " \"" .. reason .. "\"")
                        cprint(name .. " was kicked for " .. reason, 4 + 8)
                    elseif (action == "ban") then
                        local bantime = settings.mod["Anti Impersonator"].bantime
                        execute_command("b" .. " " .. id .. " " .. bantime .. " \"" .. reason .. "\"")
                        cprint(name .. " was banned for " .. bantime .. " minutes for " .. reason, 4 + 8)
                    end
                    break
                end
            end
        end
    end

    -- #Chat Logging
    if (settings.mod["Chat Logging"].enabled == true) then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local timestamp = os.date("[%d/%m/%Y - %H:%M:%S]")
            file:write(timestamp .. "    [JOIN]    Name: " .. name .. "    ID: [" .. id .. "]    IP: [" .. ip .. "]    CD-Key Hash: [" .. hash .. "]\n")
            file:close()
        end
    end


    -- #Admin Chat
    if (settings.mod["Admin Chat"].enabled == true) then
        players[p_table].adminchat = nil
        players[p_table].boolean = nil
        if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Admin Chat") then
            if (settings.mod["Admin Chat"].restore_previous_state == true) then
                local t = tokenizestring(tostring(data[PlayerIndex]), ":")
                if t[2] == "true" then
                    rprint(PlayerIndex, "Your admin chat is on!")
                    players[p_table].adminchat = true
                    players[p_table].boolean = true
                else
                    players[p_table].adminchat = false
                    players[p_table].boolean = false
                end
            else
                players[p_table].adminchat = false
                players[p_table].boolean = false
            end
        end
    end
end

function OnPlayerLeave(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = get_var(PlayerIndex, "$n")
    local ip

    -- Used Globally
    local p_table = name .. ", " .. hash
    
    -- #Alias System
    if (settings.mod["Alias System"].enabled == true) then
        alias_bool[PlayerIndex] = false
        trigger[PlayerIndex] = false
        players[p_table].alias_timer = 0
    end
    
    -- #CONSOLE OUTPUT
    for k, v in ipairs(player_data) do
        if (v:match(name) and v:match(hash) and v:match(id)) then
            ip = settings.global.player_data[3]
            cprint("--------------------------------------------------------------------------------")
            cprint(v, 4 + 8)
            cprint("--------------------------------------------------------------------------------")
            table.remove(player_data, k)
            break
        end
    end


    -- #Message Board
    if (settings.mod["Message Board"].enabled == true) then
        welcome_timer[PlayerIndex] = false
        players[p_table].message_board_timer = 0
    end


    -- #Chat Logging
    if (settings.mod["Chat Logging"].enabled == true) then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local timestamp = os.date("[%d/%m/%Y - %H:%M:%S]")
            file:write(timestamp .. "    [QUIT]    Name: " .. name .. "    ID: [" .. id .. "]    IP: [" .. ip .. "]    CD-Key Hash: [" .. hash .. "]\n")
            file:close()
        end
    end

    -- #Admin Chat
    if (settings.mod["Admin Chat"].enabled == true) then
        if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Admin Chat") then
            if PlayerIndex ~= 0 then
                if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Admin Chat") then
                    if (settings.mod["Admin Chat"].restore_previous_state == true) then
                        if players[p_table].adminchat == true then
                            bool = "true"
                        else
                            bool = "false"
                        end
                        data[PlayerIndex] = get_var(PlayerIndex, "$name") .. ":" .. bool
                        stored_data[data] = stored_data[data] or { }
                        table.insert(stored_data[data], tostring(data[PlayerIndex]))
                    else
                        players[p_table].adminchat = false
                        players[p_table].boolean = false
                    end
                end
            end
        end
    end
end

function OnPlayerSpawn(PlayerIndex)
    -- #Custom Weapons
    if (settings.mod["Custom Weapons"].enabled == true) then
        weapon[PlayerIndex] = true
        if player_alive(PlayerIndex) then
            local player_object = get_dynamic_player(PlayerIndex)
            if (player_object ~= 0) then
                if (settings.mod["Custom Weapons"].assign_custom_frags == true) then
                    local frags = settings.mod["Custom Weapons"].weapons[mapname][5]
                    write_word(player_object + 0x31E, tonumber(frags))
                end
                if (settings.mod["Custom Weapons"].assign_custom_plasmas == true) then
                    local plasmas = settings.mod["Custom Weapons"].weapons[mapname][6]
                    write_word(player_object + 0x31F, tonumber(plasmas))
                end
            end
        end
    end
end

function OnPlayerChat(PlayerIndex, Message, type)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = get_var(PlayerIndex, "$n")
    local response
    
        -- Used Globally
    local p_table = name .. ", " .. hash

    -- #Command Spy
    if (settings.mod["Command Spy"].enabled == true) then
        local command
        local iscommand = nil
        local message = tostring(Message)
        local String = tokenizestring(message)
        if string.sub(String[1], 1, 1) == "/" then
            command = String[1]:gsub("\\", "/")
            iscommand = true
        else
            iscommand = false
        end

        local hidden_messages = settings.mod["Command Spy"].commands_to_hide
        for k, v in pairs(hidden_messages) do
            if (command == k) then
                hidden = true
                break
            else
                hidden = false
            end
        end

        if (tonumber(get_var(PlayerIndex, "$lvl")) == -1) and (iscommand) then
            local hidden_status = settings.mod["Command Spy"].hide_commands
            if (hidden_status == true and hidden == true) then
                response = false
            elseif (hidden_status == true and hidden == false) or (hidden_status == false) then
                CommandSpy(settings.mod["Command Spy"].prefix .. " " .. name .. ":    \"" .. message .. "\"")
                response = true
            end
        end
    end


    -- #Chat Logging
    if (settings.mod["Chat Logging"].enabled == true) then
        local message = tostring(Message)
        local command = tokenizestring(message)
        iscommand = nil
        if string.sub(command[1], 1, 1) == "/" or string.sub(command[1], 1, 1) == "\\" then
            iscommand = true
            chattype = "[COMMAND] "
        else
            iscommand = false
        end

        local chat_type = nil

        if type == 0 then
            chat_type = "[GLOBAL]  "
        elseif type == 1 then
            chat_type = "[TEAM]    "
        elseif type == 2 then
            chat_type = "[VEHICLE] "
        end

        if (player_present(PlayerIndex) ~= nil) then
            local dir = settings.mod["Chat Logging"].dir
            local function LogChat(dir, value)
                local timestamp = os.date("[%d/%m/%Y - %H:%M:%S]")
                local file = io.open(dir, "a+")
                if file ~= nil then
                    local chatValue = string.format("%s\t%s\n", timestamp, tostring(value))
                    file:write(chatValue)
                    file:close()
                end
            end
            if iscommand then
                LogChat(dir, "   " .. chattype .. "     " .. name .. " [" .. id .. "]: " .. message)
                cprint(chattype .. " " .. name .. " [" .. id .. "]: " .. message, 3 + 8)
            else
                LogChat(dir, "   " .. chat_type .. "     " .. name .. " [" .. id .. "]: " .. message)
                cprint(chat_type .. " " .. name .. " [" .. id .. "]: " .. message, 3 + 8)
            end
        end
    end

    -- #Chat IDs
    if (settings.mod["Chat IDs"].enabled == true) then
        if not (game_over) then
            local data
            local message = tokenizestring(Message)
            if (#message == 0) then
                return nil
            end
            local messages_to_ignore = settings.mod["Chat IDs"].ignore_list

            for a = 1, #messages_to_ignore do
                data = messages_to_ignore[a]
            end

            if not data:match(message[1]) then
                local function ChatHandler(PlayerIndex, Message)
                    local function SendToTeam(Message, PlayerIndex)
                        for i = 1, 16 do
                            if player_present(i) then
                                if (get_var(i, "$team")) == (get_var(PlayerIndex, "$team")) then
                                    local TeamMessageFormat = settings.mod["Chat IDs"].team_format[1]
                                    for k, v in pairs(settings.mod["Chat IDs"].team_format) do
                                        TeamMessageFormat = string.gsub(TeamMessageFormat, "%%sender_name%%", name)
                                        TeamMessageFormat = string.gsub(TeamMessageFormat, "%%index%%", id)
                                        TeamMessageFormat = string.gsub(TeamMessageFormat, "%%message%%", Message)
                                        execute_command("msg_prefix \"\"")
                                        say(i, TeamMessageFormat)
                                        execute_command("msg_prefix \" " .. settings.global.server_prefix .. "\"")
                                        response = false
                                    end
                                end
                            end
                        end
                    end
                    local function SendToAll(Message)
                        local GlobalMessageFormat = settings.mod["Chat IDs"].global_format[1]
                        for k, v in pairs(settings.mod["Chat IDs"].global_format) do
                            GlobalMessageFormat = string.gsub(GlobalMessageFormat, "%%sender_name%%", name)
                            GlobalMessageFormat = string.gsub(GlobalMessageFormat, "%%index%%", id)
                            GlobalMessageFormat = string.gsub(GlobalMessageFormat, "%%message%%", Message)
                            execute_command("msg_prefix \"\"")
                            say_all(GlobalMessageFormat)
                            execute_command("msg_prefix \" " .. settings.global.server_prefix .. "\"")
                            response = false
                        end
                    end
                    for b = 0, #message do
                        if message[b] then
                            if not (string.sub(message[1], 1, 1) == "/" or string.sub(message[1], 1, 1) == "\\") then
                                if (GetTeamPlay() == true) then
                                    if (type == 0 or type == 2) then
                                        SendToAll(Message)
                                    elseif (type == 1) then
                                        SendToTeam(Message, PlayerIndex)
                                    end
                                else
                                    SendToAll(Message)
                                end
                            else
                                response = true
                            end
                            break
                        end
                    end
                end
                if (settings.mod["Admin Chat"].enabled == true) then
                    if (players[p_table].adminchat ~= true) then
                        ChatHandler(PlayerIndex, Message)
                    end
                else
                    ChatHandler(PlayerIndex, Message)
                end
            end
        end
    end

    -- #Admin Chat
    if (settings.mod["Admin Chat"].enabled == true) then
        local function AdminChat(Message, PlayerIndex)
            for i = 1, 16 do
                if player_present(i) and tonumber(get_var(i, "$lvl")) >= getPermLevel("Admin Chat") then
                    if (settings.mod["Admin Chat"].environment == "rcon") then
                        rprint(i, "|l" .. Message)
                    elseif (settings.mod["Admin Chat"].environment == "chat") then
                        execute_command("msg_prefix \"\"")
                        say(i, Message)
                        execute_command("msg_prefix \" *  * SERVER *  * \"")
                    end
                end
            end
        end
        local message = tokenizestring(Message)
        if #message == 0 then
            return nil
        end
        
        if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Admin Chat") and players[p_table].adminchat == true then
            for c = 0, #message do
                if message[c] then
                    if string.sub(message[1], 1, 1) == "/" or string.sub(message[1], 1, 1) == "\\" then
                        response = true
                    else
                        local AdminMessageFormat = settings.mod["Admin Chat"].message_format[1]
                        for k, v in pairs(settings.mod["Admin Chat"].message_format) do
                            local prefix = settings.mod["Admin Chat"].prefix
                            AdminMessageFormat = string.gsub(AdminMessageFormat, "%%prefix%%", prefix)
                            AdminMessageFormat = string.gsub(AdminMessageFormat, "%%sender_name%%", name)
                            AdminMessageFormat = string.gsub(AdminMessageFormat, "%%index%%", id)
                            AdminMessageFormat = string.gsub(AdminMessageFormat, "%%message%%", Message)
                            AdminChat(AdminMessageFormat)
                            response = false
                        end
                    end
                    break
                end
            end
        end
    end
    return response
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    
    -- Used Globally
    local p_table = name .. ", " .. hash
    
    -- #List Players
    if (settings.mod["List Players"].enabled == true) then
        local t = tokenizestring(Command)
        local commands = settings.mod["List Players"].command_aliases
        local count = #t
        for k, v in pairs(commands) do
            local cmds = tokenizestring(v, ",")
            for i = 1, #cmds do
                if (t[1] == cmds[i]) then
                    if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("List Players") then
                        listPlayers(PlayerIndex, count)
                    else
                        rprint(PlayerIndex, "Insufficient Permission")
                    end
                    return false
                end
            end
        end
    end

    -- #Admin Chat
    if (settings.mod["Admin Chat"].enabled == true) then
        local t = tokenizestring(Command)
        local command = settings.mod["Admin Chat"].base_command
        if t[1] == (command) then
            if PlayerIndex ~= -1 and PlayerIndex >= 1 and PlayerIndex < 16 then
                if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Admin Chat") then
                    if t[2] == "on" or t[2] == "1" or t[2] == "true" or t[2] == '"1"' or t[2] == '"on"' or t[2] == '"true"' then
                        if players[p_table].boolean ~= true then
                            players[p_table].adminchat = true
                            players[p_table].boolean = true
                            rprint(PlayerIndex, "Admin Chat enabled.")
                            return false
                        else
                            rprint(PlayerIndex, "Admin Chat is already enabled.")
                            return false
                        end
                    elseif t[2] == "off" or t[2] == "0" or t[2] == "false" or t[2] == '"off"' or t[2] == '"0"' or t[2] == '"false"' then
                        if players[p_table].boolean ~= false then
                            players[p_table].adminchat = false
                            players[p_table].boolean = false
                            rprint(PlayerIndex, "Admin Chat disabled.")
                            return false
                        else
                            rprint(PlayerIndex, "Admin Chat is already disabled.")
                            return false
                        end
                    else
                        rprint(PlayerIndex, "Invalid Syntax: Type /achat on|off")
                        return false
                    end
                else
                    rprint(PlayerIndex, "You do not have permission to execute that command!")
                    return false
                end
            else
                cprint("The Server cannot execute this command!", 4 + 8)
            end
        end
    end
    -- #Alias System
    if (settings.mod["Alias System"].enabled == true) then
        local t = tokenizestring(Command)
        if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("List Players") then 
            if t[1] == string.lower(settings.mod["Alias System"].base_command) then
                if t[2] ~= nil then
                    if t[2] == string.match(t[2], "^%d+$") and t[3] == nil then
                        if player_present(tonumber(t[2])) then
                            local index = tonumber(t[2])
                            target_hash = tostring(get_var(index, "$hash"))
                            if trigger[PlayerIndex] == true then
                                -- aliases already showing (clear console then show again)
                                cls(PlayerIndex)
                                players[p_table].alias_timer = 0
                                trigger[PlayerIndex] = true
                                alias_bool[PlayerIndex] = true
                            else
                                -- show aliases (first time)
                                trigger[PlayerIndex] = true
                                alias_bool[PlayerIndex] = true
                            end
                        else
                            players[p_table].alias_timer = 0
                            trigger[PlayerIndex] = false
                            cls(PlayerIndex)
                            rprint(PlayerIndex, "Player not present")
                        end
                    else
                        players[p_table].alias_timer = 0
                        trigger[PlayerIndex] = false
                        cls(PlayerIndex)
                        rprint(PlayerIndex, "Invalid player id")
                    end
                    return false
                else
                    rprint(PlayerIndex, "Invalid syntax. Use /" .. base_command .. " [id]")
                    return false
                end
            end
        else
            rprint(PlayerIndex, "Insufficient Permission")
        end
    end
end

-- #List Players
function listPlayers(PlayerIndex, count)
    if (count == 1) then
        rprint(PlayerIndex, "|" .. settings.mod["List Players"].alignment .. " [ ID.    -    Name.    -    Team.    -    IP. ]")
        for i = 1, 16 do
            if player_present(i) then
                local name = get_var(i, "$name")
                local id = get_var(i, "$n")
                local team = get_var(i, "$team")
                local ip = get_var(i, "$ip")
                local hash = get_var(i, "$hash")
                if get_var(0, "$ffa") == "0" then
                    if team == "red" then
                        team = "Red Team"
                    elseif team == "blue" then
                        team = "Blue Team"
                    else
                        team = "Hidden"
                    end
                else
                    team = "FFA"
                end
                rprint(PlayerIndex, "|" .. settings.mod["List Players"].alignment .. id .. ".   " .. name .. "   |   " .. team .. "  -  IP: " .. ip)
            end
        end
    else
        rprint(PlayerIndex, "Invalid Syntax")
        return false
    end
end

-- #Command Spy
function CommandSpy(Message)
    for i = 1, 16 do
        if (tonumber(get_var(i, "$lvl"))) >= getPermLevel("Command Spy") then
            rprint(i, Message)
        end
    end
end

-- #Message Board
function read_widestring(address, length)
    local count = 0
    local byte_table = {}
    for i = 1, length do
        if read_byte(address + count) ~= 0 then
            byte_table[i] = string.char(read_byte(address + count))
        end
        count = count + 2
    end
    return table.concat(byte_table)
end

-- #Anti Impersonator
function table.match(table, value)
    for k, v in pairs(table) do
        if v == value then
            return k
        end
    end
end

-- Clears the players console
function cls(PlayerIndex)
    for _ = 1, 25 do
        rprint(PlayerIndex, " ")
    end
end

-- Used Globally
function tokenizestring(inputString, Separator)
    if Separator == nil then
        Separator = "%s"
    end
    local t = {};
    i = 1
    for str in string.gmatch(inputString, "([^" .. Separator .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

-- Used Globally
function getPermLevel(script)
    return settings.mod[script].permission_level
end

-- Used Globally
function GetTeamPlay()
    if get_var(0, "$ffa") == "0" then
        return true
    else
        return false
    end
end

-- Used Globally
function lines_from(file)
    lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

-- Saves player join data (name, hash, ip address, id)
function savePlayerData(name, hash, ip, id)
    local a = string.gsub(settings.global.player_data[1], "%%name%%", name)
    local b = string.gsub(settings.global.player_data[2], "%%hash%%", hash)
    local c = string.gsub(settings.global.player_data[3], "%%ip_address%%", ip)
    local d = string.gsub(settings.global.player_data[4], "%%index_id%%", id)
    local data = a .. "\n" .. b .. "\n" .. c .. "\n" .. d
    table.insert(player_data, data)
end

-- Prints enabled scripts | Called by OnScriptLoad()
function printEnabled()
    for k, v in pairs(settings.mod) do
        if (settings.mod[k].enabled == true) then
            cprint(k .. " is enabled", 2 + 8)
        else
            cprint(k .. " is disabled", 4 + 8)
        end
    end
end

-- #Weapon Settings
function loadWeaponTags()
    pistol = "weapons\\pistol\\pistol"
    sniper = "weapons\\sniper rifle\\sniper rifle"
    plasma_cannon = "weapons\\plasma_cannon\\plasma_cannon"
    rocket_launcher = "weapons\\rocket launcher\\rocket launcher"
    plasma_pistol = "weapons\\plasma pistol\\plasma pistol"
    plasma_rifle = "weapons\\plasma rifle\\plasma rifle"
    assault_rifle = "weapons\\assault rifle\\assault rifle"
    flamethrower = "weapons\\flamethrower\\flamethrower"
    needler = "weapons\\needler\\mp_needler"
    shotgun = "weapons\\shotgun\\shotgun"
end

function table.val_to_str (v)
    if "string" == type(v) then
        v = string.gsub(v, "\n", "\\n")
        if string.match(string.gsub(v, "[^'\"]", ""), '^"+$') then
            return "'" .. v .. "'"
        end
        return '"' .. string.gsub(v, '"', '\\"') .. '"'
    else
        return "table" == type(v) and table.tostring(v) or
                tostring(v)
    end
end

function table.key_to_str (k)
    if "string" == type(k) and string.match(k, "^[_%a][_%a%d]*$") then
        return k
    else
        return "[" .. table.val_to_str(k) .. "]"
    end
end

function table.tostring(tbl)
    local result, done = {}, {}
    for k, v in ipairs(tbl) do
        table.insert(result, table.val_to_str(v))
        done[k] = true
    end
    for k, v in pairs(tbl) do
        if not done[k] then
            table.insert(result,
                    table.key_to_str(k) .. "=" .. table.val_to_str(v))
        end
    end
    return "{" .. table.concat(result, ",") .. "}"
end

-- #Alias System
function addAlias(name, hash)
    local file_name = settings.mod["Alias System"].dir
    local file = io.open(file_name, "r")
    local data = file:read("*a")
    file:close()
    if string.match(data, hash) then
        local lines = lines_from(file_name)
        for k, v in pairs(lines) do
            if string.match(v, hash) then
                if not v:match(name) then
                    local alias = v .. ", " .. name
                    local f = io.open(file_name, "r")
                    local content = f:read("*all")
                    f:close()
                    content = string.gsub(content, v, alias)
                    local f = io.open(file_name, "w")
                    f:write(content)
                    f:close()
                end
            end
        end
    else
        local file = assert(io.open(file_name, "a+"))
        file:write("\n" .. hash .. ":" .. name, "\n")
        file:close()
    end
end

-- #Alias System
function checkFile()
    local file_name = settings.mod["Alias System"].dir
    local file = io.open(file_name, "rb")
    if file then
        file:close()
    else
        local file = io.open(file_name, "a+")
        if file then
            file:close()
        end
    end
end

function concatValues(PlayerIndex, start_index, end_index)
    local file_name = settings.mod["Alias System"].dir
    local lines = lines_from(file_name)
    for k, v in pairs(lines) do
        if v:match(target_hash) then
            local aliases = string.match(v, (":(.+)"))
            local words = tokenizestring(aliases, ", ")
            local word_table = {}
            local row
            for i = tonumber(start_index), tonumber(end_index) do
                if words[i] ~= nil then
                    table.insert(word_table, words[i])
                    row = table.concat(word_table, ", ")
                end
            end
            if row ~= nil then
                rprint(PlayerIndex, "|" .. settings.mod["Alias System"].alignment .. " " .. row)
            end
            for _ in pairs(word_table) do
                word_table[_] = nil
            end
            break
        end
    end
end

function OnError(Message)
    print(debug.traceback())
end
