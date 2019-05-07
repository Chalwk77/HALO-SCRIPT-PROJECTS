--[[
--=====================================================================================================--
Script Name: Force Field, for SAPP (PC & CE)
Description: Force Field, when activated, will propel enemies backward if they enter your force-field bubble.
			 Force Field will also prevent harm from small-arms projectiles, however, will be temporarily deactivated 
			 if hit by, for example, a rocket.
				
Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local forcefield = {}

-- Force Field Configuration [starts] --

-- Base Command: 
forcefield.command = "ff" -- /command on|off [me | id | */all]
-- If Player ID parameter ([me | id | */all]) is not specified, Force Field will target the executor.

-- Maximum forcefield range - FYI: (forcefield is a sphere)
forcefield.range = 10 -- world units (1 world unit = 10 feet or ~3.048 meters)
forcefield.strength = 0.2 -- not yet implemented

-- Minimum Permission level required to execute /forcefield.command
forcefield.permission_level = 1

-- Minimum Permission level required to turn on forcefield for other players.
forcefield.execute_on_others = 4

-- Global Server Prefix:
-- local function 'Say' temporarily removes the **SERVER** prefix when it announces messges.
-- The prefix will be restored to 'forcefield.serverprefix' when the relay has finished.
forcefield.serverprefix = "**SERVER**"

-- Let players know when someone goes into Force Field mode:
forcefield.announce = true

-- Particle Effects:
-- 1). Simulated with non-inflicting bullet projectiles. 
-- 2). Propagate outward in a 360 degree radius from the player's standing position.

-- Appear when: 
-- 1). Force Field is turned on.
-- 2). Someone is forced backward.
-- 3). Someone attempts to shoot through your forcefield.
forcefield.particle_effects = false -- not yet implemented.

-- Projectile Tag IDs used for particle effects.
forcefield.particles = { -- not yet implemented 
    "weapons\\needler\\mp_needle",
    "weapons\\flamethrower\\flame",
    "weapons\\plasma rifle\\charged bolt",
}

-- Force Field Configuration [ends] --

-- Stores Player IP to an array...
-- Because SAPP cannot retrieve the player IP on 'event_leave' if playing on PC.
-- This table is only accessed when 'event_leave' is called.
local ip_table = { }

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")

    register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerDisconnect")

    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")

    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
end

local lower, upper = string.lower, string.upper

local game_over
function OnGameStart()  
    game_over = false
end

local function getip(p)
    if (p) then
        return get_var(p, "$ip"):match("(%d+.%d+.%d+.%d+)")
    end
end

function OnGameEnd()
    game_over = true
    for i = 1, 16 do
        if player_present(i) then
            local ip = getip(i)
            forcefield = { [ip] = {} }
        end
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
        if tonumber(level) >= forcefield.execute_on_others then
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
        execute_command("msg_prefix \" " .. forcefield.serverprefix .. "\"")
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

    -- Stores Player IP to an array...
    -- Because SAPP cannot retrieve the player IP on 'event_leave' if playing on PC.
    ip_table[p] = ip_table[p] or { }
    ip_table[p] = ip

    forcefield[ip] = {}
    forcefield[ip] = { enabled = false }
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

    forcefield[ip(p)] = { }
    ip_table[p] = nil
end

-- This function returns the total number of players currently online.
local player_count = function()
    return tonumber(get_var(0, "$pn"))
end

