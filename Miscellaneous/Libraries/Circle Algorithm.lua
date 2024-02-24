api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
end

function OnGameStart()

    -- Number of flags to spawn:
    local total_flags = 16

    -- height added to the z-axis:
    local height = 2

    -- Spacing between flags:
    local radius = 3 --self.boundary_size

    -- Circle center point:
    local x, y, z = 79.48, -118.68, 0.24

    -- Iterations is used to determine the angle of each flag:
    local iterations = 0

    -- Loop through 360 degrees and spawn a flag every 22.5 degrees:
    for i = 0, 360 do
        -- If the iteration is greater than 360 / total_flags, then spawn a flag:
        if (i > iterations) then
            iterations = iterations + 360 / total_flags

            -- Convert the angle to radians:
            local angle = i * math.pi / 180

            -- Calculate the x, y, and z coordinates for the flag:
            local x1 = x + radius * math.cos(angle)
            local y1 = y + radius * math.sin(angle)
            local z1 = z + height

            -- Spawn the flag:
            spawn_object('weap', 'weapons\\flag\\flag', x1, y1, z1)
        end
    end
end

function OnScriptUnload()
    -- N/A
end