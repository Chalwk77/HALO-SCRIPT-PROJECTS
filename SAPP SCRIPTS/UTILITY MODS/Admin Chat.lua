--[[
--=====================================================================================================--
Script Name: Admin Chat, for SAPP (PC & CE)

Description: This is a utility that allows you to chat privately with other admins.
             Command Syntax: /achat on|off [me | id | */all]

             When Admin Chat is enabled your messages will appear in the rcon console environment.
             Only admins will see these messages.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]] --

-- config starts --

local AdminChat = {

    -- Custom command used to toggle admin chat on/off:
    command = "achat",

    -- Minimum permission needed to execute the custom command:
    permission = 1,

    -- Minimum permission needed to toggle admin chat for other players:
    permission_others = 4,

    -- Should A-Chat be restored for returning players? (if previously activated)
    restore = true,

    -------------------------------
    -- Fully customizable messages:
    -------------------------------

    -- Admin Chat output format:
    [1] = "$name [$id]: $str",

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

    -----------------------
    -- Advanced users only:
    -----------------------

    -- The table index for each client will either be "IP", or "IP:PORT".
    -- Set to 1 for ip-only indexing.
    -- Set to 2 for ip & port indexing.
    ClientIndexType = 2
}
-- config ends --

api_version = "1.12.0.0"

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
    local args = { }

    for Params in CMD:gsub('"', ""):gmatch("([^%s]+)") do
        args[#args + 1] = Params:lower()
    end

    return args
end

local function Respond(Ply, Msg)
    return (Ply == 0 and cprint(Msg) or rprint(Ply, Msg))
end

local function IsAdmin(Ply, CMD)

    local lvl = tonumber(get_var(Ply, "$lvl"))
    if (lvl >= AdminChat.permission) or (Ply == 0) then
        return true, lvl
    end

    -- Return false if player is not admin.
    -- Send player Insufficient Permission message if callback came from OnCommand()
    return false, (CMD and Respond(Ply, "Insufficient Permission", 10))
end

function AdminChat:InitPlayer(Ply, Reset)

    if (IsAdmin(Ply)) then

        local ip = self:GetIP(Ply)
        if (not Reset) then

            self[ip] = self[ip] or nil

            -- Restores this player Admin Chat:
            if (self.restore) and (self[ip]) then
                Respond(Ply, self.messages[7])
            end

            -- Disable Admin Chat:
        elseif (not self.restore or not self[ip]) then
            self[ip] = nil
        end
    end
end

local function GetPlayers(Ply, Args)
    local pl = { }
    if (Args == nil or Args == "me") then
        if (Ply ~= 0) then
            pl[#pl + 1] = Ply
        else
            Respond(Ply, "Please enter a valid player id")
        end
    elseif (Args ~= nil and Args:match("^%d+$")) then
        if player_present(Args) then
            pl[#pl + 1] = Args
        else
            Respond(Ply, "Player #" .. Args .. " is not online")
        end
    elseif (Args == "all" or Args == "*") then
        for i = 1, 16 do
            if player_present(i) then
                pl[#pl + 1] = i
            end
        end
        if (#pl == 0) then
            Respond(Ply, "There are no players online!")
        end
    else
        Respond(Ply, "Invalid Command Syntax. Please try again!")
    end
    return pl
end

function AdminChat:OnCommand(Ply, CMD)

    local args = STRSplit(CMD)
    if (#args > 0 and args[1] == self.command) then

        -- Admin [boolean], lvl [number]
        local admin, lvl = IsAdmin(Ply, true)

        if (not admin) then
            return false
        end

        if (args[2] ~= nil) then
            local pl = GetPlayers(Ply, args[3])
            if (pl) then
                for i = 1, #pl do
                    local player = tonumber(pl[i])
                    if (player ~= Ply and lvl < self.permission_others and Ply ~= 0) then
                        Respond(Ply, self[9], 10)
                    else
                        self:Toggle({
                            eid = Ply,
                            tid = player,
                            state = args[2],
                            tip = self:GetIP(player),
                            en = get_var(Ply, '$name'),
                            tn = get_var(player, '$name')
                        })
                    end
                end
            end
        else
            Respond(Ply, "Invalid Syntax. Usage: /" .. self.command .. " on|off [me | id | */all]", 10)
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
        return false, Respond(Executor, self[8]:gsub("$cmd", self.command), 12)
    end
end

local function Feedback(str, t)
    for k, v in pairs(t) do
        str = str:gsub(k, v)
    end
    return str
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

            local is_self = (eid == tid)
            local t = { ["$state"] = state, ["$target_name"] = tn, ["$executor_name"] = en }

            if (not already_set) then
                if (is_self) then
                    Respond(eid, Feedback(self[2], t))
                else
                    Respond(eid, Feedback(self[3], t))
                    Respond(tid, Feedback(self[4], t))
                end
            else
                if (is_self) then
                    Respond(eid, Feedback(self[5], t))
                else
                    Respond(eid, Feedback(self[6], t))
                end
            end
        end
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
                local cmd = (args[1]:sub(1, 1) == "/" or args[1]:sub(1, 1) == "\\")

                if (not cmd) then

                    -- Admin Chat message formatter:
                    local name = get_var(Ply, "$name")
                    local msg = self[1]:gsub("$name", name):gsub("$id", Ply):gsub("$str", Msg)

                    -- Check if player is an admin and send them the message:
                    for i = 1, 16 do
                        if player_present(i) then
                            if (tonumber(get_var(i, '$lvl')) >= self.permission) then
                                Respond(i, msg)
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