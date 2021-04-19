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
local TBag = {

    -- Message sent when a player is t-bagging
    --
    on_tbag = "%name% is lap-dancing on %victim%'s body!",

    -- Radius (in w/units) a player must be from a victim's corpse to trigger a t-bag:
    --
    radius = 2.5,

    -- A player's death coordinates expire after this many seconds:
    --
    coordinate_expiration = 60,

    -- A player must crouch over a victim's corpse this many times in order to trigger the t-bag:
    --
    crouch_count = 4,
    -- Configuration Ends --
}

local time_scale = 1 / 30
local sqrt, gsub = math.sqrt, string.gsub

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    TBag:Init()
end

function OnGameStart()
    TBag:Init()
end

function TBag:Init()
    if (get_var(0, "$gt") ~= "n/a") then
        self.players = { }
        for i = 1, 16 do
            if player_present(i) then
                TBag:InitPlayer(i, false)
            end
        end
    end
end

function TBag:InProximity(pX, pY, pZ, X, Y, Z)
    return sqrt((pX - X) ^ 2 + (pY - Y) ^ 2 + (pZ - Z) ^ 2) <= self.radius
end

function TBag:Monitor()

    -- 1st Loop (tea baggers)
    --
    for i, itab in pairs(self.players) do

        -- 2nd Loop (victims)
        --
        for j, jtab in pairs(self.players) do
            if (i ~= j) then

                -- Loop through all victim coordinate tables:
                --

                for cIndex, CTab in pairs(jtab.coordinates) do

                    -- increment expiration timer:
                    --
                    CTab.timer = CTab.timer + time_scale

                    -- Delete coordinate table on expire:
                    --

                    if (CTab.timer >= self.coordinate_expiration) then
                        jtab.coordinates[cIndex] = nil
                    else

                        -- Get x,y,z position of tea bagger:
                        local i_pos = self:GetXYZ(i)
                        if (i_pos and not i_pos.in_vehicle) then

                            -- tea bagger coordinates:
                            local px, py, pz = i_pos.x, i_pos.y, i_pos.z
                            --

                            -- corpse coordinates:
                            local x, y, z = CTab.x, CTab.y, CTab.z
                            --

                            -- Check if tea bagger is within proximity of victim's corpse:
                            if self:InProximity(px, py, pz, x, y, z) then

                                -- Check if player is crouching & increment crouch count:
                                local crouch = read_bit(i_pos.dyn + 0x208, 0)
                                if (crouch ~= itab.crouch_state and crouch == 1) then
                                    itab.crouch_count = itab.crouch_count + 1


                                    -- Broadcast tea bag message:
                                    --
                                elseif (itab.crouch_count >= self.crouch_count) then
                                    say_all(gsub(gsub(self.on_tbag, "%%name%%", itab.name), "%%victim%%", jtab.name))
                                    itab.crouch_count = 0
                                    jtab.coordinates[cIndex] = nil
                                end
                                itab.crouch_state = crouch
                            end
                        end
                    end
                end
            end
        end
    end
end

function TBag:OnDeath(Ply)
    local pos = self:GetXYZ(Ply)
    if (pos and self.players[Ply]) then
        table.insert(self.players[Ply].coordinates, {
            timer = 0,
            x = pos.x,
            y = pos.y,
            z = pos.z
        })
    end
end

function OnPlayerConnect(Ply)
    TBag:InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    TBag:InitPlayer(Ply, true)
end

function OnPlayerSpawn(Ply)
    TBag.players[Ply].crouch_state = 0
    TBag.players[Ply].crouch_count = 0
end

function TBag:InitPlayer(Ply, Reset)
    if (not Reset) then
        self.players[Ply] = {
            coordinates = { },
            name = get_var(Ply, "$name")
        }
        return
    end
    self.players[Ply] = nil
end

function TBag:GetXYZ(Ply)
    local pos = { }
    local DyN = get_dynamic_player(Ply)
    if (player_alive(Ply) and DyN ~= 0) then
        pos.dyn = DyN
        local VehicleID = read_dword(DyN + 0x11C)
        local VObject = get_object_memory(VehicleID)
        if (VehicleID == 0xFFFFFFFF) then
            pos.in_vehicle = false
            pos.x, pos.y, pos.z = read_vector3d(DyN + 0x5c)
        elseif (VObject ~= 0) then
            pos.in_vehicle = true
            pos.x, pos.y, pos.z = read_vector3d(VObject + 0x5c)
        end
    end
    return pos
end

function OnScriptUnload()
    -- N/A
end

function OnTick()
    return TBag:Monitor()
end
function OnPlayerDeath(P)
    return TBag:OnDeath(P)
end