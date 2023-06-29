local player = {}

-- Check if a player is walking on top of an object:
function player:walkingOnTop(px, py, pz)

    local ignore_player = read_dword(get_player(self.id) + 0x34)
    local success, _, _, _, target = intersect(px, py, pz, 0, 0, -1, ignore_player)

    return (success and target) or nil
end

local function crouchZ(dynamic_player, z)
    local crouch = read_float(dynamic_player + 0x50C)
    if (crouch == 0) then
        z = z + 0.65
    else
        z = z + 0.35
    end
    return z
end

function player:intersecting()

    if (not self.looting.enabled or not self.loot) then
        return
    end

    local dyn = get_dynamic_player(self.id)
    if (dyn == 0 or not player_alive(self.id)) then
        return
    end

    local px, py, pz = self:getXYZ(dyn)
    pz = crouchZ(dyn, pz)

    for item, _ in pairs(self.loot) do
        local object_memory = get_object_memory(item)
        if (object_memory ~= 0) then
            local power_up = self:walkingOnTop(px, py, pz)
            if (item == power_up) then
                cprint(self.name .. ' is walking on top of the object.', 10)
            end
        end
    end
end

return player