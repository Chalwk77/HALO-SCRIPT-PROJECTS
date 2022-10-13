-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = { }

-- Spawns a flag object.
-- @arg [number] x - x-coordinate
-- @arg [number] y - y-coordinate
-- @arg [number] z - z-coordinate
local function SpawnFlag(x, y, z)
    local z_off = 0.2
    spawn_object('weap', 'weapons\\flag\\flag', x, y, z + z_off)
end

-- Setup function called when a new game begins:
function Event:OnStart()

    self.map = get_var(0, '$map')
    if (get_var(0, '$gt') == 'n/a' or not self[self.map]) then
        return
    end

    execute_command('disable_object "weapons\\flag\\flag" 0')
    execute_command('disable_object "weapons\\ball\\ball" 0')

    self.players = {}
    self.objects = {}

    for i = 1, 16 do
        if player_present(i) then
            self:OnJoin(i)
        end
    end

    local start = self[self.map].start
    local finish = self[self.map].finish

    self.map_checkpoints = self[self.map].checkpoints

    self.starting_line = {
        { -- point A
            x = start[1],
            y = start[2],
            z = start[3]
        },
        { -- point B
            x = start[4],
            y = start[5],
            z = start[6]
        }
    }

    self.finish_line = {
        { -- point A
            x = finish[1],
            y = finish[2],
            z = finish[3]
        },
        { -- point B
            x = finish[4],
            y = finish[5],
            z = finish[6]
        }
    }

    -- Spawn flags to represent the start/finish lines:
    if (self.spawn_flags) then
        for i = 1, 2 do

            local x1, y1, z1 = self.starting_line[i].x, self.starting_line[i].y, self.starting_line[i].z
            local x2, y2, z2 = self.finish_line[i].x, self.finish_line[i].y, self.finish_line[i].z

            SpawnFlag(x1, y1, z1)
            SpawnFlag(x2, y2, z2)
        end
    end

    -- Spawn an oddball to represent a checkpoint:
    for i = 1, #self.map_checkpoints do
        local checkpoint = self.map_checkpoints[i]
        if (checkpoint) then
            local x, y, z = checkpoint[1], checkpoint[2], checkpoint[3]
            local object = spawn_object('weap', 'weapons\\ball\\ball', x, y, z + 0.2)
            self.objects[object] = {
                x = x,
                y = y,
                z = z + 0.2
            }
        end
    end
end

register_callback(cb['EVENT_GAME_START'], 'OnStart')

return Event