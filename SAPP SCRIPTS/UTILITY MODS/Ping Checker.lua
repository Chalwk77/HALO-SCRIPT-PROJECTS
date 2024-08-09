--[[
--=====================================================================================================--
Script Name: PingChecker, for SAPP (PC & CE)
Description: A simple addon to check your ping (or others)

Copyright (c) 2020-2024, Jericho Crosby <jericho.crosby227@gmail.com>

Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts:

-- Custom ping command:
--
local pingCommand = 'ping'

-- Minimum permission level to execute the custom command:
--
local permissionLevel = -1

-- Message template for ping output:
-- The $name & $ping placeholders will be replaced by the corresponding values.
--
local outputTemplate = '$name: $ping'
-- config ends (do not touch anything below this point)

-- SAPP Lua API Version:
api_version = '1.12.0.0'

-- Responsible for handling the loading of the script:
--
function OnScriptLoad()
    -- register needed event callback for the Command Handler:
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
end

-- Checks if a player has permission to execute the custom command:
-- @param p (Player memory address index) [number]
--
function HasAccess(Ply)
    local lvl = tonumber(get_var(Ply, '$lvl'))
    return (Ply == 0 or lvl >= permissionLevel)
end

-- Splits a string by whitespace into an array:
-- @param s (String to split) [string]
--
function CMD_Split(s)
    local args = {}
    for arg in s:gmatch('([^%s]+)') do
        args[#args + 1] = arg:lower()
    end
    return args
end

-- Sends a response to the player:
-- @param ply (Player memory address index) [number]
-- @param str (Message to send) [string]
--
function Respond(Ply, Str)
    return (Ply == 0 and cprint(Str) or rprint(Ply, Str))
end

-- Gets a player's ping:
-- @param ply (Player memory address index) [number]
-- @return player's ping [number]
--
function GetPlayerPing(Ply)
    return get_var(Ply, '$ping')
end

-- Gets a player's name:
-- @param ply (Player memory address index) [number]
-- @return player's name [string]
--
function GetPlayerName(Ply)
    return get_var(Ply, '$name')
end

-- Replaces placeholders in a string with provided values:
-- @param str (String with placeholders) [string]
-- @param name (Player's name) [string]
-- @param ping (Player's ping) [number]
-- @return modified string [string]
--
function ReplacePlaceholders(str, name, ping)
    return str:gsub('$ping', ping):gsub('$name', name)
end

-- Checks if a player ID is valid:
-- @param ply (Player memory address index) [number]
-- @return true if player is present, false otherwise [boolean]
--
function CheckPlayerId(Ply)
    return (Ply and player_present(Ply))
end

-- Handles the custom command execution:
-- @param ply (Player memory address index) [number]
-- @param cmd (Command string) [string]
--
function OnCommand(Ply, CMD, _, _)
    local args = CMD_Split(CMD)

    if (args and args[1] == pingCommand and HasAccess(Ply)) then
        local player = tonumber(args[2])
        local name, ping

        if CheckPlayerId(player) then

            -- Get player name and ping:
            ping = GetPlayerPing(player)
            name = GetPlayerName(player)

            -- Replace placeholders in output template:
            local output = ReplacePlaceholders(outputTemplate, name, ping)

            -- Send output message to the player:
            Respond(Ply, output)
        else
            -- Notify the player that the target player is invalid or not online:
            Respond(Ply, 'Invalid Player ID or Player not online!')
        end

        -- Return false to indicate that the command has been handled:
        return false
    end
end

-- Placeholder function for unloading the script:
--
function OnScriptUnload()
    -- N/A
end