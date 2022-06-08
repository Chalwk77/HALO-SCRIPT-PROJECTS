--[[
--=====================================================================================================--
Script Name: RegToPlay, for SAPP (PC & CE)
Description: Players have to register a username (bound to their IP) within 10 seconds after joining, otherwise, they will be kicked.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local RegToPlay = {

    kick_delay = 10, -- in seconds
    --

    command = 'cow2',
    password = 'listen0',
    --

    permission_level = -1,
    --

    file = 'players.txt',
    --

    --
    -- If true, user data will only be saved to players.txt when a game ends.

    -- This means the data ip|user is cached in a table until the game ends.
    -- Then we do an i/o that saves it to players.txt.

    -- Recommended for larger databases,
    -- otherwise, the i/o operation may cause a lag spike during gameplay.

    -- This does, however, mean that if the server crashes, the cached session
    -- will never be saved because event_game_end was never fired.
    -- In which case, the user will have to register again when the server is rebooted.
    save_on_register = false
}

api_version = '1.12.0.0'

local players, database = {}, {}
local time, open = os.time, io.open

function RegToPlay:NewPlayer(o)

    setmetatable(o, self)
    self.__index = self

    o.start = time
    o.finish = time() + self.kick_delay

    return o
end

function RegToPlay:HasPerm()
    local lvl = tonumber(get_var(self.id, '$lvl'))
    return (lvl == 0 or lvl >= self.permission_level)
end

local function StrSplit(str, d)
    local t = { }
    for arg in str:gmatch('([^' .. d .. ']+)') do
        t[#t + 1] = arg
    end
    return t
end

function RegToPlay:Write()
    local path = RegToPlay.dir
    local file = open(path, 'w')
    for ip, name in pairs(database) do
        file:write(ip .. '|' .. name .. '\n')
    end
    file:close()
end

function RegToPlay:RegisterThisUser()

    database[self.ip] = self.name

    if (self.save_on_register) then
        self:Write()
    end

    say(self.id, 'Username successfully registered.')
    players[self.id] = nil
end

function OnScriptLoad()

    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')

    if (not RegToPlay.save_on_register) then
        register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    end

    local path = read_string(read_dword(sig_scan('68??????008D54245468') + 0x1))
    RegToPlay.dir = path .. '\\sapp\\' .. RegToPlay.file

    OnStart()
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        local path = RegToPlay.dir
        local file = open(path, 'a')
        if (not file) then
            return
        end
        file:close()

        file = open(path, 'r')
        for line in file:lines() do
            local users = StrSplit(line, '|')
            database[users[1]] = users[2] -- [1] IP, [2] Username
        end
        file:close()

        players = {}
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnEnd()
    self:Write()
end

function OnJoin(P)
    local ip = get_var(P, '$ip'):match('%d+.%d+.%d+.%d+')
    local name = get_var(P, '$name')
    if (database[ip] == nil or database[ip] ~= name) then
        local delay = RegToPlay.kick_delay
        say(P, 'Please register a new username within ' .. delay .. ' seconds.')
        players[P] = RegToPlay:NewPlayer({
            id = P,
            ip = ip,
            name = name
        })
    end
end

function OnQuit(P)
    players[P] = nil
end

function OnTick()
    for i, v in pairs(players) do
        if (i and v.start() >= v.finish) then
            execute_command('k ' .. i .. ' "Not registered to this server!"')
        end
    end
end

function OnCommand(P, CMD)
    local args = StrSplit(CMD, '%s')
    local p = players[P]
    if (p and args and args[1] == p.command) then
        if not p:HasPerm() then
            say(p.id, 'Server says no!')
        elseif (args[2] == p.password) then
            p:RegisterThisUser()
        else
            say(p.id, 'Server says no!')
        end
        return false
    end
end

function OnScriptUnload()
    -- N/A
end