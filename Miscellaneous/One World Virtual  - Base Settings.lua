--[[    
--=====================================================================================================--
Script Name: One World Virtual | Base Settings

Copyright © 2016-2018 Jericho Crosby <jericho.crosby227@gmail.com>
You do not have permission to use this document.

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]-- 
api_version = "1.12.0.0"

-- SCRIPT SETTINGS --
script_settings = {
    -- Message Board
    ["UseMessageBoard"] = false,
    -- General
    ["AnnouncePlayerIsAdmin"] = false,
    -- Weapon Settings
    ["UseCustomWeapons"] = false,
    ["AssignFrags"] = true,
    ["AssignPlasmas"] = true,
    -- Admin Chat
    ["UseAdminChat"] = true,
    -- Chat Logging
    ["UseChatLogging"] = true,
    -- Command Spy
    ["UseCommandSpy"] = true,
    -- Anti Impersonator
    ["UseAntiImpersonator"] = true
}

-- ADMIN CHAT --
min_admin_level = 1
prefix = "[ADMIN CHAT] "
Restore_Previous_State = true
Format = "rcon"
data = { }
players = { }
adminchat = { }
stored_data = { }
boolean = { }

-- CHAT LOGGING --
local dir = 'sapp\\Server Chat.txt'
local timestamp = os.date("[%d/%m/%Y - %H:%M:%S]")

-- COMMAND SPY --
settings = {
    ["HideCommands"] = true
}
commands_to_hide = {
    "/null",
    "/null"
    }
    
-- MESSAGE BOARD --
welcome_timer = { }
new_timer = { }
mb_players = { }
message_board = {
    "Welcome to $SERVER_NAME",
    "Bug reports and suggestions:",
    "https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues/25"
    }
Message_Duration = 10
Message_Alignment = "l"

-- WEAPON SETTINGS --
weapons = { }
weapon = { }
frags = { }
plasmas = { }
weapons[00000] = "nil\\nil\\nil"
MapIsListed = nil
weapons[1] = "weapons\\pistol\\pistol"
weapons[2] = "weapons\\sniper rifle\\sniper rifle"
weapons[3] = "weapons\\rocket launcher\\rocket launcher" 
weapons[4] = "weapons\\shotgun\\shotgun"
tertiary_quaternary_delay = 50
mapnames = {
    "bloodgulch",
}
frags = {
    bloodgulch = 7,
    }
plasmas = {
    bloodgulch = 7,
}

-- ANTI-IMPERSONATOR
response = {
    ["kick"] = true,
    ["ban"] = false
}
BANTIME = 10
REASON = "Impersonating"

function OnScriptLoad()
    -- Console Output
    timer(50, "consoleLogo")
    -- EVENTS
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_COMMAND'],"OnServerCommand")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    if halo_type == "PC" then ce = 0x0 else ce = 0x40 end
    local ns = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    -- ADMIN CHAT
    if script_settings["UseAdminChat"] == true then
        for i = 1,16 do
            if player_present(i) then
                players[get_var(i, "$name")].adminchat = nil
                players[get_var(i, "$name")].boolean = nil
            end
        end
    end
    -- MESSAGE BOARD
    if script_settings["UseMessageBoard"] == true then
        for i = 1, 16 do
            if player_present(i) then
                mb_players[get_var(i, "$n")].new_timer = 0
            end
        end
    end
    -- WEAPON SETTINGS
    if script_settings["UseCustomWeapons"] == true then
        if get_var(0, "$gt") ~= "n/a" then
            mapname = get_var(0, "$map")
        end
    end
    -- ANTI-IMPERSONATOR
    if script_settings["UseAntiImpersonator"] == true then
        LoadTables( )
        if (response["ban"] == true) and (response["kick"] == true) then
            cprint("Script Error: AntiImpersonator.lua", 4+8)
            cprint("Only one option should be enabled! [punishment configuration] - (line 73/74)", 4+8)
            unregister_callback(cb['OnPlayerJoin'])
            unregister_callback(cb['OnGameEnd'])
        end
    end
end

function OnScriptUnload()
    -- ADMIN CHAT
    if script_settings["UseAdminChat"] == true then
        for i = 1,16 do
            if player_present(i) then
                players[get_var(i, "$name")].adminchat = false
                players[get_var(i, "$name")].boolean = false
            end
        end
    end
    -- WEAPON SETTINGS
    if script_settings["UseCustomWeapons"] == true then
        frags = { }
        plasmas = { }
        weapon = { }
        weapons = { }
        maps = { }
    end
    -- ANTI-IMPERSONATOR
    if script_settings["UseAntiImpersonator"] == true then
        NameList = { }
        HashList = { }
    end
end

-- ANTI-IMPERSONATOR
function LoadTables( )
    NameList = {"Chalwk"}	
    HashList = {"6c8f0bc306e0108b4904812110185edd"}
end

function OnNewGame()
    cprint("A new game has started.", 2+8)
    -- ADMIN CHAT
    if script_settings["UseAdminChat"] == true then
        for i = 1,16 do
            if player_present(i) then
                players[get_var(i, "$name")].adminchat = nil
                players[get_var(i, "$name")].boolean = nil
            end
        end
    end
    -- CHAT LOGGING
    if script_settings["UseChatLogging"] == true then
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
    -- MESSAGE BOARD
    if script_settings["UseMessageBoard"] == true then
        for i = 1, 16 do
            if player_present(i) then
                if player_present(i) then
                    mb_players[get_var(i, "$n")].new_timer = 0
                end
            end
        end
        local ns = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
        server_name = rws(ns + 0x8, 0x42)
    end
    -- WEAPON SETTINGS
    if script_settings["UseCustomWeapons"] == true then
        mapname = get_var(0, "$map")
        if (table.match(mapnames, mapname) == nil) then 
            MapIsListed = false
            Error = 'Error: ' .. mapname .. ' is not listed in "mapnames table" - line 615'
            cprint(Error, 4+8)
            execute_command("log_note \""..Error.."\"")
        else
            MapIsListed = true
        end
    end
end

function OnGameEnd(PlayerIndex)
    cprint("The game is ending...", 4+8)
    -- ADMIN CHAT
    if script_settings["UseAdminChat"] == true then
        for i = 1,16 do
            if player_present(i) then
                if (Restore_Previous_State == true) then
                    if players[get_var(i, "$name")].adminchat == true then bool = "true" else bool = "false" end
                    data[i] = get_var(i, "$name") .. ":" .. bool
                    stored_data[data] = stored_data[data] or { }
                    table.insert(stored_data[data], tostring(data[i]))
                else
                    players[get_var(i, "$name")].adminchat = false
                    players[get_var(i, "$name")].boolean = false
                end
            end
        end
    end
    -- CHAT LOGGING
    if script_settings["UseChatLogging"] == true then
        local file = io.open(dir, "a+")
        if file ~= nil then
            local data = os.date("[%A %d %B %Y] - %X - The game is ending - ")
            file:write(data)
            file:close()
        end
    end
    -- MESSAGE BOARD
    if script_settings["UseMessageBoard"] == true then
        for i = 1, 16 do
            if player_present(i) then
                if player_present(i) then
                    welcome_timer[i] = false
                    mb_players[get_var(i, "$n")].new_timer = 0
                end
            end
        end
    end
    -- ANTI-IMPERSONATOR
    if script_settings["UseAntiImpersonator"] == true then
        NameList = { }
        HashList = { }
    end
end

-- WEAPON SETTINGS
function TertiaryDelay(x,y,z, player)
    assign_weapon(spawn_object("weap", weapons[1], x, y, z), player)
    assign_weapon(spawn_object("weap", weapons[4], x, y, z), player)
end

function OnTick()
    -- MESSAGE BOARD
    if script_settings["UseMessageBoard"] == true then
        for i = 1, 16 do
            if player_present(i) then
                if (welcome_timer[i] == true) then
                    mb_players[get_var(i, "$n")].new_timer = mb_players[get_var(i, "$n")].new_timer + 0.030
                    cls(i)
                    for k, v in pairs(message_board) do
                        for j=1, #message_board do
                            if string.find(message_board[j], "$SERVER_NAME") then
                                message_board[j] = string.gsub(message_board[j], "$SERVER_NAME", server_name)
                            elseif string.find(message_board[j], "$PLAYER_NAME") then
                                message_board[j] = string.gsub(message_board[j], "$PLAYER_NAME", get_var(i, "$name"))
                            end
                        end
                        rprint(i, "|" .. Message_Alignment .. " " .. v)
                    end
                    if mb_players[get_var(i, "$n")].new_timer >= math.floor(Message_Duration) then
                        welcome_timer[i] = false
                        mb_players[get_var(i, "$n")].new_timer = 0
                    end
                end
            end
        end
    end
    -- WEAPON SETTINGS
    if script_settings["UseCustomWeapons"] == true then
        for i = 1, 16 do
            if (player_alive(i)) then
                if MapIsListed == false then
                    return false
                else
                    if (weapon[i] == true) then
                        execute_command("wdel " .. i)
                        local x, y, z = read_vector3d(get_dynamic_player(i) + 0x5C)
                        if (mapname == "bloodgulch") then
                            assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                            assign_weapon(spawn_object("weap", weapons[3], x, y, z), i)
                            timer(tertiary_quaternary_delay, "TertiaryDelay", x, y, z, i)
                            weapon[i] = false
                        end
                    end
                end
            end
        end
    end
end

function OnPlayerPrejoin(PlayerIndex)
    -- CONSOLE OUTPUT
    os.execute("echo \7")
    local ns = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local cns = ns + 0x1AA + ce + to_real_index(PlayerIndex) * 0x20
    cprint("--------------------------------------------------------------------------------")
    cprint("Player: " .. rws(cns, 12), 2+8)
    cprint("CD Hash: " .. get_var(PlayerIndex, "$hash"))
    cprint("IP Address: " .. get_var(PlayerIndex, "$ip"))
    cprint("IndexID: " .. get_var(PlayerIndex, "$n"))
end

function OnPlayerJoin(PlayerIndex)
    -- CONSOLE OUTPUT
    cprint("Join Time: " .. os.date("%A %d %B %Y - %X"))
    cprint("Status: connected successfully.")
    cprint("--------------------------------------------------------------------------------")
    -- GENERAL SETTINGS
    if script_settings["AnnouncePlayerIsAdmin"] == true then
        if (tonumber(get_var(PlayerIndex,"$lvl"))) >= 1 then
            execute_command("msg_prefix \"\"")
            say_all("Server Admin: " .. get_var(PlayerIndex, "$name"))
            execute_command("msg_prefix \"** SERVER ** \"")
        end
    end
    -- ADMIN CHAT
    if script_settings["UseAdminChat"] == true then
        players[get_var(PlayerIndex, "$name")] = { }
        players[get_var(PlayerIndex, "$name")].adminchat = nil
        players[get_var(PlayerIndex, "$name")].boolean = nil
        if (Restore_Previous_State == true) then
            local t = tokenizestring(tostring(data[PlayerIndex]), ":")
            if t[2] == "true" then
                rprint(PlayerIndex, "Your admin chat is on!")
                players[get_var(PlayerIndex, "$name")].adminchat = true
                players[get_var(PlayerIndex, "$name")].boolean = true
            else
                players[get_var(PlayerIndex, "$name")].adminchat = false
                players[get_var(PlayerIndex, "$name")].boolean = false
            end
        else
            players[get_var(PlayerIndex, "$name")].adminchat = false
            players[get_var(PlayerIndex, "$name")].boolean = false
        end
    end
    -- CHAT LOGGING
    if script_settings["UseChatLogging"] == true then
        local name = get_var(PlayerIndex, "$name")
        local id = get_var(PlayerIndex, "$n")
        local ip = get_var(PlayerIndex, "$ip")
        local hash = get_var(PlayerIndex, "$hash")
        local file = io.open(dir, "a+")
        if file ~= nil then
            file:write(timestamp .. "    [JOIN]    Name: " .. name .. "    ID: [" .. id .. "]    IP: [" .. ip .. "]    CD-Key Hash: [" .. hash .. "]\n")
            file:close()
        end
    end
    -- MESSAGE BOARD
    if script_settings["UseMessageBoard"] == true then
        mb_players[get_var(PlayerIndex, "$n")] = { }
        mb_players[get_var(PlayerIndex, "$n")].new_timer = 0
        welcome_timer[PlayerIndex] = true
    end
    -- ANTI-IMPERSONATOR
    if script_settings["UseAntiImpersonator"] == true then
        local Name = get_var(PlayerIndex,"$name")
        local Hash = get_var(PlayerIndex,"$hash")
        local Index = get_var(PlayerIndex, "$n")
        if (table.match(NameList, Name)) and not (table.match(HashList, Hash)) then
            if (response["kick"] == true) and (response["ban"] == false) then 
                execute_command("k" .. " " .. Index .. " \"" .. REASON .. "\"")
            end
            if (response["ban"] == true) and (response["kick"] == false) and (BANTIME >= 1) then  
                execute_command("b" .. " " .. Index .. " " .. BANTIME .. " \"" .. REASON .. "\"")
            elseif (BANTIME == 0) then
                execute_command("b" .. " " .. Index .. " \"" .. REASON .. "\"")
            end
        end
    end
end

function OnPlayerSpawn(PlayerIndex)
    if script_settings["UseCustomWeapons"] == true then
        weapon[PlayerIndex] = true
        mapname = get_var(0, "$map")
        if player_alive(PlayerIndex) then
            local player_object = get_dynamic_player(PlayerIndex)
            if (player_object ~= 0) then
                if (script_settings["AssignFrags"] == true) then
                    if (frags[mapname] == nil) then 
                        Error = 'Error: ' .. mapname .. ' is not listed in the Frag Grenade Table - Line 73 | Unable to set frags.'
                        cprint(Error, 4+8)
                        execute_command("log_note \""..Error.."\"")
                    else
                        write_word(player_object + 0x31E, frags[mapname])
                    end
                end
                if (script_settings["AssignPlasmas"] == true) then
                    if (plasmas[mapname] == nil) then 
                        Error = 'Error: ' .. mapname .. ' is not listed in the Plasma Grenade Table - Line 76 | Unable to set plasmas.'
                        cprint(Error, 4+8)
                        execute_command("log_note \""..Error.."\"")
                    else
                        write_word(player_object + 0x31F, plasmas[mapname])
                    end
                end
            end
        end
    end
end

function OnPlayerLeave(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = get_var(PlayerIndex, "$n")
    local ping = get_var(PlayerIndex, "$ping")
    local ip = get_var(PlayerIndex, "$ip")
    cprint("--------------------------------------------------------------------------------")
    cprint(name.. " quit the game!", 4+8)
    cprint("CD Hash: " ..hash)
    cprint("IndexID: " ..id)
    cprint("Player Ping: " ..ping)
    cprint("Time: " .. os.date("%A %d %B %Y - %X"))
    cprint("--------------------------------------------------------------------------------")
    cprint("")
    -- ADMIN CHAT
    if script_settings["UseAdminChat"] == true then
        if PlayerIndex ~= 0 then
            if (Restore_Previous_State == true) then
                if players[get_var(PlayerIndex, "$name")].adminchat == true then bool = "true" else bool = "false" end
                data[PlayerIndex] = get_var(PlayerIndex, "$name") .. ":" .. bool
                stored_data[data] = stored_data[data] or { }
                table.insert(stored_data[data], tostring(data[PlayerIndex]))
            else
                players[get_var(PlayerIndex, "$name")].adminchat = false
                players[get_var(PlayerIndex, "$name")].boolean = false
            end
        end
    end
    -- CHAT LOGGING
    if script_settings["UseChatLogging"] == true then
        local file = io.open(dir, "a+")
        if file ~= nil then
            file:write(timestamp .. "    [QUIT]    Name: " .. name .. "    ID: [" .. id .. "]    IP: [" .. ip .. "]    CD-Key Hash: [" .. hash .. "]\n")
            file:close()
        end
    end
    -- MESSAGE BOARD
    if script_settings["UseMessageBoard"] == true then
        welcome_timer[PlayerIndex] = false
        mb_players[get_var(PlayerIndex, "$n")].new_timer = 0
    end
end

-- MESSAGE BOARD
function cls(PlayerIndex)
    for clear_cls = 1, 25 do
        rprint(PlayerIndex, " ")
    end
end

-- CONSOLE OUTPUT
function consoleLogo()
    local ns = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local servername = rws(ns + 0x8, 0x42)
    -- Logo: ascii: 'kban'
    cprint("================================================================================", 2+8)
    cprint(os.date("%A, %d %B %Y - %X"), 6)
    cprint("")
    cprint("          ..|'''.| '||'  '||'     |     '||'      '|| '||'  '|' '||'  |'    ",  4+8)
    cprint("          .|'     '   ||    ||     |||     ||        '|. '|.  .'   || .'    ",  4+8)
    cprint("          ||          ||''''||    |  ||    ||         ||  ||  |    ||'|.    ",  4+8)
    cprint("          '|.      .  ||    ||   .''''|.   ||          ||| |||     ||  ||   ",  4+8)
    cprint("          ''|....'  .||.  .||. .|.  .||. .||.....|     |   |     .||.  ||.  ",  4+8)
    cprint("                  ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
    cprint("                               " .. servername)
    cprint("                  ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
    cprint("")
    cprint("================================================================================", 2+8)
end

function OnServerCommand(PlayerIndex, Command)
    -- ADMIN CHAT
    if script_settings["UseAdminChat"] == true then
        Command = string.lower(Command)
        local t = tokenizestring(Command)
        response = nil
        if t[1] == "achat" then
            if PlayerIndex ~= -1 and PlayerIndex >= 1 and PlayerIndex < 16 then
                if (tonumber(get_var(PlayerIndex,"$lvl"))) >= min_admin_level then
                    if t[2] == "on" or t[2] == "1" or t[2] == "true" or t[2] == '"1"' or t[2] == '"on"' or t[2] == '"true"' then
                        if players[get_var(PlayerIndex, "$name")].boolean ~= true then 
                            rprint(PlayerIndex, "Admin Chat enabled.")
                            players[get_var(PlayerIndex, "$name")].adminchat = true
                            players[get_var(PlayerIndex, "$name")].boolean = true
                        else
                            rprint(PlayerIndex, "Admin Chat is already enabled.")
                        end
                    elseif t[2] == "off" or t[2] == "0" or t[2] == "false" or t[2] == '"off"' or t[2] == '"0"' or t[2] == '"false"' then
                        if players[get_var(PlayerIndex, "$name")].boolean ~= false then
                            players[get_var(PlayerIndex, "$name")].adminchat = false
                            players[get_var(PlayerIndex, "$name")].boolean = false
                            rprint(PlayerIndex, "Admin Chat disabled.")
                        else
                            rprint(PlayerIndex, "Admin Chat is already disabled.")
                        end
                    else
                        rprint(PlayerIndex, "Invalid Syntax: Type /achat on|off")
                    end
                else
                    rprint(PlayerIndex, "You do not have permission to execute that command!")
                end
            else
                cprint("The Server cannot execute this command!", 4+8)
            end
            response = false
        end
        return response
    end
end

function OnPlayerChat(PlayerIndex, Message, type)
    -- GENERAL SETTINGS
    local Message = string.lower(Message)
    if (Message == "/st") or (Message == "\\st") then
            if (tonumber(get_var(PlayerIndex,"$lvl"))) >= 1 then
				execute_command("msg_prefix \"\"")
				execute_command("st ", PlayerIndex)
				say_all(get_var(PlayerIndex, "$name") .. " switched teams!")
				execute_command("msg_prefix \"** SERVER ** \"")
				else
				say(PlayerIndex, "You're not allowed to use that command")
            return false
        end
    end
    local character = "/" or "\\"
    if (tonumber(get_var(PlayerIndex,"$lvl"))) == -1 then
        if (Message == character .. "about") or (Message == character .. "info") then
            say(PlayerIndex, "Sorry, that's private information!")
            return false
        end
    end
    -- ADMIN CHAT
    if script_settings["UseAdminChat"] == true then
        local message = tokenizestring(Message)
        if #message == 0 then return nil end
        if players[get_var(PlayerIndex, "$name")].adminchat == true then
            for i = 0, #message do
                if message[i] then
                    if string.sub(message[1], 1, 1) == "/" or string.sub(message[1], 1, 1) == "\\" then
                        return true
                    else
                        AdminChat(prefix .. " " .. get_var(PlayerIndex, "$name") .. ":  " .. Message, PlayerIndex)
                        return false
                    end
                end
            end
        end
    end
    -- CHAT LOGGING
    if script_settings["UseChatLogging"] == true then
        local Message = tostring(Message)
        local Command = tokenizestring(Message)
        local iscommand = nil
        if string.sub(Command[1], 1, 1) == "/" or string.sub(Command[1], 1, 1) == "\\" then 
            iscommand = true
            chattype = "[COMMAND] "
        else 
            iscommand = false
        end
        if type == 0 then
            Type = "[GLOBAL]  "
        elseif type == 1 then
            Type = "[TEAM]    "
        elseif type == 2 then
            Type = "[VEHICLE] "
        end    
        if (player_present(PlayerIndex) ~= nil) then
            if iscommand then 
                WriteData(dir, "   " .. chattype .. "     " .. get_var(PlayerIndex, "$name") .. " [" .. get_var(PlayerIndex, "$n") .. "]: " .. Message)
                cprint(chattype .." " .. get_var(PlayerIndex, "$name") .. " [" .. get_var(PlayerIndex, "$n") .. "]: " .. Message, 3+8)
            else
                WriteData(dir, "   " .. Type .. "     " .. get_var(PlayerIndex, "$name") .. " [" .. get_var(PlayerIndex, "$n") .. "]: " .. Message)
                cprint(Type .." " .. get_var(PlayerIndex, "$name") .. " [" .. get_var(PlayerIndex, "$n") .. "]: " .. Message, 3+8)
            end
        end
    end
    -- COMMAND SPY
    if script_settings["UseCommandSpy"] == true then
        if (tonumber(get_var(PlayerIndex,"$lvl"))) >= 0 then
            AdminIndex = tonumber(PlayerIndex)
        end
        local cSpy_iscommand = nil
        local Message = tostring(Message)
        local command = tokenizestring(Message)
        if string.sub(command[1], 1, 1) == "/" then
            cmd = command[1]:gsub("\\", "/")
            cSpy_iscommand = true
        else 
            cSpy_iscommand = false
        end
        for k, v in pairs(commands_to_hide) do
            if (cmd == v) then
                hidden = true
                break
            else
                hidden = false
            end
        end    
        if (tonumber(get_var(PlayerIndex,"$lvl"))) == -1 then
            if (cSpy_iscommand and PlayerIndex) then
                if (settings["HideCommands"] == true and hidden == true) then
                    return false
                elseif (settings["HideCommands"] == true and hidden == false) or (settings["HideCommands"] == false) then
                    CommandSpy("[SPY]   " .. get_var(PlayerIndex, "$name") .. ":    \"" .. Message .. "\"", PlayerIndex)
                    return true
                end
            end
        end
    end
    return true
end

-- ADMIN CHAT
function AdminChat(Message, PlayerIndex)
    for i = 1, 16 do
        if player_present(i) then
            if (tonumber(get_var(i,"$lvl"))) >= min_admin_level then
                if (Format == "rcon") then
                    rprint(i, "|l" .. Message)
                elseif (Format == "chat") then
                    execute_command("msg_prefix \"\"")
                    say(i, Message)
                    execute_command("msg_prefix \"** SERVER ** \"")
                else
                    cprint("Error in base_game_settings.lua - Format not defined properly. Line 26", 4+8)
                end
            end
        end
    end
end

-- COMMANY SPY
function CommandSpy(Message, AdminIndex) 
    for i = 1,16 do
        if (tonumber(get_var(i,"$lvl"))) >= 1 then
            rprint(i, Message)
        end
    end
end

-- CHAT LOGGING
function WriteData(dir, value)
    local file = io.open(dir, "a+")
    if file ~= nil then
        local chatValue = string.format("%s\t%s\n", timestamp, tostring(value))
        file:write(chatValue)
        file:close()
    end
end

-- WEAPON SETTINGS | ANTI-IMPERSONATOR
function table.match(table, value)
    for k,v in pairs(table) do
        if v == value then
            return k
        end
    end
end

function rws(address, length)
    local count = 0
    local byte_table = {}
    for i = 1,length do
        if read_byte(address + count) ~= 0 then
            byte_table[i] = string.char(read_byte(address + count))
        end
        count = count + 2
    end
    return table.concat(byte_table)
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function OnError(Message)
    print(debug.traceback())
end
