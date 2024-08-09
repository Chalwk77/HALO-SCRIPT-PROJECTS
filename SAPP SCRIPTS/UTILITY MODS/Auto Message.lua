--[[
--=====================================================================================================--
Script Name: Auto Message, for SAPP (PC & CE)
Description: This script will periodically broadcast pre-defined messages to all players.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local AutoMessage = {

    --
    -- ANNOUNCEMENTS --
    --
    announcements = {

        { -- message 1 (multi line message)
            'Multi-Line Support | Message 1, line 1',
            'Message 1, line 2',
        },


        { -- message 2 (single line message)
            'Like us on Facebook | facebook.com/page_id'
        },


        { -- message 3
            'Follow us on Twitter | twitter.com/twitter_id'
        },


        {  -- message 4
            'We are recruiting. Sign up on our website | website url'
        },


        {  -- message 5
            'Rules / Server Information'
        },


        {  -- message 6
            'announcement 6'
        },


        {  -- message 7
            'other information here'
        },

        -- repeat the structure to add more entries --
    },
    --
    ------------------------------------------------------------------------------

    -- Time (in seconds) between message announcements:
    --
    interval = 300,


    -- If true, messages will appear in chat.
    -- Otherwise they will appear in the player console.
    --
    show_announcements_in_chat = true,


    -- If true, messages will also be printed to server console terminal (in pink):
    --
    show_announcements_on_console = true,


    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished:
    --
    server_prefix = '**SAPP**',


    -- config ends --
}

api_version = '1.12.0.0'

local timer
local index = 1
local time = os.time

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_GAME_END'], "OnEnd")
    register_callback(cb['EVENT_COMMAND'], "OnCommand")
    register_callback(cb['EVENT_GAME_START'], "OnStart")
    OnStart()
end

local function newTimer(finish)
    return {
        start = time,
        finish = time() + finish,
    }
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        index = 1
        timer = newTimer(AutoMessage.interval)
    end
end

function OnEnd()
    timer = nil
end

local function Respond(Ply, Msg)
    return (Ply == 0 and cprint(Msg) or rprint(Ply, Msg))
end

local function Broadcast()

    local am = AutoMessage
    local message = am.announcements[index]

    for _, msg in ipairs(message) do

        if (am.show_announcements_on_console) then
            Respond(0, msg)
        end

        if (am.show_announcements_in_chat) then
            execute_command('msg_prefix ""')
            say_all(msg)
            execute_command('msg_prefix "' .. am.server_prefix .. '"')
            goto next
        end

        for i = 1, 16 do
            if player_present(i) then
                Respond(i, msg)
            end
        end

        :: next ::
    end
end

function OnTick()
    local am = AutoMessage
    if (timer and timer.start() >= timer.finish) then
        timer = newTimer(am.interval)
        Broadcast()
        index = (index == #am.announcements) and 1 or index + 1
    end
end