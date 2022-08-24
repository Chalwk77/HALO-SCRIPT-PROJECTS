--[[
--=====================================================================================================--
Script Name: Auto Message, for SAPP (PC & CE)
Description: This script will periodically announce defined messages from an announcements array.
You can manually broadcast a message from this array with a simple command (see below).

Command Syntax:
/broadcast list (view list of available announcements)
/broadcast [message id] (force immediate announcement broadcast)

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local AutoMessage = {

    -- ANNOUNCEMENTS ARRAY --
    announcements = {

        { -- message 1
            "Multi-Line Support | Message 1, line 1",
            "Message 1, line 2",
        },


        { -- message 2
            "Like us on Facebook | facebook.com/page_id"
        },


        { -- message 3
            "Follow us on Twitter | twitter.com/twitter_id"
        },


        {  -- message 4
            "We are recruiting. Sign up on our website | website url"
        },


        {  -- message 5
            "Rules / Server Information"
        },


        {  -- message 6
            "announcement 6"
        },


        {  -- message 7
            "other information here"
        },

        -- repeat the structure to add more entries --
    },
    --
    ------------------------------------------------------------------------------

    -- Time (in seconds) between message announcements:
    --
    interval = 300,

    -- If true, messages will appear in chat; Otherwise they will appear in the player console:
    --
    show_announcements_in_chat = true,

    -- If true, messages will also be printed to server console terminal (in pink):
    --
    show_announcements_on_console = true,

    -- Custom command used to view or broadcast announcements:
    --
    command = "broadcast",

    -- Minimum permission level required to execute custom broadcast command:
    --
    permission = 1,

    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished:
    --
    server_prefix = "**SAPP**",

    -- Advanced Users Only: (timer tick rate, 30 ticks = 1 second)
    --
    time_scale = 1 / 30
}

-- SAPP Lua API version:
api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_GAME_END'], "OnEnd")
    register_callback(cb['EVENT_COMMAND'], "OnCommand")
    register_callback(cb['EVENT_GAME_START'], "OnStart")
    AutoMessage:Timer(true)
end

function AutoMessage:Timer(START)
    if (get_var(0, "$gt") ~= "n/a") then
        self.index, self.timer = 1, 0
        if (START) then
            self.init = true
        else
            self.init = false
        end
    end
end

function OnStart()
    AutoMessage:Timer(true)
end

function OnEnd()
    AutoMessage:Timer(false)
end

local function Respond(Ply, Msg)
    return (Ply == 0 and cprint(Msg) or rprint(Ply, Msg))
end

function AutoMessage:GameTick()
    if (self.init) then
        self.timer = self.timer + self.time_scale
        if (self.timer >= self.interval) then
            self.timer = 0

            for _ = 1, #self.announcements do
                if (self.index == #self.announcements + 1) then
                    self.index = 1
                end
            end

            self:Show(self.announcements[self.index])
            self.index = self.index + 1
        end
    end
end

function AutoMessage:Show(TAB)
    for _, Msg in pairs(TAB) do

        if (self.show_announcements_on_console) then
            Respond(0, Msg)
        end

        if (self.show_announcements_in_chat) then
            execute_command('msg_prefix ""')
            say_all(Msg)
            execute_command('msg_prefix "' .. self.server_prefix .. ' "')
            goto next
        end

        for i = 1, 16 do
            if player_present(i) then
                Respond(i, Msg)
            end
        end

        :: next ::
    end
end

local match = string.match

local function StrSplit(s)
    local args = { }
    for arg in s:gmatch("([^%s]+)") do
        arg[#arg + 1] = arg:lower()
    end
    return args
end

function AutoMessage:OnCommand(Ply, CMD, _, _)

    local args = StrSplit(CMD)

    if (#args > 0 and args[1] == self.command) then

        local lvl = tonumber(get_var(Ply, "$lvl"))
        if (lvl >= self.permission or Ply == 0) then

            local error
            if (args[2] ~= nil) then
                if (args[2] == 'list') then
                    Respond(Ply, "[Broadcast ID] [Line Number]")
                    Respond(Ply, "--------------------------------------------------------------------------------")
                    local t = self.announcements
                    for i = 1, #t do
                        for j = 1,#t[i] do
                            local v = t[i][j]
                            Respond(Ply, "[" .. i .. "] [" .. j .. "] " .. v)
                        end
                    end
                    Respond(Ply, "--------------------------------------------------------------------------------")
                elseif (args:match("^%d+$") and args[3] == nil) then
                    local n = tonumber(args[2])
                    if (self.announcements[n]) then
                        self:Show(self.announcements[n])
                    else
                        Respond(Ply, "Invalid Broadcast ID")
                        Respond(Ply, "Please enter a number between 1-" .. #self.announcements)
                    end
                else
                    error = true
                end
            else
                error = true
            end
            if (error) then
                Respond(Ply, "Invalid Command Syntax. Please try again!")
            end
        end
        return false
    end
end

function OnTick()
    AutoMessage:GameTick()
end

function OnCommand(P, C, _, _)
    return AutoMessage:OnCommand(P, C, _, _)
end

-- For a future update ...
return AutoMessage