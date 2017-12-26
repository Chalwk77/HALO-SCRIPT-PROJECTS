--[[
--=====================================================================================================--
Script Name: Message Board (utility), for SAPP (PC & CE)
Description:    This mod will announce welcome messages to the newly joined player. 
                These welcome messages are displayed in the rcon console. You can specify how long the messages are displayed on screen.
                
				Change Log [26/12/2017]
                [+] Added custom message board output variables: $SERVER_NAME, $PLAYER_NAME
                
    
Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"
welcome_timer = { }
new_timer = { }
players = { }
--[[ 
    
Configuration Starts


Message Board: 
Use $SERVER_NAME variable to output the server name.
Use $PLAYER_NAME variable to output the joining player's name.

]]
-- messages --
message_board = {
    "Welcome to $SERVER_NAME",
    "Message Board created by Chalwk (Jericho Crosby)",
    "https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS"
    }
-- How long should the message be displayed on screen for? (in seconds) --
Message_Duration = 10

-- Message Alignment:
-- Left = l,    Right = r,    Center = c,    Tab: t
Message_Alignment = "l"
-- Configuration Ends --
--=====================================================================================================--

-- Do not touch anything below (unless you know what you're doing) --
function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    for i = 1, 16 do
        if player_present(i) then
            players[get_var(i, "$n")].new_timer = 0
        end
    end
end
    
function OnNewGame()
    for i = 1, 16 do
        if player_present(i) then
            if player_present(i) then
                players[get_var(i, "$n")].new_timer = 0
            end
        end
    end
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    servername = read_widestring(network_struct + 0x8, 0x42)
end

function OnGameEnd()
    for i = 1, 16 do
        if player_present(i) then
            if player_present(i) then
                welcome_timer[i] = false
                players[get_var(i, "$n")].new_timer = 0
            end
        end
    end
end
    
function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            if (welcome_timer[i] == true) then
                players[get_var(i, "$n")].new_timer = players[get_var(i, "$n")].new_timer + 0.030
                cls(i)
                for k, v in pairs(message_board) do
                    for j=1, #message_board do
                        if string.find(message_board[j], "$SERVER_NAME") then
                            message_board[j] = string.gsub(message_board[j], "$SERVER_NAME", servername)
                        elseif string.find(message_board[j], "$PLAYER_NAME") then
                            message_board[j] = string.gsub(message_board[j], "$PLAYER_NAME", get_var(i, "$name"))
                        end
                    end
                    rprint(i, "|" .. Message_Alignment .. " " .. v)
                end
                if players[get_var(i, "$n")].new_timer >= math.floor(Message_Duration) then
                    welcome_timer[i] = false
                    players[get_var(i, "$n")].new_timer = 0
                end
            end
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    welcome_timer[PlayerIndex] = true
    players[get_var(PlayerIndex, "$n")] = { }
    players[get_var(PlayerIndex, "$n")].new_timer = 0
end

function OnPlayerLeave(PlayerIndex)
    welcome_timer[PlayerIndex] = false
    players[get_var(PlayerIndex, "$n")].new_timer = 0
end

function cls(PlayerIndex)
    for clear_cls = 1, 25 do
        rprint(PlayerIndex, " ")
    end
end

function read_widestring(address, length)
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
