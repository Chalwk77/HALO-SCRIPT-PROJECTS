--[[
--=====================================================================================================--
Script Name: Base Game Settings

Copyright (c) 2016-2019 Jericho Crosby <jericho.crosby227@gmail.com>
You do not have permission to use this document.

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

settings = {
    -- Enabled = true, Disabled = false
    mod = {
        ["Admin Chat"] = {
            enabled = true,
        },
        ["Chat IDs"] = {
            enabled = true,
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
            enabled = false,
            assign_custom_frags = false,
            assign_custom_plasmas = false
        },
        ["Anti Impersonator"] = {
            enabled = true,
            action = "kick",
            reason = "impersonating",
            bantime = 10,
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
        }
    }
}

-- #Anti Impersonator
NameList = {
    "Chalwk",
}
HashList = {
    "6c8f0bc306e0108b4904812110185edd",
}

-- Table used globally
players = { }

-- #Message Board
welcome_timer = { }
message_board_timer = { }

function OnScriptLoad()
    printEnabled()
    register_callback(cb['EVENT_TICK'], "OnTick")
    
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    
    register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    
    if (settings.mod["Message Board"].enabled == true) then
        -- #Message Board
        for i = 1, 16 do
            if player_present(i) then
                players[get_var(i, "$n")].message_board_timer = 0
            end
        end
    end
    
    -- Used OnPlayerJoin()
    if halo_type == "PC" then
        ce = 0x0
    else
        ce = 0x40
    end
end
   
function OnScriptUnload()
    --
end

function OnNewGame()
    -- Used globally
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    servername = read_widestring(network_struct + 0x8, 0x42)
    
    
    -- #Message Board
    if (settings.mod["Message Board"].enabled == true) then
        for i = 1, 16 do
            if player_present(i) then
                if player_present(i) then
                    players[get_var(i, "$n")].message_board_timer = 0
                end
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
end

function OnGameEnd()
    -- #Message Board
    if (settings.mod["Message Board"].enabled == true) then
        for i = 1, 16 do
            if player_present(i) then
                if player_present(i) then
                    welcome_timer[i] = false
                    players[get_var(i, "$n")].message_board_timer = 0
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
                    players[get_var(i, "$n")].message_board_timer = players[get_var(i, "$n")].message_board_timer + 0.030
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
                    if players[get_var(i, "$n")].message_board_timer >= math.floor(settings.mod["Message Board"].duration) then
                        welcome_timer[i] = false
                        players[get_var(i, "$n")].message_board_timer = 0
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
    cprint("Player: " .. read_widestring(cns, 12), 2 + 8)
    cprint("CD Hash: " .. get_var(PlayerIndex, "$hash"))
    cprint("IP Address: " .. get_var(PlayerIndex, "$ip"))
    cprint("IndexID: " .. get_var(PlayerIndex, "$n"))
end

function OnPlayerJoin(PlayerIndex)
    local Name = get_var(PlayerIndex, "$name")
    local Hash = get_var(PlayerIndex, "$hash")
    local Index = get_var(PlayerIndex, "$n")
    
    -- CONSOLE OUTPUT (todo: future update = store join data to table)
    cprint("Join Time: " .. os.date("%A %d %B %Y - %X"))
    cprint("Status: connected successfully.")
    cprint("--------------------------------------------------------------------------------")
    
    -- #Message Board
    if (settings.mod["Message Board"].enabled == true) then
        players[Index] = { }
        players[Index].message_board_timer = 0
        welcome_timer[PlayerIndex] = true
    end
    
    -- #Anti Impersonator
    if (settings.mod["Anti Impersonator"].enabled == true) then
        if (table.match(NameList, Name)) and not (table.match(HashList, Hash)) then
            local action = settings.mod["Anti Impersonator"].action
            local reason = settings.mod["Anti Impersonator"].reason
            if (action == "kick") then
                execute_command("k" .. " " .. Index .. " \"" .. reason .. "\"")
                cprint(Name .. " was kicked for " .. reason, 4+8)
            elseif (action == "ban") then
                local bantime = settings.mod["Anti Impersonator"].bantime
                execute_command("b" .. " " .. Index .. " " .. bantime .. " \"" .. reason .. "\"")
                cprint(Name .. " was banned for " .. bantime .. " minutes for " .. reason, 4+8)
            end
        end
    end
end

function OnPlayerLeave(PlayerIndex)
    local player_name = get_var(PlayerIndex, "$name")
    
    -- #Message Board
    if (settings.mod["Message Board"].enabled == true) then
        welcome_timer[PlayerIndex] = false
        players[get_var(PlayerIndex, "$n")].message_board_timer = 0
    end
end

function OnPlayerChat(PlayerIndex, Message, type)
    local player_name = get_var(PlayerIndex, "$name")
    
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
                return false
            elseif (hidden_status == true and hidden == false) or (hidden_status == false) then
                CommandSpy(settings.mod["Command Spy"].prefix .. " " .. player_name .. ":    \"" .. message .. "\"")
                return true
            end
        end
    end
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
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

-- Used globally
function getPermLevel(script)
    return settings.mod[script].permission_level
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

function OnError(Message)
    print(debug.traceback())
end
