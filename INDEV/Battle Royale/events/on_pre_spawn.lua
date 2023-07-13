local event = {}

function event:onPreSpawn(id)

    local player = self.players[id]
    if (not player) then
        return
    elseif (not self.pre_game_timer or not self.pre_game_timer.started or not player.god) then
        return
    end

    -- @args: god, height
    self.players[id]:teleport(true, true)
end

register_callback(cb['EVENT_PRESPAWN'], 'OnPreSpawn')

return event