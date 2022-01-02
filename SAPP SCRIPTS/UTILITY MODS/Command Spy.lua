--[[
--=====================================================================================================--
Script Name: Command Spy, for SAPP (PC & CE)
Description: Get notified when a player executes a command.

             - features -
             Admins of level 1 (or higher) will be notified when
             someone executes a command originating from rcon or chat (see "output_format" table).

             Command Spy is enabled for all admins by default.
             Command Spy can be turned on or off for yourself (or others players)

             See config section for more information.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
local CSpy = {

    -- This is the custom command used to toggle command spy on or off:
    -- Command syntax: /command
    command = "spy",
    --

    -- Minimum permission required to execute /command (for yourself)
    permission = 1,
    --

    -- If true, command spy will be enabled for admins by default:
    enabled_by_default = true,

    -- If true, you will not see admin commands:
    ignore_admins = false,

    -- Command Spy message format:
    output = {
        -- RCON:
        [1] = "[R-SPY] $name: $cmd",
        -- CHAT:
        [2] = "[C-SPY] $name: /$cmd"
    },

    -- Command(s) containing these words will not be seen:
    blacklist = {
        "login",
        "admin_add",
        "sv_password",
        "change_password",
        "admin_change_pw",
        "admin_add_manually",
        -- Repeat the structure to add more commands.
    }
}
-- config ends --

api_version = "1.12.0.0"

function OnScriptLoad()

    register_callback(cb["EVENT_JOIN"], "OnJoin")
    register_callback(cb["EVENT_LEAVE"], "OnQuit")

    register_callback(cb["EVENT_COMMAND"], "OnCommand")

    register_callback(cb["EVENT_GAME_START"], "OnGameStart")

    OnGameStart()
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        CSpy.players = { }
        for i = 1, 16 do
            if player_present(i) then
                CSpy:InitPlayer(i, false)
            end
        end
    end
end

local function Respond(Ply, Msg)
    return (Ply == 0 and cprint(Msg)) or rprint(Ply, Msg)
end

--
-- This function checks if the command contains any blacklisted keywords:
--
local function BlackListed(CMD)
    for _, word in pairs(CSpy.blacklist) do
        if CMD:lower():find(word) then
            return true
        end
    end
    return false
end

local function GetLevel(Ply)
    return tonumber(get_var(Ply, "$lvl"))
end

local function CMDSplit(CMD)
    local args = { }
    for Command in CMD:gmatch("([^%s]+)") do
        args[#args + 1] = Command:lower()
    end
    return args
end

function CSpy:SPY(Ply, CMD, ENV, _)

    local args = CMDSplit(CMD)
    if (#args > 0) then

        if (args[1] == self.command) then

            if (Ply == 0) then
                Respond(Ply, "Server cannot execute this command.")
                return false
            end

            local lvl = GetLevel(Ply)
            local spy = self.players[Ply]
            if (lvl >= self.permission) then
                if (spy.state) then
                    spy.state = false
                else
                    spy.state = true
                end
                Respond(Ply, "Command Spy " .. (spy.state and "enabled" or not spy.state and "disabled"))
            else
                Respond(Ply, "You do not have permission to execute that command")
            end
            return false

        elseif (Ply > 0 and not BlackListed(args[1])) then

            local lvl = GetLevel(Ply)
            if (lvl >= 1 and self.ignore_admins) then
                goto done
            end

            for i = 1, 16 do
                if (player_present(i) and i ~= Ply) then
                    lvl = GetLevel(i)
                    local spy = self.players[i]
                    if (spy.state and lvl >= self.permission) then
                        local cmd = ""
                        for j = 1, #args do
                            cmd = cmd .. args[j] .. " "
                        end
                        local msg = self.output[ENV]
                        local name = get_var(Ply, "$name")
                        msg = msg:gsub("$name", name):gsub("$cmd", cmd)
                        Respond(i, msg)
                    end
                end
            end

            :: done ::
        end
    end
end

function CSpy:InitPlayer(Ply, Reset)

    if (not Reset) then
        local lvl = tonumber(get_var(Ply, "$lvl"))
        local on_by_default = (lvl >= self.permission and self.enabled_by_default)
        self.players[Ply] = { state = (on_by_default or false) }
        return
    end

    self.players[Ply] = nil
end

function OnJoin(Ply)
    CSpy:InitPlayer(Ply, false)
end

function OnQuit(Ply)
    CSpy:InitPlayer(Ply, true)
end

function OnCommand(P, C, E)
    return CSpy:SPY(P, C, E)
end

-- for a future update:
return CSpy
--