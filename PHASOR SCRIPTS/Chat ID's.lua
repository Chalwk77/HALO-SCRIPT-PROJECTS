--[[
--=====================================================================================================--
Script Name: Chat IDs, for Phasor V2, (PC & CE)
Description: Suffixes the player's name with their Index ID.
Example output: Chalwk [1]: This is some message

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
--=====================================================================================================--
]]--

function GetRequiredVersion()
    return 200
end

function OnScriptLoad()
    -- N/A
end

function OnServerChat(Ply, _, Msg)
    return true, "[" .. resolveplayer(Ply) .. "]: " .. Msg
end