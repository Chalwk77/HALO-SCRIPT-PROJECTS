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

Copyright (c) 2022-2024, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- Configuration
local CSpy = {
    command = "spy", -- Command to toggle command spy
    permission = 1, -- Minimum permission level to use the command
    enabled_by_default = true, -- Enable command spy by default for admins
    ignore_admins = false, -- Ignore admin commands
    output = {
        [1] = "[R-SPY] $name: $cmd", -- RCON command format
        [2] = "[C-SPY] $name: /$cmd" -- Chat command format
    },
    blacklist = { -- Commands to ignore
        "login",
        "admin_add",
        "sv_password",
        "change_password",
        "admin_change_pw",
        "admin_add_manually"
    }
}

local players = {}

api_version = "1.12.0.0"

-- Register event callbacks
function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnJoin")
    register_callback(cb["EVENT_LEAVE"], "OnQuit")
    register_callback(cb["EVENT_COMMAND"], "OnCommand")
    register_callback(cb["EVENT_GAME_START"], "OnStart")
    OnStart()
end

-- Initialize players on game start
function OnStart()
    if get_var(0, "$gt") ~= "n/a" then
        players = {}
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

-- Handle player joining
function OnJoin(id)
    players[id] = {
        id = id,
        name = get_var(id, "$name"),
        level = tonumber(get_var(id, "$lvl")),
        state = CSpy.enabled_by_default
    }
end

-- Handle player quitting
function OnQuit(id)
    players[id] = nil
end

-- Check if a command is blacklisted
local function isBlacklisted(cmd)
    for _, word in ipairs(CSpy.blacklist) do
        if cmd:lower():find(word) then
            return true
        end
    end
    return false
end

-- Respond to player or server
local function respond(id, msg)
    if id == 0 then
        cprint(msg)
    else
        rprint(id, msg)
    end
end

-- Toggle command spy for a player
local function toggleSpy(player)
    if player.level >= CSpy.permission then
        player.state = not player.state
        respond(player.id, "Command Spy " .. (player.state and "on" or "off"))
    else
        respond(player.id, "Insufficient Permission")
    end
end

-- Notify admins of a command
local function notifyAdmins(env, cmd, player)
    if player.level >= 1 and CSpy.ignore_admins then
        return
    end

    for _, admin in pairs(players) do
        if admin.id ~= player.id and admin.state and admin.level >= CSpy.permission then
            local msg = CSpy.output[env]:gsub("$name", player.name):gsub("$cmd", cmd)
            respond(admin.id, msg)
        end
    end
end

-- Handle command execution
function OnCommand(id, cmd, env)
    local player = players[id]
    if player then
        local command = cmd:lower()
        if command == CSpy.command then
            toggleSpy(player)
            return false
        elseif id > 0 and not isBlacklisted(command) then
            notifyAdmins(env, cmd, player)
        end
    end
end

function OnScriptUnload()
    -- No actions needed on script unload
end