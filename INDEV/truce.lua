--[[
--=====================================================================================================--
Script Name: Truce, for SAPP (PC & CE)
Description: Initiate a truce with other players!

    WARNING. This mod is a prototype and probably contains bugs.

Command Syntax: 
    * /truce [player id]
    * /accept [player id]
    * /deny [player id]
    * /trucelist

Copyright (c) 2016-2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --


api_version = "1.12.0.0"
truce = {}
wait_for_response = {}
tracker = { }

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
end

function OnScriptUnload()
    
end

function OnServerCommand(PlayerIndex, Command)
    local t = tokenizestring(Command)
    if t[1] == nil then
        return nil
    end
    local command = t[1]:gsub("\\", "/")
    if (command == "truce") then
        if (t[2] ~= nil) then
            if (t[2]:match("%d+")) then
                local tID = tonumber(t[2])
                if (tID > 0 and tID < 17) then
                    if (tID ~= PlayerIndex) then
                        if player_present(tID) then
                        
                            local function notPreviousRequest()
                                for k,v in pairs(tracker) do
                                    if tracker ~= nil then
                                        local eID = tonumber(get_var(PlayerIndex, "$n"))
                                        local prev_eID = tonumber(tracker[k]["rID"])
                                        if (eID == prev_eID) then 
                                            local prev_tID = tonumber(tracker[k]["tID"])
                                            if (tID == prev_tID) then
                                                return false
                                            end
                                        end
                                    end
                                end
                                return true
                            end
                            
                            if notPreviousRequest() then
                                rprint(tID, get_var(PlayerIndex, "$name") .. " is requesting a truce with you.")
                                rprint(tID, "To accept, type /accept")
                                rprint(tID, "To deny this request, type /deny")

                                local rName = get_var(PlayerIndex, "$name")
                                local rID = get_var(PlayerIndex, "$n")
                                table.insert(tracker, {["rName"] = rName, ["rID"] = rID, ["tID"] = tID})
                                
                                rprint(PlayerIndex, "Request sent to " .. get_var(tID, "$name"))
                                wait_for_response[tID].requests = wait_for_response[tID].requests + 1
                            else
                                rprint(PlayerIndex, "You have already sent this player a request!")
                            end
                        else
                            rprint(PlayerIndex, "Error. Player not online")
                        end
                    else
                        rprint(PlayerIndex, "You cannot truce with yourself")
                    end
                else
                    rprint(PlayerIndex, "Error. Please enter a number between 1-16")
                end
            else
                rprint(PlayerIndex, "Error. Invalid player id")
            end
        else
            rprint(PlayerIndex, "Invalid syntax. Usage: /truce [player id]")
        end
        return false
    end
    
    if (command == "trucelist") then
        local id = tonumber(get_var(PlayerIndex, "$n"))
        for k, _ in ipairs(tracker) do
            if tracker ~= nil then
                if (id == tonumber(tracker[k]["tID"])) then
                    local names = tostring(tracker[k]["rName"])
                    local index = tonumber(tracker[k]["rID"])
                    rprint(PlayerIndex, "[" .. index .. "] " .. names)
                else
                    rprint(PlayerIndex, "You have no pending truce requests")
                    break
                end
            end
        end
        return false
    end
    
    local proceed
    for key, _ in ipairs(tracker) do
        if tracker ~= nil then
            if (command == "accept") then
                if (wait_for_response[PlayerIndex].requests > 0) then
                    if (t[2] ~= nil) then
                        local tID = tonumber(t[2])
                        if (t[2]:match("%d+")) then
                            if (tID > 0 and tID < 17) then
                                if player_present(tID) then
                                    if (tID == tonumber(tracker[key]["rID"])) then
                                        local rName = tostring(tracker[key]["rName"])
                                        truce[tID] = truce[tID] or {}
                                        truce[tID][#truce[tID]+1] = PlayerIndex
                                        
                                        truce[PlayerIndex] = truce[PlayerIndex] or {}
                                        truce[PlayerIndex][#truce[PlayerIndex]+1] = tID
                                        
                                        rprint(PlayerIndex, "You are now in a truce with " .. rName)
                                        rprint(tID, "[request accepted] You are now in a truce with " .. get_var(PlayerIndex, "$name"))
                                        
                                        proceed = true
                                        wait_for_response[PlayerIndex].requests = wait_for_response[PlayerIndex].requests - 1
                                    end
                                else
                                    rprint(PlayerIndex, "Error. Player not online")
                                end
                            else
                                rprint(PlayerIndex, "Error. Please enter a number between 1-16")
                            end
                        else
                            rprint(PlayerIndex, "Error. Invalid player id")
                        end
                    else
                        rprint(PlayerIndex, "Invalid syntax. Usage: /accept [player id]")
                    end
                else
                    rprint(PlayerIndex, "You don't have any pending truce requests")
                end
                return false
            elseif (command == "deny") then
                if (wait_for_response[PlayerIndex].requests > 0) then
                    if (t[2] ~= nil) then
                        local tID = tonumber(t[2])
                        if (t[2]:match("%d+")) then
                            if (tID > 0 and tID < 17) then
                                if player_present(tID) then
                                    if (tID == tonumber(tracker[key]["rID"])) then
                                        local rName = tostring(tracker[key]["rName"])
                                        rprint(PlayerIndex, "You denied " .. rName .. "'s truce request")
                                        rprint(tID, get_var(PlayerIndex, "$name") .. " denied your truce request")
                                        proceed = true
                                        tracker[_] = nil 
                                        wait_for_response[PlayerIndex].requests = wait_for_response[PlayerIndex].requests - 1
                                    end
                                else
                                    rprint(PlayerIndex, "Error. Player not online")
                                end
                            else
                                rprint(PlayerIndex, "Error. Please enter a number between 1-16")
                            end
                        else
                            rprint(PlayerIndex, "Error. Invalid player id")
                        end
                    else
                        rprint(PlayerIndex, "Invalid syntax. Usage: /accept [player id]")
                    end
                else
                    rprint(PlayerIndex, "You don't have any pending truce requests")
                end
                break
            end
            return false
        end
        if not (proceed) and (command ~= "trucelist") then
            for key, _ in ipairs(tracker) do
                if (tonumber(tracker[key]["tID"]) == tonumber(PlayerIndex)) then
                    rprint(PlayerIndex, "[truce] That is not a valid response, please try again.")
                    rprint(PlayerIndex, "[truce] Type /accept or /deny [you] - > " .. tostring(tracker[key]["rName"]))
                end
            end
        end
    end
end                                         
   
function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
        if truce[CauserIndex] ~= nil then
            if (truce[CauserIndex][1] == tonumber(PlayerIndex)) then
                return false
            end
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    wait_for_response[PlayerIndex] = {}
    wait_for_response[PlayerIndex].requests = 0
end

function OnPlayerLeave(PlayerIndex)
    if truce[PlayerIndex] ~= nil then
        local id = tonumber(get_var(PlayerIndex, "$n"))
        local target
        for key, _ in ipairs(tracker) do
            if tracker ~= nil then
                local rID = tonumber(tracker[key]["rID"])
                local tID = tonumber(tracker[key]["tID"])
                if (id == rID) then
                    rprint(tID, "Your truce with " .. get_var(PlayerIndex, "$name") .. " has ended.")
                elseif (id == tID) then
                    rprint(rID, "Your truce with " .. get_var(PlayerIndex, "$name") .. " has ended.")
                end
            end
        end
    end
    wait_for_response[PlayerIndex].requests = 0
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
