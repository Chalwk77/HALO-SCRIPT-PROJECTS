--[[
--=====================================================================================================--
Script Name: Console Logo, for SAPP (PC & CE)
Description: Custom ascii console logo (font is kban)

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

function OnScriptLoad()
    timer(50, "PrintLogo")
end

local function read_widestring(a, l)
    local count = 0
    local byte_table = {}
    for i = 1, l do
        if (read_byte(a + count) ~= 0) then
            byte_table[i] = string.char(read_byte(a + count))
        end
        count = count + 2
    end
    return table.concat(byte_table)
end

function PrintLogo()
    if (get_var(0, "$gt") ~= "n/a") then
        local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
        local server_name = read_widestring(network_struct + 0x8, 0x42)
        local time_stamp = os.date("%A, %d %B %Y - %X")
        cprint("================================================================================", 10)
        cprint(time_stamp, 6)
        cprint("")
        cprint("     '||'  '||'     |     '||'       ..|''||           ..|'''.| '||''''|  ", 12)
        cprint("      ||    ||     |||     ||       .|'    ||        .|'     '   ||  .    ", 12)
        cprint("      ||''''||    |  ||    ||       ||      ||       ||          ||''|    ", 12)
        cprint("      ||    ||   .''''|.   ||       '|.     ||       '|.      .  ||       ", 12)
        cprint("     .||.  .||. .|.  .||. .||.....|  ''|...|'         ''|....'  .||.....| ", 12)
        cprint("               ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-", 7)
        cprint("                             " .. server_name, 10)
        cprint("               ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-", 7)
        cprint("")
        cprint("================================================================================", 10)
    end
end

function OnScriptUnload()
    -- N/A
end