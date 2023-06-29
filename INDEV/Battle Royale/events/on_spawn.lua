local event = {}

function event:onSpawn(id)

    local player = self.players[id]
    if (not player) then
        return
    elseif (self.pre_game_timer and self.pre_game_timer.started and player.god) then
        execute_command('god ' .. id)
    end

    execute_command('hp ' .. id .. ' ' .. self.health)
    execute_command('wdel ' .. id)
end

register_callback(cb['EVENT_SPAWN'], 'OnSpawn')

return event