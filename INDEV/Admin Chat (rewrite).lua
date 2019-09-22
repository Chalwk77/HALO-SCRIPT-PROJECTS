--[[
--=====================================================================================================--
Script Name: Admin Chat (v2), for SAPP (PC & CE)
				
Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local adminchat = {
    
    -- ============= Configuration Starts ============= --

    -- Custom Command:
    command = "achat",
    
    -- Minimum permission needed to execute the custom command:
    permission = 1,
    
    -- Minimum permission needed to execute the custom command on others players:
    permission_extra = 4,
    
    -- Messages printed when you enabled/disable Admin Chat:
    messages = {
        [1] = "Admin Chat %state%!",
        [2] = "Admin Chat %state% for %target_name%",
        [3] = "Your Admin Chat was %state% by %executor_name%",
        [4] = "Your Admin Chat is already %state%!",
        [5] = "%target_name%%'s Admin Chat is already %state%!",
    },

    -- ============= Configuration Ends ============= --
}

-- Variables for String Library:
local format = string.format
local sub, gsub = string.sub, string.gsub
local lower, upper = string.lower, string.upper
local match, gmatch = string.match, string.gmatch

-- Variables for Math Library:
local floor, sqrt = math.floor, math.sqrt

-- Game Variables:
local game_over

-- Game Tables: 
local ip_table = { }
local others_cmd_error = { }
-- ...

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    
    if (get_var(0, "$gt") ~= "n/a") then
        game_over = false
        for i = 1,16 do
            if player_present(i) then
                -- ...
            end
        end
    end
end

function OnScriptUnload()
    --
end

function OnGameStart()
    game_over = false
end

function OnGameEnd()
    game_over = true
end

function OnPlayerConnect(p)
    ip_table[p] = get_var(p, '$ip')
    
    local ip = adminchat:GetIP(p)
    --
end

function OnPlayerDisconnect(p)
    local ip = adminchat:GetIP(p)
    
    ip_table[p] = nil
    --
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local command, args = adminchat:StringSplit(Command)
    local executor = tonumber(PlayerIndex)
    
    if (command == nil) then
        return
    end
    command = lower(command) or upper(command)

    if (command == adminchat.command) then
        if not adminchat:isGameOver(executor) then
            if adminchat:checkAccess(executor) then
                if (args[1] ~= nil) then
                
                    local params = adminchat:ValidateCommand(executor, args)
                    
                    if (params ~= nil) and (not params.target_all) and (not params.is_error) then
                        local Target = tonumber(args[2]) or tonumber(executor)                        
                        if adminchat:isOnline(Target, executor) then
                            adminchat:ExecuteCore(params)
                        end
                    end
                else
                    adminchat:Respond(executor, "Invalid Syntax: Usage: /" .. adminchat.command .. " on|off [me | id | */all]", 4 + 8)
                end
            end
        end
        return false
    end
end

function adminchat:ExecuteCore(params)
    local params = params or nil
    if (params ~= nil) then
                
        -- Target Parameters:
        local tid, tip, tn  = params.tid, params.tip, params.tn
        
        -- Executor Parameters:
        local eid, eip, en = params.eid, params.eip, params.en
    
        -- 
        local is_console = adminchat:isConsole(eid)
        if is_console then
            en = "SERVER"
        end

        local is_self = (eid == tid)
        local admin_level = tonumber(get_var(eid, '$lvl'))
                
        local proceed = adminchat:executeOnOthers(eid, is_self, is_console, admin_level)
        
        if (proceed) then
        
            local state = params.state
            adminchat[tip] = adminchat[tip] or nil
                        
            local already_activated = (adminchat[tip] == true)            
            local already_set
            
            if (state == "on") or (state == "1") or (state == "true") then
                state = "enabled"
                if (adminchat[tip] == nil) then
                    adminchat[tip] = true
                else
                    already_set = true
                end
            elseif (state == "off") or (state == "0") or (state == "false") then
                state = "disabled"
                if (adminchat[tip] == already_activated) then
                    adminchat[tip] = nil
                else
                    already_set = true
                end
            end
            
                           
            local messages = adminchat.messages
            local Feedback = function(Message)
                local words = {
                    ["%%state%%"] = state,
                    ["%%executor_name%%"] = en,
                    ["%%target_name%%"]  = tn,
                }
                
                for k,v in pairs(words) do
                    Message = gsub(Message, k, v)
                end
                return Message
            end          
            
            if (not already_set) then 
                if (is_self) then
                    adminchat:Respond(eid, Feedback(messages[1]), 2 + 8)
                else
                    adminchat:Respond(eid, Feedback(messages[2]), 2 + 8)
                    adminchat:Respond(tid, Feedback(messages[3]), 2 + 8)
                end
            else
                if (is_self) then
                    adminchat:Respond(eid, Feedback(messages[4]), 4 + 8)
                else
                    adminchat:Respond(eid, Feedback(messages[5]), 4 + 8)
                end
            end
        end
    end
end

function adminchat:ValidateCommand(executor, args)
    local params = { }
                
    local function getplayers(arg)
        local players = { }
        
        if (arg == nil) or (arg == 'me') then
            table.insert(players, executor)
        elseif (arg:match('%d+')) then
            table.insert(players, tonumber(arg))
        elseif (arg == '*' or arg == 'all') then
            params.target_all = true
            for i = 1, 16 do
                if player_present(i) then
                    table.insert(players, i)
                end
            end
        elseif (arg == 'rand' or arg == 'random') then
            local temp = { }
            for i = 1,16 do
                if player_present(i) then
                    temp[#temp + 1] = i
                end
            end
            table.insert(players, temp[math.random(#temp)])
        else
            adminchat:Respond(executor, "Invalid player id. Usage: [number: 1-16] | */all | me", 4 + 8)
            params.is_error = true
            return false
        end

        for i = 1, #players do
            if (executor ~= tonumber(players[i])) then
                others_cmd_error[executor] = { }
                others_cmd_error[executor] = true
            end
        end
        
        if players[1] then return players end
        return false
    end
    
    
    local pl = getplayers(args[2])
    if (pl) then
        for i = 1, #pl do
        
            if (pl[i] == nil) then
                break
            end

            params.state = args[1]
            params.eid, params.en, params.eip = executor, get_var(executor, '$name'), adminchat:GetIP(executor)
            params.tid, params.tn, params.tip  = tonumber(pl[i]), get_var(pl[i], '$name'), adminchat:GetIP(pl[i])

            if (params.target_all) then
                adminchat:ExecuteCore(params)
            end
        end
    end
    return params
end

function adminchat:isOnline(target, executor)
    if (target > 0 and target < 17) then
        if player_present(target) then
            return true
        else
            adminchat:Respond(executor, "Command Failed. Player not online!", 4 + 8)
            return false
        end
    else
        adminchat:Respond(executor, "Invalid Player ID. Please enter a number between 1-16", 4 + 8)
    end
end

function adminchat:checkAccess(p)
    local access
    if not adminchat:isConsole(p) then
        if (tonumber(get_var(p, '$lvl')) >= adminchat.permission) then
            access = true
        else
            adminchat:Respond(p, "Command Failed. Insufficient permission!", 4 + 8)
            access = false
        end
    else
        access = true
    end
    return access
end

function adminchat:executeOnOthers(e, self, is_console, level)
    if (not self) and (not is_console) then
        if tonumber(level) >= adminchat.permission_extra then
            return true
        elseif (others_cmd_error[e]) then
            others_cmd_error[e] = nil
            adminchat:Respond(e, "You are not allowed to execute this command on other players.", 4 + 8)
            return false
        end
    else
        return true
    end
end

function adminchat:isConsole(e)
    if (e) then
        if (e ~= -1 and e >= 1 and e < 16) then
            return false
        else
            return true
        end
    end
end

function adminchat:isGameOver(p)
    if (game_over) then
        adminchat:Respond(p, "Command Failed -> Game has Ended.", 4+8)
        adminchat:Respond(p, "Please wait until the next game has started.", 4+8)
        return true
    end
end

function adminchat:GetIP(p)
    local ip_address
    
    if (p) then        
        if (halo_type == 'PC') then
            ip_address = ip_table[p]
        else
            ip_address = get_var(p, '$ip')
        end
    end
    
    return ip_address:match('(%d+.%d+.%d+.%d+)')
end

function adminchat:Respond(p, msg, color)
    local color = color or 4 + 8
    if not adminchat:isConsole(p) then
        rprint(p, msg)
    else
        cprint(msg, color)
    end
end

function adminchat:StringSplit(str)
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

    local cmd, args = subs[1], subs
    table.remove(args, 1)

    return cmd, args
end

-- For a future update:
return adminchat
