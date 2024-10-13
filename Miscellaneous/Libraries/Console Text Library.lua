--[[
--=====================================================================================================--
Script Name: Console Text Override for SAPP (PC & CE)
Description: This library allows sending timed RCON messages to players.
             Console messages appear for a specified duration.

Configuration Steps:
1. Place 'Console Text Library.lua' in the server's root directory (same location as sapp.dll).
   Do not change the name of the .lua file.

2. At the top of your Lua script, include the library:
   local ConsoleText = loadfile("Console Text Library.lua")()

3. In the function registered to EVENT_TICK, call:
   ConsoleText:GameTick()

4. To create a new message, use:
   ConsoleText:NewMessage(pid, message, duration, clear)

   pid      = Player ID [number]
   message  = Message string or table of strings, e.g., {string, string, string}
   duration = Time [number] (in seconds) the message will appear on screen
   clear    = Boolean [true/false] Clear the player's RCON console before sending the message.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
License: You can use this script subject to the conditions specified here:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local time = os.time
local ConsoleText = {
    messages = {},
}

--- Creates a new message for a player.
-- @param playerID Number: The player ID to send the message to.
-- @param content String | Table: The message content (string or table of strings).
-- @param duration Number: Time (in seconds) the message will be displayed.
-- @param clear Boolean: Clear the player's RCON console before sending the message.
function ConsoleText:NewMessage(playerID, content, duration, clear)
    local messageData = {
        player = playerID,
        clear = clear,
        content = content,
        finish = time() + duration,
        stdout = function(p, m, c)
            if c then
                for _ = 1, 25 do
                    rprint(p, ' ') -- Clear previous messages
                end
            end
            if type(m) == 'table' then
                for _, msg in ipairs(m) do
                    rprint(p, msg) -- Print each message in the table
                end
            else
                rprint(p, m) -- Print single message
            end
        end,
    }

    table.insert(self.messages, messageData)
end

--- Handles game ticks to update message display.
function ConsoleText:GameTick()
    for index = #self.messages, 1, -1 do
        local messageData = self.messages[index]
        if not player_present(messageData.player) or time() >= messageData.finish then
            table.remove(self.messages, index) -- Remove expired messages
        else
            messageData.stdout(messageData.player, messageData.content, messageData.clear) -- Display message
        end
    end
end

return ConsoleText