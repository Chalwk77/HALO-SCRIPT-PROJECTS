--[[
--=====================================================================================================--
Script Name: Anti-Camp V1 (v1.2), for SAPP (PC & CE)

- Description -
Player enters Anti-Camp Zone.
A warning message appears with a countdown from X seconds.
If the player doesn't leave that area before the countdown has elapsed it will teleport (or kill) them.

The x,y,z coordinates for each anti-camp zone and teleport locations can be configured along with customizable messages. 
The countdown duration can be customized on a per-location basis as well as the radius (in world units) in which it is triggered.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"

local mod, positions = {},{}
function mod:init()

    mod.team = "both" -- Valid Teams: "red", "blue" & "both"
    mod.action = "kill" -- Valid Actions: "teleport, kill"

    mod.messages = {
        on_enter = { -- to camper
            "|cWarning! You have entered an Anti-Camp zone",
            "|cYou will be teleported in %seconds% second%s%",
        },
        on_teleport = {
            "You were teleported for camping.", -- to camper
            "%name% was teleported for camping.", -- to other players
        },
        on_kill = {
            "You were killed for camping."
        }
    }

    positions = {
    
        -- Camp Site X,Y,Z | Teleport X,Y,Z | Trigger Radius | Duration
        
        -- NOTE: Teleport x,y,z coordinates are only required if "mod.action" is set to "teleport".
        
        
        ["beavercreek"] = { 
            {15.360, 16.324, 5.059, nil, nil, nil, 3, 10},
        },
        ["bloodgulch"] = { 
            {0, 0, 0, nil, nil, nil, 3, 10},
        },
        ["boardingaction"] = { 
            {0, 0, 0, nil, nil, nil, 3, 10},
        },
        ["carousel"] = { 
            {0, 0, 0, nil, nil, nil, 3, 10},
        },
        ["dangercanyon"] = { 
            {0, 0, 0, nil, nil, nil, 3, 10},
        },
        ["deathisland"] = { 
            {0, 0, 0, nil, nil, nil, 3, 10},
        },
        ["gephyrophobia"] = { 
            {0, 0, 0, nil, nil, nil, 3, 10},
        },
        ["icefields"] = { 
            {0, 0, 0, nil, nil, nil, 3, 10},
        },
        ["infinity"] = { 
            {0, 0, 0, nil, nil, nil, 3, 10},
        },
        ["sidewinder"] = { 
            {0, 0, 0, nil, nil, nil, 3, 10},
        },
        ["timberland"] = { 
            {0.97, -1.18,-21.20, nil, nil, nil, 3, 10},
        },
        ["hangemhigh"] = { 
            {7.84, 2.02, -3.45, nil, nil, nil, 3, 10},
        },
        ["ratrace"] = { 
            {0, 0, 0, nil, nil, nil, 3, 10},
        },
        ["damnation"] = { 
            {-7.13, 12.93, 5.60, nil, nil, nil, 3, 10},
            {-10.47, -13.62, 3.82, nil, nil, nil, 3, 10},
            {-10.53, -9.80, 3.82, nil, nil, nil, 3, 10},
        },
        ["putput"] = { 
            {0, 0, 0, nil, nil, nil, 3, 10},
        },
        ["prisoner"] = { 
            {0, 0, 0, nil, nil, nil, 3, 10},
        },
        ["wizard"] = { 
            {-9.916, 9.950, 0.027, nil, nil, nil, 2, 10},
            {-9.969, -9.956, 0.064, nil, nil, nil, 2, 10},
            {9.915, -9.949, 0.025, nil, nil, nil, 2, 10},
            {9.957, 9.964, 0.059, nil, nil, nil, 2, 10},
        },
    }
    --# Do Not Touch #--
    mod.players = {}
    messages = mod.messages
    positions = positions[get_var(0, "$map")]
    for i = 1,#positions do
        positions[i].onsite = {}
        positions[i].timer = {}
        for j = 1,16 do
            positions[i].timer[j] = 0
            positions[i].onsite[j] = false
        end
    end
end

-- Variables for String Library:
local format, gsub = string.format, string.gsub
-- Variables for Math Library:
local floor, sqrt = math.floor, math.sqrt

-- Game Variables:
local gamestarted, delta_time = nil, 0.03333333333333333
local delta_time = 0.03333333333333333

function OnScriptLoad()

    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    if (get_var(0, '$gt') ~= "n/a") then
        mod:init()
        for i = 1, 16 do
            if player_present(i) then
                mod:Reset(i)
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, '$gt') ~= "n/a") then
        mod:init()
        gamestarted = true
    end
