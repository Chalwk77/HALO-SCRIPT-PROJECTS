--[[
--=====================================================================================================--
Script Name: Truce, for SAPP (PC & CE)
Description: N/A

Command Syntax: 
    * /truce [player id]
    * /accept [player id]
    * /deny [player id]
    * /untruce [player id]
    * /trucelist
    
    [!] WARNING: This mod is in development and does not represent the finished product.

Copyright (c) 2016-2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

api_version = "1.12.0.0"
-- configuration [starts] -->

-- Minimum privilege level required to execute /truce command. Set to -1 (negative one) for all players
local privilege_level = -1

local base_command = "truce"
local accept_command = "accept"
local deny_command = "deny"

-- # Message Configuration:
local on_request = {
    msgToTarget = {
        "%executor_name% is requesting a truce with you.",
        "To accept, type /accept %executor_id%",
        "To deny this request, type /deny %executor_id%"
    },
    msgToExecutor = { "Request sent to %target_name%" }
}

local on_accept = {
    msgToExecutor = { "You are now in a truce with %target_name%" },
    msgToTarget = { "[request accepted] You are now in a truce with %executor_name%" }
}

local on_deny = {
    msgToTarget = { "%executor_name% denied your truce request" },
    msgToExecutor = { "You denied %target_name%'s truce request" }
}

-- configuration [ends] <--

local truce = { }
local requests = { }
local members = { }
local tracker = { }
local pending = { }
local gsub = string.gsub

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerDisconnect")
end

function OnScriptUnload()

end

function OnPlayerConnect(PlayerIndex)
    requests[PlayerIndex] = 0
end

function OnPlayerDisconnect(PlayerIndex)
    requests[PlayerIndex] = 0
    if tracker[PlayerIndex] ~= nil then
        if next(members) ~= nil then
        
            local name = get_var(PlayerIndex, "$name")
            local id = tonumber(get_var(PlayerIndex, "$n"))
            
            for key, _ in ipairs(members) do
            
                local tn = members[key]["tn"]
                local tid = tonumber(members[key]["tid"])
                
                local en = members[key]["en"]
                local eid = tonumber(members[key]["eid"])

                if (name == tn) and (id == tid) then
                    rprint(eid, "Your truce with " .. get_var(PlayerIndex, "$name") .. " has ended.")
                    members[key] = nil
                elseif (name == en) and (id == eid) then
                    rprint(tid, "Your truce with " .. get_var(PlayerIndex, "$name") .. " has ended.")
                    members[key] = nil
                end
            end
        end
    end
end

local function checkAccess(PlayerIndex)
    if (PlayerIndex ~= -1 and PlayerIndex >= 1 and PlayerIndex < 16) then
        if (tonumber(get_var(PlayerIndex, "$lvl"))) >= privilege_level then
            return true
        else
            rprint(PlayerIndex, "Command failed. Insufficient Permission.")
            return false
        end
    else
        cprint("You cannot execute this command from the console.", 4+8)
        return false
    end
end

local function isOnline(TargetID, executor)
    if (TargetID > 0 and TargetID < 17) then
        if player_present(TargetID) then
            return true
        else
            rprint(executor, "Command failed. Player not online.")
            return false
        end
    else
        rprint(executor, "Invalid player id. Please enter a number between 1-16")
    end
end

local function cmdself(t, e)
    if tonumber(t) == tonumber(e) then
        rprint(e, "You cannot execute this command on yourself.")
        return true
    end
end

local function hasRequest(PlayerIndex, id)
    if tonumber(requests[PlayerIndex]) > 0 then
        return tonumber(requests[PlayerIndex])
    else
        rprint(PlayerIndex, "You do not have any pending truce requests to " .. id)
    end
end

function truce:isPending(TargetID, executor)
    local name = get_var(executor, "$name")
    local id = tonumber(get_var(executor, "$n"))
    local TargetName = get_var(TargetID, "$name")
    
    for key, _ in ipairs(pending) do
        local tn = pending[key]["tn"]
        local tid = tonumber(pending[key]["tid"])
        local en = pending[key]["en"]
        local eid = tonumber(pending[key]["eid"])
        if (name == en) and (id == eid) then
            if tn == TargetName and tid == TargetID then
                rprint(executor, "You have already sent this player a request!")
                return true
            end
        else
            return false
        end
    end
end

function truce:inTruce(TargetID, executor)
    if tracker[executor] ~= nil then
        for i = 1, #tracker[executor] do
            if (tracker[executor][i] == tonumber(TargetID)) then
                rprint(executor, "You are already in a truce with this player.")
                return true
            end
        end
    end
    return false
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)

    local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)
    local TargetID = tonumber(args[1])

    if (command == string.lower(base_command) and checkAccess(executor)) then
        if args[1] ~= nil then
            if isOnline(TargetID, executor) then
                if not cmdself(TargetID, executor) then
                    if not truce:isPending(TargetID, executor) then
                        if not truce:inTruce(TargetID, executor) then 
                            local players = {}
                            players.en = get_var(executor, "$name")
                            players.eid = tonumber(get_var(executor, "$n"))
                            players.tn = get_var(TargetID, "$name")
                            players.tid = tonumber(get_var(TargetID, "$n"))
                            truce:sendrequest(players)
                        end
                    end
                end
            end
        else
            rprint(executor, "Invalid syntax. Usage: /truce [player id]")
        end
        return false
    elseif (command == string.lower(accept_command) and checkAccess(executor)) then
        if args[1] ~= nil then
            if hasRequest(executor, "accept") then
                if isOnline(TargetID, executor) then
                    if not cmdself(TargetID, executor) then
                        local players = {}
                        players.en = get_var(executor, "$name")
                        players.eid = tonumber(get_var(executor, "$n"))
                        players.tn = get_var(TargetID, "$name")
                        players.tid = tonumber(get_var(TargetID, "$n"))
                        truce:enable(players)
                    end
                end
            end
        else
            rprint(executor, "Invalid syntax. Usage: /accept [player id]")
        end
        return false
    elseif (command == string.lower(deny_command) and checkAccess(executor)) then
        if args[1] ~= nil then
            if hasRequest(executor, "deny") then
                if isOnline(TargetID, executor) then
                    if not cmdself(TargetID, executor) then
                        local players = {}
                        players.en = get_var(executor, "$name")
                        players.eid = tonumber(get_var(executor, "$n"))
                        players.tn = get_var(TargetID, "$name")
                        players.tid = tonumber(get_var(TargetID, "$n"))
                        truce:deny(players)
                    end
                end
            end
        else
            rprint(executor, "Invalid syntax. Usage: /deny [player id]")
        end
        return false
    end

