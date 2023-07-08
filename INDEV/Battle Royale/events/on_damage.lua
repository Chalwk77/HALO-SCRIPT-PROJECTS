local event = {}

-- Prevent spectators from damaging (or being damaged) by other players:
function event:onDamage(victim, killer, meta_id, damage)

    local v = tonumber(victim)
    local k = tonumber(killer)

    if (k == 0 or k == v) then
        return true
    end

    victim = self.players[v]
    killer = self.players[k]

    if (victim.spectator or killer.spectator) then
        return false
    end

    local dyn = get_dynamic_player(killer.id)
    local weapon = read_dword(dyn + 0x118)
    local object = get_object_memory(weapon)

    weapon = self:getWeapon(object)
    if (weapon) then
        return true, damage * weapon.damage_multiplier
    end
end

register_callback(cb['EVENT_DAMAGE_APPLICATION'], 'OnDamage')

return event