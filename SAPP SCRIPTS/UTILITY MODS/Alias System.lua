--[[
--=====================================================================================================--
Script Name: Alias System, for SAPP (PC & CE)
Description: Query a player's hash to check what aliases have been used with it.

Command syntax: /alias [id]

* Coming in a future update:
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

-- How long should the alias results be display for? (in seconds) --
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
    for i = 1, 1 do
        if player_present(i) then
            if (trigger[i] == true) then
                players[get_var(i, "$n")].new_timer = players[get_var(i, "$n")].new_timer + 0.030
                cls(i)
                local lines = lines_from("sapp\\" .. file_name)
                for k, v in pairs(lines) do
                    local hash = tostring(get_var(index, "$hash"))
                    if v:match(hash) then
                        local aliases = string.match(v, (":(.+)"))
                        rprint(i, 'Showing aliases for: "' .. hash .. '"')
                        rprint(i, "Aliases: " .. aliases)
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
    if not string.match(data, hash) then
        local file = assert(io.open("sapp\\" .. file_name, "a+"))
        file:write(hash .. ":" .. name, "\n")
        file:close()
    else
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
            if t[2] == string.match(t[2], "[A-Za-z]") then
                cls(PlayerIndex)
                rprint(PlayerIndex, "Invalid player id")
            else
                if player_present(tonumber(t[2])) then
                    index = tonumber(t[2])
                    if trigger[PlayerIndex] == true then
                        trigger[PlayerIndex] = false
                        cls(PlayerIndex)
                    else
                        trigger[PlayerIndex] = true
                    end
                else
                    trigger[PlayerIndex] = false
                    cls(PlayerIndex)
                    rprint(PlayerIndex, "Player not present")
                end
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
