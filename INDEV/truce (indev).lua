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
    msgToTarget = { "You denied %target_name%'s truce request" },
    msgToExecutor = { "%executor_name% denied your truce request" }
}

-- configuration [ends] <--

local truce = { }
local requests = { }
local members = { }
local tru = { }
local gsub = string.gsub

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
end

function OnScriptUnload()

end

function OnPlayerConnect(PlayerIndex)
    requests[PlayerIndex] = 0
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

local function hasRequest(PlayerIndex)
    if tonumber(requests[PlayerIndex]) > 0 then
        return tonumber(requests[PlayerIndex])
    else
        rprint(PlayerIndex, "You don't have any pending truce requests")
    end
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)

    local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)
    local TargetID = tonumber(args[1])

    if (command == string.lower(base_command) and checkAccess(executor)) then
        if args[1] ~= nil then
            if isOnline(TargetID, executor) then
                if not cmdself(TargetID, executor) then
                    local players = {}
                    players.en = get_var(executor, "$name")
                    players.eid = tonumber(get_var(executor, "$n"))
                    players.tn = get_var(TargetID, "$name")
                    players.tid = tonumber(get_var(TargetID, "$n"))
                    truce:sendrequest(players)
                end
            end
        else
            rprint(executor, "Invalid syntax. Usage: /truce [player id]")
        end
        return false
    elseif (command == string.lower(accept_command) and checkAccess(executor)) then
        if args[1] ~= nil then
            if hasRequest(executor) then
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
            if isOnline(TargetID, executor) then
                if not cmdself(TargetID, executor) then
                    -- deny logic
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
    
    requests[target_id] = requests[target_id] + 1
end

function truce:enable(params)
    local params = params or {}

    local executor_name = params.en or nil
    local executor_id = params.eid or nil

    local target_name = params.tn or nil
    local target_id = params.tid or nil
    
    table.insert(members, {["en"] = executor_name, ["eid"] = executor_id, ["tn"] = target_name, ["tid"] = target_id})
    tru[executor_id] = tru[executor_id] or {}
    tru[executor_id][#tru[executor_id] + 1] = target_id
    
    tru[target_id] = tru[target_id] or {}
    tru[target_id][#tru[target_id] + 1] = executor_id
    
    local msgToExecutor, msgToTarget = on_accept.msgToExecutor, on_accept.msgToTarget
    
    for k, _ in pairs(msgToExecutor) do
        local StringFormat = gsub(msgToExecutor[k], "%%target_name%%", target_name)
        rprint(executor_id, StringFormat)
    end
    for k, _ in pairs(msgToTarget) do
        local StringFormat = gsub(msgToTarget[k], "%%executor_name%%", executor_name)
        rprint(target_id, StringFormat)
    end
    
    requests[executor_id] = requests[executor_id] - 1
end

function truce:disable(params)
    local params = params or {}
end

function truce:list(params)
    local params = params or {}
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
        if tru[CauserIndex] ~= nil then
            for i = 1, #tru[CauserIndex] do
                if (tru[CauserIndex][i] == tonumber(PlayerIndex)) then
                
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
