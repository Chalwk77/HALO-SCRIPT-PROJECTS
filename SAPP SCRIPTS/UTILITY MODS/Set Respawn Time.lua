--[[
--=====================================================================================================--
Script Name: Set Respawn Time, for SAPP (PC & CE)
Description: This script will allow you to set respawn times on a per-map, per-gametype basis.

            COMMAND SYNTAX:

            Set the global respawn time on demand with the following command:
            /setrespawn <time>

             Additionally, you can manually set a specific player's respawn time on demand with the following command:
             /setrespawn <pid> <time> <-s>
             The "-s" parameter is optional. If you specify the "-s" flag, your command will be executed silently.
             This means the target player will not receive the "[Command Executor name] set your respawn time to X seconds" message.


Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local settings = {

    -- Custom command used to manually change global/player respawn time
    custom_command = "setrespawn",

    -- Minimum level required to execute "custom_command"
    permission_level = 1,

    -- Minimum level required to change the respawn time for other players
    permission_level_extra = 4,

    -- If map is not listed below, it will use this global default respawn time:
    default_respawn_time = 100,

    silent_flag = "-s",

    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished
    serverPrefix = "**SAPP**",

    messages = {
        [1] = "Global server respawn time set to %time% second%s%",
        [2] = {

            "Your respawn time has been set to %time% second%s%",

            "You have set %target_name%'s respawn time to %time% second%s%",
            "%executor_name% set your respawn time to %time% second%s%",

            "[silent command] %target_name%'s respawn time has been set to %time% second%s%",
        },
        [3] = "Invalid time format. Please use a number!",
        [4] = "Invalid Syntax or Player ID. Usage: /%cmd% [number: 1-16] | */all | me <time> <opt silent -s>",
        [5] = "Player #%target_id% is not online!",
        [6] = "There are no players online!",
        [7] = "You do not have permission to execute that command.",
        [8] = "You do not have permission to execute that command on other players",
    },

    maps = {
        --	CTF | SLAYER | TEAM-S | KOTH |   TEAM-KOTH |   ODDBALL |   TEAM-ODDBALL |   RACE |   TEAM-RACE
        ["beavercreek"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
        ["bloodgulch"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
        ["boardingaction"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
        ["carousel"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
        ["dangercanyon"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
        ["deathisland"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
        ["chillout"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
        ["gephyrophobia"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
        ["icefields"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
        ["infinity"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
        ["sidewinder"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
        ["timberland"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
        ["hangemhigh"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
        ["ratrace"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
        ["damnation"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
        ["putput"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
        ["prisoner"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
        ["wizard"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
        ["longest"] = { 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0 },
    }
}

local gmatch, gsub, lower, upper = string.gmatch, string.gsub, string.lower, string.upper

local function Init()
    local gt = get_var(0, "$gt")
    local map = get_var(0, "$map")
    if (gt ~= "n/a") then
        settings.respawn_time = getSpawnTime(gt, map)
    end
end

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    Init()
end

function OnNewGame()
    Init()
end

local function SetRespawn(PlayerIndex, Time)
    local player = get_player(PlayerIndex)
    if (player ~= 0) then
        write_dword(player + 0x2C, tonumber(Time) * 33)
    end
end

function OnPlayerDeath(PlayerIndex)
    SetRespawn(PlayerIndex, settings.respawn_time)
end

local function getTeamPlay()
    if (get_var(0, "$ffa") == "0") then
        return true
    else
        return false
    end
end

function getSpawnTime(gt, map)
    for k, v in pairs(settings.maps) do
        if (map == k) then
            if (gt == "ctf") then
                return v[1]
            elseif (gt == "slayer") then
                if not getTeamPlay() then
                    return v[2]
                else
                    return v[3]
                end
            elseif (gt == "koth") then
                if not getTeamPlay() then
                    return v[4]
                else
                    return v[5]
                end
            elseif (gt == "oddball") then
                if not getTeamPlay() then
                    return v[6]
                else
                    return v[7]
                end
            elseif (gt == "race") then
                if not getTeamPlay() then
                    return v[8]
                else
                    return v[9]
                end
            end
        end
    end

    cprint('[RESPAWN SCRIPT] "' .. map .. '" is not listed in the map table config section.', 12)
    return settings.default_respawn_time
end

local function CmdSplit(Cmd)
    local t, i = {}, 1
    for Args in gmatch(Cmd, "([^%s]+)") do
        t[i] = Args
        i = i + 1
    end
    return t
end

local function Plural(n)
    if (tonumber(n) > 1) then
        return "s"
    elseif (tonumber(n) <= 1) then
        return ""
    end
    return ""
end

function OnServerCommand(Executor, Command, _, _)
    local Args = CmdSplit(Command)
    if (Args == nil) then
        return
    else

        Args[1] = (lower(Args[1]) or upper(Args[1]))
        if (Args[1] == settings.custom_command) then
            local lvl = tonumber(get_var(Executor, "$lvl"))

            if (Args[2] ~= nil and Args[3] == nil) then

                if (lvl >= settings.permission_level) or (Executor == 0) then
                    if (Args[2]:match("^%d+$")) then
                        settings.respawn_time = Args[2]
                        local str = gsub(gsub(settings.messages[1], "%%time%%", Args[2]), "%%s%%", Plural(Args[2]))
                        Respond(Executor, str, "rprint", 10)
                    else
                        Respond(Executor, settings.messages[3], "rprint", 10)
                    end
                else
                    Respond(Executor, settings.messages[7], "rprint", 10)
                end
            elseif (Args[2] ~= nil) and (Args[3]:match("^%d+$")) then

                local pl = GetPlayers(Executor, Args)
                if (#pl > 0) then
                    for i = 1, #pl do
                        local TargetID = tonumber(pl[i])

                        if (TargetID ~= Executor) and (lvl < settings.permission_level_extra) and (Executor ~= 0) then
                            Respond(Executor, settings.messages[8], "rprint", 10)
                            return false
                        elseif (Args[4] ~= nil) and (Args[4] ~= settings.silent_flag) then
                            Respond(Executor, settings.messages[4], "rprint", 10)
                            return false
                        end

                        local t_name = get_var(TargetID, "$name")
                        local e_name = get_var(Executor, "$name")

                        if (Executor == 0) then
                            e_name = "[SERVER]"
                        end

                        SetRespawn(TargetID, Args[3])
                        for MsgIndex, v in pairs(settings.messages[2]) do
                            local str = gsub(gsub(gsub(gsub(v, "%%time%%", Args[3]), "%%s%%", Plural(Args[3])), "%%target_name%%", t_name), "%%executor_name%%", e_name)
                            if (MsgIndex == 1) and (TargetID == Executor) and (Args[4] == nil) then
                                Respond(Executor, str, "rprint", 10)
                            elseif (MsgIndex == 2) and (TargetID ~= Executor) and (Args[4] == nil) then
                                Respond(Executor, str, "rprint", 10)
                            elseif (MsgIndex == 3) and (TargetID ~= Executor) and (Args[4] == nil) then
                                Respond(TargetID, str, "rprint", 10)
                            elseif (MsgIndex == 4) and (Args[4] ~= nil and Args[4] == settings.silent_flag) then
                                Respond(Executor, str, "rprint", 10)
                            end
                        end
                    end
                end
            else
                Respond(Executor, settings.messages[4], "rprint", 10)
            end
            return false
        end
    end
end

function GetPlayers(Executor, Args)
    local pl = { }
    if (Args[2] == "me") then
        if (Executor ~= 0) then
            table.insert(pl, Executor)
        else
            Respond(Executor, "I am not a player!", "rprint", 12)
        end
    elseif (Args[2]:match("%d+")) then
        if player_present(Args[2]) then
            table.insert(pl, Args[2])
        else
            local str = gsub(settings.messages[5], "%%target_id%%", Args[2])
            Respond(Executor, str, "rprint", 12)
        end
    elseif (Args[2] == "all" or Args[2] == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(pl, i)
            end
        end
        if (#pl == 0) then
            Respond(Executor, settings.messages[6], "rprint", 12)
        end
    else
        local str = gsub(settings.messages[4], "%%cmd%%", Args[1])
        Respond(Executor, str, "rprint", 12)
    end
    return pl
end

function Respond(Ply, Message, Type, Color)

    Color = Color or 10
    execute_command("msg_prefix \"\"")

    if (Ply == 0) then
        cprint(Message, Color)
    end

    if (Type == "rprint") then
        rprint(Ply, Message)
    elseif (Type == "say") then
        say(Ply, Message)
    elseif (Type == "say_all") then
        say_all(Message)
    end
    execute_command("msg_prefix \" " .. settings.serverPrefix .. "\"")
end

function OnScriptUnload()
    --
end
