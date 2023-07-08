local event = {}

function event:onObjectSpawn(player, map_id, parent_id, object_id, sapp_spawning)

    if (not sapp_spawning) then
        -- not currently used
    end

    local dyn = get_dynamic_player(player.id)
    if (player > 0 and dyn ~= 0) then
        player = self.players[player]

        local this_weapon = read_dword(dyn + 0x118)
        local object = get_object_memory(this_weapon)

        local weapon = self:getWeapon(object)
        if (weapon and weapon.ammo_type == 3) then
            return false, player:createExplosiveBullet(dyn)
        end
    end

    return true
end

register_callback(cb['EVENT_OBJECT_SPAWN'], 'OnObjectSpawn')

return event