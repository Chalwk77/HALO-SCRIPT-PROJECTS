local event = {}

local function endGame(self)

    local lives = {}
    for _,v in pairs(self.players) do
        if (v.lives > 0) then
            lives[#lives + 1] = v
        end
    end

    if (#lives == 1) then
        execute_command('sv_end_game')
        local winner = lives[1]
        self:say(string.format('[VICTORY] %s has won the game!', winner.name), true)
        return true
    end

    return false
end

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

        local game_over = endGame(self)
        if (game_over) then
            return
        end

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