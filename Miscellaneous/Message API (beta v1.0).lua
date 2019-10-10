--[[
--=====================================================================================================--
Script Name: Message API (beta v1.0), for SAPP (PC & CE)


Call this to init a new timed message:
API:NewMessage(Message, Duration, Player, Type)

* Message (string) is the message to display
* Duration (number) is the amount of time that message will appear on screen
* Player (number) is the target player index

* Type ("string", "table")
This script supports tables in place of Message and will output the contents of it.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local API = { }
local delta_time = 0.03333333333333333

function OnScriptLoad()
    if (get_var(0, '$gt') ~= 'n/a') then
        API = { }
    end
    register_callback(cb["EVENT_TICK"], "OnTick")
end

function API:NewMessage(Message, Duration, Player, Type)

    API.Messages = API.Messages or { }

    local function Add(a, b, c, d)
        return {
            message = a,
            duration = b,
            player = c,
            type = d,
            time = 0,
        }
    end

    table.insert(API.Messages, Add(Message, Duration, Player, Type))
end

function API:Pause(PlayerIndex)
    for k,v in pairs(messages) do
        if (v.player == PlayerIndex) then
            v.paused = true
        end
    end
end

function API:ClearConsole(PlayerIndex, Buffer)
    local Buffer = Buffer or 25
    for _ = 1,Buffer do
        rprint(PlayerIndex, " ")
    end
end

function OnTick()

    local messages = API.Messages

    if (#messages > 0) then
        for k,v in pairs(messages) do
            if v.player and player_present(v.player) then
                
                if (not v.paused) then
                    v.time = v.time + delta_time
                    
                    API:ClearConsole(v.player, 25)
                    
                    if type(v.message) == "table" then
                        for i = 1,#v.message do                    
                            rprint(v.player, v.message[i])
                        end
                    else                    
                        rprint(v.player, v.message)
                    end
                    
                    if (v.time >= v.duration) then
                        messages[k] = nil
                    end
                else
                    
                    v.pause_timer = v.pause_timer + delta_time
                    v.time = v.duration
                    
                    if (v.pause_timer >= 5) then
                        v.paused = false
                    end
                end
            end
        end
    end
end

return API