end

function OnGameEnd()
    gamestarted = false
end

function OnPlayerConnect(p)
    mod:Reset(p)
end

function OnPlayerDisconnect(p)
    mod:Reset(p)
end

local function inCampSite(pX, pY, pZ, sX, sY, sZ, R)
    return (sqrt((pX - sX) ^ 2 + (pY - sY) ^ 2 + (pZ - sZ) ^ 2) <= R)
end

function OnTick()
    if (positions ~= nil) then
        for i = 1,16 do
            if player_present(i) and (gamestarted) then
                
                if player_alive(i) then
                    local team = get_var(i, "$team")
                    if (team == mod.team or mod.team == "both") then
                        local player_object = get_dynamic_player(i)
                        if (player_object ~= 0) then
                            local coords = mod:getXYZ(i, player_object)
                            local px,py,pz = coords.x,coords.y,coords.z
                            local name = get_var(i, "$name")
                            for k,v in pairs(positions) do
                                
                                -- CHECK IF PLAYER IS IN CAMP SITE:
                                if inCampSite(px,py,pz, v[1], v[2], v[3], v[7]) then
                                    v.onsite[i] = true
                                    v.timer[i] = v.timer[i] + delta_time
                                    
                                    local timeRemaining = v[8] - floor(v.timer[i] % 60)
                                    mod:cls(i, 25)
                                    
                                    -- WARN PLAYER:
                                    local char = mod:getChar(timeRemaining)
                                    for j = 1,#messages.on_enter do
                                        local msg = gsub(gsub(messages.on_enter[j], "%%seconds%%", timeRemaining), "%%s%%", char)
                                        rprint(i, msg)
                                    end
                                    
                                    -- TELEPORT PLAYER
                                    if (timeRemaining <= 0) then
                                        mod:cls(i, 25)
                                        v.onsite[i], v.timer[i] = false, 0 
                                        if (mod.action == "teleport") then
                                            write_vector3d(player_object + 0x5C, v[4], v[5], v[6])
                                            say(i, messages.on_teleport[1])
                                        elseif (mod.action == "kill") then
                                            local player = get_player(i)
                                            local OldValue = read_word(player + 0xD4)
                                            write_word(player + 0xD4, 0xFFFF)
                                            kill(i)
                                            write_word(player + 0xD4, OldValue)
                                            say(i, messages.on_kill[1])
                                        end
                                        local msg = gsub(messages.on_teleport[2], "%%name%%", name)
                                        mod:broadcast(msg, i)
                                    end
                                    
                                elseif (v.onsite[i]) then
                                    mod:cls(i, 25)
                                    v.onsite[i], v.timer[i] = false, 0 
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function mod:getXYZ(PlayerIndex, PlayerObject)
    local coords, x, y, z = { }
    if player_alive(PlayerIndex) then
        local VehicleID = read_dword(PlayerObject + 0x11C)
        if (VehicleID == 0xFFFFFFFF) then
            coords.invehicle = false
            x, y, z = read_vector3d(PlayerObject + 0x5c)
        else
            coords.invehicle = true
            x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
        end

        if (coords.invehicle) then
            z = z + 1
        end
        coords.x, coords.y, coords.z = x, y, z
    end
    return coords
end

function mod:Reset(p)
    if (p) then
        for k,v in pairs(positions) do
            v.onsite[p], v.timer[p] = false, 0
        end
    end
end

function mod:getChar(input)
    local char = ""
    if (tonumber(input) > 1) then
        char = "s"
    elseif (tonumber(input) <= 1) then
        char = ""
    end
    return char
end

function mod:broadcast(message, player)
    for i = 1, 16 do
        if player_present(i) then
            if (i ~= player) then
                say(i, message)
            end
        end
    end
end

function mod:cls(PlayerIndex, count)
    count = count or 25
    for _ = 1, count do
        rprint(PlayerIndex, " ")
    end
end

function OnScriptUnload()
    --
end

return mod
