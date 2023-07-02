local event = {}

-- Prevent spectators from damaging (or being damaged) by other players:
function event:onDamage(victim, killer)

    local v = tonumber(victim)
    local k = tonumber(killer)

    if (k == 0) then
        return true
    end

    victim = self.players[v]
    killer = self.players[k]

    if (victim.spectator or killer.spectator) then
        return false
    end

    return true
end

register_callback(cb['EVENT_DAMAGE_APPLICATION'], 'OnDamage')

return event