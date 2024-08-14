-- This module is responsible for creating checkpoints using map-specific settings.
-- The checkpoints are represented by oddballs spawned at specific coordinates.
-- The 'checkpoint' table contains functions related to checkpoint management.
local checkpoint = {}

-- Function to spawn an oddball at the given coordinates using SAPP's built-in 'spawn_object' function.
-- Parameters:
--   - x: The x-coordinate of the oddball.
--   - y: The y-coordinate of the oddball.
--   - z: The z-coordinate of the oddball.
-- Returns:
--   - object: The spawned oddball object.
local function spawnOddball(x, y, z)
    return spawn_object('weap', 'weapons\\ball\\ball', x, y, z)
end

-- Function to create checkpoints using map-specific settings.
-- Parameters:
--   - self: The parent table containing map-specific settings.
function checkpoint:createCheckpoints()

    -- Get the checkpoints from the map-specific settings.
    local checkpoints = self[self.map].checkpoints

    -- Set the offset for the z-coordinate to spawn oddballs above the terrain.
    local z_off = 0.3

    -- If checkpoints exist, create oddballs at their coordinates.
    if checkpoints then

        -- Iterate over the checkpoints using 'ipairs'.
        for _, coord in ipairs(checkpoints) do

            -- Extract coordinates from the checkpoint table.
            local x, y, z = coord[1], coord[2], coord[3]

            -- Spawn an oddball at the checkpoint coordinates with the z-offset.
            local object = spawnOddball(x, y, z + z_off)

            -- Store the spawned oddball's coordinates in the 'self.oddballs' table.
            -- Used to anchor the oddball to the checkpoint.
            self.oddballs[object] = {
                x = x,
                y = y,
                z = z + z_off
            }
        end
    end
end

-- Return the 'checkpoint' table.
return checkpoint