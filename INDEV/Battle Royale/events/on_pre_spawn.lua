local event = {}

function event:onPreSpawn(id)

    local player = self.players[id]
    if (not player) then
        return
    elseif (not self.pre_game_timer or not self.pre_game_timer.started or not player.god) then
        return
    end

    self.players[id]:teleport() -- sky spawning system / only works if the pre-game timer has elapsed.
end

register_callback(cb['EVENT_PRESPAWN'], 'OnPreSpawn')

return event