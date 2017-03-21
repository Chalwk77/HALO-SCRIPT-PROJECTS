--[[    
------------------------------------
Script Name: vm351 - Game Settings

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
All Rights Reserved.
You do not have permission to use this script.

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
-----------------------------------
]]-- 
api_version = "1.11.0.0"
delay = 1000*7

function OnScriptLoad()
    logo = timer(50, "consoleLogo")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    if halo_type == "PC" then ce = 0x0 else ce = 0x40 end
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
	if get_var(0, "$gt") ~= "n/a" then end		
end

function OnScriptUnload() end
function OnGameEnd(PlayerIndex)
    cprint("The game is ending...", 4+8)
end

function OnPlayerPrejoin(PlayerIndex)
    os.execute("echo \7")
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local client_network_struct = network_struct + 0x1AA + ce + to_real_index(PlayerIndex) * 0x20
    local name = read_widestring(client_network_struct, 12)
    local hash = get_var(PlayerIndex, "$hash")
    local ip = get_var(PlayerIndex, "$ip")
    local id = get_var(PlayerIndex, "$n")
    cprint("---------------------------------------------------------------------------------------------------")
    cprint("              - - |   P L A Y E R   J O I N   | - -")
    cprint("     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")
    cprint("Player: " ..name, 2+8)
    cprint("CD Hash: " ..hash)
    cprint("IP Address: " ..ip)
    cprint("IndexID: " ..id)
end

function OnPlayerJoin(PlayerIndex)
    local timestamp = os.date("%A %d %B %Y - %X")
    cprint("Join Time: " ..timestamp)
    cprint("Status: connected successfully.")
    cprint("---------------------------------------------------------------------------------------------------")
end

function OnPlayerLeave(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = get_var(PlayerIndex, "$n")
    local ping = get_var(PlayerIndex, "$ping")
    local timestamp = os.date("%A %d %B %Y - %X")
    cprint("---------------------------------------------------------------------------------------------------")
    cprint(name.. " quit the game!", 4+8)
    cprint("CD Hash: " ..hash)
    cprint("IndexID: " ..id)
    cprint("Player Ping: " ..ping)
    cprint("Time: " ..timestamp)
    cprint("---------------------------------------------------------------------------------------------------")
    cprint("")
end

function consoleLogo()
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    servername = read_widestring(network_struct + 0x8, 0x42)
    local timestamp = os.date("%A, %d %B %Y - %X")
    -- Logo: ascii: 'kban'
    cprint("===================================================================================================", 2+8)
    cprint(timestamp, 6)
    cprint("")
    cprint("                  '||'                  ||     ..|'''.|                   .'|.   .", 4+8)
    cprint("                   ||    ....  ... ..  ...   .|'     '  ... ..   ....   .||.   .||.", 4+8)
    cprint("                   ||  .|...||  ||' ''  ||   ||          ||' '' '' .||   ||     ||", 4+8)
    cprint("                   ||  ||       ||      ||   '|.      .  ||     .|' ||   ||     ||", 4+8)
    cprint("               || .|'   '|...' .||.    .||.   ''|....'  .||.    '|..'|' .||.    '|.'", 4+8)
    cprint("                '''", 4+8)
    cprint("                      ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
    cprint("                                         Chalwk's Realm")
    cprint("                                      " .. servername)
    cprint("                      ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
    cprint("")
    cprint("===================================================================================================", 2+8)
end

function OnPlayerChat(PlayerIndex, Message, type)
    local Message = string.lower(Message)
    if (Message == "/suicide") or (Message == "\\suicide") then
        execute_command("kill ", PlayerIndex)
        execute_command("msg_prefix \"\"")
        say_all("[R.I.P] " .. get_var(PlayerIndex, "$name") .. " committed suicide.")
        execute_command("msg_prefix \"** SERVER ** \"")
        return false
    end
    if (Message == "/st") or (Message == "\\st") then
            if (tonumber(get_var(PlayerIndex,"$lvl"))) >= 1 then
            execute_command("msg_prefix \"\"")
            execute_command("st ", PlayerIndex)
            say_all(get_var(PlayerIndex, "$name") .. " switched teams!")
            execute_command("msg_prefix \"** SERVER ** \"")
            return false
        end
    end
    if (Message == "/about") 
    or (Message == "/about ") 
    or (Message == "/info") 
    or (Message == "/info ")
    or (Message == "\\about") 
    or (Message == "\\about ") 
    or (Message == "\\info") 
    or (Message == "\\info ")
    or (Message == "@about") 
    or (Message == "@about ") 
    or (Message == "@info") 
    or (Message == "@info ") then
        return false
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