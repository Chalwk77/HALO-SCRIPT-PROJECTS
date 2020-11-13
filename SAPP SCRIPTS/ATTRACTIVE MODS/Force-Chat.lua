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
        -- [-keyword] {"message format", message type}
        ["-global"] = { "%name%: %message%", 1 },
        ["-team"] = { "[%name%]: %message%", 2 },
        ["-vehicle"] = { "[%name%]: %message%", 3 },
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

function InVehicle(Ply)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        local vehicle = read_dword(DyN + 0x11C)
        if (vehicle ~= 0xFFFFFFFF) then
            return true
        end
    end
    return false
end

function ForceChat:SendMessage(MSG, Type, Team, Executor, TargetID)
    execute_command("msg_prefix \"\"")
    if (Type == 1) then
        say_all(MSG)
    elseif (Type == 2 or Type == 3) then
        for i = 1, 16 do
            if player_present(i) then
                if (Type == 2 and get_var(i, "$team") == Team) then
                    say(i, MSG)
                elseif (Type == 3) then
                    if InVehicle(TargetID) then
                        if (TargetID == i) then
                            say(TargetID, MSG)
                        else
                            local i_team = get_var(i, "$team")
                            if (i_team == Team and InVehicle(i, Team)) then
                                say(i, MSG)
                            end
                        end
                    else
                        local name = get_var(TargetID, "$name")
                        self:Respond(Executor, name .. " is not in a vehicle!", 10)
                        break
                    end
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

            if (Args[2] ~= nil and Args[2]:match("^%d+$")) then
                local TargetID = tonumber(Args[2])
                if player_present(TargetID) then

                    if (TargetID ~= Executor) then

                        local str_format = self.default
                        local cmd_len = len(self.command)
                        local cmd_to_replace = sub(Command, 1, cmd_len + 1)
                        local message = Command:match(cmd_to_replace .. "[%s%d+%s](.*)")

                        local name = get_var(TargetID, "$name")
                        local team = get_var(TargetID, "$team")

                        local index = 1
                        for k, v in pairs(self.specific_format) do
                            if (Command:match(k)) then
                                index = v[2]
                                str_format = gsub(gsub(v[1], "%%name%%", name), "%%message%%", message)
                                message = gsub(str_format, k, "")
                                return false, self:SendMessage(message, index, team, Executor, TargetID)
                            end
                        end

                        message = gsub(gsub(str_format, "%%name%%", name), "%%message%%", message)
                        self:SendMessage(message, index, team, Executor, TargetID)
                    else
                        self:Respond(Executor, "You cannot execute this command on yourself!", 10)
                    end
                else
                    self:Respond(Executor, "Player #" .. TargetID .. " is not online.", 10)
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