function OnTick()
    if (player_count() > 1) then
        for i = 1,player_count() do
            for j = 1,player_count() do        
                if (i ~= j) then
                    if (player_alive(i)) and (player_alive(j)) then
                        local ip1, ip2 = getip(i), getip(j)
                        if (forcefield[ip1].enabled) and not (forcefield[ip2].enabled) then
                            local P1Object, P2Object = get_dynamic_player(i), get_dynamic_player(j)            
                            if (P1Object ~= 0) and (P2Object ~= 0) then
                                local x1, y1, z1 = read_vector3d(P1Object + 0x5C)
                                local x2, y2, z2 = read_vector3d(P2Object + 0x5C)
                                if forcefield:insphere(x1, y1, z1, x2, y2, z2, forcefield.range) then
                                    forcefield:pushback(P2Object, x2, y2, z2)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function forcefield:insphere(x1, y1, z1, x2, y2, z2, r)
    if ((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2 <= r) then
        return true
    elseif ((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2 > r + 1) then
        return false
    end
end

function forcefield:pushback(PlayerObject, x2, y2, z2)
    local strength = forcefield.strength
    
    local x_aim = read_float(PlayerObject + 0x230)
    local y_aim = read_float(PlayerObject + 0x234)
    local z_aim = read_float(PlayerObject + 0x238)
 
    local x = x2 + strength * math.sin(x_aim)
    local y = y2 + strength * math.sin(y_aim)
    local z = z2 + strength * math.sin(z_aim)
    
    write_vector3d(PlayerObject + 0x5C, x, y, z)
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
            if (tonumber(get_var(e, "$lvl")) >= forcefield.permission_level) then
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
            if (arg == nil) then
                arg = executor
            end
            if (arg == "me") then
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

                params.eid = executor
                params.en = name
                params.tid, params.tn = tonumber(pl[i]), get_var(pl[i], "$name")
                params.tip = getip(executor)

                if (args[1] ~= nil) then
                    params.option = args[1]
                end

                if (target_all_players) then
                    forcefield:enable(params)
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

    if (command == forcefield.command) then
        if not gameover() then
            if (checkAccess(executor)) then
                if (args[1] ~= nil) then
                    validate_params(2) -- 2 = /command <args> id | 2 = /command id <args>
                    if not (target_all_players) then
                        if not (is_error) and isOnline(TargetID, executor) then
                            forcefield:enable(params)
                        end
                    end
                else
                    respond(executor, "Invalid Syntax: Usage: /" .. forcefield.command .. " on|off [me | id | */all]", "rcon", 4 + 8)
                end
            end
        end
        return false
    end
end

function forcefield:enable(params)
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

    local function Enable()
        forcefield[tip].enabled = true
        if (forcefield.announce) then
            announceExclude(tid, tn .. " is now in Force Field mode!")
        end
    end

    local function Disable(tid)
        forcefield[tip].enabled = false
        if (forcefield.announce) then
            announceExclude(tid, tn .. " is no longer in Force Field mode!")
        end
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))
    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl)) then
        local status, already_set, is_error
        if (option == "on") or (option == "1") or (option == "true") then
            if (forcefield[tip].enabled ~= true) then
                status, already_set, is_error = "Enabled", false, false
                Enable(tid, tn)
            else
                status, already_set, is_error = "Enabled", true, false
            end
        elseif (option == "off") or (option == "0") or (option == "false") then
            if (forcefield[tip].enabled ~= false) then
                status, already_set, is_error = "Disabled", false, false
                Disable(tid, tn)
            else
                status, already_set, is_error = "Disabled", true, false
            end
        else
            is_error = true
            respond(eid, "Invalid Syntax: Type /" .. forcefield.command .. " [id] on|off.", "rcon", 4 + 8)
        end
        if not (is_error) and not (already_set) then
            if not (is_self) then
                respond(eid, "Force Field " .. status .. " for " .. tn, "rcon", 2 + 8)
                respond(tid, "Your Force Field Mode was " .. status .. " by " .. en, "rcon")
            else
                respond(eid, "Force Field Mode " .. status, "rcon", 2 + 8)
            end
        elseif (already_set) then
            respond(eid, "[SERVER] -> " .. tn .. ", Force Field already " .. status, "rcon", 4 + 8)
        end
    end
    return false
end

function forcefield:showparticles(x, y, z)
    -- not yet implement
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    -- not yet implemented
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
