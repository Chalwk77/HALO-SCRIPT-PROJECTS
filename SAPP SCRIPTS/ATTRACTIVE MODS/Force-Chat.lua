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
--=====================================================================================================--
]]--

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

local gsub = string.gsub
api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
end

local function CMDSplit(CMD)
    local Args = {}
    CMD = CMD:gsub('"', "")
    for Params in CMD:gmatch("([^%s]+)") do
        Args[#Args + 1] = Params:lower()
    end
    return Args
end

local function InVehicle(Ply)
    local DyN = get_dynamic_player(Ply)
    local vehicle = read_dword(DyN + 0x11C)
    return ((DyN ~= 0 and vehicle ~= 0xFFFFFFFF)) or false
end

function ForceChat:SendMessage(MSG, Type, Team, Ply, TID)
    execute_command("msg_prefix \"\"")
    if (Type == 1) then
        say_all(MSG)
    elseif (Type == 2 or Type == 3) then
        for i = 1, 16 do
            if player_present(i) then
                local team = get_var(i, "$team")
                if (Type == 2 and team == Team) then
                    say(i, MSG)
                elseif (Type == 3) then
                    if InVehicle(TID) then
                        if (TID == i) then
                            say(TID, MSG)
                        elseif (team == Team and InVehicle(i, Team)) then
                            say(i, MSG)
                        end
                    else
                        local name = get_var(TID, "$name")
                        self:Respond(Ply, name .. " is not in a vehicle!", 10)
                        break
                    end
                end
            end
        end
    end
    execute_command("msg_prefix \" " .. self.server_prefix .. "\"")
end

function ForceChat:OnCommand(Ply, CMD)
    local Args = CMDSplit(CMD)
    if (Args and Args[1] == self.command) then

        local lvl = tonumber(get_var(Ply, "$lvl"))
        if (lvl >= self.permission or Ply == 0) then

            if (Args[2] ~= nil and Args[2]:match("^%d+$")) then

                local TID = tonumber(Args[2])
                if player_present(TID) then

                    if (TID ~= Ply) then

                        local str_format = self.default
                        local cmd_len = self.command:len()
                        local cmd_to_replace = CMD:sub(1, cmd_len + 1)
                        local message = CMD:match(cmd_to_replace .. "[%s%d+%s](.*)")

                        local name = get_var(TID, "$name")
                        local team = get_var(TID, "$team")

                        local index = 1
                        for k, v in pairs(self.specific_format) do
                            if (CMD:match(k)) then
                                index = v[2]
                                str_format = gsub(gsub(v[1], "%%name%%", name), "%%message%%", message)
                                message = str_format:gsub(k, "")
                                return false, self:SendMessage(message, index, team, Ply, TID)
                            end
                        end

                        message = gsub(gsub(str_format, "%%name%%", name), "%%message%%", message)
                        self:SendMessage(message, index, team, Ply, TID)
                    else
                        self:Respond(Ply, "You cannot execute this command on yourself!", 10)
                    end
                else
                    self:Respond(Ply, "Player #" .. TID .. " is not online.", 10)
                end
            else
                self:Respond(Ply, "Please enter a valid player id: [1-16]", 10)
            end
        else
            self:Respond(Ply, "Insufficient Permission", 10)
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
    return ForceChat:OnCommand(P, C)
end

function OnScriptUnload()
    -- N/A
end