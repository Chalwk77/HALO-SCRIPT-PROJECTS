--[[
--=====================================================================================================--
Script Name: List Players, for SAPP (PC & CE)
Description: An alternative player list mod (Overrides SAPP's built in /pl command.)
     
Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

~ Written by Jericho Crosby (Chalwk)

- This script is included in the Velocity Multi-Mod with many improvements.
--=====================================================================================================--
]]

api_version = '1.12.0.0'

-- Config [starts]
local command_aliases = { 
    "pl", "players", "playerlist", "playerslist" 
}
    
-- Minimum privilege level required to execute (-1 for all players, 1-4 for admins):
local permission_level = 1 
-- Config [ends]

local gsub = string.gsub

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload()
    --
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)
    local level = tonumber(get_var(executor, "$lvl"))
    
    local function checkAccess(e, level)
        if (e ~= -1 and e >= 1 and e < 16) then
            if (level >= permission_level) then
                return true
            else
                respond(e, "Command failed. Insufficient Permission.", "rcon", 4+8)
                return false
            end
        else
            return true
        end
    end
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

local function isConsole(e)
    if (e) then
        if (e ~= -1 and e >= 1 and e < 16) then
            return false
        else
            return true
        end
    end
end

function showlist(e)
    local header, cheader, ffa
    local player_count = 0
    local header_bool, ffa = true, false
    
    if (get_var(0, "$ffa") == "0") then
        header = "|l [ ID.    -    Name.    -    Team.    -    IP.    -    Total Players: %total%/16 ]"
        cheader = "    ID.   Name.   Team.   IP.   (Total Players:%total%/16)"
    else
        ffa = true
        header = "|l [ ID.    -    Name.    -    IP.    -    Total Players: %total%/16 ]"
        cheader = "    ID.   Name.   IP.   (Total Players:%total%/16)"
    end
    
    for i = 1, 16 do
        if player_present(i) then
            player_count = player_count + 1
        
            if (header_bool) then
                header_bool = false
                if not (isConsole(e)) then
                    header = gsub(header, "%%total%%", player_count)
                    respond(e, header, "rcon")
                else
                    cheader = gsub(cheader, "%%total%%", player_count)
                    respond(e, cheader, 7 + 8)
                end
            end
        
            
            local id, name, team, ip = get_var(i, "$n"), get_var(i, "$name"), get_var(i, "$team"), get_var(i, "$ip")

            local sep, seperator = ".         ", " | "
            local str = ""

            if not (ffa) then
                str = "    " .. id .. sep .. name .. seperator .. team .. seperator .. ip
            else
                str = "    " .. id .. sep .. name .. seperator .. ip
            end
            if not (isConsole(e)) then
                respond(e, "|l " .. str, "rcon")
            else
                respond(e, str, "rcon", 5 + 8)
            end
        end
    end
    if (player_count == 0) and (isConsole(e)) then
        respond(e, "------------------------------------", "rcon", 5 + 8)
        respond(e, "There are no players online", 4 + 8)
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
