--[[
--=====================================================================================================--
Script Name: Chalwk - Script Template, for SAPP (PC & CE)
				
Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local mod = {
    
    -- ============= Configuration Starts ============= --

    -- Custom Command:
    command = "custom_command",
    
    -- Minimum permission needed to execute the custom command:
    permission = 1,
    
    -- Minimum permission needed to execute the custom command on others players:
    permission_extra = 4,
    
    -- ============= Configuration Ends ============= --
    --
    --
    --
    -- Do not touch:
    others_cmd_error = { }
}

-- Variables for String Library:
local format = string.format
local sub, gsub = string.sub, string.gsub
local match, gmatch = string.match, string.gmatch
local lower, upper = string.lower, string.upper

-- Variables for Math Library:
local floor, sqrt = math.floor, math.sqrt

-- Game Variables:
local game_over

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    
    if (get_var(0, "$gt") ~= "n/a") then
        game_over = false
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
    local ip = mod:GetIP(p)
    --
end

function OnPlayerDisconnect(p)
    local ip = mod:GetIP(p)
    --
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local command, args = mod:StringSplit(Command)
    
    local cmd = { }
    
    -- Executor ID, Executor Name, Executor IP, Command Args
    cmd.eid, cmd.en = tonumber(PlayerIndex), get_var(PlayerIndex, "$name")
    cmd.eip = mod:GetIP(PlayerIndex)
    cmd.args = args
    
    if (command == nil) then
        return
    end
    command = lower(command) or upper(command)

    if (command == mod.command) then
        if not mod:isGameOver(cmd.eid) then
            if mod:checkAccess(cmd.eid) then
                if (args[1] ~= nil) then
                
                    local params = mod:ValidateCommand(cmd)
                    
                    if (params ~= nil) and (not params.target_all) and (not params.is_error) then
                        local Target = tonumber(args[2]) or tonumber(cmd.eid)
                        
                        if mod:isOnline(Target, cmd.eid) then
                            mod:ExecuteCore(params)
                        end
                    end
                else
                    mod:Respond(cmd.eid, "Invalid Syntax: Usage: /" .. mod.command .. " on|off [me | id | */all]", 4 + 8)
                end
            end
        end
        return false
    end
end

function mod:ExecuteCore(params)
    local params = params or nil
    if (params ~= nil) then
        
        -- Target Parameters:
        local tid, tip, tn  = params.tid, params.tip, params.tn
        
        -- Executor Parameters:
        local eid, eip, en = params.eid, params.eip, params.en
    
        -- 
        local is_console = mod:isConsole(eid)
        if is_console then
            en = "SERVER"
        end

        local is_self = (eid == tid)
        if (is_self) then
            is_self = true
        end
                
        local admin_level = tonumber(get_var(eid, "$lvl"))
        local proceed = mod:executeOnOthers(eid, is_self, is_console, admin_level)
        
        if (proceed) then
            
            -- execute main logic:
        end
    end
end

function mod:ValidateCommand(cmd)
    local cmd = cmd or nil
    
    if (cmd ~= nil) then
        local params = { }
        local args = cmd.args
                    
        local function getplayers(arg)
            local players = { }
            
            if (arg == nil) or (arg == "me") then
                table.insert(players, cmd.eid)
            elseif (arg:match("%d+")) then
                table.insert(players, tonumber(cmd.eid))
            elseif (arg == "*" or arg == "all") then
                params.target_all = true
                for i = 1, 16 do
                    if player_present(i) then
                        table.insert(players, i)
                    end
                end
            else
                mod:Respond(cmd.eid, "Invalid player id. Usage: [number: 1-16] | */all | me", 4 + 8)
                params.is_error = true
                return false
            end

            for i = 1, #players do
                if (cmd.eid ~= tonumber(players[i])) then
                    mod.others_cmd_error[cmd.eid] = { }
                    mod.others_cmd_error[cmd.eid] = true
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
                params.eid, params.en, params.eip = cmd.eid, cmd.en, cmd.eip
                params.tid, params.tn, params.tip  = tonumber(pl[i]), get_var(pl[i], "$name"), mod:GetIP(pl[i])

                if (params.target_all) then
                    mod:ExecuteCore(params)
                end
            end
        end
        return params
    end
    return nil
end

function mod:isOnline(target, executor)
    if (target > 0 and target < 17) then
        if player_present(target) then
            return true
        else
            mod:Respond(executor, "Command Failed. Player not online!", 4 + 8)
            return false
        end
    else
        mod:Respond(executor, "Invalid Player ID. Please enter a number between 1-16", 4 + 8)
    end
end

function mod:checkAccess(p)
    local access
    if not mod:isConsole(p) then
        if (tonumber(get_var(p, "$lvl")) >= mod.permission) then
            access = true
        else
            mod:Respond(p, "Command Failed. Insufficient permission!", 4 + 8)
            access = false
        end
    else
        access = true
    end
    return access
end

function mod:executeOnOthers(e, self, is_console, level)
    if (not self) and (not is_console) then
        if tonumber(level) >= mod.permission_extra then
            return true
        elseif (mod.others_cmd_error[e]) then
            mod.others_cmd_error[e] = nil
            mod:Respond(e, "You are not allowed to execute this command on other players.", 4 + 8)
            return false
        end
    else
        return true
    end
end

function mod:isConsole(e)
    if (e) then
        if (e ~= -1 and e >= 1 and e < 16) then
            return false
        else
            return true
        end
    end
end

function mod:isGameOver(p)
    if (game_over) then
        mod:Respond(p, "Command Failed -> Game has Ended.", 4+8)
        mod:Respond(p, "Please wait until the next game has started.", 4+8)
        return true
    end
end

function mod:GetIP(p)
    local ip_address
    
    if (p) then        
        if (halo_type == "PC") then
            ip_address = ip_table[p]
        else
            ip_address = get_var(p, "$ip")
        end
    end
    
    return ip_address:match("(%d+.%d+.%d+.%d+)")
end

function mod:Respond(p, msg, color)
    local color = color or 4 + 8
    if not mod:isConsole(p) then
        rprint(p, msg)
    else
        cprint(msg, color)
    end
end

function mod:StringSplit(str)
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
return mod
