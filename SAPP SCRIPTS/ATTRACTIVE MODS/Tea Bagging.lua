--[[
--=====================================================================================================--
Script Name: T-Bagging, for SAPP (PC & CE)
Description: Description: Humiliate your friends with this nifty little script.
Crouch over your victims corpse 3 times to trigger a funny message "name is t-bagging victim".
T-bag any corpse within 30 seconds after they die.

Copyright (c) 2020-2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration Starts --

-- Output: "Chalwk is dancing on FIG-Noob's body!"
local on_tbag = "%name% is dancing on %victim%'s body!"

-- Radius (in world units) a player must be from a victim's corpse to trigger a t-bag:
local trigger_radius = 2

-- A player's death coordinates expire after this many seconds:
local coordinate_expiration = 60

-- A player must crouch over a victim's corpse this many times in order to trigger the t-bag:
local crouch_count = 3
-- Configuration Ends --

local players = { }
local time_scale = 1 / 30
local sqrt, gsub = math.sqrt, string.gsub

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    if (get_var(0, "$gt") ~= "n/a") then
        players = { }
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, false)
            end
        end
    end
end

local function GetRadius(pX, pY, pZ, X, Y, Z)
    if (pX) then
        return sqrt((pX - X) ^ 2 + (pY - Y) ^ 2 + (pZ - Z) ^ 2)
    end
    return nil
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            for j, ply in pairs(players) do
                if (i ~= j and ply.coords) then

                    local pos = GetXYZ(i)
                    if (pos) and (not pos.invehicle) then
                        local px, py, pz = pos.x, pos.y, pos.z

                        for k, v in pairs(ply.coords) do
                            v.timer = v.timer + time_scale
                            if (v.timer >= coordinate_expiration) then
                                ply.coords[k] = nil
                            else

                                local x, y, z = v.x, v.y, v.z
                                local distance = GetRadius(px, py, pz, x, y, z)
                                if (distance) and (distance <= trigger_radius) then

                                    local crouch = read_bit(pos.DyN + 0x208, 0)
                                    if (crouch ~= players[i].crouch_state and crouch == 1) then
                                        players[i].crouch_count = players[i].crouch_count + 1

                                    elseif (players[i].crouch_count >= crouch_count) then
                                        players[i].crouch_count = 0
                                        say_all(gsub(gsub(on_tbag, "%%name%%", players[i].name), "%%victim%%", ply.name))
                                        ply.coords[k] = nil
                                    end
                                    players[i].crouch_state = crouch
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function OnPlayerDeath(V, _)
    local victim = tonumber(V)
    local pos = GetXYZ(victim)
    if (pos) then
        players[victim].coords[#players[victim].coords + 1] = {
            timer = 0, x = pos.x, y = pos.y, z = pos.z,
        }
    end
end

function OnPlayerConnect(Ply)
    InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    InitPlayer(Ply, true)
end

function InitPlayer(Ply, Reset)
    if (not Reset) then
        players[Ply] = {
            coords = { },
            name = get_var(Ply, "$name"),
            crouch_state = 0, crouch_count = 0,
        }
    else
        players[Ply] = nil
    end
end

function GetXYZ(Ply)
    local coords, x, y, z = { }
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        local VehicleID = read_dword(DyN + 0x11C)
        if (VehicleID == 0xFFFFFFFF) then
            coords.invehicle = false
            x, y, z = read_vector3d(DyN + 0x5c)
        else
            coords.invehicle = true
            x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
        end
        coords.x, coords.y, coords.z, coords.DyN = x, y, z, DyN
    end
    return coords
end

function OnScriptUnload()

end