--[[
--=====================================================================================================--
Script Name: Force Chat, for SAPP (PC & CE)
Description: Force a player to say something.

Command Examples:
/fchat 1 hello there!
* Forces player #1 to say "hi there" (uses global chat format)
> output: Chalwk: hello there!

/fchat 1 hello there! -team
- output: [Chalwk]: hello there!
* Forces player #1 to say "hi there" (uses team chat format)

/fchat 1 hello there! -vehicle
- output: [Chalwk]: hello there!
* Forces player #1 to say "hi there" (uses vehicle chat format similar to team format)

/fchat 1 hello there! -global
- output: Chalwk: hello there!
* Forces player #1 to say "hi there" (uses global chat format - same as first example)

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration Starts --------------------------------------------------------------
local ForceChat = {

    -- Command Syntax: /command <pid> {message} [opt -global, -team, -vehicle]
    command = "fchat",

    -- Minimum permission level required to execute /command
    permission = 1,

    -- If you do not specify a message type, this will be the default message format:
    default = "%name%: %message%",

    -- Message format based on message type:
    specific_format = {

        -- [-command parameter trigger] "message format"

        ["-global"] = "%name%: %message%",
        ["-team"] = "[%name%]: %message%",
        ["-vehicle"] = "[%name%]: %message%",
    },

    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished
    server_prefix = "**SAPP**",
    --
}
-- Configuration Ends --------------------------------------------------------------

local gsub, gmatch = string.gsub, string.gmatch
local lower, len, sub = string.lower, string.len, string.sub

function OnScriptLoad()
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
end

function OnScriptUnload()

end

local function CMDSplit(CMD)
    local Args, index = { }, 1
    CMD = gsub(CMD, '"', "")
    for Params in gmatch(CMD, "([^%s]+)") do
        Args[index] = lower(Params)
        index = index + 1
    end
    return Args
end

function ForceChat:SendMessage(MSG, Type, Team)
    execute_command("msg_prefix \"\"")
    if (Type == 1) then
        say_all(MSG)
    elseif (Type == 2 or Type == 3) then
        for i = 1, 16 do
            if player_present(i) then
                if (i and get_var(i, "$team") == Team) then
                    say(i, MSG)
                end
            end
        end
    end
    execute_command("msg_prefix \" " .. self.server_prefix .. "\"")
end

function ForceChat:OnServerCommand(Executor, Command, _, _)
    local Args = CMDSplit(Command)
    if (Args == nil) then
        return
    elseif (Args[1] == self.command) then

        local lvl = tonumber(get_var(Executor, "$lvl"))
        if (lvl >= self.permission or Executor == 0) then
            if (Args[2] ~= nil and tonumber(Args[2]:match("^%d+$"))) then
                if player_present(Args[2]) then
                    if (Args[2] ~= Executor) then

                        local str_format = self.default
                        local cmd_len = len(self.command)
                        local cmd_to_replace = sub(Command, 1, cmd_len + 1)
                        local message = Command:match(cmd_to_replace .. "[%s%d+%s](.*)")

                        local name = get_var(Args[2], "$name")
                        local team = get_var(Args[2], "$team")

                        local index = 0
                        for k, v in pairs(self.specific_format) do
                            index = index + 1
                            if (Command:match(k)) then
                                str_format = gsub(gsub(v, "%%name%%", name), "%%message%%", message)
                                message = gsub(str_format, k, "")
                                return self:SendMessage(message, index, team)
                            end
                        end

                        message = gsub(gsub(str_format, "%%name%%", name), "%%message%%", message)
                        self:SendMessage(message, index, team)
                    else
                        self:Respond(Executor, "You cannot execute this command on yourself!", 10)
                    end
                else
                    self:Respond(Executor, "Player #" .. Args[2] .. " is not online.", 10)
                end
            else
                self:Respond(Executor, "Please enter a valid player id: [1-16]", 10)
            end
        else
            self:Respond(Executor, "Insufficient Permission", 10)
        end
        return false
    end
end

function ForceChat:Respond(Ply, Message, Color)
    Color = Color or 10
    if (Ply == 0) then
        cprint(Message, Color)
    else
        rprint(Ply, Message)
    end
end

function OnServerCommand(P, C)
    return ForceChat:OnServerCommand(P, C)
end