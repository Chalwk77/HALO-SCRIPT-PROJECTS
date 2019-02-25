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
local base_command = "damage"

-- do not touch unless you know what you're doing --
local min_damage = 0
local max_damage = 10
local default_damage = 1
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
            if t[3] ~= nil then
                local multiplier, _MIN, _MAX = tonumber(t[3]), tonumber(min_damage), tonumber(max_damage)
                if (multiplier >= _MIN) and (multiplier <= _MAX) then
                
                    local executor = tonumber(PlayerIndex)
                    local TargetID, execute_silenty, is_all
                    if (t[2] == "me") then
                        TargetID = tonumber(PlayerIndex)
                    elseif (t[2]:match("%d+")) then
                        TargetID = tonumber(t[2])
                    -- not currently implemented
                    elseif (tostring(t[2]) == "*") then
                        is_all = true
                    end
                    
                    if not player_present(TargetID) then
                        rprint(PlayerIndex, "Player not present!")
                        return false
                    end
                    
                    if t[4] ~= nil then
                        if t[4] == "-s" then
                            execute_silenty = true
                        else
                            rprint(executor, "Error! (t[4]) ->  Invalid command flag. Usage: -s")
                        end
                    end
                
                    local function set_multiplier()
                        damage_multiplier[TargetID] = multiplier
                        modify_damage[TargetID] = true
                        if not (execute_silenty) then
                            if (TargetID ~= executor) then
                                rprint(TargetID, "Now dealing " .. multiplier .. "x damage")
                                rprint(executor, get_var(TargetID, "$name") .. " is dealing " .. multiplier .. "x damage")
                            else
                                rprint(TargetID, "Now dealing " .. multiplier .. "x damage")
                            end
                        else
                            rprint(executor, "Setting " .. multiplier .. "x damage" .. " for " .. get_var(TargetID, "$name"))
                        end
                    end
                    
                    if not (modify_damage[TargetID]) then
                        if (multiplier == default_damage) then
                            if not (execute_silenty) then
                                if (TargetID ~= executor) then
                                    rprint(executor, get_var(TargetID, "$name") .. " is already dealing default damage.")
                                else
                                    rprint(executor, "No change. You are already dealing default damage.")
                                end
                            else
                                rprint(executor, "No change. " .. get_var(TargetID, "$name") .. " is already dealing default damage.")
                            end
                        elseif (multiplier == _MIN) then
                            damage_multiplier[TargetID] = multiplier
                            modify_damage[TargetID] = true
                            if not (execute_silenty) then
                                if (TargetID ~= executor) then
                                    rprint(TargetID, "You will no longer inflict damage!")
                                    rprint(executor, get_var(TargetID, "$name") .. " will no longer inflict damage!")
                                else
                                    rprint(executor, "You will no longer inflict damage!")
                                end
                            else
                                rprint(executor, get_var(TargetID, "$name") .. " will no longer inflict damage!")
                            end
                        else
                            set_multiplier()
                        end
                        
                    elseif (modify_damage[TargetID]) then
                        if (multiplier == default_damage and (damage_multiplier[TargetID] ~= default_damage)) then
                            if not (execute_silenty) then
                                if (TargetID ~= executor) then
                                    rprint(TargetID, "You are now dealing default damage.")
                                    rprint(executor, get_var(TargetID, "$name") .. " now dealing default damage.")
                                else
                                    rprint(executor, "You are now dealing default damage.")
                                end
                            else
                                rprint(executor, get_var(TargetID, "$name") .. " is now dealing default damage.")
                            end
                            damage_multiplier[TargetID] = nil
                            modify_damage[TargetID] = false
                        elseif (multiplier == _MIN) then
                            damage_multiplier[TargetID] = multiplier
                            modify_damage[TargetID] = true
                            if not (execute_silenty) then
                                if (TargetID ~= executor) then
                                    rprint(TargetID, "You will no longer inflict damage!")
                                    rprint(executor, get_var(TargetID, "$name") .. " will no longer inflict damage!")
                                else
                                    rprint(executor, "You will no longer inflict damage!")
                                end
                            else
                                rprint(executor, get_var(TargetID, "$name") .. " will no longer inflict damage!")
                            end
                        elseif (multiplier == damage_multiplier[TargetID]) then
                            if not (execute_silenty) then
                                if (TargetID ~= executor) then
                                    rprint(TargetID, "You're already dealing (" .. multiplier.. "x) damage")
                                    rprint(executor, get_var(TargetID, "$name") .. " is already dealing (" .. multiplier.. "x) damage")
                                else
                                    rprint(executor, "You're already dealing (" .. multiplier.. "x) damage")
                                end
                            else
                                rprint(executor, get_var(TargetID, "$name") .. " is already dealing (" .. multiplier.. "x) damage")
                            end
                        else
                            set_multiplier()
                        end
                    end
                else
                    rprint(PlayerIndex, "Please enter a number between [" .. min_damage .. "-" .. max_damage .. "]")
                end
            end
        else
            rprint(PlayerIndex, "Invalid syntax. Usage: /" .. base_command .. " [" .. min_damage .. "-" .. max_damage .. "]")
        end
        return false
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
        if (modify_damage[CauserIndex]) then
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
