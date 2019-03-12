--[[
--=====================================================================================================--
Script Name: Crash Player (utility), for SAPP (PC & CE)
Description: Crash someone automatically when they join the server (based on Name/Hash comparisons)
            - or Crash someone (anyone) on demand!
            Command Syntax: /crash <player id>
            
            
    Change Log: 
    * Bug Fixes + Refactored 90% of the code

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"

-- Configuration [start] -------------

local base_command = "crash"
local privilege_level = 4
local users = {
    -- Make sure the player's name matches exactly as it will in game.
    -- NAME             HASH
    {["username1"] = {"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"}},
    {["username2"] = {"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"}},
    {["username3"] = {"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"}},
    
    -- repeat the structure to add more entries 
    {["name"] = {"hash"}},
}

-- Configuration [end] -------------

local mod, trigger, lower, find = { }, { }, string.lower, string.find

function OnScriptLoad()
    
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")
    register_callback(cb['EVENT_TICK'], "OnTick")
    
    if halo_type == "PC" then
        ce = 0x0
    else
        ce = 0x40
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
    
    if (lookup_tag("vehi", "vehicles\\rwarthog\\rwarthog") ~= 0) then
        local player_object = get_dynamic_player(tid)
        if player_object ~= 0 then
            trigger[tid] = true
            rprint(eid, "You have crashed " .. tn .. "'s game client")
        end
    else
        rprint(eid, "Error. Crash does not work on this map!")
    end
end

function Crash(target, name)
    local player_object = get_dynamic_player(target)
    if (player_object ~= 0) then
        local x, y, z = read_vector3d(player_object + 0x5C)
        local vehicle_id = spawn_object("vehi", "vehicles\\rwarthog\\rwarthog", x, y, z)
        local veh_obj = get_object_memory(vehicle_id)
        if (veh_obj ~= 0) then
            for j = 0, 20 do
                enter_vehicle(vehicle_id, target, j)
                exit_vehicle(target)
            end
            destroy_object(vehicle_id)
        end
        cprint("Crashed " .. name .. "'s game client", 4+8)
    end
    return false
end

function OnPlayerPrejoin(PlayerIndex)
    trigger[PlayerIndex] = nil
    if (lookup_tag("vehi", "vehicles\\rwarthog\\rwarthog") ~= 0) then
        local ns = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
        local cns = ns + 0x1AA + ce + to_real_index(PlayerIndex) * 0x20
        
        local function read_widestring(address, length)
            local count = 0
            local byte_table = { }
            for i = 1, length do
                if read_byte(address + count) ~= 0 then
                    byte_table[i] = string.char(read_byte(address + count))
                end
                count = count + 2
            end
            return table.concat(byte_table)
        end
        
        local name, hash = read_widestring(cns, 12), get_var(PlayerIndex, "$hash")

        for key, _ in ipairs(users) do
            local userdata = users[key][name]
            if (userdata ~= nil) then
                for i = 1,#userdata do
                    if find(userdata[i], hash) then
                        trigger[PlayerIndex] = true
                        break
                    end
                end
            end
        end
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
