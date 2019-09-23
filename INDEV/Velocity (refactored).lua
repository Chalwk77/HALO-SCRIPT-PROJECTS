--[[
--=====================================================================================================--
Script Name: Velocity Multi-Mod, for SAPP (PC & CE)
	
    IN DEVELOPMENT
    --------------
    
Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local velocity = {

    mods = {
        ["Admin Chat"] = {
            enabled = true,
            command = "achat",
            prefix = "[ADMIN CHAT]",
            permission = 1,
            permission_extra = 4,
            restore = true,
            messages = {
                [1] = "%prefix% %name% [%id%]: %message%",
                [2] = "Admin Chat %state%!",
                [3] = "Admin Chat %state% for %target_name%",
                [4] = "Your Admin Chat was %state% by %executor_name%",
                [5] = "Your Admin Chat is already %state%!",
                [6] = "%target_name%%'s Admin Chat is already %state%!",
                [7] = "Your Admin Chat is Enabled! (auto-restore)",
                ['invalid_syntax'] = "Invalid Syntax: Usage: /%command% on|off [me | id | */all]",
            },
            activated = {},
        },
    }
}

-- Variables for String Library:
local sub, gsub = string.sub, string.gsub
local lower, upper = string.lower, string.upper
local match, gmatch = string.match, string.gmatch

-- Game Variables:
local game_over

-- Game Tables: 
local ip_table = { }
local others_cmd_error = { }
-- ...

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb["EVENT_CHAT"], "OnPlayerChat")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    
    if (get_var(0, "$gt") ~= "n/a") then
        game_over = false
        for i = 1,16 do
            if player_present(i) then
                if velocity:hasPermission(i, "Admin Chat") then
                    ip_table[i] = get_var(i, '$ip')
                    
                    local ip = velocity:GetIP(i)
                    velocity[ip] = nil
                end
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
    for k,v in pairs(velocity.mods) do
        if velocity:hasPermission(p, k) then
            
            ip_table[p] = get_var(p, '$ip')
            
            local ip = velocity:GetIP(p)
            v.activated[ip] = v.activated[ip] or nil
            
            local already_activated = (v.activated[ip] == true)
            if (v.restore) and (already_activated) then
                local feedback = velocity:GetMessageTable("Admin Chat")
                velocity:Respond(p, feedback[7])
            end
        end
    end
end

function OnPlayerDisconnect(p)  
    for k,v in pairs(velocity.mods) do
        
        if velocity:hasPermission(p, k) then
            local ip = velocity:GetIP(p)
                    
            local already_activated = (v.activated[ip] == true)
            if (not v.restore) or (not already_activated) then
                ip_table[p] = nil
            end
        end
    end
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local command, args = velocity:StringSplit(Command)
    local executor = tonumber(PlayerIndex)
    
    if (command == nil) then
        return
    end
    command = lower(command) or upper(command)

    for k,v in pairs(velocity.mods) do
        if (command == v.command) then
            if not velocity:isGameOver(executor) then
                if velocity:checkAccess(executor, k) then
                    if (args[1] ~= nil) then
                    
                        local params = velocity:ValidateCommand(executor, args, k)
                        
                        if (params ~= nil) and (not params.target_all) and (not params.is_error) then
                            local Target = tonumber(args[2]) or tonumber(executor)                        
                            if velocity:isOnline(Target, executor) then
                                velocity:ExecuteCore(params)
                            end
                        end
                    else
                        local message = velocity:GetMessageTable(k)
                        local feedback = gsub(message['invalid_syntax'], "%%command%%", v.command)
                        velocity:Respond(executor, feedback, 4 + 8)
                    end
                end
            end
            return false
        end
    end
end

function OnPlayerChat(PlayerIndex, Message, type)
    if (type ~= 6) then
    
        local msg = velocity:StringSplit(Message)
        if (#msg == 0) then
            return nil
        end
        
        local p = tonumber(PlayerIndex)
        local ip = velocity:GetIP(p)
        local name = get_var(p, "$name")
        
        for k,v in pairs(velocity.mods) do
            if (k == "Admin Chat") then
            
                local activated = (v.activated[ip] == true)            
                if (activated) then

                    local is_command = (sub(msg, 1, 1) == "/") or (sub(msg, 1, 1) == "\\")
                
                    if (is_command) then
                        return true
                    else
                        
                        local feedback = velocity:GetMessageTable(k)
                        local msg = gsub(gsub(gsub(gsub(feedback[1], "%%name%%", name), 
                        "%%id%%", p), 
                        "%%message%%", Message), 
                        "%%prefix%%", v.prefix)
                    
                        for i = 1, 16 do
                            if player_present(i) then
                                if (tonumber(get_var(i, '$lvl')) >= velocity:GetPermission(k)) then
                                    rprint(i, "|l" .. msg)
                                end
                            end
                        end
                        
                        return false
                    end
                end
            end
        end
    end
end

function velocity:ExecuteCore(params)
    local params = params or nil
    if (params ~= nil) then
                
        -- Target Parameters:
        local tid, tip, tn  = params.tid, params.tip, params.tn
        
        -- Executor Parameters:
        local eid, eip, en = params.eid, params.eip, params.en
    
        local mod = params.mod
    
        -- 
        local is_console = velocity:isConsole(eid)
        if is_console then
            en = "SERVER"
        end

        local is_self = (eid == tid)
        local admin_level = tonumber(get_var(eid, '$lvl'))
                
        local proceed = velocity:executeOnOthers(eid, is_self, is_console, admin_level)
        local valid_state
        
        if (proceed) then
        
            local state = params.state
            local state = velocity:ActivationState(eid, state, mod)
            
            if (state) then
            
                for k,v in pairs(velocity.mods) do
                    if (k == mod) then

                        v.activated[tip] = v.activated[tip] or nil
                                    
                        local already_activated = (v.activated[tip] == true)
                        local already_set
                        
                        if (state == 1) then
                            state, valid_state = "enabled", true
                            if (v.activated[tip] == nil) then
                                v.activated[tip] = true
                            else
                                already_set = true
                            end
                        elseif (state == 0) then
                            state, valid_state = "disabled", true
                            if (v.activated[tip] == already_activated) then
                                v.activated[tip] = nil
                            else
                                already_set = true
                            end
                        end
                        
                        if (valid_state) then               
                            local messages = velocity:GetMessageTable(mod)
                            
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
                                    velocity:Respond(eid, Feedback(messages[2]), 2 + 8)
                                else
                                    velocity:Respond(eid, Feedback(messages[3]), 2 + 8)
                                    velocity:Respond(tid, Feedback(messages[4]), 2 + 8)
                                end
                            else
                                if (is_self) then
                                    velocity:Respond(eid, Feedback(messages[5]), 4 + 8)
                                else
                                    velocity:Respond(eid, Feedback(messages[6]), 4 + 8)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function velocity:ValidateCommand(executor, args, mod)
    local params = { }
    params.mod = mod
                
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
            velocity:Respond(executor, "Invalid player id. Usage: [number: 1-16] | */all | me", 4 + 8)
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
            params.eid, params.en, params.eip = executor, get_var(executor, '$name'), velocity:GetIP(executor)
            params.tid, params.tn, params.tip  = tonumber(pl[i]), get_var(pl[i], '$name'), velocity:GetIP(pl[i])

            if (params.target_all) then
                velocity:ExecuteCore(params)
            end
        end
    end
    return params
end

function velocity:isOnline(target, executor)
    if (target > 0 and target < 17) then
        if player_present(target) then
            return true
        else
            velocity:Respond(executor, "Command Failed. Player not online!", 4 + 8)
            return false
        end
    else
        velocity:Respond(executor, "Invalid Player ID. Please enter a number between 1-16", 4 + 8)
    end
end

function velocity:checkAccess(p, mod)
    local access
    if not velocity:isConsole(p) then
        if velocity:hasPermission(p, mod) then
            access = true
        else
            velocity:Respond(p, "Command Failed. Insufficient permission!", 4 + 8)
            access = false
        end
    else
        access = true
    end
    return access
end

function velocity:executeOnOthers(e, self, is_console, level, mod)
    if (not self) and (not is_console) then
        
        local permission_needed
        for k,v in pairs(velocity.mods) do
            if (k == mod) then
                permission_needed = v.permission_extra 
            end
        end
    
        if tonumber(level) >= permission_needed then
            return true
        elseif (others_cmd_error[e]) then
            others_cmd_error[e] = nil
            velocity:Respond(e, "You are not allowed to execute this command on other players.", 4 + 8)
            return false
        end
    else
        return true
    end
end

function velocity:ActivationState(e, s, mod)
    if (s == "on") or (s == "1") or (s == "true") then
        return 1
    elseif (s == "off") or (s == "0") or (s == "false") then
        return 0
    else for k,v in pairs(velocity.mods) do
            if (k == mod) then                
                local feedback = gsub(v.messages['invalid_syntax'], "%%command%%", v.command)
                velocity:Respond(e, feedback, 4 + 8)
            end
        end
        return false
    end
end

function velocity:isConsole(e)
    if (e) then
        if (e ~= -1 and e >= 1 and e < 16) then
            return false
        else
            return true
        end
    end
end

function velocity:isGameOver(p)
    if (game_over) then
        velocity:Respond(p, "Please wait until the next game has started.", 4+8)
        return true
    end
end

function velocity:GetIP(p)
    
    if (halo_type == 'PC') then
        ip_address = ip_table[p]
    else
        ip_address = get_var(p, '$ip')
    end
    
    if (ip_address ~= nil) then
        return ip_address:match('(%d+.%d+.%d+.%d+)')
    else
        error(debug.traceback())
    end
end

function velocity:hasPermission(p, mod)
    for k,v in pairs(velocity.mods) do
        if (k == mod) then
            if (v.permission) then
                return tonumber(get_var(p, "$lvl")) >= v.permission
            else
                return error(k .. " doesn't have a permission node!")
            end
        end
    end
end

function velocity:Respond(p, msg, color)
    local color = color or 4 + 8
    if not velocity:isConsole(p) then
        rprint(p, msg)
    else
        cprint(msg, color)
    end
end

function velocity:GetMessageTable(mod)
    for k,v in pairs(velocity.mods) do
        if (k == mod) then
            if (v.messages) then
                return v.messages
            else
                return error(k .. " doesn't have a message table!")
            end
        end
    end
end

function velocity:GetPermission(mod)
    for k,v in pairs(velocity.mods) do
        if (k == mod) then
            if (v.permission) then
                return tonumber(v.permission)
            else
                return error(k .. " doesn't have a permission node!")
            end
        end
    end
end

function velocity:StringSplit(str, bool)
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
return velocity
