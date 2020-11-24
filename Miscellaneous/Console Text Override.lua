-- Console Text Override for SAPP, by Chalwk
-- This library will print defined messages for a specified period of time.

-- Usage:
-- 1). Init library like so:
-- local ConsoleText = (loadfile "Console Text Library.lua")()

-- 2). Put ConsoleText:GameTick() inside of your EVENT_TICK function.

-- 3). Create a new message like so:
-- ConsoleText:NewMessage(PID, "MESSAGE STRING", 10, "|l", true)
-- ConsoleText:NewMessage expects 5 parameters:
-- . Target Player ID
-- . Message String
-- . Message Duration
-- . Message Alignment ("|l", "|r", "|c", "|t" = Left, Right, Center, Tab)
-- . Console-Clear boolean (true/false)

local ConsoleText = { messages = {} }
local time_scale = 1 / 30

function ConsoleText:NewMessage(Player, String, Time, Alignment, Clear)
    self.messages[#self.messages + 1] = {
        player = Player,
        content = String,
        timer = Time,
        clear = Clear,
        alignment = Alignment or "|l"
    }
end

function ConsoleText:GameTick()
    if (#self.messages > 0) then
        for k, v in pairs(self.messages) do
            v.timer = v.timer - time_scale
            if (v.timer <= 0) then
                self.messages[k] = nil
                return
            elseif (v.clear) then
                for _ = 1, 25 do
                    rprint(v.player, " ")
                end
            end
            rprint(v.player, v.alignment .. " " .. v.content)
        end
    end
end

return ConsoleText