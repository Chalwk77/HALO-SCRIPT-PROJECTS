--[[
--=====================================================================================================--
Script Name: Base Settings

Copyright © 2016-2019 Jericho Crosby <jericho.crosby227@gmail.com>
You do not have permission to use this document.

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    if halo_type == "PC" then
        ce = 0x0
    else
        ce = 0x40
    end
end
function OnPlayerPrejoin(PlayerIndex)
    -- CONSOLE OUTPUT
    os.execute("echo \7")
    local ns = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local cns = ns + 0x1AA + ce + to_real_index(PlayerIndex) * 0x20
    cprint("--------------------------------------------------------------------------------")
    cprint("Player: " .. rws(cns, 12), 2 + 8)
    cprint("CD Hash: " .. get_var(PlayerIndex, "$hash"))
    cprint("IP Address: " .. get_var(PlayerIndex, "$ip"))
    cprint("IndexID: " .. get_var(PlayerIndex, "$n"))
end

function OnPlayerJoin(PlayerIndex)
    cprint("Join Time: " .. os.date("%A %d %B %Y - %X"))
    cprint("Status: connected successfully.")
    cprint("--------------------------------------------------------------------------------")
    if (tonumber(get_var(PlayerIndex, "$lvl"))) >= 1 then
        for i = 1,16 do
            if player_present(i) then
                rprint(i, "Admin: " .. get_var(PlayerIndex, "$name"))
            end
        end
    end
end

function OnPlayerLeave(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = get_var(PlayerIndex, "$n")
    local ping = get_var(PlayerIndex, "$ping")
    cprint("--------------------------------------------------------------------------------")
    cprint(name .. " quit the game!", 4 + 8)
    cprint("CD Hash: " .. hash)
    cprint("IndexID: " .. id)
    cprint("Player Ping: " .. ping)
    cprint("Time: " .. os.date("%A %d %B %Y - %X"))
    cprint("--------------------------------------------------------------------------------")
    cprint("")
end

function rws(address, length)
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

function OnError(Message)
    print(debug.traceback())
end
