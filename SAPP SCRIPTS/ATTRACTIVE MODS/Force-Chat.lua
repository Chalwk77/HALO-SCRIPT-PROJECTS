--[[
--=====================================================================================================--
Script Name: Force Chat, for SAPP (PC & CE)
Description: Force a player to say something.

             Syntax: /fc <player> <message>
             Example: /fc 1 Hello World!
             Output: Player 1 will say "Chalwk: Hello World!"

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local ForceChat = {

    -- Custom command used to force a player to say something:
    command = 'fc',

    -- Minimum permission level required to use the command:
    --
    permission_level = 1,

    -- Chat message format:
    --
    format = '$name: $msg',

    -- A message relay function temporarily removes the "msg_prefix" and will
    -- restore it to this when finished:
    --
    prefix = '**SAPP**'
}

api_version = '1.12.0.0'

local players = { }

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

function ForceChat:NewPlayer(o)
    setmetatable(o, self)
    self.__index = self
    return o
end

function ForceChat:HasPerm()
    return (tonumber(get_var(self.id, "$lvl")) >= self.permission_level)
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        players = {}
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnJoin(Ply)
    players[Ply] = ForceChat:NewPlayer({
        id = Ply,
        name = get_var(Ply, '$name')
    })
end

function OnQuit(Ply)
    players[Ply] = nil
end

local function CMDSplit(s)
    local args = {}
    for arg in s:gmatch('([^%s]+)') do
        args[#args + 1] = arg:lower()
    end
    return args
end

function OnCommand(Ply, CMD)
    local args = CMDSplit(CMD)
    local player = players[Ply]
    if (args and player) then

        local command = (args[1]:sub(1, player.command:len()) == player.command)
        local victim = (args[2] and tonumber(args[2]:match('%d+')))

        if (not victim) then
            rprint(Ply, 'Usage: /fc <player> <message>')
            return false
        elseif (command) then

            if (player:HasPerm()) then

                if (victim and player_present(victim)) then

                    local message = table.concat(args, ' ', 3)
                    if (message and message ~= '') then
                        local name = players[victim].name
                        local format = player.format
                        execute_command('msg_prefix ""')
                        say_all(format:gsub('$name', name):gsub('$msg', message))
                        execute_command('msg_prefix "' .. player.prefix .. '"')
                    else
                        rprint(Ply, 'Usage: /fc <player> <message>')
                    end
                else
                    rprint(Ply, 'Player #' .. victim .. ' is not online.')
                end
            else
                rprint(Ply, 'Insufficient Permission')
            end
            return false
        end
    end
end

function OnScriptUnload()
    -- N/A
end