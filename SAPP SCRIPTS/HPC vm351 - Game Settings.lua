--[[
    ------------------------------------
Script Name: HPC vm351 - Game Settings
    - Implementing API version: 1.11.0.0

    Only on github for safe keeping

Description:

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]-- 

api_version = "1.11.0.0"

function OnScriptLoad()
    logo = timer(50, "consoleLogo")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    if halo_type == "PC" then ce = 0x0 else ce = 0x40 end
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
end

function OnScriptUnload()
    logo = nil
end

function OnNewGame()
    logo = nil
end

function OnGameEnd()
    logo = nil
    -- delayend = timer(1000*2, "NextGame")
end

function NextGame()
    execute_command("next_game")
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
    cprint("            - - |   P L A Y E R   A T T E M P T I N G   T O   J O I N   | - -")
    cprint("                 - - - - - - - - - - - - - - - - - - - - - - - - - - - -                    ")
    cprint("Player: " .. name, 2 + 8)
    cprint("CD Hash: " .. hash)
    cprint("IP Address: " .. ip)
    cprint("IndexID: " .. id)
end

function OnPlayerJoin(PlayerIndex)

    local timestamp = os.date("%A %d %B %Y - %X")
    cprint("Join Time: " .. timestamp)
    cprint("Status: connected successfully.")
    cprint("---------------------------------------------------------------------------------------------------")
end

function OnPlayerLeave(PlayerIndex)

    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    -- local ip = get_var(PlayerIndex, "$ip")
    local id = get_var(PlayerIndex, "$n")
    local ping = get_var(PlayerIndex, "$ping")
    local timestamp = os.date("%A %d %B %Y - %X")

    cprint("---------------------------------------------------------------------------------------------------")
    cprint(name .. " quit the game!", 4 + 8)
    cprint("CD Hash: " .. hash)
    -- cprint("IP Address: " ..ip)
    cprint("IndexID: " .. id)
    cprint("Player Ping: " .. ping)
    cprint("Time: " .. timestamp)
    cprint("---------------------------------------------------------------------------------------------------")
    cprint("")
end

function consoleLogo()

    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    servername = read_widestring(network_struct + 0x8, 0x42)
    local timestamp = os.date("%A, %d %B %Y - %X")
    cprint("===================================================================================================", 2 + 8)
    cprint(timestamp, 6)
    cprint("")
    cprint("                  '||'                  ||     ..|'''.|                   .'|.   .", 4 + 8)
    cprint("                   ||    ....  ... ..  ...   .|'     '  ... ..   ....   .||.   .||.", 4 + 8)
    cprint("                   ||  .|...||  ||' ''  ||   ||          ||' '' '' .||   ||     ||", 4 + 8)
    cprint("                   ||  ||       ||      ||   '|.      .  ||     .|' ||   ||     ||", 4 + 8)
    cprint("               || .|'   '|...' .||.    .||.   ''|....'  .||.    '|..'|' .||.    '|.'", 4 + 8)
    cprint("                '''", 4 + 8)
    cprint("                      ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
    cprint("                                         Chalwk's Realm")
    cprint("                                  " .. servername)
    cprint("                      ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
    cprint("")
    cprint("===================================================================================================", 2 + 8)
end

function read_widestring(address, length)
    local count = 0
    local byte_table = { }
    for i = 1, length do
        if read_byte(address + count) ~= 0 then
            byte_table[i] = string.char(read_byte(address + count))
        end
        count = count + 2
    end
    return table.concat(byte_table)
end