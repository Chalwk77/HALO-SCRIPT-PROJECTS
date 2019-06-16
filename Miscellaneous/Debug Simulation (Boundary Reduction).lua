-- Debug Simulation of a working Zone Reduction prototype for a custom gamemode called Battle Royale for Halo PC|CE.
-- By Jericho Crosby (Chalwk)

api_version = "1.12.0.0"
local game_timer, reduction_timer = 0,0
local time_scale = 0.03333333333333333

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
end

local min_size, max_size = 20, 1250
local reduction_rate, reduction_amount = 15, 300
local game_time, bonus_time = 0, 2
local bR = max_size

local radius = max_size
local expected_reductions
for i = 1,max_size do
    if (radius <= max_size) then
        radius = (radius - reduction_amount)
        if (radius < min_size) then
            local offset = math.abs(radius)
            local calculated_max = (max_size + offset)
            local extra_time = (bonus_time * 60)
            game_time = (reduction_rate * (calculated_max / reduction_amount) + extra_time)
            expected_reductions = (i)
            break
        end
    end
end

function OnTick()
    local countdown = os.clock() -- delay the simulation by 2 seconds.
    if (countdown >= 2) then
        if (game_timer ~= nil) then
            game_timer = game_timer + time_scale
            
            local time = ((game_time + 1) - (game_timer))
            local minutes, seconds = select(1, secondsToTime(time)), select(2, secondsToTime(time))
            local time_remaining = ("G TIME: " .. minutes .. ":" .. seconds)
            
            local until_next_shrink
            if (reduction_timer ~= nil) then
                reduction_timer = reduction_timer + time_scale
                
                local time_left = ((reduction_rate + 1) - (reduction_timer))
                local mins, secs = select(1, secondsToTime(time_left)), select(2, secondsToTime(time_left))
                
                local calculated_radius = (bR - reduction_amount)
                if (calculated_radius <= 0) then 
                    calculated_radius = calculated_radius + min_size
                end

                until_next_shrink = ("REDUCTION T: " .. mins .. ":" .. secs .. " | bR: " .. bR .. " -> " .. calculated_radius .. "/" .. min_size .. " | Reductions Left: " .. expected_reductions)
     
                if (reduction_timer >= (reduction_rate)) then
                    reduction_timer = 0                
                    if (bR <= max_size) then
                        bR = (bR - reduction_amount)
                        if (bR <= min_size) then
                            bR, reduction_timer = min_size, nil
                            game_timer = nil
                            cprint("BOUNDRY IS NOW AT ITS SMALLEST POSSIBLE SIZE!", 5 + 8)
                            cprint(time_remaining .. " | REDUCTION IN: " .. until_next_shrink .. " BR: " .. bR, 5 + 8)
                        else
                            expected_reductions = expected_reductions - 1
                            cprint("[ BOUNDRY REDUCTION ] Radius now (" .. bR .. ") world units", 6 + 8)
                        end       
                    end
                end
            end
            
            local header
            if (until_next_shrink == nil) then
                header = ""
            else
                header = " | " .. until_next_shrink
            end

            cprint(time_remaining .. header, 2+8)
        end
    end
end

local floor, format = math.floor, string.format
function secondsToTime(seconds)
    local seconds = tonumber(seconds)
    if (seconds <= 0) then
        return "00", "00";
    else
        local hours, mins, secs = format("%02.f", floor(seconds / 3600));
        mins = format("%02.f", floor(seconds / 60 - (hours * 60)));
        secs = format("%02.f", floor(seconds - hours * 3600 - mins * 60));
        return mins, secs
    end
end

function OnScriptUnload()

end