end

function truce:sendrequest(params)
    local params = params or {}

    local executor_name = params.en or nil
    local executor_id = params.eid or nil

    local target_name = params.tn or nil
    local target_id = params.tid or nil

    local msgToExecutor, msgToTarget = on_request.msgToExecutor, on_request.msgToTarget
    for k, _ in pairs(msgToExecutor) do
        local StringFormat = gsub(msgToExecutor[k], "%%target_name%%", target_name)
        rprint(executor_id, StringFormat)
    end
    for k, _ in pairs(msgToTarget) do
        local StringFormat = (gsub(gsub(msgToTarget[k], "%%executor_name%%", executor_name), "%%executor_id%%", executor_id))
        rprint(target_id, StringFormat)
    end
    
    table.insert(pending, {["en"] = executor_name, ["eid"] = executor_id, ["tn"] = target_name, ["tid"] = target_id})
    requests[target_id] = requests[target_id] + 1
end

function truce:enable(params)
    local params = params or {}

    local executor_name = params.en or nil
    local executor_id = params.eid or nil

    local target_name = params.tn or nil
    local target_id = params.tid or nil
    
    table.insert(members, {["en"] = executor_name, ["eid"] = executor_id, ["tn"] = target_name, ["tid"] = target_id})
    tracker[executor_id] = tracker[executor_id] or {}
    tracker[executor_id][#tracker[executor_id] + 1] = target_id
    
    tracker[target_id] = tracker[target_id] or {}
    tracker[target_id][#tracker[target_id] + 1] = executor_id
    
    local msgToExecutor, msgToTarget = on_accept.msgToExecutor, on_accept.msgToTarget
    for k, _ in pairs(msgToExecutor) do
        local StringFormat = gsub(msgToExecutor[k], "%%target_name%%", target_name)
        rprint(executor_id, StringFormat)
    end
    for k, _ in pairs(msgToTarget) do
        local StringFormat = gsub(msgToTarget[k], "%%executor_name%%", executor_name)
        rprint(target_id, StringFormat)
    end
    
    for key, _ in ipairs(pending) do
        local en = pending[key]["tn"]
        local eid = tonumber(pending[key]["tid"])
        
        local tn = pending[key]["en"]
        local tid = tonumber(pending[key]["eid"])

        if (target_name == tn) and (target_id == tid) then
            if (executor_name == en) and (executor_id == eid) then
                pending[key] = nil
            end
            return true
        end
    end
   
    requests[executor_id] = requests[executor_id] - 1
end

function truce:disable(params)
    local params = params or {}
end

function truce:deny(params)
    local params = params or {}

    local executor_name = params.en or nil
    local executor_id = params.eid or nil

    local target_name = params.tn or nil
    local target_id = params.tid or nil
    
    for key, _ in ipairs(pending) do
        local en = pending[key]["tn"]
        local eid = tonumber(pending[key]["tid"])
        
        local tn = pending[key]["en"]
        local tid = tonumber(pending[key]["eid"])

        if (target_name == tn) and (target_id == tid) then
            if (executor_name == en) and (executor_id == eid) then
                pending[key] = nil
                local msgToExecutor, msgToTarget = on_deny.msgToExecutor, on_deny.msgToTarget
                for k, _ in pairs(msgToExecutor) do
                    local StringFormat = gsub(msgToExecutor[k], "%%target_name%%", target_name)
                    rprint(executor_id, StringFormat)
                end
                for k, _ in pairs(msgToTarget) do
                    local StringFormat = gsub(msgToTarget[k], "%%executor_name%%", executor_name)
                    rprint(target_id, StringFormat)
                end
            end
        end
    end
end

function truce:list(params)
    local params = params or {}
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
        if tracker[CauserIndex] ~= nil then
            for i = 1, #tracker[CauserIndex] do
                if (tracker[CauserIndex][i] == tonumber(PlayerIndex)) then
                
                    --local cid, cn = get_var(CauserIndex, "$n"), get_var(CauserIndex, "$name")
                    --local pid, pn = get_var(PlayerIndex, "$n"), get_var(PlayerIndex, "$name")
                
                    --cprint("TRUCE BETWEEN: [".. cid .."] " .. cn .. " -> [".. pid .."] " .. pn)
                    return false
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
