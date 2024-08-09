--[[
--=====================================================================================================--
Script Name: Flip a Coin, for SAPP (PC & CE)
Description: A simple addon that lets you flip a text-based virtual coin!

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- Config Starts

local command = "flip"
local permission_level = -1
local output = {
    "Flipping $flips times...",
    "Heads: $head_count/$flips - $percent",
    "Tails: $tail_count/$flips - $percent",
    "This took $time seconds"
}

local flips = 100000000

-- Config Ends

local heads = 1
local head_count, tail_count = 0, 0

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb["EVENT_COMMAND"], "OnCommand")
end

local function HasPermission(Ply)
    local lvl = tonumber(get_var(Ply, '$lvl'))
    return (lvl >= permission_level)
end

local function Send(Ply, Str)
    return (Ply == 0 and cprint(Str, 10) or rprint(Ply, Str))
end

function OnCommand(Ply, CMD)

    if (CMD:sub(1, command:len()):lower() == command) then

        if HasPermission(Ply) then

            local start_time = os.time()

            local Flipping = output[1]:gsub("$flips", flips)
            Send(Ply, Flipping)

            math.randomseed(os.time())
            local x
            for _ = 1, flips do
                x = math.random(2)
                if (x == heads) then
                    head_count = head_count + 1
                else
                    tail_count = tail_count + 1
                end
            end

            local end_time = os.time()

            local Heads = output[2]      :
            gsub("$head_count", head_count):
            gsub('$flips', flips)        :
            gsub('$percent', head_count / flips * 100)

            Send(Ply, Heads)

            local Tails = output[3]      :
            gsub("$tail_count", head_count):
            gsub('$flips', flips)        :
            gsub('$percent', tail_count / flips * 100)

            Send(Ply, Tails)

            local TimeLapsed = output[4]:gsub('$time', end_time - start_time)
            Send(Ply, TimeLapsed)

            return false
        end
    else
        Send(Ply, 'Insufficient Permission')
    end
end

function OnScriptUnload()
    -- N/A
end