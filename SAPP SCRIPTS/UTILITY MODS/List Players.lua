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
local len = string.len

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
end

function OnGameStart()
              
    local pl = {}
    pl[#pl+1] = {id = 1,name = "Chalwk",team = "red",ip = "127.0.0.1:2309",}
    pl[#pl+1] = {id = 2,name = "Whicker",team = "blue",ip = "127.0.0.1:21774",}
    pl[#pl+1] = {id = 3,name = "Sneak",team = "red",ip = "127.0.0.1:30947",}
    pl[#pl+1] = {id = 4,name = "Walla Walla",team = "blue",ip = "127.0.0.1:3485",}
    pl[#pl+1] = {id = 5,name = "Howard",team = "red",ip = "127.0.0.1:1581",}
    pl[#pl+1] = {id = 6,name = "Saucy",team = "blue",ip = "127.0.0.1:10627",}
    pl[#pl+1] = {id = 7,name = "Stompy",team = "red",ip = "127.0.0.1:13435",}
    pl[#pl+1] = {id = 8,name = "The Big L",team = "blue",ip = "127.0.0.1:16036",}
    
    local header = " [ ID.    -    Name.    -    Team.    -    IP.    -    Total Players: %total%/16 ]"
    cprint(gsub(header, "%%total%%", #pl), 2+8)
    
    for i = 1,#pl do
        local name_len = len(pl[i].name)
        local nameteam_spacing = ""
        for _ = (name_len),13 do
            nameteam_spacing = nameteam_spacing .. " "
        end
                    
        local ip_spaces = 0
        if (pl[i].team == "red") or (pl[i].team == "ffa") then
            ip_spaces = 11
        else
            ip_spaces = 10
        end
        
        local ip_spacing = ""
        for _ = 1,ip_spaces do
            ip_spacing = ip_spacing .. " "
        end
        local str = "    " .. pl[i].id .. ".         " .. pl[i].name .. nameteam_spacing .. pl[i].team .. ip_spacing .. pl[i].ip
        cprint(str)
    end
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
    
    local pl = {}
    for i = 1, 16 do
        if player_present(i) then
            pl[#pl+1] = {
                id = i,
                name = get_var(i, "$name"),
                team = get_var(i, "$team"),
                ip = get_var(i, "$ip"),
            }
        end
    end

    if (#pl > 0) then
    
        local header = " [ ID.    -    Name.    -    Team.    -    IP.    -    Total Players: %total%/16 ]"
        respond(e, gsub(header, "%%total%%", #pl), "rcon", 2+8)

        for i = 1,#pl do
        
            if (get_var(0, "$ffa") ~= "0") then
                team = "ffa"
            end
        
            local name_len = len(pl[i].name)
            local nameteam_spacing = ""
            for _ = (name_len),13 do
                nameteam_spacing = nameteam_spacing .. " "
            end
                        
            local ip_spaces = 0
            if (pl[i].team == "red") or (pl[i].team == "ffa") then
                ip_spaces = 11
            else
                ip_spaces = 10
            end
            
            local ip_spacing = ""
            for _ = 1,ip_spaces do
                ip_spacing = ip_spacing .. " "
            end
            local str = "    " .. pl[i].id .. ".         " .. pl[i].name .. nameteam_spacing .. pl[i].team .. ip_spacing .. pl[i].ip
            if not (isConsole(e)) then
                respond(e, str, "rcon")
            else
                respond(e, str, "rcon", 5 + 8)
            end
        end
    else
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
