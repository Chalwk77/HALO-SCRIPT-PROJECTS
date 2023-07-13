local spectator = {}

function spectator:spectate()

    local id = self.id
    if (not self.game or not self.game.started) then
        return
    end

    local dyn = get_dynamic_player(id) -- dynamic memory address
    local player = get_player(id) -- static memory address

    if (dyn == 0 or not player or not self.spectator) then
        return
    end

    self:hide(player, dyn)

    -- In case the player picks up a weapon, force them to drop it:
    execute_command('wdrop ' .. id)

    -- In case a player enters a vehicle, force them to exit it:
    execute_command('vexit ' .. id)

    -- Force the player into camoflauge mode:
    execute_command('camo ' .. id .. ' 1')

    -- Force the player into god mode:
    execute_command('god ' .. id)
end

function spectator:setSpectatorBits()

    local id = self.id
    local dyn = get_dynamic_player(id)
    if (dyn == 0) then
        return
    end

    write_bit(dyn + 0x10, 0, 1)     -- uncollidable/invulnerable
    write_bit(dyn + 0x106, 11, 1)   -- undamageable except for shields w explosions
end

return spectator