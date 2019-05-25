--[[
--=====================================================================================================--
Script Name: Player Vanish (v 1.2), for SAPP (PC & CE)
Description: Vanish yourself (or others) on demand!

Command syntax: /vanish.command on|off [me | id | */all]

Features:
* God Mode (option to toggle on|off)
* Speed Boost (option to toggle on|off)
* Boost (option to toggle on|off)
* Customizable Messages
* Optionally save vanish-status on quit (vanish upon return)

				
Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local vanish = {}

-- Player Vanish Configuration [starts] --

-- Base Command: 
vanish.command = "vanish" -- /command on|off [me | id | */all]
-- If Player ID parameter ([me | id | */all]) is not specified, Vanish will default to the executor.

-- Minimum Permission level required to execute /vanish.command
vanish.permission_level = 1

-- Minimum Permission level required to turn on vanish for other players.
vanish.execute_on_others = 4

-- Global Server Prefix:
-- local function 'Say' temporarily removes the **SERVER** prefix when it announces messges.
-- The prefix will be restored to 'vanish.serverprefix' when the relay has finished.
vanish.serverprefix = "**SERVER**"

-- Let players know when someone goes into Player Vanish mode:
vanish.announce = true

-- If this is enabled, you will teleport to the nearest object that you are aiming directly at:
vanish.boost = true
-- What action triggers boost? (see below for a list of valid actions):
vanish.boost_trigger = "crouch_and_shoot"
-- VALID ACTIONS:
-- crouch_and_shoot  (crouch and shoot to activate boost)
-- crouch            (crouch only, to activate boost)

-- If this is true, the player will have invincibility:
vanish.invincibility = true

-- If this is true, vanish will be auto-disabled (for all players) when the game ends, thus, players will not be in vanish when the next game begins.
-- They will have to turn it back on.
vanish.auto_off = false

-- If this is true, the player wlll have a speed boost:
vanish.speed_boost = true
-- Speed boost applied (default running speed is 1):
vanish.running_speed = 2
-- Speed the player returns to when they exit out of Vanish Mode:
vanish.default_running_speed = 1

-- =============== ENABLE | DISABLE Messages =============== --
-- (optional) -> Use "%name%" variable to output the joining players name.
vanish.onEnableMsg = "%name% is now invisible. Poof!"
vanish.onDisabeMsg = "%name% is no longer invisible!"
--==================================================================================================--


-- =============== JOIN SETTINGS =============== --
-- Keep vanish on quit? (When the player returns, they will still be in vanish).
vanish.keep = true

-- Remind the newly joined player that they are in vanish? (requires vanish.keep to be enabled) 
vanish.join_tell = true
-- (optional) -> Use "%name%" variable to output the joining players name.
vanish.join_msg = "%name%, You have joined vanished."

-- Tell other players that PlayerX joined in vanish? (requires vanish.keep to be enabled) 
vanish.join_tell_others = true
vanish.join_others_msg = "%name% joined vanished!"
--==================================================================================================--
-- Vanish Configuration [ends] --

local script_version, weapon_status = 1.2, { }
local lower, upper, format, gsub = string.lower, string.upper, string.format, string.gsub

local function getip(p)
    if (p) then
        return get_var(p, "$ip")--:match("(%d+.%d+.%d+.%d+)")
    end
end

local function reset()
    for i = 1, 16 do
        if player_present(i) then
            if (vanish[getip(i)] ~= nil) then
                vanish[getip(i)] = nil
                weapon_status[i] = nil
                if (vanish.speed_boost) then
                    execute_command("s " .. tonumber(i) .. " " .. tonumber(vanish.default_running_speed))
                end
            end
        end
    end
end

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")

    register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerDisconnect")

    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    reset()
end

function OnScriptUnload()

end

-- Stores Player IP to an array...
-- Because SAPP cannot retrieve the player IP on 'event_leave' if playing on PC.
-- This table is only accessed when 'event_leave' is called.
local ip_table = { }

local game_over
function OnGameStart()  
    game_over = false
end

function OnGameEnd()
    game_over = true
    if (vanish.auto_off) then
        reset()
    end
end

local function isConsole(e)
    if (e) then
        if (e ~= -1 and e >= 1 and e < 16) then
            return false
        else
            return true
        end
    end
end

local execute_on_others_error = { }
local function executeOnOthers(e, self, is_console, level)
    if not (self) and not (is_console) then
        if tonumber(level) >= vanish.execute_on_others then
            return true
        elseif (execute_on_others_error[e]) then
            execute_on_others_error[e] = false
            respond(e, "You are not allowed to execute this command on other players.", "rcon", 4 + 8)
            return false
        end
    else
        return true
    end
end

local Say = function(Player, Message)
    if (Player) and (Message) then
        execute_command("msg_prefix \"\"")
        say(Player, Message)
        execute_command("msg_prefix \" " .. vanish.serverprefix .. "\"")
    end
end

local function announceExclude(PlayerIndex, message)
    for i = 1, 16 do
        if (player_present(i) and i ~= PlayerIndex) then
            Say(i, message)
        end
    end
end

local function respond(executor, message, environment, color)
    if (executor) then
        color = color or 4 + 8
        if not (isConsole(executor)) then
            if (environment == "chat") then
                Say(executor, message)
            elseif (environment == "rcon") then
                rprint(executor, message)
            end
        else
            cprint(message, color)
        end
    end
end

function OnPlayerConnect(p)

    local ip = getip(p)

    ip_table[p] = ip_table[p] or { }
    ip_table[p] = ip
    
    local status = vanish[ip]
    if (status ~= nil) and (status.enabled) then
        if (vanish.join_tell) then
            local join_message = gsub(vanish.join_msg, "%%name%%", get_var(p, "$name"))
            respond(p, join_message, "rcon", 2+8)
        end
    
        if (vanish.join_tell_others) then
            local msg = gsub(vanish.join_others_msg, "%%name%%", get_var(p, "$name"))
            announceExclude(p, msg, "rcon", 2+8)
        end
    end
end

function OnPlayerDisconnect(p)
    local ip = function(pid)
        if (pid) then
            local ip_address
            if (halo_type == "PC") then
                ip_address = ip_table[pid]
            else
                ip_address = getip(pid)
            end
            return ip_address
        end
    end
    if (vanish[ip(p)] ~= nil) then
        if not (vanish[ip(p)].enabled) or not (vanish.keep) then
            vanish[ip(p)] = { }
            weapon_status[p] = nil
        end
    end
    ip_table[p] = nil
end

function OnPlayerSpawn(PlayerIndex)
    if (weapon_status[PlayerIndex] ~= nil) then
        weapon_status[PlayerIndex] = 0
    end
end

function OnTick()
    for i = 1,16 do
        if player_present(i) and player_alive(i) then
           local status = vanish[getip(i)]
           if (status ~= nil) and (status.enabled) then
                local coords = getXYZ(i)
                if (coords) then
                    write_float(get_player(i) + 0x100, coords.z - 1000)
                end
                
                -- Speed seems to decrease over time on SAPP, so continuously updating player speed here seems to fix that.
                if (vanish.speed_boost) then
                    execute_command("s " .. tonumber(i) .. " " .. tonumber(vanish.running_speed))
                end
                
                if (vanish.boost) then
                    local player = get_dynamic_player(i)
                    if (player ~= 0) then
                        local couching = read_float(player + 0x50C)
                        local is_crouching, shot_fired
                        if (couching == 0) then
                            is_crouching = false
                        else
                            is_crouching = true
                        end
                        if (vanish.boost_trigger == "crouch_and_shoot") then
                            shot_fired = read_float(player + 0x490)
                            if (shot_fired ~= weapon_status[i] and shot_fired == 1 and is_crouching) then
                                execute_command("boost " .. i)
                            end
                            weapon_status[i] = shot_fired
                        elseif (vanish.boost_trigger == "crouch" and is_crouching) then
                            execute_command("boost " .. i)
                        end
                    end
                end
            end
        end
    end
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)
    local TargetID, target_all_players, is_error
    local name = get_var(executor, "$name")
    command = lower(command) or upper(command)

    local function checkAccess(e)
        local access
        if not isConsole(e) then
            if (tonumber(get_var(e, "$lvl")) >= vanish.permission_level) then
                access = true
            else
                rprint(e, "Command failed. Insufficient Permission.")
                access = false
            end
        else
            access = true
        end
        return access
    end

    local function isOnline(t, e)
        if (t) then
            if (t > 0 and t < 17) then
                if player_present(t) then
                    return true
                else
                    respond(e, "Command failed. Player not online.", "rcon", 4 + 8)
                    return false
                end
            else
                respond(e, "Invalid player id. Please enter a number between 1-16", "rcon", 4 + 8)
            end
        end
    end

    local params = { }
    local function validate_params(pos)
        local function getplayers(arg)
            local players = { }
            if (arg == nil) or (arg == "me") then
                TargetID = executor
                table.insert(players, executor)
            elseif (arg:match("%d+")) then
                TargetID = tonumber(arg)
                table.insert(players, arg)
            elseif (arg == "*" or arg == "all") then
                for i = 1, 16 do
                    if player_present(i) then
                        target_all_players = true
                        table.insert(players, i)
                    end
                end
            else
                respond(executor, "Invalid player id. Usage: [number: 1-16] | */all | me", "rcon", 4 + 8)
                is_error = true
                return false
            end

            for i = 1, #players do
                if (executor ~= tonumber(players[i])) then
                    execute_on_others_error[executor] = { }
                    execute_on_others_error[executor] = true
                end
            end
            if players[1] then
                return players
            end
            players = nil
            return false
        end
        local pl = getplayers(args[tonumber(pos)])
        if pl then
            for i = 1, #pl do
                if pl[i] == nil then
                    break
                end

                params.eid, params.en = executor, name
                params.tid, params.tn = tonumber(pl[i]), get_var(pl[i], "$name")
                params.tip = getip(pl[i])

                if (args[1] ~= nil) then
                    params.option = args[1]
                end

                if (target_all_players) then
                    vanish:set(params)
                end
            end
        end
    end

    local gameover = function()
        if (game_over) then
            rprint(executor, "Command Failed -> Game has Ended.")
            rprint(executor, "Please wait until the next game has started.")
            return true
        end
    end

    if (command == vanish.command) then
        if not gameover() then
            if (checkAccess(executor)) then
                if (args[1] ~= nil) then
                    validate_params(2) -- /command <args> [me | id | */all]
                    if not (target_all_players) then
                        if not (is_error) and isOnline(TargetID, executor) then
                            vanish:set(params)
                        end
                    end
                else
                    respond(executor, "Invalid Syntax: Usage: /" .. vanish.command .. " on|off [me | id | */all]", "rcon", 4 + 8)
                end
            end
        end
        return false
    end
end

function vanish:set(params)
    local params = params or { }

    local en = params.en or nil
    local eid = params.eid or nil
    if (eid == nil) then
        eid = 0
    end

    local tn = params.tn or nil
    local tip = params.tip or nil

    local tid = params.tid or nil
    if (tid == nil and eid ~= nil) then
        tid = eid
    end

    local option = params.option or nil

    local is_self
    if (eid == tid) then
        is_self = true
    end

    if isConsole(eid) then
        en = "SERVER"
    end

    vanish[tip] = vanish[tip] or {}

    local function Enable()
        vanish[tip].enabled = true
        if (vanish.invincibility) then
            execute_command("god " .. tid)
        end
        if (vanish.announce) then
            announceExclude(tid, gsub(vanish.onEnableMsg, "%%name%%", tn))
        end
    end

    local function Disable(tid)
        vanish[tip].enabled = false
        if (vanish.invincibility) then
            execute_command("ungod " .. tid)
        end
        if (vanish.announce) then
            announceExclude(tid, gsub(vanish.onDisabeMsg, "%%name%%", tn))
        end
        if (vanish.speed_boost) then
            execute_command("s " .. tonumber(tid) .. " " .. tonumber(vanish.default_running_speed))
        end
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))
    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl)) then
        local status, already_set, is_error
        if (option == "on") or (option == "1") or (option == "true") then
            if (vanish[tip].enabled ~= true) then
                status, already_set, is_error = "Enabled", false, false
                Enable(tid, tn)
            else
                status, already_set, is_error = "Enabled", true, false
            end
        elseif (option == "off") or (option == "0") or (option == "false") then
            if (vanish[tip].disabled ~= false) then
                status, already_set, is_error = "Disabled", false, false
                Disable(tid, tn)
            else
                status, already_set, is_error = "Disabled", true, false
            end
        else
            is_error = true
            respond(eid, "Invalid Syntax: Type /" .. vanish.command .. " [id] on|off.", "rcon", 4 + 8)
        end
        if not (is_error) and not (already_set) then
            if not (is_self) then
                respond(eid, "Invisibility " .. status .. " for " .. tn, "rcon", 2 + 8)
                respond(tid, "Invisibility Mode was " .. status .. " by " .. en, "rcon")
            else
                respond(eid, "Invisibility Mode " .. status, "rcon", 2 + 8)
            end
        elseif (already_set) then
            respond(eid, "[SERVER] -> " .. tn .. ", Invisibility already " .. status, "rcon", 4 + 8)
        end
    end
    return false
