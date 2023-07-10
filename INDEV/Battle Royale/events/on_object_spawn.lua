local event = {}

function event:onObjectSpawn(player, map_id, parent_id, object_id, sapp_spawning)

    if (not sapp_spawning) then
        -- not currently used
    end

    local dyn = get_dynamic_player(player)
    if (player > 0 and dyn ~= 0) then

        -- Prevent players from using special ammo in vehicles:
        player = self.players[player]
        if player:inVehicle(dyn) then
            return
        end

        local this_weapon = read_dword(dyn + 0x118)
        local object = get_object_memory(this_weapon)

        local weapon = self:getWeapon(object)
        if (not weapon) then
            return
        elseif (weapon.ammo_type == 3 or weapon.ammo_type == 5) then
            return false, player:createProjectile(dyn, weapon)
        elseif (weapon.ammo_type == 6 and map_id == self.rocket_projectile) then
            destroy_object(weapon.weapon)
            self.nukes[#self.nukes + 1] = {
                meta_id = object_id,
                weapon = weapon,
                player = player,
                object = object,
                projectile = map_id
            }
        end
    end
end

local function translate(object, x, y, z)
    write_vector3d(object + 0x5C, x, y, z)
    write_float(object + 0x68, 0) -- x velocity
    write_float(object + 0x6C, 0) -- y velocity
    write_float(object + 0x70, -99999) -- z velocity
end

local function createNuke(total, radius, projectile, cx, cy, cz)

    local angle = 0
    local angle_step = 360 / total

    -- Rockets with no spread but spawn in a circle:
    for _ = 1, total do
        local x = cx + (math.cos(angle) * radius)
        local y = cy + (math.sin(angle) * radius)
        local z = cz
        local rocket = spawn_projectile(projectile, 0, x, y, z)
        local object = get_object_memory(rocket)
        translate(object, x, y, z)
        angle = angle + angle_step
    end

     --Rockets with random spread:
    for _ = 1, 5 do
        local rocket = spawn_projectile(projectile, 0, cx, cy, cz)
        local object = get_object_memory(rocket)
        local x = cx + rand(-radius, radius + 1)
        local y = cy + rand(-radius, radius + 1)
        local z = cz
        translate(object, x, y, z)
    end
end

-- called every tick:
function event:trackNuke()

    local nukes = self.nukes
    if (nukes and #nukes == 0) then
        return
    end

    for k, v in pairs(self.nukes) do
        local object = get_object_memory(v.meta_id)
        if (object == 0) then
            self.nukes[k] = nil
            self:modifyRocket()
            createNuke(5, 5, v.projectile, v.x, v.y, v.z)
            createNuke(5, 10, v.projectile, v.x, v.y, v.z)
            self:rollbackRocket()
            goto next
        end
        v.x, v.y, v.z = read_vector3d(object + 0x5C)
        :: next ::
    end
end

register_callback(cb['EVENT_OBJECT_SPAWN'], 'OnObjectSpawn')

return event