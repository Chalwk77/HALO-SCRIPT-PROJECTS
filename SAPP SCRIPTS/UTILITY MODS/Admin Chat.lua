--[[
--=====================================================================================================--
Script Name: Admin Chat, for SAPP (PC & CE)

Description: This is a utility that allows you to chat privately with other admins.
             Command Syntax: /achat on|off [me | id | */all]

             When Admin Chat is enabled your messages will appear in the rcon console environment.
             Only admins will see these messages.

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]] --

api_version = "1.12.0.0"

-- config starts --

local AdminChat = {

    -- Custom command used to toggle admin chat on/off:
    command = "achat",

    -- Minimum permission needed to execute the custom command:
    permission = 1,

    -- Minimum permission needed to toggle admin chat for other players:
    permission_others = 4,

    -- Fully customizable messages:
    messages = {

        -- Admin Chat output format:
        [1] = "$name [$id]: $message",

        -- This message is sent to (you) when you enable/disable for yourself.
        [2] = "Admin Chat $state!",

        -- This message is sent to (you) when you enable/disable for others.
        [3] = "Admin Chat $state for $target_name",

        -- This message is sent to (target player) when you enable/disable for them.
        [4] = "Your Admin Chat was $state by $executor_name",

        -- This message is sent to (you) when your Admin Chat is already enabled/disabled.
        [5] = "Your Admin Chat is already $state!",

        -- This message is sent to (target player) when their Admin Chat is already enabled/disabled.
        [6] = "$target_name's Admin Chat is already $state!",

        -- This message is sent when a player connects to the server (if previously activated).
        -- This requires the 'restore' setting to be TRUE.
        [7] = "Your Admin Chat is Enabled! (auto-restore)",

        -- This message is sent to (you) when there is a command syntax error.
        [8] = "Invalid Syntax: Usage: /$cmd on|off [me | id | */all]",

        -- If command executors permission level is < permission_others, send this message:
        [9] = "You lack permission to execute this command on other players",
    },

    -- Should A-Chat be restored for returning players? (if previously activated)
    restore = true,

    --
    -- Advanced users only:
    --

    -- The table index for each client will either be "IP", or "IP:PORT".
    -- Set to 1 for ip-only indexing.
    -- Set to 2 for ip & port indexing.
    ClientIndexType = 2
}
-- config ends --

function OnScriptLoad()

    register_callback(cb["EVENT_JOIN"], "OnJoin")
    register_callback(cb["EVENT_LEAVE"], "OnQuit")
    register_callback(cb["EVENT_CHAT"], "SendMessage")
    register_callback(cb["EVENT_COMMAND"], "OnCommand")
    register_callback(cb["EVENT_GAME_START"], "OnStart")

    OnStart()
end

function OnStart()
    if (get_var(0, "$gt") ~= "n/a") then
        for i = 1, 16 do
            if player_present(i) then
                AdminChat:InitPlayer(i, false)
            end
        end
    end
end

function OnScriptUnload()
    -- N/A
end

function OnJoin(Ply)
    AdminChat:InitPlayer(Ply, false)
end

function OnQuit(Ply)
    AdminChat:InitPlayer(Ply, true)
end

