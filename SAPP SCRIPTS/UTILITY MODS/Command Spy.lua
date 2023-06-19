--[[
--=====================================================================================================--
Script Name: Command Spy, for SAPP (PC & CE)
Description: Get notified when a player executes a command.

Admins of level 1 or higher will be notified when someone executes a command originating from rcon or chat.
Command Spy is enabled for all admins by default and can be turned on/off with /spy.

Command(s) containing these words will not be seen:
* 	login
* 	admin_add
* 	sv_password
* 	change_password
* 	admin_change_pw
* 	admin_add_manually

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
local CSpy = {

    -- This is the custom command used to toggle command spy on or off:
    -- Command syntax: /command
    --
    command = "spy",

    -- Minimum permission required to execute /command:
    --
    permission = 1,

    -- If true, command spy will be enabled for admins by default:
    --
    enabled_by_default = true,

    -- If true, you will not see admin commands:
    --
    ignore_admins = false,

    -- Command Spy message format:
    --
    output = {
        -- RCON:
        [1] = "[R-SPY] $name: $cmd",
        -- CHAT:
        [2] = "[C-SPY] $name: /$cmd"
    },

    -- Command(s) containing these words will not be seen:
    --
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

local players = {}

api_version = "1.12.0.0"

function OnScriptLoad()

    register_callback(cb["EVENT_JOIN"], "OnJoin")
    register_callback(cb["EVENT_LEAVE"], "OnQuit")
    register_callback(cb["EVENT_COMMAND"], "OnCommand")
    register_callback(cb["EVENT_GAME_START"], "OnStart")

    OnStart()
end

local function Respond(Ply, Msg)
    return (Ply == 0 and cprint(Msg)) or rprint(Ply, Msg)
end

function CSpy:NewPlayer(o)

    setmetatable(o, self)
    self.__index = self

    o.lvl = function()
        return tonumber(get_var(o.pid, "$lvl"))
    end

    local state = (o.lvl() >= self.permission and self.enabled_by_default)
    o.state = (state or false)

    return o
end

function CSpy:Toggle()
    if (self.lvl() >= self.permission) then
        self.state = (not self.state and true or false)
        Respond(self.pid, "Command Spy " .. (self.state and "on" or not self.state and "off"))
    else
        Respond(self.pid, "Insufficient Permission")
    end
    return true
end

function CSpy:ShowCommand(ENV, CMD)

    if (self.lvl() >= 1 and self.ignore_admins) then
        goto done
    end

    for i, spy in pairs(players) do
        if (i ~= self.pid and spy.state and spy.lvl() >= self.permission) then
            local msg = self.output[ENV]
            local name = get_var(self.pid, '$name')
            msg = msg:gsub('$name', name):gsub('$cmd', CMD)
            Respond(i, msg)
        end
    end

    :: done ::
end

function OnStart()
    if (get_var(0, "$gt") ~= "n/a") then
        players = { }
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

local function blackListed(CMD)
    for _, word in pairs(CSpy.blacklist) do
        if CMD:lower():find(word) then
            return true
        end
    end
    return false
end

function OnCommand(Ply, CMD, ENV, _)
    local t = players[Ply]
    if (t) then
        local cmd = CMD:sub(1, CMD:len()):lower()
        if (cmd == t.command and t:Toggle()) then
            return false
        elseif (Ply > 0 and not blackListed(cmd)) then
            t:ShowCommand(ENV, CMD)
        end
    end
end

function OnJoin(Ply)
    players[Ply] = CSpy:NewPlayer({
        pid = Ply,
        name = get_var(Ply, '$name')
    })
end

function OnQuit(Ply)
    players[Ply] = nil
end

function OnScriptUnload()
    -- N/A
end