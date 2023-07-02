local spectator = {}

function spectator:spectate()

    if (not self.pre_game_timer or not self.pre_game_timer.started) then
        return
    end

    local dyn = get_dynamic_player(self.id) -- dynamic memory address
    local player = get_player(self.id) -- static memory address

    if (dyn == 0 or not player or not self.spectator) then
        return
    end

    -- Makes player 'invisible' to other players:
    local x, y, z = self:getXYZ(dyn)

    write_float(player + 0xF8, x - 1000)
    write_float(player + 0xFC, y - 1000)
    write_float(player + 0x100, z - 1000)

    -- In case the player picks up a weapon, force them to drop it:
    execute_command('wdrop ' .. self.id)

    -- In case a player enters a vehicle, force them to exit it:
    execute_command('vexit ' .. self.id)

    -- Force the player into camoflauge mode:
    execute_command('camo ' .. self.id .. ' 1')
end

function spectator:setSpectatorBits()

    local dyn = get_dynamic_player(self.id)
    if (dyn == 0) then
        return
    end

    write_bit(dyn + 0x10, 0, 1)     -- uncollidable/invulnerable
    write_bit(dyn + 0x106, 11, 1)   -- undamageable except for shields w explosions
end

return spectator