local crates = {}

local function crouchZ(dynamic_player, z)
    local crouch = read_float(dynamic_player + 0x50C)
    if (crouch == 0) then
        z = z + 0.65
    else
        z = z + 0.35
    end
    return z
end

function crates:crateIntersect()

    if (not self.looting.enabled or not self.loot_crates) then
        return
    end

    local dyn = get_dynamic_player(self.id)
    if (dyn == 0 or not player_alive(self.id)) then
        return
    end

    local px, py, pz = self:getXYZ(dyn)
    pz = crouchZ(dyn, pz)

    for meta_id, v in pairs(self.loot_crates) do
        if (get_object_memory(meta_id) ~= 0) then
            local ox, oy, oz = v.x, v.y, v.z
            local distance = self:getDistance(px, py, pz, ox, oy, oz)
            if (distance <= 1) then
                destroy_object(meta_id)

                --
                --
                --

            end
        end
    end
end

return crates