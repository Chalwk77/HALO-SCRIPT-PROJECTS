--[[
--=====================================================================================================--
Script Name: Ban on Sight (BoS), for SAPP (PC & CE)
Description: Ban players who are online|offline

Command Syntax: /bos [id]
                /boslist
                
Command usage:
To immediately BoS someone who is currently online, simply type /bos [player id].
To BoS a player who just left the server, type the same command: /bos [player id] (requires knowing what their index id was before they left). 

     
Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

~ Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]

api_version = '1.11.0.0'


-- Configuration [starts] --
-- Min admin level required to use these commands...
min_admin_level = 1

-- Command to BoS a player.
base_command = "bos"

-- Command to list player's who are currently "banned on sight".
list_command = "boslist"
-- Configuration [ends] --

-- do not touch -------
bos_table = { }
boslog_table = { }

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")

    for i = 1, 16 do
        if player_present(i) then
            local name = get_var(i, "$name")
            local hash = get_var(i, "$hash")
            bos_table[i] = name .. "," .. hash .. "," .. get_var(i, "$ip")
        end
    end

    local file = io.open('sapp\\bos.data', "r")
    if file then
        for line in file:lines() do
            local words = tokenizestring(line, ",")
            words[1] = words[1]:gsub(" ", "", 1)
            if words[3] ~= nil then
                table.insert(boslog_table, words[1] .. "," .. words[2] .. "," .. words[3])
            end
        end
        file:close()
    end
    table.sort(boslog_table)
end

function OnScriptUnload()

end

function OnNewGame()
    bos_table = { }
end

function OnPlayerJoin(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    bos_table[PlayerIndex] = name .. "," .. hash .. "," .. get_var(PlayerIndex, "$ip")
end

function OnPlayerLeave(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local words = tokenizestring(bos_table[PlayerIndex], ",")
    bos_table[PlayerIndex] = name .. "," .. hash .. "," .. words[3]
end

function OnPlayerPrejoin(PlayerIndex)
    local ip_address = get_var(PlayerIndex, "$ip")
    for k, v in pairs(boslog_table) do
        local words = tokenizestring(v, ",")
        if (words[3] == ip_address) then
            local entry_name = words[1]
            for i = 1, 16 do
                if player_present(i) and isAdmin(i) then

                    rprint(i, "Rejecting " .. entry_name .. " - banned from BoS.")
                    rprint(i, "Entry: " .. entry_name .. " - " .. words[2] .. " - " .. words[3])

                    rprint(PlayerIndex, "Unable to connect. You are currently banned!")

                    -- TO DO: find a way to "silently" kick this player
                    execute_command("k" .. " " .. PlayerIndex .. " \"[Auto Ban on Sight]\"")
                    break
                end
            end
            return false
        end
    end
    return nil
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local t = tokenizestring(Command)
    local args = #t
    if (t[1] == base_command) then
        if isAdmin(PlayerIndex) then
            Command_Bos(PlayerIndex, t[2], args)
        else
            rprint(PlayerIndex, "Insufficient Permission")
        end
        return false
    elseif (t[1] == list_command) then
        Command_Boslist(PlayerIndex, args)
        return false
    end
end

function Command_Bos(PlayerIndex, index, args)
    if args == 2 then
        local player_number = tonumber(index)
        local bos_entry = bos_table[player_number]
        if bos_entry == nil then
            rprint(PlayerIndex, "Invalid Player")
        else
            local words = tokenizestring(bos_entry, ",")
            local bool = true
            for k, v in pairs(boslog_table) do
                if bos_entry == v then
                    bool = false
                end
            end
            if bool then
                table.insert(boslog_table, bos_entry)
                local file = io.open('sapp\\bos.data', "w+")
                if file then
                    for k, v in pairs(boslog_table) do
                        if v then
                            file:write(v .. "\n")
                        end
                    end
                    file:close()
                end
                rprint(PlayerIndex, "Adding " .. words[1] .. " to BoS.")
                rprint(PlayerIndex, "Entry: " .. words[1] .. " - " .. words[2] .. " - " .. words[3])
                execute_command("k" .. " " .. player_number .. " \"[Ban on Sight]\"")
            else
                rprint(PlayerIndex, words[1] .. " is already on the BoS")
            end
        end
    else
        rprint(PlayerIndex, "Invalid Syntax. Correct usage is: /bos [player]")
        return false
    end
end

function Command_Boslist(PlayerIndex, count)
    if count == 1 then
        local response
        local bool = true
        for k, v in pairs(boslog_table) do
            if v then
                local words = tokenizestring(v, ",")
                response = "\n[" .. k .. " " .. words[1] .. " - " .. words[2] .. " - " .. words[3] .. "]"
                if bool then
                    bool = false
                    rprint(PlayerIndex, "[ID - Name - Hash - IP]")
                end
                rprint(PlayerIndex, response)
            end
        end
    else
        rprint(PlayerIndex, "Invalid Syntax. Correct usage is: /bos [player] | /bos [list]")
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
