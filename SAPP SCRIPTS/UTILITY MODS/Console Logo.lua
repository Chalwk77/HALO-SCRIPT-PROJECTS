--[[
--=====================================================================================================--
Script Name: Console Logo, for SAPP (PC & CE)
Description: Custom ascii console logo (font is kban)

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- USE THIS WEBSITE TO GENERATE YOUR LOGO:
-- https://patorjk.com/software/taag/#p=display&f=Graffiti&t=Type%20Something%20
-- Make sure logo text is encapsulated in quotes.

-- config starts --
local logo = {

    -- format: {"text", text color}
    -- See SAPP documentation for color codes.

    { "================================================================================", 10 },
    { "%time_stamp%", 6 },
    { "" },
    { "     '||'  '||'     |     '||'       ..|''||           ..|'''.| '||''''|  ", 12, },
    { "      ||    ||     |||     ||       .|'    ||        .|'     '   ||  .    ", 12, },
    { "      ||''''||    |  ||    ||       ||      ||       ||          ||''|    ", 12, },
    { "      ||    ||   .''''|.   ||       '|.     ||       '|.      .  ||       ", 12, },
    { "     .||.  .||. .|.  .||. .||.....|  ''|...|'         ''|....'  .||.....| ", 12, },
    { "               ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-", 7 },
    { "                             %server_name%", 10 },
    { "               ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-", 7 },
    { "" },
    { "================================================================================", 10 }
}

-- config ends --

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
        for _, v in pairs(logo) do
            local text = v[1]
            local color = v[2] or 0
            cprint(text:gsub("%%time_stamp%%", time_stamp):gsub("%%server_name%%", server_name), color)
        end
    end
end

function OnScriptUnload()
    -- N/A
end