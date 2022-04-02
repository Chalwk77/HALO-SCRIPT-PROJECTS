-- Rank System [Game Tick File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = {}

local function GetXYZ(dyn)
    local x, y, z
    local crouch = read_float(dyn + 0x50C)
    local vehicle = read_dword(dyn + 0x11C)
    local object = get_object_memory(vehicle)
    if (vehicle == 0xFFFFFFFF) then
        x, y, z = read_vector3d(dyn + 0x5C)
    elseif (object ~= 0) then
        x, y, z = read_vector3d(object + 0x5C)
    end
    return x, y, (crouch == 0 and z + 0.65 or z + 0.35 * crouch)
end

function math.round(n, p)
    return math.floor(n * (10 ^ p) + 0.5) / (10 ^ p)
end

local sqrt = math.sqrt
function Event:GameTick()
    for i = 1, 16 do
        local dyn = get_dynamic_player(i)
        if player_present(i) and dyn ~= 0 and player_alive(i) then
            local v = self:GetPlayer(i)
            if (v and v.logged_in) then
                local x, y, z = GetXYZ(dyn)
                if (v.pos.x) then

                    local dz = x - v.pos.x
                    local dy = y - v.pos.y
                    local dx = z - v.pos.z
                    local dist = sqrt(dx ^ 2 + dy ^ 2 + dz ^ 2)
                    v.stats.distance[self.map] = v.stats.distance[self.map] + dist

                    local d = math.round(v.stats.distance[self.map] / 1000, 2)
                    local t = self.credits.distance_travelled
                    for j = 1, #t do

                        local b = t[j]
                        local km = math.round(b[2] * 100 / 1000, 2)

                        --print(d, km, d >= km)
                        if (d >= km and d < km + 1) then
                            v:UpdateCR({ b[1], b[3] })
                        elseif (d > t[#t][2] and d % 50 == 0) then
                            v:UpdateCR({ b[1], b[3] })
                        end
                    end
                end

                v.pos.x, v.pos.y, v.pos.z = x, y, z
            end
        end
    end
end

return Event