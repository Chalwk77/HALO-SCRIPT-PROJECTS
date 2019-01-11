--[[
--=====================================================================================================--
Script Name: Alias System, for SAPP (PC & CE)
Description: Query a player's hash to check what aliases have been used with it.

Command syntax: /alias [id]

* Coming in a future update:
    - ip search feature
    - name search feature
    - hash search feature

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"

-- configuration starts
file_name = "alias.lua" -- File is saved to server root dir/sapp/alias.lua
base_command = "alias"

-- How long should the alias results be displayed for? (in seconds) --
duration = 10

-- Message Alignment:
-- Left = l,    Right = r,    Center = c,    Tab: t
Message_Alignment = "l"

-- minimum admin level required to use /alias command
min_admin_level = 1
-- configuration ends

-- do not touch
trigger = { }
new_timer = { }
players = { }
index = nil

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    checkFile()
    for i = 1, 16 do
        if player_present(i) then
            players[get_var(i, "$n")].new_timer = 0
        end
    end
end

function OnScriptUnload()

end

function OnPlayerJoin(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    addAlias(name, hash)
    players[get_var(PlayerIndex, "$n")] = { }
    players[get_var(PlayerIndex, "$n")].new_timer = 0
end

function OnPlayerLeave(PlayerIndex)
    trigger[PlayerIndex] = false
    players[get_var(PlayerIndex, "$n")].new_timer = 0
end

function OnNewGame()
    for i = 1, 16 do
        if player_present(i) then
            if player_present(i) then
                trigger[i] = false
                players[get_var(i, "$n")].new_timer = 0
            end
        end
    end
end

function OnGameEnd()
    for i = 1, 16 do
        if player_present(i) then
            if player_present(i) then
                trigger[i] = false
                players[get_var(i, "$n")].new_timer = 0
            end
        end
    end
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            if (trigger[i] == true) then
                players[get_var(i, "$n")].new_timer = players[get_var(i, "$n")].new_timer + 0.030
                cls(i)
                local lines = lines_from("sapp\\" .. file_name)
                for k, v in pairs(lines) do
                    local hash = tostring(get_var(index, "$hash"))
                    if v:match(hash) then
                        local aliases = string.match(v, (":(.+)"))
                        local words = tokenizestring(aliases, ", ")
                        local word_table = {}
                        local row_1
                        local row_2
                        local row_3
                        local row_4
                        local row_5
                        
                        -- table indexes 1-6
                        for j = 1, 6 do
                            if words[j] ~= nil then
                                table.insert(word_table, words[j])
                                row_1 = table.concat(word_table, ", ")
                            end
                        end
                        if row_1 ~= nil then rprint(i, row_1) end
                        for _ in pairs(word_table) do word_table[_] = nil end

                        -- table indexes 7-12
                        for j = 7, 12 do
                            if words[j] ~= nil then
                                table.insert(word_table, words[j])
                                row_2 = table.concat(word_table, ", ")
                            end
                        end
                        if row_2 ~= nil then rprint(i, row_2) end
                        for _ in pairs(word_table) do word_table[_] = nil end

                        -- table indexes 13-18
                        for j = 13, 18 do
                            if words[j] ~= nil then
                                table.insert(word_table, words[j])
                                row_3 = table.concat(word_table, ", ")
                            end
                        end
                        if row_3 ~= nil then rprint(i, row_3) end
                        for _ in pairs(word_table) do word_table[_] = nil end
                        
                        -- table indexes 19-24
                        for j = 19, 24 do
                            if words[j] ~= nil then
                                table.insert(word_table, words[j])
                                row_4 = table.concat(word_table, ", ")
                            end
                        end
                        if row_4 ~= nil then rprint(i, row_4) end
                        for _ in pairs(word_table) do word_table[_] = nil end
                        
                        -- table indexes 25-30
                        for j = 25, 30 do
                            if words[j] ~= nil then
                                table.insert(word_table, words[j])
                                row_5 = table.concat(word_table, ", ")
                            end
                        end
                        if row_5 ~= nil then rprint(i, row_5) end
                        for _ in pairs(word_table) do word_table[_] = nil end
                        
                        rprint(i, "|" .. Message_Alignment .. " " .. 'Showing aliases for: "' .. hash .. '"')
                        break
                    end
                end
                if players[get_var(i, "$n")].new_timer >= math.floor(duration) then
                    trigger[i] = false
                    players[get_var(i, "$n")].new_timer = 0
                end
            end
        end
    end
end

function addAlias(name, hash)
    local file = io.open("sapp\\" .. file_name, "r")
    local data = file:read("*a")
    file:close()
    if string.match(data, hash) then
        local lines = lines_from("sapp\\" .. file_name)
        for k, v in pairs(lines) do
            if string.match(v, hash) then
                if not v:match(name) then
                    local alias = v .. ", " .. name
                    local f = io.open("sapp\\" .. file_name, "r")
                    local content = f:read("*all")
                    f:close()
                    content = string.gsub(content, v, alias)
                    local f = io.open("sapp\\" .. file_name, "w")
                    f:write(content)
                    f:close()
                end
            end
        end
    else
        local file = assert(io.open("sapp\\" .. file_name, "a+"))
        file:write(hash .. ":" .. name, "\n")
        file:close()
    end
end

function checkFile()
    local file = io.open('sapp\\' .. file_name, "rb")
    if file then
        file:close()
    else
        local file = io.open('sapp\\' .. file_name, "a+")
        if file then
            file:close()
        end
    end
end

function OnServerCommand(PlayerIndex, Command)
    local t = tokenizestring(Command)
    if isAdmin(PlayerIndex) and t[1] == string.lower(base_command) then
        if t[2] ~= nil then
            if t[2] == string.match(t[2], "^%d+$") and t[3] == nil then
                if player_present(tonumber(t[2])) then
                    index = tonumber(t[2])
                    if trigger[PlayerIndex] == true then
                        cls(PlayerIndex)
                        players[get_var(PlayerIndex, "$n")].new_timer = 0
                        trigger[PlayerIndex] = true
                    else
                        trigger[PlayerIndex] = true
                    end
                else
                    players[get_var(PlayerIndex, "$n")].new_timer = 0
                    trigger[PlayerIndex] = false
                    cls(PlayerIndex)
                    rprint(PlayerIndex, "Player not present")
                end
            else
                players[get_var(PlayerIndex, "$n")].new_timer = 0
                trigger[PlayerIndex] = false
                cls(PlayerIndex)
                rprint(PlayerIndex, "Invalid player id")
            end
            return false
        else
            rprint(PlayerIndex, "Invalid syntax. Use /" .. base_command .. " [id]")
            return false
        end
    end
end

function isAdmin(PlayerIndex)
    if (tonumber(get_var(PlayerIndex, "$lvl"))) >= min_admin_level then
        return true
    else
        return false
    end
end

function lines_from(file)
    lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = { };
    i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function cls(PlayerIndex)
    for _ = 1, 25 do
        rprint(PlayerIndex, " ")
    end
end
