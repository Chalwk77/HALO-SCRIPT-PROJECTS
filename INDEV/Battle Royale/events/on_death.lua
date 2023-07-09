local event = {}

function event:onDeath(victim)

    if (not self.pre_game_timer or not self.pre_game_timer.started) then
        return
    end

    victim = tonumber(victim)
    local player = self.players[victim]
    player.weapon_parts = nil -- weapons parts loot
    player.stun = nil -- stun grenades
    player.can_stun = nil -- stun grenades

    if (not player.can_spectate) then
        return
    end

    player.lives = player.lives - 1
    if (player.lives <= 0) then
        player.spectator = true
        player:setSpectatorBits()
        for _, v in pairs(self.players) do
            v:newMessage(player.name .. ' has been eliminated', 5)
        end
        return
    end

    local life = (player.lives == 1 and 'life' or 'lives')
    player:newMessage('You have ' .. player.lives .. ' ' .. life .. ' remaining', 5)
end

register_callback(cb['EVENT_DIE'], 'OnDeath')

return event