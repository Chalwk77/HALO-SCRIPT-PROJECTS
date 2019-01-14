--[[
--=====================================================================================================--
Script Name: List Players (SAPP alternative), for SAPP (PC & CE)
Description: An alternative player list mod. Overrides SAPP's built in /pl command.

Command Syntax: /pl
                /players
                /playerlist
                /playerslist
     
Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

~ Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]

api_version = '1.12.0.0'

-- Configuration [starts] --
-- Min admin level required to use these commands...
min_admin_level = 1

-- Custom command(s)
base_command = {"pl", "players", "playerlist", "playerslist"}

-- Message Alignment:
-- Left = l,    Right = r,    Center = c,    Tab: t
Message_Alignment = "l"
-- Configuration [ends] --

player_count = 0

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload()

end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local t = tokenizestring(Command)
    local count = #t
    for k, v in pairs(base_command) do
        if v then
            local cmds = tokenizestring(v, ",")
            for i = 1,#cmds do
                if (t[1] == cmds[i]) then
                    if isAdmin(PlayerIndex) then
                        listPlayers(PlayerIndex, count)
                    else
                        rprint(PlayerIndex, "Insufficient Permission")
                    end
                    return false
                end
            end
        end
    end
end

function listPlayers(PlayerIndex, count)
    if (count == 1) then
        rprint(PlayerIndex, "|" .. Message_Alignment .. " [ ID.    -    Name.    -    Team.    -    IP. ]")
        for i = 1, 16 do
            if player_present(i) then
                local name = get_var(i, "$name")
                local id = get_var(i, "$n")
                local team = get_var(i, "$team")
                local ip = get_var(i, "$ip")
                local hash = get_var(i, "$hash")
                if get_var(0, "$ffa") == "0" then
                    if team == "red" then
                        team = "Red Team"
                    elseif team == "blue" then
                        team = "Blue Team"
                    else
                        team = "Hidden"
                    end
                else
                    team = "FFA"
                end
                rprint(PlayerIndex, "|" .. Message_Alignment .. id .. ".   " .. name .. "   |   " .. team .. "  -  IP: " .. ip)
            end
        end
    else
        rprint(PlayerIndex, "Invalid Syntax")
        return false
    end
end

function isAdmin(PlayerIndex)
    if (tonumber(get_var(PlayerIndex, "$lvl"))) >= min_admin_level then
        return true
    else
        return false
    end
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = { };
    i = 1
    for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
        t[i] = str
        i = i + 1
    end
    return t
end

function OnError(Message)
    print(debug.traceback())
end
