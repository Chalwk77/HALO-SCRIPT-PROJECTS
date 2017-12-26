--[[
--=====================================================================================================--
Script Name: Set Ammo (command), for SAPP (PC & CE)
Implementing API version: 1.11.0.0
Description: Set loaded|unloaded ammo for yourself (or others)

Command Syntax: /setammo [player] [type] [ammo]
    
    Valid Arguments:
    >   me              Set ammo for yourself
    >   1-16            Set ammo for [player number]
    >   *               Set ammo for All players in the server
    >   red             Set Ammo for everybody on Red Team
    >   blue            Set Ammo for everybody on Blue Team
    >   rand|random     Set ammo for 1 random player


Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]-- 

api_version = "1.12.0.0"
cur_players = 0

-- Minimum admin level required to execute /setammo command
ADMIN_LEVEL = 1

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnNewGame()
    for i = 1, 16 do
        if get_player(i) then
            cur_players = cur_players + 1
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    cur_players = cur_players + 1
end

function OnPlayerLeave(PlayerIndex)
    cur_players = cur_players - 1
end

function OnServerCommand(PlayerIndex, Command, Environment)
    local response = nil
    t = tokenizestring(Command)
    count = #t
    if t[1] == "setammo" then
        if tonumber(get_var(PlayerIndex, "$lvl")) >= ADMIN_LEVEL then
            response = false
            Command_Setammo(PlayerIndex, t[1], t[2], t[3], t[4], count)   
        end        
    end
    return response
end

function Command_Setammo(executor, command, PlayerIndex, type, ammo, count)
    if count == 4 and tonumber(ammo) then
        local players = getvalidplayers(PlayerIndex, executor)
        if players then
            for i = 1, #players do
                local player_object = get_dynamic_player(players[i])
                if player_object then
                    local m_weaponId = read_dword(player_object + 0x118)
                    local weapon_id = get_object_memory(m_weaponId)
                    if m_weaponId then
                        if type == "unloaded" or type == "1" then
                            safe_write(true)
                            write_dword(weapon_id + 0x2B6, tonumber(ammo))
                            safe_write(false)
                            sync_ammo(m_weaponId)
                            sendresponse(get_var(players[i], "$name") .. " had their unloaded ammo changed to " .. ammo, command, executor)
                        elseif type == "2" or type == "loaded" then
                            safe_write(true)
                            write_dword(weapon_id + 0x2B8, tonumber(ammo))
                            safe_write(false)
                            sync_ammo(m_weaponId)
                            sendresponse(get_var(players[i], "$name") .. " had their loaded ammo changed to " .. ammo, command, executor)
                        else
                            sendresponse("Invalid type: 1 for unloaded, 2 for loaded ammo", command, executor)
                        end
                    else
                        sendresponse(get_var(players[i], "$name") .. " is not holding any weapons", command, executor)
                    end
                else
                    sendresponse(get_var(players[i], "$name") .. " is dead", command, executor)
                end
            end
        else
            sendresponse("Invalid Player", command, executor)
        end
    else
        sendresponse("Invalid Syntax: " .. command .. " [player] [type] [ammo]", command, executor)
    end
end

function getvalidplayers(expression, PlayerIndex)
    if cur_players ~= 0 then
        local players = { }
        if expression == "*" then
            for i = 1, 16 do
                if getplayer(i) then
                    table.insert(players, i)
                end
            end
        elseif expression == "me" then
            if PlayerIndex ~= nil and PlayerIndex ~= -1 and PlayerIndex then
                table.insert(players, PlayerIndex)
            end
        elseif string.sub(expression, 1, 3) == "red" then
            for i = 1, 16 do
                if getplayer(i) and get_var(i, "$team") == "red" then
                    table.insert(players, i)
                end
            end
        elseif string.sub(expression, 1, 4) == "blue" then
            for i = 1, 16 do
                if get_player(i) and get_var(i, "$team") == "blue" then
                    table.insert(players, i)
                end
            end
        elseif (tonumber(expression) or 0) >= 1 and(tonumber(expression) or 0) <= 16 then
            local expression = tonumber(expression)
            if resolveplayer(expression) then
                table.insert(players, resolveplayer(expression))
            end
        elseif expression == "random" or expression == "rand" then
            if cur_players == 1 and PlayerIndex ~= nil then
                table.insert(players, PlayerIndex)
                return players
            end
            local bool = false
            while not bool do
                num = math.random(1, 16)
                if get_player(num) and num ~= PlayerIndex then
                    bool = true
                end
            end
            table.insert(players, num)
        end
        if players[1] then
            return players
        end
    end
    return false
end

function resolveplayer(PlayerIndex)
    if PlayerIndex ~= nil and PlayerIndex ~= "-1" then
        local player_id = get_var(PlayerIndex, "$n")
        return player_id
    else
        return nil
    end
    return nil
end

function sendresponse(message, command, PlayerIndex)
    if message then
        if message == "" then
            return
        elseif type(message) == "table" then
            message = message[1]
        end
        PlayerIndex = tonumber(PlayerIndex)
        if command then
            if PlayerIndex ~= -1 and PlayerIndex >= 1 and PlayerIndex < 16 then
                execute_command("msg_prefix \"\"")
                say(PlayerIndex, message)
                execute_command("msg_prefix \"** SERVER ** \"")
            else
                cprint(message .. "", 2 + 8)
            end
        else
            cprint("Internal Error has Occured.", 4 + 8)
        end
    end
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = { }; i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
