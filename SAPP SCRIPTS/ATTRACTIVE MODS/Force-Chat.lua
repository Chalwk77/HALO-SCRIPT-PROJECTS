--[[
--=====================================================================================================--
Script Name: Force Chat, for SAPP (PC & CE)
Description: Force a player to say something.

             Syntax: /fc <player> <message>
             Example: /fc 1 Hello World!
             Output: Player 1 will say "Chalwk: Hello World!"

             Note: For players using Chimera, fake chat messages will appear as server messages, thus will be obvious they're fake.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- Custom command used to force a player to say something:
local command = 'fc'

-- Minimum permission level required to use the command:
--
local permission_level = 1

-- Chat message format:
--
local format = '$name: $msg'

-- A message relay function temporarily removes the "msg_prefix" and will
-- restore it to this when finished:
--
local prefix = '**SAPP**'

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
end

local function HasPerm(Ply)
    return (Ply == 0 and true or tonumber(get_var(Ply, "$lvl")) >= permission_level)
end

local function CMDSplit(s)
    local args = {}
    for arg in s:gmatch('([^%s]+)') do
        args[#args + 1] = arg:lower()
    end
    return args
end

local function Say(Ply, Msg)
    return (Ply == 0 and cprint(Msg) or rprint(Ply, Msg))
end

function OnCommand(Ply, CMD)
    local args = CMDSplit(CMD)
    if (args) then

        local cmd = (args[1]:sub(1, command:len()) == command)
        if (cmd) then
            local victim = (args[2] and tonumber(args[2]:match('%d+')))

            if (not victim or not args[3]) then
                Say(Ply, 'Usage: /fc <player> <message>')
                return false
            elseif (cmd) then

                if (HasPerm(Ply)) then

                    if (victim and player_present(victim)) then

                        local message = table.concat(args, ' ', 3)
                        if (message and message ~= '') then
                            local name = get_var(victim, '$name')
                            execute_command('msg_prefix ""')
                            say_all(format:gsub('$name', name):gsub('$msg', message))
                            execute_command('msg_prefix "' .. prefix .. '"')
                        else
                            Say(Ply, 'Usage: /fc <player> <message>')
                        end
                    else
                        Say(Ply, 'Player #' .. victim .. ' is not online.')
                    end
                else
                    Say(Ply, 'Insufficient Permission')
                end
                return false
            end
        end
    end
end

function OnScriptUnload()
    -- N/A
end