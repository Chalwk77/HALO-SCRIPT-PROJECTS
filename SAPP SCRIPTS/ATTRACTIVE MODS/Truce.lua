--[[
--=====================================================================================================--
Script Name: Truce, for SAPP (PC & CE)
Description: Initiate a truce with other players.
             While in a truce with someone, neither player can harm one another.

Command Syntax: 
    * /truce [player id]
    * /accept [player id]
    * /deny [player id]
    * /untruce [player id]
    * /trucelist

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
local untruce_command = "untruce"
local trucelist_command = "trucelist"

-- If enabled, truce data will be saved when the map cycles.
local save_on_newgame = true

-- # Message Configuration:
local on_request = {
    {["msgToExecutor"] = {"Request sent to %target_name%"}},
    {["msgToTarget"] = {
        "%executor_name% is requesting a truce with you.",
        "To accept, type /accept %executor_id%",
        "To deny this request, type /deny %executor_id%"
    }},
}

local on_accept = {
    {["msgToExecutor"] = {"You are now in a truce with %target_name%"}},
    {["msgToTarget"] = {"[request accepted] You are now in a truce with %executor_name%"}},
}

local on_deny = {
    {["msgToExecutor"] = {"You denied %target_name%'s truce request"}},
    {["msgToTarget"] = {"%executor_name% denied your truce request"}},
}

-- configuration [ends] <--

local truce = { }
local requests = { }
local members = { }
local tracker = { }
local pending = { }
local lower, gsub = string.lower, string.gsub

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerDisconnect")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
end

local function clearData()
    if not (save_on_newgame) then
        for i = 1, 16 do
            if player_present(i) then
                if (tracker[i] ~= nil) then
                    for key, _ in pairs(tracker[i]) do
                        tracker[i][key] = nil
                    end
                end
            end
        end
        if (next(members) ~= nil) then
            for key, _ in ipairs(members) do
                for i = 1, #members do
                    members[i] = nil
                end
            end
        end
        if (next(pending) ~= nil) then
            for key, _ in ipairs(pending) do
                for i = 1, #pending do
                    pending[i] = nil
                end
            end
        end
    end
end

function OnScriptUnload()
    clearData()
end

function OnGameEnd()
    clearData()
end

function OnPlayerDisconnect(PlayerIndex)
    requests[PlayerIndex] = 0
    local name = get_var(PlayerIndex, "$name")
    local id = tonumber(get_var(PlayerIndex, "$n"))
    if (next(members) ~= nil) and (tracker[PlayerIndex] ~= nil) then
    
        local function removeTracker(a, b)
            for key, _ in pairs(tracker[a]) do
                if tracker[a][key] == b then
                    tracker[a][key] = nil
                end
            end
            for key, _ in pairs(tracker[b]) do
                if tracker[b][key] == a then
                    tracker[b][key] = nil
                end
            end
        end

        for key, _ in ipairs(members) do
            local tn = members[key]["tn"]
            local tid = tonumber(members[key]["tid"])
            local en = members[key]["en"]
            local eid = tonumber(members[key]["eid"])
            if (name == tn) and (id == tid) then
                rprint(eid, "Your truce with " .. name .. " has ended.")
                removeTracker(eid, tid)
                members[key] = nil
            elseif (name == en) and (id == eid) then
                rprint(tid, "Your truce with " .. name .. " has ended.")
                removeTracker(tid, eid)
                members[key] = nil
            end
        end
    end
    
    if (next(pending) ~= nil) then
        for key, _ in ipairs(pending) do

            local tn = pending[key]["tn"]
            local tid = tonumber(pending[key]["tid"])

            local en = pending[key]["en"]
            local eid = tonumber(pending[key]["eid"])

            if (name == tn) and (id == tid) then
                pending[key] = nil
                rprint(eid, "Your truce request with " .. name .. " expired")
            elseif (name == en) and (id == eid) then
                pending[key] = nil
                rprint(tid, "Your truce request with " .. name .. " expired")
            end
        end
    end
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

local function hasRequest(e, id)
    if requests[e] ~= nil then
        if tonumber(requests[e]) > 0 then
            return tonumber(requests[e])
        else
            rprint(e, "You do not have any pending truce requests to " .. id)
        end
    else
        rprint(e, "You do not have any pending truce requests to " .. id)
    end
end

local function sameTeam(t, e)
    if not getTeamPlay() then
        return false
    elseif get_var(e, "$team") == get_var(t, "$team") then
        rprint(e, "You cannot initiate a truce with someone on the same team!")
        return true
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

function truce:inTruce(TargetID, executor, bool)
    local found, intruce
    if tracker[executor] ~= nil then
        intruce = true
        for i = 1, #tracker[executor] do
            if (tracker[executor][i] == tonumber(TargetID)) then
                if not (bool) then
                    rprint(executor, "You are already in a truce with this player.")
                end
                found = true
                return true
            end
        end
    end
    if not (found) then 
        if (intruce) then
            rprint(executor, "You are not in a truce with that player")
        else 
            rprint(executor, "You are not in a truce with anybody")
        end
        return false
    end
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)

    local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)
    local TargetID = tonumber(args[1])

    local players = {}
    local function set_info(param)
        players.en = get_var(executor, "$name")
        players.eid = tonumber(get_var(executor, "$n"))
        if (param) then
            if args[1]:match("%d+") and not args[1]:match('[A-Za-z]') then
                players.tn = get_var(TargetID, "$name")
                players.tid = tonumber(get_var(TargetID, "$n"))
            else
                rprint(executor, "Invalid command parameter.")
                return false
            end
        end
    end

    if (command == lower(base_command) and checkAccess(executor)) then
        if args[1] ~= nil then
            set_info(true)
            if isOnline(TargetID, executor) then
                if not cmdself(TargetID, executor) then
                    if not sameTeam(TargetID, executor) then
                        if not truce:isPending(TargetID, executor) then
                            if not truce:inTruce(TargetID, executor, false) then
                                truce:sendrequest(players)
                            end
                        end
                    end
                end
            end
        else
            rprint(executor, "Invalid syntax. Usage: /truce [player id]")
        end
        return false
    elseif (command == lower(accept_command) and checkAccess(executor)) then
        if args[1] ~= nil then
            set_info(true)
            if hasRequest(executor, "accept") then
                if isOnline(TargetID, executor) then
                    if not cmdself(TargetID, executor) then
                        truce:enable(players)
                    end
                end
            end
        else
            rprint(executor, "Invalid syntax. Usage: /accept [player id]")
        end
        return false
    elseif (command == lower(deny_command) and checkAccess(executor)) then
        if args[1] ~= nil then
            set_info(true)
            if hasRequest(executor, "deny") then
                if isOnline(TargetID, executor) then
                    if not cmdself(TargetID, executor) then
                        truce:deny(players)
                    end
                end
            end
        else
            rprint(executor, "Invalid syntax. Usage: /deny [player id]")
        end
        return false
    elseif (command == lower(untruce_command) and checkAccess(executor)) then
        if args[1] ~= nil then
            set_info(true)
            if isOnline(TargetID, executor) then
                if not cmdself(TargetID, executor) then
                    if truce:inTruce(TargetID, executor, true) then
                        truce:disable(players)
                    end
                end
            end
        else
            rprint(executor, "Invalid syntax. Usage: /untruce [player id]")
        end
        return false
    elseif (command == lower(trucelist_command) and checkAccess(executor)) then
        if args[1] == nil then
            set_info(false)
            truce:list(players)
        else
            rprint(executor, "Invalid syntax. Usage: /trucelist")
        end
        return false
    end
    players = nil
