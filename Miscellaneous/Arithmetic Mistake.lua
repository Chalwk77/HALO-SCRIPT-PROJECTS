
api_version = "1.12.0.0"

-- :settings: -------------------------------------------------
local min_size, max_size = 50, 2500
local reduction_rate, reduction_amount = 30, 100
local bonus_time = 2
---------------------------------------------------------------

local bR, extra_time = max_size, 0
local game_time, game_timer = 0,0
local reduction_timer, time_scale = 0, 1

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
end

function OnGameStart()
    -- Convert 'extra_time' from -> minutes to -> seconds:
    extra_time = (bonus_time * 60)
    
    -- Calculated total game time:
    game_time = (reduction_rate * ((max_size - min_size) / reduction_amount))
    
    -- Game Time equals itelf plus 'extra_time':
    game_time = (game_time + extra_time) 
    
    -- Game time formula needs to be written such that at exactly the 2 minute mark (bonus_time mark), 
    -- the radius (bR) will be at its smallest possible size of 'min_size'.
end

local function DispayHUD(params)
    if (game_timer ~= nil) then
    
        local time_remaining = params.time
        local time_stamp = params.time_stamp
        local until_reduction = params.until_reduction

        local header, send_timestamp = ""
        if (time_remaining > extra_time) then
            send_timestamp = true
            header = "Time: " .. time_stamp
        elseif (time_remaining > 0) and (time_remaining <= extra_time) then
            send_timestamp = true
            header = "FINAL MINUTES: " .. time_stamp
        elseif (time_remaining <= 0) then
            send_timestamp = false
            game_timer = nil
        end
        
        local footer = " "
        if (reduction_timer ~= nil and until_reduction ~= nil) then
            footer = " | Reduction: " .. until_reduction .. " | bR: " .. bR .. " | Final: " .. min_size .. " | rRate: " .. reduction_amount
        else
            footer = ""
        end

        if (send_timestamp) then
            cprint(header .. footer)
        end
    end
end

function OnTick()
    if (game_timer ~= nil) then
        game_timer = game_timer + time_scale
    
        local game_time_left, until_reduction

        local time = ((game_time) - (game_timer))  
        local minutes, seconds = select(1, secondsToTime(time)), select(2, secondsToTime(time))
        local game_time_left = (minutes .. ":" .. seconds)
        
        if (reduction_timer ~= nil) then
            reduction_timer = reduction_timer + time_scale
            local time_left = ((reduction_rate) - (reduction_timer))
            local mins, secs = select(1, secondsToTime(time_left)), select(2, secondsToTime(time_left))
            until_reduction = (mins .. ":" .. secs)
            if (reduction_timer >= (reduction_rate)) then
                if (bR <= max_size) then
                    reduction_timer = 0
                    bR = (bR - reduction_amount)
                    if (bR <= min_size) then
                        bR = min_size
                        reduction_timer = nil
                        local Minutes, Seconds = select(1, secondsToTime(extra_time)), select(2, secondsToTime(extra_time))
                        local expected = (Minutes .. ":" .. Seconds)                        
                        cprint("bR (min_size): " ..  bR .. " | (Time Remaining: " .. game_time_left .. "  - expected: " .. expected .. ")", 2 + 8)
                    else
                        cprint("[ REDUCTION ] Radius now (" .. bR .. ") world units", 5 + 8)
                    end
                end
            end
        end
        
        local p = { }
        p.time, p.time_stamp, p.time_stamp, p.until_reduction = time, game_time_left, game_time_left, until_reduction
        DispayHUD(p)
    end
end

local floor, format = math.floor, string.format
function secondsToTime(seconds)
    local seconds = tonumber(seconds)
    if (seconds <= 0) then
        return "00", "00";
    else
        hours = format("%02.f", floor(seconds / 3600));
        mins = format("%02.f", floor(seconds / 60 - (hours * 60)));
        secs = format("%02.f", floor(seconds - hours * 3600 - mins * 60));
        return mins, secs
    end
end

function OnScriptUnload()
    --
end
