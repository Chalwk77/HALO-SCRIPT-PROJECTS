--[[
--=====================================================================================================--
Script Name: List Players (SAPP alternative), for SAPP (PC & CE)
Description: An alternative player list mod (Overrides SAPP's built in /pl command.)
     
Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

~ Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]

api_version = '1.12.0.0'

-- CONFIG (starts) -------------------------------------------------------------------
local command_aliases = { "pl", "players", "playerlist", "playerslist" }
local permission_level = 1 -- <<- Minimum privilege level required to execute (-1 for all players, 1-4 for admins):
-- CONFIG (ends) -------------------------------------------------------------------

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload()
    --
end

local function checkAccess(e, level)
    if (e ~= -1 and e >= 1 and e < 16) then
        if (tonumber(get_var(e, "$lvl"))) >= level then
            return true
        else
            rprint(e, "Command failed. Insufficient Permission.")
            return false
        end
    else
        return true
    end
end

local isConsole = function(e)
    if (e) then
        if (e ~= -1 and e >= 1 and e < 16) then
            return false
        else
            return true
        end
    end
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)
    local level = tonumber(get_var(executor, "$lvl"))
    for i = 1, #command_aliases do
        if (command == command_aliases[i]) then
            if (checkAccess(executor, level)) then
                if (args[1] == nil) then
                    showlist(executor)
                else
                    respond(executor, "Invalid Syntax. Usage: /" .. command, "rcon", 4 + 8)
                end
            end
            return false
        end
    end
end

local isTeamPlay = function()
    if (get_var(0, "$ffa") == "0") then
        return true
    end
end

function showlist(e)
    local header, cheader, ffa
    local player_count = 0
    local bool = true
    
    if (isTeamPlay) then
        header = "[ ID.    -    Name.    -    Team.    -    IP. ]"
        cheader = "ID.        Name.        Team.        IP."
    else
        ffa = true
        header = "[ ID.    -    Name.    -    IP. ]"
        cheader = "ID.        Name.        IP"
    end
    
    for i = 1, 16 do
        if player_present(i) then
            if (bool) then
                bool = false
                if not (isConsole(e)) then
                    respond(e, header, "rcon", 7 + 8)
                else
                    respond(e, cheader, "rcon", 7 + 8)
                end
            end
            
            player_count = player_count + 1
            local id, name, team, ip = get_var(i, "$n"), get_var(i, "$name"), get_var(i, "$team"), get_var(i, "$ip"):match("(%d+.%d+.%d+.%d+)")

            local sep, seperator = ".         ", " | "

            local str = ""
            
            if not (ffa) then
                str = "    " .. id .. sep .. name .. seperator .. team .. seperator .. ip
            else
                str = "    " .. id .. sep .. name .. seperator .. ip
            end
            respond(e, str, "rcon", 5 + 8)
        end
    end
    
    if (player_count == 0) and (isConsole(e)) then
        respond(e, "------------------------------------", "rcon", 5 + 8)
        respond(e, "There are no players online", "rcon", 5 + 8)
        respond(e, "------------------------------------", "rcon", 5 + 8)
    end
end

function respond(executor, message, environment, color)
    if (executor) then
        color = color or 4 + 8
        if not (isConsole(executor)) then
            if (environment == "chat") then
                say(executor, message)
            elseif (environment == "rcon") then
                rprint(executor, message)
            end
        else
            cprint(message, color)
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

function OnError(Message)
    print(debug.traceback())
end
