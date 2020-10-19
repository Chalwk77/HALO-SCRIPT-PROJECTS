api_version = "1.12.0.0"

-- Time until shields begin regenerating (in ticks) - 1/30th tick = 1 second
local delay = 0 -- 0 = instant

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
end

function OnScriptUnload()

end

function OnTick()
    for i = 1, 16 do
        if player_present(i) and player_alive(i) then
            local DyN = get_dynamic_player(i)
            if (DyN ~= 0) then
                if (read_float(DyN + 0xE4) < 1) then
                    write_word(DyN + 0x104, delay)
                end
            end
        end
    end
end