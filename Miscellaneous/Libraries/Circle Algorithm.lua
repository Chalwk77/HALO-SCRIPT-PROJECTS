api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
end

function OnGameStart()

    local r = 3
    local x, y, z = 79.48, -118.68, 0.24

    local iterations = 0
    for i = 0, 360 do
        if (i > iterations) then
            iterations = iterations + 22.5
            local angle = i * math.pi / 180
            local px = x + r * math.cos(angle)
            local py = y + r * math.sin(angle)
            spawn_object("weap", "weapons\\flag\\flag", px, py, z + 0.3)
        end
    end
end

function OnScriptUnload()
    -- N/A
end