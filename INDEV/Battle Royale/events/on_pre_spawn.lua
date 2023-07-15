local event = {}

function event:onPreSpawn(id)

    local player = self.players[id]
    if (not player) then
        return
    elseif (not self.game or not self.game.started or not player.god) then
        return
    end

    -- @args: god, height
    self.players[id]:teleport(true, true)
end

register_callback(cb['EVENT_PRESPAWN'], 'OnPreSpawn')

return event