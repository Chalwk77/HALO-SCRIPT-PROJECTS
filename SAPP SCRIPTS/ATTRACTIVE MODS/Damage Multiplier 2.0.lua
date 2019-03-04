--[[
--=====================================================================================================--
Script Name: Damage Multiplier 2.0, for SAPP (PC & CE)
Description: N/A

Command Syntax: 
    * /damage [player id | me | *] [number range 0-10] (optional -s)
    "me" can be used in place of your own player id

Copyright (c) 2016-2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --
api_version = "1.12.0.0"

-- Configuration [starts] ->
-- Minimum privilege level required to execute /damage command. Set to -1 (negative one) for all players
local privilege_level = 4
local base_command = "damage"

local min_damage = 0
local max_damage = 10
local default_damage = 1

-- Configuration [ends] <-

local mod, damage, modify, silentcmd = { }, { }, { }, { }

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerDisconnect")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
end

local lower = string.lower

function OnScriptUnload()
    --
end

local function checkAccess(e)
    if (e ~= -1 and e >= 1 and e < 16) then
        if (tonumber(get_var(e, "$lvl"))) >= privilege_level then
            return true
        else
            rprint(e, "Command failed. Insufficient Permission.")
            return false
        end
    else
        cprint("You cannot execute this command from the console.", 4 + 8)
        return false, "console"
    end
end

local function isOnline(t, e)
    if (t) then
        if (t > 0 and t < 17) then
            if player_present(t) then
                return true
            else
                rprint(e, "Command failed. Player not online.")
                return false
            end
        else
            rprint(e, "Invalid player id. Please enter a number between 1-16")
        end
    end
end

function OnServerCommand(PlayerIndex, Command)
    local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)

    local players, TargetID, all_players = { }, { }

    local function validate_params()
        local multiplier, _min, _max = tonumber(args[2]), tonumber(min_damage), tonumber(max_damage)

        if (args[3] ~= nil) then
            if (args[3] == "-s") then
                silentcmd[executor] = true
            else
                rprint(executor, "Error! (args[3]) ->  Invalid command flag. Usage: -s")
            end
        end

        local function getplayers(arg, executor)
            local pl = { }
            if arg == "*" then
                for i = 1, 16 do
                    if player_present(i) then
                        all_players = true
                        table.insert(pl, i)
                    end
                end
            elseif arg == "me" then
                TargetID = executor
                table.insert(pl, executor)
            elseif arg:match("%d+") then
                TargetID = tonumber(args[1])
                table.insert(pl, arg)
            else
                rprint(executor, "Invalid command parameter")
                return false
            end
            if pl[1] then
                return pl
            end
            pl = nil
            return false
        end

        local pl = getplayers(args[1], executor)
        if pl then
            for i = 1, #pl do
                if pl[i] == nil then
                    break
                end
                if (multiplier >= _min) and (multiplier <= _max) then
                    players.en = get_var(executor, "$name")
                    players.eid = tonumber(get_var(executor, "$n"))

                    players.tn = get_var(pl[i], "$name")
                    players.tid = tonumber(get_var(pl[i], "$n"))

                    players.mul = multiplier
                    players.min = _min
                    players.max = _max
                    if (all_players) then
                        mod:setdamage(players)
                    end
                else
                    rprint(PlayerIndex, "Please enter a number between [" .. min_damage .. "-" .. max_damage .. "]")
                end
            end
        end
    end

    if (command == lower(base_command) and checkAccess(executor)) then
        if (args[1] ~= nil) and (args[2] ~= nil) then
            validate_params()
            if not (all_players) then
                if isOnline(TargetID, executor) then
                    mod:setdamage(players)
                end
            end
        else
            rprint(executor, "Invalid syntax. Usage: /" .. base_command .. " [player id] [number range 0-10] (optional -s)")
        end
        return false
    end
end

function mod:setdamage(params)
    local params = params or {}

    local executor_name = params.en or nil
    local executor_id = params.eid or nil

    local target_name = params.tn or nil
    local target_id = params.tid or nil

    local multiplier = params.mul or nil
    local _min = params.min or nil
    local _max = params.max or nil

    local function set_multiplier(a, b)
        if (a) then
            damage[target_id] = multiplier
            modify[target_id] = true
        else
            modify[target_id] = false
            damage[target_id] = nil
        end
        if (b) then
            if not (silentcmd[executor_id]) then
                if (target_id ~= executor_id) then
                    rprint(target_id, executor_name .. " set your damage multiplier to " .. multiplier .. "x damage")
                    rprint(executor_id, target_name .. " is dealing " .. multiplier .. "x damage")
                else
                    rprint(target_id, "You are now dealing " .. multiplier .. "x damage")
                end
            else
                if (target_id ~= executor_id) then
                    rprint(executor_id, "[silent] Setting " .. multiplier .. "x damage" .. " for " .. target_name)
                else
                    rprint(executor_id, "You are dealing " .. multiplier .. "x damage")
                end
            end
        end
    end

    if not (modify[target_id]) then
        if (multiplier == default_damage) then
            if (target_id ~= executor_id) then
                rprint(executor_id, target_name .. " is already dealing default damage.")
            else
                rprint(executor_id, "No change. You are already dealing default damage.")
            end
            return false
        end
    elseif (multiplier == default_damage and (damage[target_id] ~= default_damage)) then
        set_multiplier(false, false)
        if not (silentcmd[executor_id]) then
            if (target_id ~= executor_id) then
                rprint(target_id, "[" .. executor_name .. "] -> [you]: You will now deal default damage")
                rprint(executor_id, target_name .. " now dealing default damage.")
            else
                rprint(executor_id, "You are now dealing default damage.")
            end
        else
            rprint(executor_id, "[silent] " .. target_name .. " is now dealing default damage.")
        end
        return false
    end

    if (multiplier == _min) then
        set_multiplier(true, false)
        if not (silentcmd[executor_id]) then
            if (target_id ~= executor_id) then
                rprint(target_id, "[" .. executor_name .. "] -> [you]: You will no longer inflict damage!")
                rprint(executor_id, target_name .. " will no longer inflict damage!")
            else
                rprint(executor_id, "You will no longer inflict damage!")
            end
        else
            rprint(executor_id, "[silent] " .. target_name .. " will no longer inflict damage!")
        end
    elseif (multiplier == _max) then
        set_multiplier(true, false)
        if not (silentcmd[executor_id]) then
            if (target_id ~= executor_id) then
                rprint(target_id, "[" .. executor_name .. "] -> [you]: You will now inflict maximum damage!")
                rprint(executor_id, target_name .. " will now inflict maximum damage!")
            else
                rprint(executor_id, "You will now inflict maximum damage!")
            end
        else
            rprint(executor_id, "[silent] " .. target_name .. " will now inflict maximum damage!")
        end
    elseif (multiplier == damage[target_id]) then
        if (target_id ~= executor_id) then
            rprint(executor_id, target_name .. " is already dealing (" .. multiplier .. "x) damage")
        else
            rprint(executor_id, "You're already dealing (" .. multiplier .. "x) damage")
        end
    else
        set_multiplier(true, true)
    end
    silentcmd[executor_id] = nil
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
        if (modify[CauserIndex]) then
            return true, Damage * tonumber(damage[CauserIndex])
        end
    end
end

function OnPlayerConnect(PlayerIndex)
    modify[PlayerIndex] = false
end

function OnPlayerDisconnect(PlayerIndex)
    if modify[PlayerIndex] then
        modify[PlayerIndex] = false
        damage[PlayerIndex] = nil
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
