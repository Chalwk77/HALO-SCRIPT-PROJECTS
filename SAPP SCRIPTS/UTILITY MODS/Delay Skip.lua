--[[
--=====================================================================================================--
Script Name: Skip Delay, for SAPP (PC & CE)
Description: Prevent players from skipping the map too early.

Copyright (c) 2021-2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- Players have to wait this many seconds before they can skip the map:
-- (Default: 10 seconds)
--
local delay = 10

api_version = "1.12.0.0"

local time
local clock = os.clock
local ceil = math.ceil

function OnScriptLoad()

    register_callback(cb['EVENT_CHAT'], 'Skip')
    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')

    OnStart()
end

local function Plural(n)
    return (n > 1 and 's') or ''
end

function Skip(Ply, Msg)
    if (time and Msg:sub(1, Msg:len()):lower() == 'skip') then
        local n = ceil(time + delay - clock())
        if (n > 0) then
            rprint(Ply, 'Please wait ' .. n .. ' second' .. Plural(n) .. ' before skipping.')
            return false
        end
    end
end

function OnStart()
    time = (get_var(0, '$gt') ~= 'n/a') and os.clock() or nil
end

function OnEnd()
    time = nil
end

function OnScriptUnload()
    -- N/A
end