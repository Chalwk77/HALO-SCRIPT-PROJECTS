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
            duration = 25,
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
            hide_commands = true,
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

function OnPlayerPrejoin(PlayerIndex)
    --
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

function OnPlayerJoin(PlayerIndex)
    local Name = get_var(PlayerIndex, "$name")
    local Hash = get_var(PlayerIndex, "$hash")
    local Index = get_var(PlayerIndex, "$n")
    
    -- #Message Board
    if (settings.mod["Message Board"].enabled == true) then
        players[get_var(PlayerIndex, "$n")] = { }
        players[get_var(PlayerIndex, "$n")].message_board_timer = 0
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
    -- #Message Board
    if (settings.mod["Message Board"].enabled == true) then
        welcome_timer[PlayerIndex] = false
        players[get_var(PlayerIndex, "$n")].message_board_timer = 0
    end
end

function OnChatMessage(PlayerIndex, Message, type)
    --
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
    for str in string.gmatch(inputstr, "([^" .. Separator .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

-- Prints enabled scripts | Called by OnScriptLoad()
function printEnabled()
    for k, v in pairs(settings.mod) do
        if (settings.mod[k].enabled == true) then
            cprint(k .. " is enabled", 2 + 8)
        end
    end
end

function OnError(Message)
    print(debug.traceback())
end
