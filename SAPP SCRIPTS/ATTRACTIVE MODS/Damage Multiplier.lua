--[[
--=====================================================================================================--
Script Name: Damage Multiplier, for SAPP (PC & CE)
Description: N/A

Command Syntax: 
    * /damage [0 - 10]
    ~ 1.00 is default damage

Copyright (c) 2016-2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --


api_version = "1.12.0.0"

-- config starts [
local min_damage = 0
local max_damage = 10
local base_command = "damage"
-- config ends ]

-- do not touch --
local damage_multiplier = { }
local modify_damage = { }

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
end

function OnScriptUnload()
    --
end

function OnServerCommand(PlayerIndex, Command)
    local t = tokenizestring(Command)
    if t[1] == nil then
        return nil
    end
    local command = t[1]:gsub("\\", "/")
    if (command == base_command) then
        if (t[2] ~= nil) then
            if (t[2]:match("%d+")) then
                local multiplier = tonumber(t[2])
                if (multiplier >= tonumber(min_damage + 1) and multiplier <= tonumber(max_damage)) then
                    damage_multiplier[PlayerIndex] = multiplier
                    modify_damage[PlayerIndex] = true
                    rprint(PlayerIndex, "Now dealing " .. multiplier .. "x damage")
                elseif (multiplier == tonumber(min_damage)) then
                    rprint(PlayerIndex, "You will no longer inflict damage!")
                elseif (damage_multiplier[PlayerIndex]) and (multiplier == damage_multiplier[PlayerIndex]) then
                    rprint(PlayerIndex, "You're already dealing (" .. multiplier.. "x) damage")
                else
                    rprint(PlayerIndex, "Please enter a number between [" .. min_damage .. "-" .. max_damage .. "]")
                end
            else
                rprint(PlayerIndex, "Error! (t[2]) ->  That is not a number!")
            end
        else
            rprint(PlayerIndex, "Invalid syntax. Usage: /" .. base_command .. " [" .. min_damage .. "-" .. max_damage .. "]")
        end
        return false
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
        if (modify_damage[CauserIndex] == true) then
            return true, Damage * tonumber(damage_multiplier[CauserIndex])
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    modify_damage[PlayerIndex] = false
end

function OnPlayerLeave(PlayerIndex)
    if modify_damage[PlayerIndex] then
        damage_multiplier[PlayerIndex] = nil
        modify_damage[PlayerIndex] = false
    end
end

function tokenizestring(inputString, Separator)
    if Separator == nil then
        Separator = "%s"
    end
    local t = {};
    local i = 1
    for str in string.gmatch(inputString, "([^" .. Separator .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
