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

    local iterations = 0
    for i = 0, 360 do
        if (i > iterations) then
            iterations = iterations + 360 / total_flags
            local angle = i * math.pi / 180
            local x1 = x + radius * math.cos(angle)
            local y1 = y + radius * math.sin(angle)
            local z1 = z + height
            spawn_object('weap', 'weapons\\flag\\flag', x1, y1, z1)
        end
    end
end

function OnScriptUnload()
    -- N/A
end