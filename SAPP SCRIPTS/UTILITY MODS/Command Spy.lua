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

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
local CSpy = {

    -- This is the custom command used to toggle command spy on or off:
    -- Command syntax: /command [1/0] [pid]
    command = "spy",
    --

    -- Minimum permission required to execute /command (for yourself)
    permission = 1,
    --

    -- Minimum permission required to toggle command spy for other players:
    permission_other = 4,

    -- If true, command spy will be enabled for admins by default:
    enabled_by_default = true,

    -- If true, you will not see admin commands:
    ignore_admins = false,

    -- Command Spy message format:
    output_format = {
        -- RCON:
        [1] = "[R-SPY] %name%: %cmd%",
        -- CHAT:
        [2] = "[C-SPY] %name%: /%cmd%",
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

    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerQuit")

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
    if (Ply == 0) then
        cprint(Msg)
    else
        rprint(Ply, Msg)
    end
end

local function GetPlayers(Ply, Args)

    local players = { }
    local TID = Args[3]

    if (TID == nil or TID == "me") then
        table.insert(players, Ply)
    elseif (TID == "all" or TID == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(players, i)
            end
        end
    elseif (TID:match("%d+") and tonumber(TID:match("%d+")) > 0) then
        if player_present(TID) then
            table.insert(players, TID)
        else
            Respond(Ply, "Player #" .. TID .. " is not online!")
        end
    else
        Respond(Ply, "Invalid Target ID Parameter")
        Respond(Ply, 'Usage: "me", "all", "*" or [pid between 1-16]')
    end

    return players
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

local gsub = string.gsub
function CSpy:SPY(Ply, CMD, ENV, _)

    local Args = { }
    for Command in CMD:gmatch("([^%s]+)") do
        Args[#Args + 1] = Command:lower()
    end

    if (#Args > 0) then
        local lvl = tonumber(get_var(Ply, "$lvl"))
        if (Args[1] == self.command) then
            if (lvl >= self.permission or Ply == 0) then
                local pl = GetPlayers(Ply, Args)
                if (pl) then
                    for i = 1, #pl do
                        local TargetID = tonumber(pl[i])
                        if (lvl < self.permission_other and TargetID ~= Ply) then
                            Respond(Ply, "Cannot toggle for other players! (no permission)")
                        elseif (TargetID == 0) then
                            Respond(Ply, "Server Cannot execute this command.", 12)
                        else
                            self:ToggleSpy(Ply, TargetID, Args)
                        end
                    end
                end
            else
                Respond(Ply, "You do not have permission to execute that command")
            end
            return false
        elseif (Ply > 0 and not BlackListed(Args[1])) then

            if (self.players[Ply].enabled and not self.ignore_admins or lvl == -1) then

                local name = get_var(Ply, "$name")
                for i = 1, 16 do
                    if player_present(i) and (i ~= Ply) then

                        lvl = tonumber(get_var(i, "$lvl"))
                        if (lvl >= 1) then

                            local cmd = ''
                            for j = 1, #Args do
                                cmd = cmd .. Args[j] .. " "
                            end

                            Respond(i, gsub(gsub(self.output_format[ENV], "%%name%%", name), "%%cmd%%", cmd))
                        end
                    end
                end
            end
        end
    end
end

function CSpy:ToggleSpy(Ply, TID, Args)

    local toggled = (self.players[TID].enabled)
    local name = self.players[TID].name

    local state = Args[2]
    if (not state) then

        state = self.players[TID].enabled
        if (state) then
            state = "activated"
        else
            state = "not activated"
        end

        if (Ply == TID) then
            Respond(Ply, "Command Spy is " .. state)
        else
            Respond(Ply, name .. "'s Command Spy is " .. state)
        end
        return

    elseif (state == "on" or state == "1" or state == "true") then
        state = "enabled"
    elseif (state == "off" or state == "0" or state == "false") then
        state = "disabled"
    else
        state = nil
    end

    if (toggled and state == "enabled" or not toggled and state == "disabled") then
        if (Ply == TID) then
            Respond(Ply, "Command Spy is already " .. state)
        else
            Respond(Ply, name .. "'s Command Spy is already " .. state)
        end
    elseif (state) then

        if (Ply == TID) then
            Respond(Ply, "Command Spy " .. state)
        else
            Respond(Ply, "Command Spy " .. state .. " for " .. name)
        end

        self.players[TID].enabled = (state == "disabled" and false) or (state == "enabled" and true)
    else
        Respond(Ply, "Invalid Command Parameter.")
        Respond(Ply, 'Usage: "on", "1", "true", "off", "0" or "false"')
    end
end

function CSpy:InitPlayer(Ply, Reset)

    if (not Reset) then
        local lvl = tonumber(get_var(Ply, "$lvl"))
        self.players[Ply] = {

            name = get_var(Ply, "$name"),

            -- Used to keep track of the command spy "state" (on or off):
            enabled = (lvl >= 1 and self.enabled_by_default or false)
            --
        }
        return
    end

    self.players[Ply] = nil
end

function OnPlayerJoin(Ply)
    CSpy:InitPlayer(Ply, false)
end

function OnPlayerQuit(Ply)
    CSpy:InitPlayer(Ply, true)
end

function OnCommand(P, C, E)
    return CSpy:SPY(P, C, E)
end

-- for a future update:
return CSpy
--