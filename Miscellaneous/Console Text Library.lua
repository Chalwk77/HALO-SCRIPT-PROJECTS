--[[
--=====================================================================================================--
Script Name: Console Text Override, for SAPP (PC & CE)
Description: This library will print defined messages for a specified period of time.

Important: This library MUST be placed inside your servers root directory (the same directory where sapp.dll is located).
Ensure the file name matches exactly "Console Text Library.lua".

Initialize this library like so:
1). Place this at the top of your script:
local ConsoleText = (loadfile "Console Text Library.lua")()

2). Place this inside the function registered to EVENT_TICK.
ConsoleText:GameTick()

Creating a new message:
ConsoleText:NewMessage(PID, "MESSAGE STRING", 10, "|l", true)

or 
ConsoleText:NewMessage(PID, table_of_strings, 10, "|l", true)

ConsoleText:NewMessage expects 5 parameters:
Target Player ID
Message Content (string or table of strings)
Message Duration
Message Alignment ("|l", "|r", "|c", "|t" = Left, Right, Center, Tab)
Console-Clear boolean (true/false)

Copyright (c) 2020-2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local time_scale = 1 / 30

local ConsoleText = { messages = {} }
function ConsoleText:NewMessage(Player, Content, Time, Alignment, Clear)
    self.messages[#self.messages + 1] = {
        player = Player,
        content = Content,
        timer = Time,
        clear = Clear,
        alignment = Alignment or "|l"
    }
end

function ConsoleText:GameTick()
    if (#self.messages > 0) then
        for k, v in pairs(self.messages) do
            if (v.player) then
                if player_present(v.player) then
                    v.timer = v.timer - time_scale
                    if (v.timer <= 0) then
                        self.messages[k] = nil
                        return
                    elseif (v.clear) then
                        for _ = 1, 25 do
                            rprint(v.player, " ")
                        end
                    end
					if type(v.content == "table") then
						for i = 1,#v.content do
							rprint(v.player, v.alignment .. " " .. v.content[i])
						end
					else
						rprint(v.player, v.alignment .. " " .. v.content)
					end
                else
                    self.messages[k] = nil
                end
            end
        end
    end
end

return ConsoleText