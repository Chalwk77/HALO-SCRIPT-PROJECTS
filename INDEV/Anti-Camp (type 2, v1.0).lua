--[[
--=====================================================================================================--
Script Name: Anti-Camp (type 2, v1.0), for SAPP (PC & CE)
Description: N/A

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"

local mod, positions = {}, {}
function mod:init()

    mod.messages = {
        on_enter = { -- to camper
            "|cWarning! You have entered an Anti-Camp zone",
            "|cYou will be teleported in %seconds% second%s%",
        },
        on_teleport = {
            "You were teleported for camping.", -- to camper
            "%name% was teleported for camping.", -- to other players
        }
    }

    positions = {

        -- Camp Site X,Y,Z | Teleport X,Y,Z | Trigger Radius | Duration

        ["beavercreek"] = {
            { 15.360, 16.324, 5.059, 22.104, 16.398, -1.356, 5, 10 },
        },
        ["bloodgulch"] = {
            { 0, 0, 0, 000, 000, 000, 3, 10 },
        },
        ["boardingaction"] = {
            { 0, 0, 0, 000, 000, 000, 3, 10 },
        },
        ["carousel"] = {
            { 0, 0, 0, 000, 000, 000, 3, 10 },
        },
        ["dangercanyon"] = {
            { 0, 0, 0, 000, 000, 000, 3, 10 },
        },
        ["deathisland"] = {
            { 0, 0, 0, 000, 000, 000, 3, 10 },
        },
        ["gephyrophobia"] = {
            { 0, 0, 0, 000, 000, 000, 3, 10 },
        },
        ["icefields"] = {
            { 0, 0, 0, 000, 000, 000, 3, 10 },
        },
        ["infinity"] = {
            { 0, 0, 0, 000, 000, 000, 3, 10 },
        },
        ["sidewinder"] = {
            { 0, 0, 0, 000, 000, 000, 3, 10 },
        },
        ["timberland"] = {
            { 0.97, -1.18, -21.20, 21, 22, 23, 5, 10 },
        },
        ["hangemhigh"] = {
            { 7.84, 2.02, -3.45, 16.16, 3.72, -7.95, 3, 10 },
        },
        ["ratrace"] = {
            { 0, 0, 0, 000, 000, 000, 3, 10 },
        },
        ["damnation"] = {
            { -7.13, 12.93, 5.60, -11.12, 13.09, -0.40, 3, 10 },
            { -10.47, -13.62, 3.82, -7.23, -6.50, -0.20, 3, 10 },
            { -10.53, -9.80, 3.82, -7.23, -6.50, -0.20, 3, 10 },
        },
        ["putput"] = {
            { 0, 0, 0, 000, 000, 000, 3, 10 },
        },
        ["prisoner"] = {
            { 0, 0, 0, 000, 000, 000, 3, 10 },
        },
        ["wizard"] = {
            { 0, 0, 0, 000, 000, 000, 3, 10 },
        },
    }
    --# Do Not Touch #--
    mod.players = {}
    messages = mod.messages
    positions = positions[get_var(0, "$map")]
    for i = 1, #positions do
        positions[i].onsite = {}
        positions[i].timer = {}
        for j = 1, 16 do
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
        for i = 1, 16 do
            if player_present(i) and (gamestarted) then

                if player_alive(i) then
                    local player_object = get_dynamic_player(i)
                    if (player_object ~= 0) then
                        local coords = mod:getXYZ(i, player_object)
                        local px, py, pz = coords.x, coords.y, coords.z
                        local name = get_var(i, "$name")
                        for k, v in pairs(positions) do

                            -- CHECK IF PLAYER IS IN CAMP SITE:
                            if inCampSite(px, py, pz, v[1], v[2], v[3], v[7]) then
                                v.onsite[i] = true
                                v.timer[i] = v.timer[i] + delta_time

                                local timeRemaining = v[8] - floor(v.timer[i] % 60)
                                mod:cls(i, 25)

                                -- WARN PLAYER:
                                local char = mod:getChar(timeRemaining)
                                for j = 1, #messages.on_enter do
                                    local msg = gsub(gsub(messages.on_enter[j], "%%seconds%%", timeRemaining), "%%s%%", char)
                                    rprint(i, msg)
                                end

                                -- TELEPORT PLAYER
                                if (timeRemaining <= 0) then
                                    mod:cls(i, 25)
                                    v.onsite[i], v.timer[i] = false, 0
                                    write_vector3d(player_object + 0x5C, v[4], v[5], v[6])
                                    say(i, messages.on_teleport[1])
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
        for k, v in pairs(positions) do
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
