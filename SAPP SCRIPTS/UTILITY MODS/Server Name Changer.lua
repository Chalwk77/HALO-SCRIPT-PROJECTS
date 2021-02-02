--[[
--=====================================================================================================--
Script Name: Server Name Changer (UTILITY), for SAPP (PC & CE)
Description: This script will periodically change the name of the server.

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- config starts --
local interval = 15 -- in seconds
-- The script will pick a new server name every 15 seconds:
local server_names = {
    "Name 1",
    "Name 2",
    "Name 3",
    "Name 4",
    "Name 5", -- repeat the structure to add more entries.
}
-- config ends --

local network_struct
function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
end

local time_scale = 1 / 30
local counter, index = 0, 1

function OnTick()
    counter = counter + time_scale
    if (counter >= interval) then
        write_widestring(network_struct + 0x8, server_names[index], 0x42)
        counter, index = 0, index + 1
        if (index > #server_names) then
            index = 1
        end
    end
end

----------------------------------------------
-- Credits to Devieth for these two functions:
function write_widestring(address, str, len)
    local Count = 0
    for _ = 1, len do
        write_byte(address + Count, 0)
        Count = Count + 2
    end
    local count = 0
    local length = string.len(str)
    for i = 1, length do
        write_byte(address + count, string.byte(string.sub(str, i, i)))
        count = count + 2
    end
end

function read_widestring(Address, Size)
    local str = ""
    for i = 0, Size - 1 do
        if (read_byte(Address + i * 2) ~= 00) then
            str = str .. string.char(read_byte(Address + i * 2))
        end
    end
    if (str ~= "") then
        return str
    end
    return nil
end