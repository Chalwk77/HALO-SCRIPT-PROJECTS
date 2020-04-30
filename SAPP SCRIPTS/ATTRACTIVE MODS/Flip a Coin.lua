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
local permission_level = -1
local output = {
    "Flipping %flips% times...",
    "Heads: %headcount%/%flips% - %percent%%",
    "Tails: %tailcount%/%flips% - %percent%%",
    "This took %time% seconds"
}

local flips = 100000000

-- Config Ends

local heads, tails = 1, 2
local headcount, tailcount = 0, 0

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

        local starttime = os.time()

        local Flipping = gsub(output[1], "%%flips%%", flips)
        Send(Executor, Flipping)

        math.randomseed(os.time())
        local x
        for i = 1, flips do
            x = math.random(2)
            if (x == heads) then
                headcount = headcount + 1
            else
                tailcount = tailcount + 1
            end
        end

        local endtime = os.time()

        local Heads = gsub(gsub(gsub(output[2],
                "%%headcount%%", headcount),
                "%%flips%%", flips),
                "%%percent%%", (headcount / flips * 100))
        Send(Executor, Heads)

        local Tails = gsub(gsub(gsub(output[3],
                "%%tailcount%%", tailcount),
                "%%flips%%", flips),
                "%%percent%%", (tailcount / flips * 100))
        Send(Executor, Tails)

        local TimeLapsed = gsub(output[4], "%%time%%", (endtime - starttime))
        Send(Executor, TimeLapsed)

        return false
    end
end

function OnScriptUnload()

end

function Send(PlayerIndex, Message)
    if (PlayerIndex == 0) then
        cprint(Message, 2 + 8)
    else
        rprint(PlayerIndex, Message)
    end
end

function CmdSplit(CMD)
    local t, i = {}, 1
    for Args in gmatch(CMD, "([^%s]+)") do
        t[i] = Args
        i = i + 1
    end
    return t
end
