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
local truce = {}
local wait_for_response = {}
local tracker = { }
local proceed = { }

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
end

function OnScriptUnload()
    
end

function OnServerCommand(PlayerIndex, Command)
    proceed[PlayerIndex] = nil
    local t = tokenizestring(Command)
    if t[1] == nil then
        return nil
    end
    local command = t[1]:gsub("\\", "/")
    local tID = { }
    local function validate_syntax(truce, accept, deny, untruce)
        if (t[2] ~= nil) then
            if (t[2]:match("%d+")) then
                local pID = tonumber(t[2])
                if (pID > 0 and pID < 17) then
                    if (pID ~= PlayerIndex) then
                        if player_present(pID) then
                            tID[PlayerIndex] = pID
                            return true
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
            if truce then
                rprint(PlayerIndex, "Invalid syntax. Usage: /truce [player id]")
            elseif accept then
                rprint(PlayerIndex, "Invalid syntax. Usage: /accept [player id]")
            elseif deny then
                rprint(PlayerIndex, "Invalid syntax. Usage: /deny [player id]")
            elseif untruce then
                rprint(PlayerIndex, "Invalid syntax. Usage: /untruce [player id]")
            end
        end
        return false
    end
    
    if (command == "truce") then
        local function notPreviousRequest()
            for k,v in pairs(tracker) do
                if tracker ~= nil then
                    local eID = tonumber(get_var(PlayerIndex, "$n"))
                    local prev_eID = tonumber(tracker[k]["rID"])
                    if (eID == prev_eID) then 
                        local prev_tID = tonumber(tracker[k]["tID"])
                        if (tID[PlayerIndex] == prev_tID) then
                            return false
                        end
                    end
                end
            end
            return true
        end
        if validate_syntax(true, false, false, false) then 
            if notPreviousRequest() then
                local TargetID = tID[PlayerIndex]
                rprint(TargetID, get_var(PlayerIndex, "$name") .. " is requesting a truce with you.")
                rprint(TargetID, "To accept, type /accept " .. get_var(PlayerIndex, "$n"))
                rprint(TargetID, "To deny this request, type /deny " .. get_var(PlayerIndex, "$n"))

                local rName = get_var(PlayerIndex, "$name")
                local tName = get_var(TargetID, "$name")
                local rID = get_var(PlayerIndex, "$n")
                table.insert(tracker, {["rName"] = rName, ["tName"] = tName, ["rID"] = rID, ["tID"] = TargetID, count})
                
                rprint(PlayerIndex, "Request sent to " .. get_var(TargetID, "$name"))
                wait_for_response[TargetID].requests = wait_for_response[TargetID].requests + 1
            else
                rprint(PlayerIndex, "You have already sent this player a request!")
            end
        end
        return false
    elseif (command == "accept") then
        if (wait_for_response[PlayerIndex].requests > 0) then
            if validate_syntax(false, true, false, false) then
                for key, _ in ipairs(tracker) do
                    if tracker ~= nil then
                        local TargetID = tID[PlayerIndex]
                        if (TargetID == tonumber(tracker[key]["rID"])) then
                            local rName = tostring(tracker[key]["rName"])
                            truce[TargetID] = truce[TargetID] or {}
                            truce[TargetID][#truce[TargetID]+1] = PlayerIndex
                            
                            truce[PlayerIndex] = truce[PlayerIndex] or {}
                            truce[PlayerIndex][#truce[PlayerIndex]+1] = TargetID
                            
                            rprint(PlayerIndex, "You are now in a truce with " .. rName)
                            rprint(TargetID, "[request accepted] You are now in a truce with " .. get_var(PlayerIndex, "$name"))
                            
                            proceed[PlayerIndex] = true
                            wait_for_response[PlayerIndex].requests = wait_for_response[PlayerIndex].requests - 1
                            break
                        end
                    end
                end
            end
        else
            rprint(PlayerIndex, "You don't have any pending truce requests")
        end
        return false
    elseif (command == "deny") then
        if (wait_for_response[PlayerIndex].requests > 0) then
            if validate_syntax(false, false, true, false) then
                for key, _ in ipairs(tracker) do
                    if tracker ~= nil then
                        local TargetID = tID[PlayerIndex]
                        if (TargetID == tonumber(tracker[key]["rID"])) then
                            local rName = tostring(tracker[key]["rName"])
                            rprint(PlayerIndex, "You denied " .. rName .. "'s truce request")
                            rprint(TargetID, get_var(PlayerIndex, "$name") .. " denied your truce request")
                            proceed[PlayerIndex] = true
                            tracker[_] = nil
                            wait_for_response[PlayerIndex].requests = wait_for_response[PlayerIndex].requests - 1
                            break
                        end
                    end
                end
            end
        else
            rprint(PlayerIndex, "You don't have any pending truce requests")
        end
        return false
    elseif (command == "untruce") then
        if validate_syntax(false, false, false, true) then 
            local proceed
            local TargetID = tonumber(tID[PlayerIndex])
            
            local function removeTruce()
                if truce[PlayerIndex] ~= nil and truce[TargetID] ~= nil then
                    for k,_ in pairs(truce[PlayerIndex]) do
                        if truce[PlayerIndex][k] == TargetID then
                            truce[PlayerIndex][k] = nil
                        end
                    end             
                    for k,_ in pairs(truce[TargetID]) do
                        if truce[TargetID][k] == PlayerIndex then
                            truce[TargetID][k] = nil
                        end
                    end
                    rprint(TargetID, "Your truce with " .. get_var(PlayerIndex, "$name") .. " has ended.")
                    rprint(PlayerIndex, "Your truce with " .. get_var(TargetID, "$name") .. " has ended.")
                end
            end
            for k, _ in ipairs(tracker) do
                if tracker ~= nil then
                    local tID = tonumber(tracker[k]["tID"])
                    if (TargetID == tID) then
                        local rName = tracker[k]["rName"]
                        local tName = tracker[k]["tName"]
                        if (get_var(PlayerIndex, "$name") == rName and get_var(TargetID, "$name") == tName) then
                            tracker[_] = nil
                            removeTruce()
                            break
                        end
                        
                        if (get_var(PlayerIndex, "$name") == tName and get_var(tID, "$name") == rName) then
                            tracker[_] = nil
                            removeTruce()
                            break
                        end
                    else
                        rprint(PlayerIndex, "You are not in a truce with " .. get_var(TargetID, "$name"))
                    end
                else
                    error('something went wrong')
                end
            end
        end
        return false
    elseif (command == "trucelist") then
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
    
    if (command == "accept" or command == "deny") then
        if not (proceed[PlayerIndex]) then
            for key, _ in ipairs(tracker) do
                if (tonumber(tracker[key]["tID"]) == tonumber(PlayerIndex)) then
                    rprint(PlayerIndex, "[truce] That is not a valid response, please try again.")
                    rprint(PlayerIndex, "[truce] Type /accept or /deny [you] - > " .. tostring(tracker[key]["rName"]))
                    break
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
