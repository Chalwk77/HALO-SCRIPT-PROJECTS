--[[
--=====================================================================================================--
Script Name: Auto Message for SAPP (PC & CE)
Description: This script will periodically broadcast pre-defined messages to all players.

Copyright (c) 2024, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- Configuration table for the Auto Message script
local AutoMessage = {

    announcements = {
        -- Each announcement can have multiple lines
        { 'Multi-Line Support | Message 1, line 1', 'Message 2, line 2' },
        { 'Like us on Facebook | facebook.com/page_id' },
        { 'Follow us on Twitter | twitter.com/twitter_id' },
        { 'We are recruiting. Sign up on our website | website url' },
        { 'Rules / Server Information' },
        { 'Announcement 6' },
        { 'Other information here' },
    },

    -- Interval in seconds between each announcement
    interval = 300,

    -- Flag to show announcements on the console
    showAnnouncementsOnConsole = true,

    -- Prefix to be used for server messages
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
    return { start = os.time(), finish = os.time() + finish }
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

local function broadcast()
    local messageTable = AutoMessage.announcements[index]
    execute_command('msg_prefix ""')
    for _, message in ipairs(messageTable) do
        if AutoMessage.showAnnouncementsOnConsole then
            cprint(message)
        end
        say_all(message)
    end
    execute_command('msg_prefix "' .. AutoMessage.serverPrefix .. '"')
    index = (index == #AutoMessage.announcements) and 1 or index + 1
end

function OnTick()
    if timer and os.time() >= timer.finish then
        timer = createTimer(AutoMessage.interval)
        broadcast()
    end
end