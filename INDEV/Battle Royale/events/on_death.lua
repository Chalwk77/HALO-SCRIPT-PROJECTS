local event = {}

function event:onDeath(victim)

    if (not self.pre_game_timer or not self.pre_game_timer.started) then
        return
    end

    victim = tonumber(victim)
    local player = self.players[victim]
    if (not player.can_spectate) then
        return
    end

    player.spectator = true
    player:setSpectatorBits()

    for _,v in pairs(self.players) do
        v:newMessage(player.name .. ' has perished', 5)
    end
end

register_callback(cb['EVENT_DIE'], 'OnDeath')

return event