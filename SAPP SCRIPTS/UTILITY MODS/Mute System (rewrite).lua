--[[
--=====================================================================================================--
Script Name: Mute System, for SAPP (PC & CE)
Description: Custom Mute System

NOTE: This mod requires that you download and install a file called "json.lua".
Place "json.lua" in the server's root directory - not inside the Lua Folder.
It's crucial that the file name is exactly "json.lua".

Download Link:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/Miscellaneous/json.lua
--------------------------------------------------------------------------------------

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local MuteSystem = { }
-- Mute System Configuration --

MuteSystem.MsgPrefix = "[Mute System]"

-- Mute CMD: The command used to mute players
MuteSystem.muteCmd = "mute"

-- CMD Perm Level: The MIN perm lvl a player must be to execute this CMD
MuteSystem.muteCmdPerm = 1

-- Un-Mute CMD: The command used to unmute players
MuteSystem.unmuteCmd = "unmute"

-- CMD Perm Level: The MIN perm lvl a player must be to execute this CMD
MuteSystem.unmuteCmdPerm = 1

-- Mute List CMD: The command used to view a list of currently muted players
MuteSystem.mutelistCmd = "mutelist"

MuteSystem.updateMutes = "updatemutes"

-- CMD Perm Level: The MIN perm lvl a player must be to execute this CMD
MuteSystem.updateMutesCmdPerm = 1

-- CMD Perm Level: The MIN perm lvl a player must be to execute this CMD
MuteSystem.mutelistCmdPerm = 1

MuteSystem.AntiSpam = {
    -- Enable or disable AntiSpam
    enabled = true,
    -- Amount of messages sent in a row that will cause a warning.
    warnThreshold = 4,
    -- Amount of messages sent in a row that will cause a kick.
    kickThreshold = 5,
    -- Amount of time (in seconds) in which messages are considered spam.
    maxInterval = 3.5,
    -- Message that will be sent in chat upon warning a user.
    warnMessage = '%name%, Please stop spamming or you will be kicked!',
    -- Message that will be sent in chat upon kicking a user.
    kickReason = 'spamming',
}

MuteSystem.Messages = {

    mute = {
        spam = { "%name% was muted for spamming", true },
        automatic = { "%name% was muted for %time% minute%s%", true },
        manual = { "%name% was muted by %admin% for %time% minute%s%", true }
    },

    unmute = {
        spam = { "%name% is no longer muted!", true },
        automatic = { "%name% is no longer muted", true },
        manual = {
            { "%name% was un-muted by %admin%", true },
            { "%name% is already un-muted!", true }
        }
    },

    mute_list = {
        no_mutes = "There are no active mutes",
        header = "------ [ MUTE LIST ] ------",
        content = "[%mute_index%] %name% %ip%",
    },

    mute_reminder = {
        { "You are muted!", true },
        { "Time Remaining: %time%", true }
    },
}

-- Whitelist: Groups that can be muted
MuteSystem.whitelist = {
    [-1] = false, -- PUBLIC
    [1] = true, -- ADMIN LEVEL 1
    [2] = true, -- ADMIN LEVEL 2
    [3] = true, -- ADMIN LEVEL 3
    [4] = true, -- ADMIN LEVEL 4

    -- Prevent specific users:
    specific_users = {
        -- Set this to true to enable "specific_users" feature.
        enabled = false,

        -- Local Host IP:
        ["127.0.0.1"] = true,
        -- repeat the structure to add more IP entries.
    }
}

-- Advanced users only: Client data will be saved as a json array and
-- the array index for each client is will be just the IP, or IP and PORT.
-- Should the array index be IP ONLY or IP and PORT (true by default)?
MuteSystem.IPPortIndex = true

-- Muted Players Directory: This file contains data about muted players:
MuteSystem.mutesDir = "mutes.txt"

-- Server Prefix: A message relay function temporarily removes the server prefix
-- and will restore it to this when the relay is finished
MuteSystem.serverPrefix = "**SAPP**"

-- [CONFIG ENDS] =========================================================================

local players, mutes = { }, { }

local len = string.len
local floor = math.floor
local format = string.format
local gmatch, gsub = string.gmatch, string.gsub

local json = (loadfile "json.lua")()

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_CHAT"], "OnPlayerChat")
    register_callback(cb["EVENT_GAME_START"], "OnNewGame")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    CheckFile()

    if (get_var(0, "$gt") ~= "n/a") then
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, false)
                local IP = GetIP(i)
                local UserData = MuteSystem:GetMuteState(IP)
                if (UserData ~= nil) and (UserData.muted) then
                    mutes[IP] = { }
                    mutes[IP].id = i
                    mutes[IP].timer = 0
                    mutes[IP].muted = true
                    mutes[IP].time_remaining = 0
                    mutes[IP].current_time = UserData.time_remaining
                end
            end
        end
    end
end

function OnScriptUnload()
    MuteSystem:UpdateALL()
end

function OnNewGame()
    if (get_var(0, "$gt") ~= "n/a") then

        CheckFile()
        if (MuteSystem.enableAntiSpam) then
            execute_command_sequence("antispam 0")
        end

        local UserData = MuteSystem:GetUserData()
        for IP, User in pairs(UserData) do
            if (IP) then
                if (User.muted) then
                    mutes[IP] = { }
                    mutes[IP].timer = 0
                    mutes[IP].muted = true
                    mutes[IP].time_remaining = 0
                    mutes[IP].current_time = User.time_remaining
                end
            end
        end
    end
end

function OnTick()
    for IP, v in pairs(mutes) do
        if (IP) then
            if (v.muted) then
                v.timer = v.timer + 1 / 30
                v.time_remaining = (v.current_time - v.timer)
                if (v.time_remaining <= 0) then
                    mutes[IP] = nil
                    local UserData = MuteSystem:GetMuteState(IP)
                    UserData.muted = false
                    UserData.time_remaining = 0
                    MuteSystem:Update(IP, UserData)
                end
            end
        end
    end
    if (MuteSystem.AntiSpam.enabled) then
        for Ply, v in pairs(players) do
            if (Ply) then
                if (v.spam.monitor) then
                    v.spam.timer = v.spam.timer + 1 / 30
                    if (v.spam.timer < MuteSystem.AntiSpam.maxInterval) then
                        if (v.spam.count >= MuteSystem.AntiSpam.warnThreshold) and (v.spam.count < MuteSystem.AntiSpam.kickThreshold) then
                            cls(Ply, 25)
                            Respond(Ply, gsub(MuteSystem.AntiSpam.warnMessage, "%%name%%", v.name), "rprint", 4+8)
                        elseif (v.spam.count >= MuteSystem.AntiSpam.kickThreshold) then
                            execute_command("k " .. Ply .. ' "' .. gsub(MuteSystem.AntiSpam.kickReason, "%%name%%", v.name) .. '"')
                        end
                    elseif (v.spam.timer >= MuteSystem.AntiSpam.maxInterval) then
                        v.spam.count = 0
                        v.spam.timer = 0
                        v.spam.monitor = false
                    end
                end
            end
        end
    end
end

local function getChar(input)
    if (tonumber(input) > 1) then
        return "s"
    end
    return ""
end

local function checkAccess(Ply, PermLvl)
    if (Ply ~= -1 and Ply >= 1 and Ply < 16) then
        if (tonumber(get_var(Ply, "$lvl")) >= PermLvl) then
            return true
        else
            Respond(Ply, "Command failed. Insufficient Permission", "rprint", 12)
            return false
        end
    elseif (Ply < 1) then
        return true
    end
    return false
end

local function CMDSelf(TargetID, Ply)
    if (tonumber(TargetID) == tonumber(Ply)) then
        Respond(Ply, MuteSystem.MsgPrefix .. "You cannot execute this command on yourself", "rprint", 12)
        return true
    end
end

local function StrSplit(Str)
    local Args, index = { }, 1
    for Params in gmatch(Str, "([^%s]+)") do
        Args[index] = Params
        index = index + 1
    end
    return Args
end

function OnServerCommand(Executor, Command, _, _)
    local CMD = StrSplit(Command)
    local muted = MuteSystem:IsMuted(Executor)
    if (CMD == nil or CMD == "") or (muted) then
        return false
    else

        Command = CMD[1]:lower()
        local EName = get_var(Executor, "$name")
        if (Executor == 0) then
            EName = "The Server"
        end

        if (Command == MuteSystem.muteCmd or Command == "mute") then
            if checkAccess(Executor, MuteSystem.muteCmdPerm) then
                if (CMD[2] ~= nil and CMD[3] ~= nil) then
                    local pl = GetPlayers(Executor, CMD)
                    if (pl) then
                        for i = 1, #pl do
                            local TargetID = pl[i]
                            if (not CMDSelf(TargetID, Executor)) then
                                if (not Whitelisted(TargetID, Executor)) then

                                    local Minutes = CMD[3]
                                    if Minutes:match("^%d+$") then
                                        MuteSystem:Mute(TargetID, Minutes)
                                        local TName = get_var(TargetID, "$name")
                                        local m = MuteSystem.Messages.mute.manual
                                        if (m[2]) then
                                            local char = getChar(Minutes)
                                            local Msg = gsub(gsub(gsub(gsub(m[1],
                                                    "%%name%%", TName),
                                                    "%%admin%%", EName),
                                                    "%%time%%", Minutes),
                                                    "%%s%%", char)
                                            Respond(Executor, Msg, "say_all", 10)
                                        end
                                    end
                                else
                                    Respond(Executor, "White-listed players cannot be muted!", "rprint", 12)
                                end
                            end
                        end
                    end
                else
                    Respond(Executor, "Invalid Syntax. Usage: /" .. Command .. " [player id] <minutes>", "rprint", 12)
                end
            end
            return false
        elseif (Command == MuteSystem.unmuteCmd or Command == "unmute") then
            if checkAccess(Executor, MuteSystem.unmuteCmdPerm) then
                local MuteIndex = CMD[2]
                if (MuteIndex ~= nil) and MuteIndex:match("^%d+$") then
                    local Users = MuteSystem:GetUserData()
                    for k, v in pairs(Users) do
                        if (v.index == tonumber(MuteIndex)) then
                            local m = MuteSystem.Messages.unmute.manual
                            if (v.muted) then

                                mutes[k] = nil
                                v.muted = false
                                v.time_remaining = 0

                                MuteSystem:Update(k, Users[k])
                                if (m[1][2]) then
                                    local str = gsub(gsub(m[1][1], "%%name%%", v.name), "%%admin%%", EName)
                                    Respond(Executor, str, "say_all", 10)
                                end

                            elseif (m[2][2]) then
                                local str = gsub(m[2][1], "%%name%%", v.name)
                                Respond(Executor, str, "rprint", 12)
                            end
                        else
                            Respond(Executor, "Invalid Mute Index", "rprint", 12)
                        end
                        break
                    end
                else
                    Respond(Executor, "Invalid Syntax. Usage: /" .. Command .. " [player id] <minutes>", "rprint", 12)
                end
            end
            return false
        elseif (Command == MuteSystem.mutelistCmd or Command == "mutes") then
            if checkAccess(Executor, MuteSystem.mutelistCmdPerm) then
                if (CMD[2] == nil) then
                    local Users = MuteSystem:GetUserData()
                    local t = MuteSystem.Messages.mute_list
                    local count = 0
                    for k, v in pairs(Users) do
                        if (k) then
                            if (v.muted) then
                                count = count + 1
                                Respond(Executor, t.header, "rprint")
                                local msg = gsub(gsub(gsub(t.content,
                                        "%%ip%%", k),
                                        "%%name%%", v.name),
                                        "%%mute_index%%", v.index)
                                Respond(Executor, msg, "rprint", 13)
                            end
                        end
                    end
                    if (count == 0) then
                        Respond(Executor, t.no_mutes, "rprint", 12)
                    end
                end
            end
            return false
        elseif (Command == MuteSystem.updateMutes) then
            if checkAccess(Executor, MuteSystem.updateMutesCmdPerm) then
                MuteSystem:UpdateALL(Executor)
            end
            return false
        end
    end
end

function OnPlayerChat(Ply, Message, Type)
    if (Message ~= "" and Type ~= 6) then
        local UserData = MuteSystem:IsMuted(Ply)
        if (UserData.muted) then
            local IP = get_var(Ply, "$ip")
            for _, v in pairs(MuteSystem.Messages.mute_reminder) do
                if (v[2]) then
                    local msg = gsub(v[1], "%%time%%", secondsToTime(mutes[IP].time_remaining))
                    Respond(Ply, msg, "rprint", 12)
                end
            end
            return false
        else

            players[Ply].spam.monitor = true
            players[Ply].spam.count = players[Ply].spam.count + 1
        end
    end
end

function OnPlayerConnect(Ply)
    InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    InitPlayer(Ply, true)
end

function InitPlayer(Ply, Reset)
    if (Reset) then
        MuteSystem:UpdateMutes(Ply, "quit")
        players[Ply] = nil
    else

        local IP = GetIP(Ply)
        players[Ply] = {
            IP = IP,
            name = get_var(Ply, "$name"),
            spam = {
                timer = 0,
                count = 0,
                monitor = false,
            }
        }
        MuteSystem:UpdateMutes(Ply, "join")
    end
end

function Whitelisted(TargetID, Executor)
    local W = MuteSystem.whitelist
    if (W.specific_users.enabled) then
        local IP = players[TargetID].IP:match("%d+.%d+.%d+.%d+")
        for k, v in pairs(W.specific_users) do
            if (k == IP) and (v) then
                return true
            end
        end
    end
    local lvl = tonumber(get_var(TargetID, "$lvl"))
    if (W[lvl]) then
        if (Executor) then
            return true
        end
    end
end

function Respond(Ply, Message, Type, Color)
    Color = Color or 10
    execute_command("msg_prefix \"\"")

    if (Ply == 0) then
        cprint(Message, Color)
    end

    if (Type == "rprint") then
        rprint(Ply, MuteSystem.MsgPrefix .. " " .. Message)
    elseif (Type == "say") then
        say(Ply, MuteSystem.MsgPrefix .. " " .. Message)
    elseif (Type == "say_all") then
        say_all(MuteSystem.MsgPrefix .. " " .. Message)
    end
    execute_command("msg_prefix \" " .. MuteSystem.serverPrefix .. "\"")
end

function MuteSystem:IsMuted(Ply)
    if (Ply > 0) then
        local IP = get_var(Ply, "$ip")
        if (mutes[IP] ~= nil) then
            return mutes[IP]
        end
    end
    return false
end

function MuteSystem:Mute(Ply, Minutes)
    local IP = players[Ply].IP

    mutes[IP] = { }
    mutes[IP].id = Ply
    mutes[IP].timer = 0
    mutes[IP].muted = true
    mutes[IP].time_remaining = 0
    mutes[IP].current_time = (Minutes * 60)

    local UserData = MuteSystem:GetMuteState(IP)
    UserData.muted = true
    UserData.time_remaining = (Minutes * 60)
    MuteSystem:Update(IP, UserData)
end

function ExternalMute(ID, TIME)
    local IP = GetIP(ID)
    local UserData = MuteSystem:GetMuteState(IP)
    if (not UserData.muted) then

        mutes[IP] = { }
        mutes[IP].id = ID
        mutes[IP].timer = 0
        mutes[IP].muted = true
        mutes[IP].time_remaining = 0
        mutes[IP].current_time = (TIME * 60)

        UserData.muted = true
        UserData.time_remaining = (TIME * 60)
        MuteSystem:Update(IP, UserData)
    end
end

function MuteSystem:UpdateMutes(Ply, Type)
    local IP = players[Ply].IP
    local UserData = MuteSystem:GetMuteState(IP)
    if (Type == "quit" and UserData.muted) then
        if (mutes[IP] ~= nil) then
            UserData.muted = true
            UserData.time_remaining = mutes[IP].time_remaining
            MuteSystem:Update(IP, UserData)
        end
    elseif (Type == "join") then
        if (mutes[IP] == nil) then
            mutes[IP] = { }
            mutes[IP].id = Ply
            mutes[IP].timer = 0
            mutes[IP].muted = false
            mutes[IP].time_remaining = 0
        else
            mutes[IP].id = Ply
        end
    end
end

function MuteSystem:GetUserData()
    local file = io.open(MuteSystem.mutesDir, "r")
    if (file) then
        local data = file:read("*all")
        return json:decode(data)
    end
    return nil
end

function MuteSystem:Update(IP, Table)
    local UserData = MuteSystem:GetUserData()
    if (UserData) then
        local file = assert(io.open(MuteSystem.mutesDir, "w"))
        if (file) then
            UserData[IP] = Table
            file:write(json:encode_pretty(UserData))
            io.close(file)
        end
    end
end

function MuteSystem:GetMuteState(IP)

    local User
    local file = io.open(MuteSystem.mutesDir, "r")
    if (file) then

        local data = file:read("*all")

        User = json:decode(data)
        if (User ~= nil) then
            User = User[IP]
        end

        if (not User) then
            MuteSystem:AddMuteTable(IP)
            User = MuteSystem:GetMuteState(IP)
        end
        io.close(file)
    end

    return User
end

function MuteSystem:AddMuteTable(IP)

    local content
    local file = io.open(MuteSystem.mutesDir, "r")
    if (file) then
        content = file:read("*all")
        io.close(file)
    end

    local file = assert(io.open(MuteSystem.mutesDir, "w"))
    if (file) then

        local name
        for i = 1, 16 do
            if player_present(i) then
                if (GetIP(i) == IP) then
                    name = players[i].name
                end
            end
        end

        local Users = json:decode(content)
        Users = Users or {}
        Users[IP] = {
            name = name,
            muted = false,
            time_remaining = 0
        }
        local index = 0
        for k, v in pairs(Users) do
            index = index + 1
            if (k == IP) then
                v.index = index
            end
        end

        file:write(json:encode_pretty(Users))
        io.close(file)
    end
end

function MuteSystem:UpdateALL(Executor)
    if (get_var(0, "$gt") ~= "n/a") then
        local UserData = MuteSystem:GetUserData()
        for IP, User in pairs(UserData) do
            if (IP) and (User.muted) then
                User.time_remaining = mutes[IP].time_remaining
                MuteSystem:Update(IP, UserData[IP])
            end
        end
        if (Executor) then
            Respond(Executor, MuteSystem.mutesDir .. " updated!", "rprint", 2 + 8)
        end
    end
end

function CheckFile()
    local file = io.open(MuteSystem.mutesDir, "a")
    if (file) then
        io.close(file)
    end
end

function GetPlayers(Ply, Args)
    local pl = { }
    if (Args[2] == nil or Args[2] == "me") then
        pl[#pl + 1] = tonumber(Ply)
    elseif (Args[2]:match("^%d+$")) and player_present(Args[2]) then
        pl[#pl + 1] = tonumber(Args[2])
    elseif (Args[2] == "all" or Args[2] == "*") then
        for i = 1, 16 do
            if player_present(i) then
                pl[#pl + 1] = tonumber(i)
            end
        end
    else
        Respond(Ply, "Invalid Player ID or Player not Online", "rprint", 4 + 8)
        Respond(Ply, "Command Usage: /" .. Args[1] .. " [number: 1-16] | */all | me", "rprint", 4 + 8)
    end
    return pl
end

function GetIP(Ply)
    local IP = get_var(Ply, "$ip")
    if (not MuteSystem.IPPortIndex) then
        IP = IP:match("%d+.%d+.%d+.%d+")
    end
    return IP
end

function secondsToTime(s)
    local y = floor(s / (60 * 60 * 24 * 365))
    s = s % (60 * 60 * 24 * 365)
    local w = floor(s / (60 * 60 * 24 * 7))
    s = s % (60 * 60 * 24 * 7)
    local d = floor(s / (60 * 60 * 24))
    s = s % (60 * 60 * 24)
    local h = floor(s / (60 * 60))
    s = s % (60 * 60)
    local m = floor(s / 60)
    s = s % 60
    return format("Y: %02d W: %02d D: %02d H: %02d M: %02d S: %02d", y, w, d, h, m, s)
end

function cls(Ply, Count)
    Count = Count or 25
    for _ = 1, Count do
        rprint(Ply, " ")
    end
end

return MuteSystem
