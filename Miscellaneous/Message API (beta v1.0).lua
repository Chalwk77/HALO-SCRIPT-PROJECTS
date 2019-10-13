--[[
--=====================================================================================================--
Script Name: Message API (beta v1.0), for SAPP (PC & CE)

Call this to init a new timed message:
API:NewMessage(Message, Duration, Player, Type)

* Message (string/table) is the message (or array of messages) to display
* Duration (number) is the amount of time that message will appear on screen
* Player (number) is the target player index

* Type ("string", "table")
This script supports tables in place of Message and will output the contents of it.
Be sure to specify what input type it is.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local API = { }
API.Messages, delta_time = { }, 0.03333333333333333

function OnScriptLoad()
    if (get_var(0, '$gt') ~= 'n/a') then API = { } end
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
end

function API:NewMessage(Message, Duration, Player, Type)
    
    API.Messages[Player] = API.Messages[Player] or { }
    local messages = API.Messages[Player]

    local function Add(a, b, c, d, State)
        return {
            message = a,
            duration = b,
            player = c,
            type = d,
            time = 0, pause_timer = 0,
            paused = State,
        }
    end

    local function isDupe(msg)
        for _,console in pairs(messages) do
            if (console.type == "table") then
                for i = 1,#console.message do          
                    for j = 1,#msg do
                        if (console.message[i] == msg[j]) then
                            return true
                        end
                    end
                end
            elseif (console.type == "string") then
                if (console.message == msg) then
                    return true
                end
            end
        end
        return false
    end
    
    if (#messages <= 0) then
        table.insert(messages, Add(Message, Duration, Player, Type, false))
    elseif API:isPaused(Player) then
        if not isDupe(Message) then
            table.insert(messages, Add(Message, Duration, Player, Type, true))
        end
    elseif not isDupe(Message) then
        table.insert(messages, Add(Message, Duration, Player, Type, false))
    end
end

function API:Pause(PlayerIndex)
    local messages = API.Messages[PlayerIndex]
    if (messages) then
        for _,console in pairs(messages) do
            if (console.player == PlayerIndex) then
                console.time = console.duration
                console.paused = true
            end
        end
    end
end

function API:ClearConsole(PlayerIndex, Buffer)
    local Buffer = Buffer or 25
    for _ = 1,Buffer do
        rprint(PlayerIndex, " ")
    end
end

function API:isPaused(PlayerIndex)
    local messages = API.Messages[PlayerIndex]
    if (messages ~= nil) then
        for _,console in pairs(messages) do
            if (console.paused) then
                return true
            end
        end
    end
end

function OnTick()
    for i = 1,16 do
        if player_present(i) then
        
            local messages = API.Messages[i]
            if (messages ~= nil) then
                
                if not API:isPaused(i) then
                    API:ClearConsole(i, 25)
                end
                
                for index,console in pairs(messages) do
                    if (not console.paused) then
                        if (console.type == "table") then
                            for j = 1,#console.message do                    
                                rprint(console.player, console.message[j])
                            end
                        elseif (console.type == "string") then           
                            rprint(console.player, console.message)
                        end
                        
                        console.time = console.time + delta_time
                        if (console.time >= console.duration) then
                            messages[index] = nil
                        end
                    else
                        console.pause_timer = console.pause_timer + delta_time
                        if (console.pause_timer >= 5) then
                            console.paused = false
                        end
                    end
                end
            end
        end
    end
end

function OnPlayerConnect(PlayerIndex)
    -- TEST:
    local message = "This seems to be working!"
    local duration = 10 -- in seconds
    
    API:NewMessage(message, duration, PlayerIndex, "string")
end

function OnPlayerDisconnect(PlayerIndex)
    local messages = API.Messages[PlayerIndex]
    if (messages) then messages = nil end
end

return API