end

function truce:sendrequest(params)
    local params = params or {}

    local executor_name = params.en or nil
    local executor_id = params.eid or nil

    local target_name = params.tn or nil
    local target_id = params.tid or nil

    for k, _ in ipairs(on_request) do
        local msgToExecutor, msgToTarget = on_request[k]["msgToExecutor"], on_request[k]["msgToTarget"]
        if (msgToExecutor ~= nil) then
            for i = 1,#msgToExecutor do
                local StringFormat = gsub(msgToExecutor[i], "%%target_name%%", target_name)
                rprint(executor_id, StringFormat)
            end
        end
        if (msgToTarget ~= nil) then
            for i = 1,#msgToTarget do
                local StringFormat = (gsub(gsub(msgToTarget[i], "%%executor_name%%", executor_name), "%%executor_id%%", executor_id))
                rprint(target_id, StringFormat)
            end
        end
    end

    table.insert(pending, { ["en"] = executor_name, ["eid"] = executor_id, ["tn"] = target_name, ["tid"] = target_id })

    if requests[target_id] == nil then
        requests[target_id] = 0
    end
    requests[target_id] = requests[target_id] + 1
end

function truce:enable(params)
    local params = params or {}

    local executor_name = params.en or nil
    local executor_id = params.eid or nil

    local target_name = params.tn or nil
    local target_id = params.tid or nil

    table.insert(members, { ["en"] = executor_name, ["eid"] = executor_id, ["tn"] = target_name, ["tid"] = target_id })
    tracker[executor_id] = tracker[executor_id] or {}
    tracker[executor_id][#tracker[executor_id] + 1] = target_id

    tracker[target_id] = tracker[target_id] or {}
    tracker[target_id][#tracker[target_id] + 1] = executor_id
    
    for k, _ in ipairs(on_accept) do
        local msgToExecutor, msgToTarget = on_accept[k]["msgToExecutor"], on_accept[k]["msgToTarget"]
        if (msgToExecutor ~= nil) then
            for i = 1,#msgToExecutor do
                local StringFormat = gsub(msgToExecutor[i], "%%target_name%%", target_name)
                rprint(executor_id, StringFormat)
            end
        end
        if (msgToTarget ~= nil) then
            for i = 1,#msgToTarget do
                local StringFormat = gsub(msgToTarget[i], "%%executor_name%%", executor_name)
                rprint(target_id, StringFormat)
            end
        end
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

    local executor_name = params.en or nil
    local executor_id = params.eid or nil

    local target_name = params.tn or nil
    local target_id = params.tid or nil

    if (next(members) ~= nil) and (tracker[executor_id] ~= nil) then
        for key, _ in ipairs(members) do
            local tn = members[key]["tn"]
            local tid = tonumber(members[key]["tid"])
            local en = members[key]["en"]
            local eid = tonumber(members[key]["eid"])
            if (executor_name == en) and (executor_id == eid) then
                if (target_name == tn) and (target_id == tid) then
                    rprint(eid, "Your truce with " .. tn .. " has ended.")
                    rprint(tid, "Your truce with " .. en .. " has ended.")
                    members[key] = nil
                end
            elseif (executor_name == tn) and (executor_id == tid) then
                if (target_name == en) and (target_id == eid) then
                    rprint(tid, "Your truce with " .. en .. " has ended.")
                    rprint(eid, "Your truce with " .. tn .. " has ended.")
                    members[key] = nil
                end
            end
        end
        for key, _ in pairs(tracker[executor_id]) do
            if tracker[executor_id][key] == target_id then
                tracker[executor_id][key] = nil
            end
        end
        for key, _ in pairs(tracker[target_id]) do
            if tracker[target_id][key] == executor_id then
                tracker[target_id][key] = nil
            end
        end
    end
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
                for k, _ in ipairs(on_deny) do
                    local msgToExecutor, msgToTarget = on_deny[k]["msgToExecutor"], on_deny[k]["msgToTarget"]
                    if (msgToExecutor ~= nil) then
                        for i = 1,#msgToExecutor do
                            local StringFormat = gsub(msgToExecutor[i], "%%target_name%%", target_name)
                            rprint(executor_id, StringFormat)
                        end
                    end
                    if (msgToTarget ~= nil) then
                        for i = 1,#msgToTarget do
                            local StringFormat = gsub(msgToTarget[i], "%%executor_name%%", executor_name)
                            rprint(target_id, StringFormat)
                        end
                    end
                end
            end
        end
    end
end

function truce:list(params)
    local params = params or {}

    local executor_name = params.en or nil
    local executor_id = params.eid or nil

    if (next(members) ~= nil) then
        for key, _ in ipairs(members) do

            local tn = members[key]["tn"]
            local tid = tonumber(members[key]["tid"])

            local en = members[key]["en"]
            local eid = tonumber(members[key]["eid"])

            if tracker[executor_id] ~= nil then
                for i = 1, #tracker[executor_id] do
                    if (tracker[executor_id][i] == tonumber(tid)) then
                        rprint(executor_id, "[" .. tid .. "] -> " .. tn .. " (truced)")
                    elseif (tracker[executor_id][i] == tonumber(eid)) then
                        rprint(executor_id, "[" .. eid .. "] -> " .. en .. " (truced)")
                    end
                end
            else
                rprint(executor_id, "You are not truced with anybody")
            end
        end
    else
        rprint(executor_id, "No active truces")
    end

    if (next(pending) ~= nil) then
        for key, _ in ipairs(pending) do

            local tn = pending[key]["tn"]
            local tid = tonumber(pending[key]["tid"])

            local en = pending[key]["en"]
            local eid = tonumber(pending[key]["eid"])

            if (executor_name == tn) and (executor_id == tid) then
                rprint(executor_id, "[" .. eid .. "] -> " .. en .. " (pending request)")
            elseif (executor_name == en) and (executor_id == eid) then
                rprint(executor_id, "[" .. tid .. "] -> " .. tn .. " (pending request)")
            end
        end
    else
        rprint(executor_id, "No pending requests")
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
        if tracker[CauserIndex] ~= nil then
            for i = 1, #tracker[CauserIndex] do
                if (tracker[CauserIndex][i] == tonumber(PlayerIndex)) then
                    return false
                end
            end
        end
    end
end

function getTeamPlay()
    if get_var(0, "$ffa") == "0" then
        return true
    else
        return false
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
