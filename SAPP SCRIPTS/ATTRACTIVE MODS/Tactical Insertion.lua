--[[
--=====================================================================================================--
Script Name: Tactical Insertion, for SAPP (PC & CE)
Description: Set your next Spawn Point with a custom command!
             You can only use Tac-Insert once per life.

Credits to "Shoo" for the idea.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local mod = {}

function mod:init()
    -- ============== Configuration Starts ============== --
    
    -- Custom Command:
    mod.command = "ti"
    -- Minimum permission needed to execute the custom command (set to -1 for all players. 1-4 admins)
    mod.permission = -1
    mod.on_execute = "Tac-Insert Coordinates set to X: %x%, Y: %y%, Z: %z%"
        -- ============== Configuration Ends ============== --
    
    -- # Do Not Touch # --
    mod.players = {}
end

-- Variables for String Library:
local gsub = string.gsub
local format = string.format
local gmatch = string.gmatch
local lower, upper = string.lower, string.upper

-- Game Variables:
local game_over

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb['EVENT_PRESPAWN'], "OnPlayerPrespawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    
    if (get_var(0, "$gt") ~= "n/a") then
        mod:init()
        game_over = false
        for i = 1,16 do
            if player_present(i) then
                mod:initPlayer(i, true)
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        mod:init()
        game_over = false
    end
end

function OnGameEnd()
    game_over = true
end

function OnPlayerConnect(p)
    mod:initPlayer(p, true)
end

function OnPlayerDisconnect(p)
    mod:initPlayer(p, false)
end

function OnPlayerPrespawn(PlayerIndex)
    local insertion = mod.players[PlayerIndex]
    insertion.expired = false
    
    if (insertion.trigger) then
        local player_object = get_dynamic_player(PlayerIndex)
        if (player_object ~= 0) then
            insertion.trigger = false
            local x,y,z,zOffset = insertion.x, insertion.y, insertion.z, 0.3
            write_vector3d(player_object + 0x5C, x, y, z + zOffset)                
        end
    end
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local args = mod:StringSplit(Command)
    local executor = tonumber(PlayerIndex)
    
    if (args[1] == nil) then
        return
    end
    local command = lower(args[1]) or upper(args[1])

    if (command == mod.command) then
        if not mod:isGameOver(executor) then
            if mod:checkAccess(executor) then
                if (args[2] == nil) then
                    if player_alive(executor) then
                        local player_object = get_dynamic_player(executor)
                        if (player_object ~= 0) then
                            local coords = mod:getXYZ(executor, player_object)
                            if (coords) then
                                local insertion = mod.players[executor]
                                if (not insertion.expired) then
                                    insertion.expired = true
                                    insertion.x = coords.x
                                    insertion.y = coords.y
                                    insertion.z = coords.z
                                    local x = format("%0.3f", coords.x)
                                    local y = format("%0.3f", coords.x)
                                    local z = format("%0.3f", coords.x)
                                    local msg = gsub(gsub(gsub(mod.on_execute,"%%x%%", x),"%%y%%", y),"%%z%%", z)
                                    mod:Respond(executor, msg, 4 + 8)
                                    
                                    insertion.trigger = true                            
                                else                                    
                                    mod:Respond(executor, "You have already used Tac-Insert for this life.", 4 + 8)
                                end
                            end
                        end
                    else
                        mod:Respond(executor, "You must be alive to execute this command", 4 + 8)
                    end
                else
                    mod:Respond(executor, "Invalid Syntax. Usage: /"..command, 4 + 8)
                end
            end
        end
        return false
    end
end

function mod:isGameOver(p)
    if (game_over) then
        mod:Respond(p, "Please wait until the next game has started.")
        return true
    end
    return false
end

function mod:Respond(p, msg, color)
    local color = color or 4 + 8
    if not mod:isConsole(p) then
        rprint(p, msg)
    else
        cprint(msg, color)
    end
end

function mod:isConsole(p)
    if (p ~= -1 and p >= 1 and p < 16) then
        return false
    else
        return true
    end
end

function mod:checkAccess(p)
    if not mod:isConsole(p) then
        local level = tonumber(get_var(p, "$lvl"))
        if (level >= mod.permission) then
            return true
        end
    else
        mod:Respond(p, "Server cannot execute this command", 4+8)
    end
end

function mod:initPlayer(PlayerIndex, Init)
    local players = mod.players
    if (Init) then
        players[PlayerIndex] = {
            x = 0,
            y = 0,
            z = 0,
            expired = false,
            trigger = false,
        }
    else
        players[PlayerIndex] = nil
    end
end

function mod:getXYZ(PlayerIndex, PlayerObject)
    local coords, x, y, z = { }
    if player_alive(PlayerIndex) then
        local VehicleID = read_dword(PlayerObject + 0x11C)
        if (VehicleID == 0xFFFFFFFF) then
            coords.invehicle = false
            x, y, z = read_vector3d(PlayerObject + 0x5c)
        else
            coords.invehicle = true
            x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
        end
        coords.x, coords.y, coords.z = x, y, z
    end
    return coords
end

function OnScriptUnload()
    --
end

function mod:StringSplit(InputString, Seperator)
    if Seperator == nil then
        Seperator = "%s"
    end
    local args = { };
    local i = 1
    for str in gmatch(InputString, "([^" .. Seperator .. "]+)") do
        args[i] = str
        i = i + 1
    end
    return args
end
