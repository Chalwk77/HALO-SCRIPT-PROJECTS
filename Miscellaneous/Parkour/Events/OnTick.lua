-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = { }

-- Clears the player's rcon buffer:
local function cls(p)
    for _ = 1, 25 do
        rprint(p, ' ')
    end
end

local function getPos(dyn)
    local x, y, z
    local vehicle = read_dword(dyn + 0x11C)
    local object = get_object_memory(vehicle)
    if (vehicle == 0xFFFFFFFF) then
        x, y, z = read_vector3d(dyn + 0x5C)
    elseif (object ~= 0) then
        x, y, z = read_vector3d(object + 0x5C)
    end
    return x, y, z
end

-- Called every 1/30th second:
-- Checks if a player has intersected with the start/finish line.
-- Starts/stops the player timer.
-- Saves the player's time.
-- Prints their time on the screen.
function Event:OnTick()

    self:Anchor()

    for i, v in ipairs(self.players) do

        local dyn = get_dynamic_player(i)
        if (player_alive(i) and dyn ~= 0) then

            if (not v.timer.paused) then

                local px, py, pz = getPos(dyn)
                v:reachedCheckpoint(px, py, pz)

                -- Start the timer if the player has intersected with the start line:
                if (not v.timer.start_time and v:lineIntersect(px, py, pz, v.starting_line)) then
                    v.timer:start()
                    v:NewHud("")


                    -- End the timer if the player has intersected with the finish line:
                elseif (v.timer.start_time and v:lineIntersect(px, py, pz, v.finish_line)) then
                    say_all(v.name .. " completed the course in " .. v:getTimeFormat() .. " seconds")
                    v:saveTime()

                    -- Update player hud:
                elseif (v.hud) then

                    local str = self.heads_up_display

                    str = str:gsub("$time", v:getTimeFormat())
                    str = str:gsub("$checkpoint", v.checkpoint)
                    str = str:gsub("$best", v:getBestTime())

                    cls(v.id)
                    rprint(v.id, str)
                end
            end
        end
    end
end

-- Register the event:
register_callback(cb['EVENT_TICK'], 'OnTick')

return Event