end

function getXYZ(p)
    local player_object = get_dynamic_player(p)
    if (player_object ~= 0) and player_alive(p) then
    
        local function isInVehicle(p)
            if (get_dynamic_player(p) ~= 0) then
                local VehicleID = read_dword(get_dynamic_player(p) + 0x11C)
                if VehicleID == 0xFFFFFFFF then
                    return false
                else
                    return true
                end
            else
                return false
            end
        end
        
        local coords, x, y, z = { }
        if isInVehicle(p) then
            coords.invehicle = true
            local VehicleID = read_dword(player_object + 0x11C)
            local vehicle, seat = get_object_memory(VehicleID), read_word(player_object + 0x2F0)
            x, y, z = read_vector3d(vehicle + 0x5c)
        else
            coords.invehicle = false
            x, y, z = read_vector3d(player_object + 0x5c)
        end
        x, y, z = format("%0.3f", x), format("%0.3f", y), format("%0.3f", z)
        coords.x, coords.y, coords.z = x, y, z
        return coords
    end
end

function cmdsplit(str)
    local subs = {}
    local sub = ""
    local ignore_quote, inquote, endquote
    for i = 1, string.len(str) do
        local bool
        local char = string.sub(str, i, i)
        if char == " " then
            if (inquote and endquote) or (not inquote and not endquote) then
                bool = true
            end
        elseif char == "\\" then
            ignore_quote = true
        elseif char == "\"" then
            if not ignore_quote then
                if not inquote then
                    inquote = true
                else
                    endquote = true
                end
            end
        end

        if char ~= "\\" then
            ignore_quote = false
        end

        if bool then
            if inquote and endquote then
                sub = string.sub(sub, 2, string.len(sub) - 1)
            end

            if sub ~= "" then
                table.insert(subs, sub)
            end
            sub = ""
            inquote = false
            endquote = false
        else
            sub = sub .. char
        end

        if i == string.len(str) then
            if string.sub(sub, 1, 1) == "\"" and string.sub(sub, string.len(sub), string.len(sub)) == "\"" then
                sub = string.sub(sub, 2, string.len(sub) - 1)
            end
            table.insert(subs, sub)
        end
    end

    local cmd = subs[1]
    local args = subs
    table.remove(args, 1)

    return cmd, args
end

-- In the event of an error, the script will trigger these two functions: OnError(), report()
function report()
    local script_version = format("%0.2f", script_version)
    cprint("--------------------------------------------------------", 5 + 8)
    cprint("Please report this error on github:", 7 + 8)
    cprint("https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", 7 + 8)
    cprint("Script Version: " .. script_version, 7 + 8)
    cprint("--------------------------------------------------------", 5 + 8)
end

-- This function will return a string with a traceback of the stack call...
-- ...and call function 'report' after 50 milliseconds.
function OnError()
    cprint(debug.traceback(), 4 + 8)
    timer(50, "report")
end
--[[ =================== Change Log ===================
[24/05/19]
1). First release (v1.0)

[25/05/19]
1). Bug fixes
2). New setting: 'vanish.auto_off' (toggle this setting on or off with 'true' or 'false'.)
If this is true, vanish will be auto-disabled (for all players) when the game ends, thus, players will not be in vanish when the next game begins.
]]
