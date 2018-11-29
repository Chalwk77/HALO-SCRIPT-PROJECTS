--[[
--=====================================================================================================--
Script Name: Periodic Messages, for SAPP (PC & CE)
Description: This mod will periodically announce the custom messages in the "message_board" table.

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
~ Created by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]

-- frequency to print the messages in "message_board" (in seconds)
frequency = 5 * 60
-- Type the %server_name% variable to output the server name.
message_board = {
    "You are playing on %server_name%",
    "your discord channel id",
    "your skype username",
    "your teamspeak ip",
    "your website url",
    "your youtube channel url"
}

api_version = '1.12.0.0'

function OnScriptLoad()
    timer(1000 * frequency, "print")
end

function OnScriptUnload()

end

function print()
    for _, v in pairs(message_board) do
        for i = 1, #message_board do
            if string.find(message_board[i], "%%server_name%%") then
                local count = 0
                local byte_table = {}
                for j = 1, 0x42 do
                    if read_byte(read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3) + 0x8 + count) ~= 0 then
                        byte_table[j] = string.char(read_byte(read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3) + 0x8 + count))
                    end
                    count = count + 2
                end
                local ServerName = table.concat(byte_table)
                message_board[i] = string.gsub(message_board[i], "%%server_name%%", ServerName)
            end
        end
        execute_command("msg_prefix \"\"")
        say_all(v)
        execute_command("msg_prefix \" *  * SERVER *  * \"")
    end
    return true
end
