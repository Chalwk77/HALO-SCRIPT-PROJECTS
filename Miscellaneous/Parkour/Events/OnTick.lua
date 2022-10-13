-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = { }

-- Clears the player's rcon buffer:
local function cls(p)
    for _ = 1, 25 do
        rprint(p, ' ')
    end
end

-- Called every 1/30th second:
-- Checks if a player has intersected with the start/finish line.
-- Starts/stops the player timer.
-- Saves the player's time.
-- Prints their time on the screen.
function Event:OnTick()
    for i, v in ipairs(self.players) do

        local dyn = get_dynamic_player(i)
        if (player_alive(i) and dyn ~= 0) then

            local px, py, pz = read_vector3d(dyn + 0x5C)

            if (not v.timer.start_time and v:lineIntersect(px, py, pz, v.starting_line)) then
                v.timer:start()
            elseif (v.timer.start_time and v:lineIntersect(px, py, pz, v.finish_line)) then
                say_all(v.name .. " completed the course in " .. v:getTimeFormat() .. " seconds")
                v:saveTime()
                v.timer:stop()
            elseif (v.timer.start_time) then
                cls(i)
                rprint(i, "Time: " .. v:getTimeFormat())
            end
        end
    end
end

-- Register the event:
register_callback(cb['EVENT_TICK'], 'OnTick')

return Event