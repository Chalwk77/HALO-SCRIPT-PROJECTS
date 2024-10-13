--[[
--=====================================================================================================--
Script Name: RegToPlay, for SAPP (PC & CE)
Description: This script requires players to register within 10 seconds of joining the server.
Players must know the secret command and password to register. If they fail to register in time,
they will be kicked from the server. Registered player information, including IP and username,
is saved in a file called players.txt in the format: 127.0.0.1|name.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local RegToPlay = {
    kick_delay = 10,                -- Time allowed for registration in seconds
    command = 'command_here',       -- Command to trigger registration
    password = 'password_here',      -- Password for registration
    permission_level = -1,           -- Minimum permission level to register
    file = 'players.txt',            -- File to save registered players
    save_on_register = false,        -- Save user data only on game end if true
}

api_version = '1.12.0.0'

local players, database = {}, {}
local time, open = os.time, io.open

-- Create a new player entry
function RegToPlay:NewPlayer(o)
    setmetatable(o, self)
    self.__index = self
    o.start = time()
    o.finish = o.start + self.kick_delay
    return o
end

-- Check if player has the necessary permissions
function RegToPlay:HasPerm()
    local lvl = tonumber(get_var(self.id, '$lvl'))
    return (lvl == 0 or lvl >= self.permission_level)
end

-- Split a string based on a delimiter
local function StrSplit(str, delim)
    local result = {}
    for part in str:gmatch('([^' .. delim .. ']+)') do
        result[#result + 1] = part
    end
    return result
end

-- Write the player data to the specified file
function RegToPlay:Write()
    local file = open(RegToPlay.dir, 'w')
    if not file then
        return cprint("Error: Unable to open file for writing.")
    end
    for ip, name in pairs(database) do
        file:write(ip .. '|' .. name .. '\n')
    end
    file:close()
end

-- Register the current user
function RegToPlay:RegisterThisUser()
    database[self.ip] = self.name

    if self.save_on_register then
        self:Write()
    end

    say(self.id, 'Username successfully registered.')
    players[self.id] = nil  -- Remove player from the registration list
end

-- Load script and set up callbacks
function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')

    if not RegToPlay.save_on_register then
        register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    end

    local path = read_string(read_dword(sig_scan('68??????008D54245468') + 0x1))
    RegToPlay.dir = path .. '\\sapp\\' .. RegToPlay.file

    OnStart()
end

-- Initialize script state at game start
function OnStart()
    if get_var(0, '$gt') ~= 'n/a' then
        local file = open(RegToPlay.dir, 'a')
        if file then file:close() end  -- Ensure file can be accessed

        file = open(RegToPlay.dir, 'r')
        for line in file:lines() do
            local users = StrSplit(line, '|')
            database[users[1]] = users[2]  -- [1] IP, [2] Username
        end
        file:close()

        players = {}
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)  -- Initialize existing players
            end
        end
    end
end

-- Save data to file when the game ends
function OnEnd()
    RegToPlay:Write()
end

-- Handle player joining
function OnJoin(playerId)
    local ip = get_var(playerId, '$ip'):match('%d+.%d+.%d+.%d+')
    local name = get_var(playerId, '$name')

    if not database[ip] or database[ip] ~= name then
        say(playerId, 'Please register a new username within ' .. RegToPlay.kick_delay .. ' seconds.')
        players[playerId] = RegToPlay:NewPlayer({ id = playerId, ip = ip, name = name })
    end
end

-- Handle player quitting
function OnQuit(playerId)
    players[playerId] = nil
end

-- Periodically check for unregistered players
function OnTick()
    for playerId, player in pairs(players) do
        if time() >= player.finish then
            execute_command('k ' .. playerId .. ' "Not registered to this server!"')
        end
    end
end

-- Handle registration command from players
function OnCommand(playerId, command)
    local args = StrSplit(command, '%s')
    local player = players[playerId]
    if player and args[1] == player.command then
        if not player:HasPerm() then
            say(player.id, 'Server says no!')
        elseif args[2] == player.password then
            player:RegisterThisUser()
        else
            say(player.id, 'Invalid password.')
        end
        return false
    end
end

-- Cleanup on script unload
function OnScriptUnload()
    -- No specific cleanup required
end