local function STRSplit(CMD)
    local Args = { }

    for Params in CMD:gsub('"', ""):gmatch("([^%s]+)") do
        Args[#Args + 1] = Params:lower()
    end

    return Args
end

function AdminChat:IsAdmin(Ply, CMD)

    local lvl = tonumber(get_var(Ply, "$lvl"))
    if (lvl >= self.permission) or (Ply == 0) then
        return true, lvl
    end

    -- Return false if player is not admin.
    -- Send player Insufficient Permission message if callback came from OnCommand()
    return false, (CMD and self:Respond(Ply, "Insufficient Permission", 10))
end

function AdminChat:InitPlayer(Ply, Reset)

    if (self:IsAdmin(Ply)) then

        local ip = self:GetIP(Ply)
        if (not Reset) then

            self[ip] = self[ip] or nil

            -- Restores this player Admin Chat:
            if (self.restore) and (self[ip]) then
                self:Respond(Ply, self.messages[7])
            end

            -- Disable Admin Chat:
        elseif (not self.restore) or (not self[ip]) then
            self[ip] = nil
        end
    end
end

function AdminChat:OnCommand(Executor, CMD)

    local Args = STRSplit(CMD)
    if (#Args > 0 and Args[1] == self.command) then

        -- Admin [boolean], lvl [int]
        local Admin, lvl = self:IsAdmin(Executor, true)

        if (Admin) then
            if (Args[2] ~= nil) then
                local pl = self:GetPlayers(Executor, Args[3])
                if (pl) then
                    local params = { }
                    for i = 1, #pl do
                        local player = tonumber(pl[i])
                        if (player ~= Executor and lvl < self.permission_others and Executor ~= 0) then
                            self:Respond(Executor, self.messages[9], 10)
                        else
                            params.state = Args[2] -- on|off
                            params.eid, params.en = Executor, get_var(Executor, '$name')
                            params.tid, params.tn, params.tip = player, get_var(player, '$name'), self:GetIP(player)
                            self:Toggle(params)
                        end
                    end
                end
            else
                self:Respond(Executor, "Invalid Syntax. Usage: /" .. self.command .. " on|off [me | id | */all]", 10)
            end
        end
        return false
    end
end

function AdminChat:ActivationState(Executor, State)
    if (State == "on" or State == "1" or State == "true") then
        return 1
    elseif (State == "off" or State == "0" or State == "false") then
        return 0
    else
        return false, self:Respond(Executor, self.messages[8]:gsub("$cmd", self.command), 12)
    end
end

function AdminChat:Toggle(params)

    -- Target Parameters:
    local tid, tip, tn = params.tid, params.tip, params.tn

    -- Executor Parameters:
    local eid, en = params.eid, params.en

    local console = (eid == 0)
    if (console) then
        en = "SERVER"
    end

    local state = self:ActivationState(eid, params.state)
    if (state) then

        self[tip] = self[tip] or nil

        local already_activated = (self[tip] == true)
        local already_set, valid_state

        if (state == 1) then
            state, valid_state = "enabled", true
            if (self[tip] == nil) then
                self[tip] = true
            else
                already_set = true
            end
        elseif (state == 0) then
            state, valid_state = "disabled", true
            if (self[tip] == already_activated) then
                self[tip] = nil
            else
                already_set = true
            end
        end

        if (valid_state) then

            local Feedback = function(str)
                local words = {
                    ["$state"] = state,
                    ["$executor_name"] = en,
                    ["$target_name"] = tn,
                }
                for k, v in pairs(words) do
                    str = str:gsub(k, v)
                end
                return str
            end

            local msg = self.messages
            local is_self = (eid == tid)
            if (not already_set) then
                if (is_self) then
                    self:Respond(eid, Feedback(msg[2]), 2 + 8)
                else
                    self:Respond(eid, Feedback(msg[3]), 2 + 8)
                    self:Respond(tid, Feedback(msg[4]), 2 + 8)
                end
            else
                if (is_self) then
                    self:Respond(eid, Feedback(msg[5]), 4 + 8)
                else
                    self:Respond(eid, Feedback(msg[6]), 4 + 8)
                end
            end
        end
    end
end

function AdminChat:GetPlayers(Executor, Param)
    local pl = { }
    if (Param == nil or Param == "me") then
        if (Executor ~= 0) then
            table.insert(pl, Executor)
        else
            self:Respond(Executor, "Please enter a valid player id", 10)
        end
    elseif (Param ~= nil and Param:match("^%d+$")) then
        if player_present(Param) then
            table.insert(pl, Param)
        else
            self:Respond(Executor, "Player #" .. Param .. " is not online", 10)
        end
    elseif (Param == "all" or Param == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(pl, i)
            end
        end
        if (#pl == 0) then
            self:Respond(Executor, "There are no players online!", 10)
        end
    else
        self:Respond(Executor, "Invalid Command Syntax. Please try again!", 10)
    end
    return pl
end

function AdminChat:Respond(Ply, Message, Color)
    Color = Color or 10
    if (Ply == 0) then
        cprint(Message, Color)
    else
        rprint(Ply, Message)
    end
end

function AdminChat:GetIP(Ply)
    local IP = get_var(Ply, "$ip")

    if (self.ClientIndexType == 1) then
        IP = IP:match("%d+.%d+.%d+.%d+")
    end

    return IP
end

function AdminChat:SendMessage(Ply, Msg, Type)
    if (Type ~= 6) then

        local args = STRSplit(Msg)
        if (args) then

            local ip = self:GetIP(Ply)

            -- check if admin chat is on:
            if (self[ip]) then

                -- check if incoming message string is chat command:
                local chat_command = (args[1]:sub(1, 1) == "/" or args[1]:sub(1, 1) == "\\")

                if (not chat_command) then

                    -- Admin Chat message formatter:
                    local name = get_var(Ply, "$name")
                    local msg = self.messages[1]:gsub("$name", name):gsub("$id", Ply):gsub("$message", Msg)

                    -- Check if player is an admin and send them the message:
                    for i = 1, 16 do
                        if player_present(i) then
                            if (tonumber(get_var(i, '$lvl')) >= self.permission) then
                                rprint(i, "|l" .. msg)
                            end
                        end
                    end

                    return false
                end
            end
        end
    end
end

function OnCommand(P, C)
    return AdminChat:OnCommand(P, C)
end
function SendMessage(P, M, T)
    return AdminChat:SendMessage(P, M, T)
end

-- for a future update:
return AdminChat