--[[
--=====================================================================================================--
Script Name: Auto Message for SAPP (PC & CE)
Description: This script will periodically broadcast pre-defined messages to all players.

Copyright (c) 2022-2025, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--
local AutoMessage = {
    --
    -- Announcements
    --
    announcements = {
        { -- Message 1 (multi-line)
            'Multi-Line Support | Message 1, line 1',
            'Message 1, line 2',
        },
        { -- Message 2 (single-line)
            'Like us on Facebook | facebook.com/page_id'
        },
        { -- Message 3
            'Follow us on Twitter | twitter.com/twitter_id'
        },
        { -- Message 4
            'We are recruiting. Sign up on our website | website url'
        },
        { -- Message 5
            'Rules / Server Information'
        },
        { -- Message 6
            'Announcement 6'
        },
        { -- Message 7
            'Other information here'
        },
        -- Add more entries with the same structure
    },
    --
    ------------------------------------------------------------------------------
    -- Time between message announcements (in seconds)
    interval = 300,
    -- If true, messages will appear in chat; otherwise, they will appear in the player console
    showAnnouncementsInChat = true,
    -- If true, messages will also be printed to server console terminal (in pink)
    showAnnouncementsOnConsole = true,
    -- A message relay function temporarily removes the server prefix and restores it to this when the relay finishes
    serverPrefix = '**SAPP**'
}

api_version = '1.12.0.0'
local timer, index

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

local function createTimer(finish)
    return {
        start = os.time(),
        finish = os.time() + finish
    }
end

function OnStart()
    if get_var(0, '$gt') ~= 'n/a' then
        index = 1
        timer = createTimer(AutoMessage.interval)
    end
end

function OnEnd()
    timer = nil
end

local function respond(playerId, msg)
    if playerId == 0 then
        cprint(msg)
    else
        rprint(playerId, msg)
    end
end

local function broadcast()
    local am = AutoMessage
    local message = am.announcements[index]
    for _, msg in ipairs(message) do
        if am.showAnnouncementsOnConsole then
            respond(0, msg)
        end
        if am.showAnnouncementsInChat then
            execute_command('msg_prefix ""')
            say_all(msg)
            execute_command('msg_prefix "' .. am.serverPrefix .. '"')
            goto next
        end
        for i = 1, 16 do
            if player_present(i) then
                respond(i, msg)
            end
        end
        :: next ::
    end
    index = (index == #am.announcements) and 1 or index + 1
end

function OnTick()
    if timer and timer.start <= timer.finish then
        timer = createTimer(AutoMessage.interval)
        broadcast()
    end
end

-- Change log:
--[[

Changes made to the script on 10/08/24

1. Converted camelCase variables and function names to lowercase for consistency.
2. Renamed some variables and functions for readability.
3. Removed unnecessary parentheses in function calls.
4. Adjusted spacing and indentation for better readability.
5. Replaced the condition in the `OnTick()` function to accurately update the timer.
6. Made minor adjustments to comments for clarity.

]]