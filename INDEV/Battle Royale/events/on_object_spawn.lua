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
            self.nukes[#self.nukes+1] = {
                meta_id = object_id,
                weapon = weapon,
                player = player,
                object = object,
                projectile = map_id
            }
        end
    end
end

function event:trackNuke()

    local nukes = self.nukes
    if (nukes and #nukes == 0) then
        return
    end

    for k, v in pairs(self.nukes) do

        -- get object memory of this nuke:
        local object = get_object_memory(v.meta_id)
        if (object == 0) then
            self.nukes[k] = nil
            goto next
        end

        local x, y, z = read_vector3d(object + 0x5C)
        print(x, y, z)

        :: next ::
    end
end

function TrackNuke(nuke)

    local object = get_object_memory(nuke)
    if (object == 0) then
        return false
    end

    local x, y, z = read_vector3d(object + 0x5C)
    print(x, y, z)

    return true
end

register_callback(cb['EVENT_OBJECT_SPAWN'], 'OnObjectSpawn')

return event