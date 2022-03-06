--[[
--=====================================================================================================--
Script Name: Console Text Override, for SAPP (PC & CE)
Description: This library lets you send timed rcon messages to a player.
             Console messages appear for

Steps to configure:

1.  Place 'Console Text Library.lua' in the server's root directory (same location as sapp.dll).
    Do not change the name of the .lua file.

2.  Place this at the top of your Lua script:
    local ConsoleText = (loadfile "Console Text Library.lua")()

3.  Place this inside the function registered to EVENT_TICK.
    ConsoleText:GameTick()

4.  Creating a new message:
    ConsoleText:NewMessage(pid, m, duration)

    pid      =  player id [number]
    m        =  message string or table of strings, e.g {string, string, string, string}
    duration =  time [number] (in seconds) a message will appear on screen.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local time = os.time

local ConsoleText = { messages = {} }
function ConsoleText:NewMessage(Ply, Content, Duration)
    self.messages[#self.messages + 1] = {
        player = Ply,
        content = Content,
        finish = time() + Duration,
        stdout = function(p, m)
            for _ = 1, 25 do
                rprint(p, ' ')
            end
            if (type(m) == 'table') then
                for _ = 1, #m do
                    rprint(p, m)
                end
            else
                rprint(p, m)
            end
        end
    }
end

function ConsoleText:GameTick()
    for k, v in pairs(self.messages) do
        if (not player_present(v.player) or time() >= v.finish) then
            self.messages[k] = nil
        else
            v.stdout(v.player, v.content)
        end
    end
end

return ConsoleText