--[[
--=====================================================================================================--
Script Name: Flip a Coin, for SAPP (PC & CE)
Description: A simple addon that lets you flip a text-based virtual coin!

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

-- Config Starts

local flip_command = "flip"
local output = "You flipped %side%"
local permission_level = -1

-- Config Ends

api_version = "1.12.0.0"
local gmatch, gsub = string.gmatch, string.gsub

function OnScriptLoad()
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
end

local hasAccess = function(PlayerIndex)
    return (tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level)
end

function OnServerCommand(Executor, Command, _, _)
    local Args = CmdSplit(Command)
    if (Args[1] == nil or Args[1] == "") then
        return
    elseif (Args[1] == flip_command and Args[2] == nil) and hasAccess(Executor) then
        math.randomseed(os.clock())
        local coin = math.random(1, 2)
        if (coin == 1) then
            coin = gsub(output, "%%side%%", "heads")
        else
            coin = gsub(output, "%%side%%", "tails")
        end
        cprint(coin, 2 + 8)
        rprint(Executor, coin)
        return false
    end
end

function OnScriptUnload()

end

function CmdSplit(CMD)
    local t, i = {}, 1
    for Args in gmatch(CMD, "([^%s]+)") do
        t[i] = Args
        i = i + 1
    end
    return t
end

