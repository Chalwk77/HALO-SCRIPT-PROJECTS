local timer = {}
local floor = math.floor

local function timeRemaining(delay, time)
    return floor(delay - time:get())
end

local function setGodMode(players)
    for _, v in pairs(players) do
        v.god = true
    end
end

function timer:preGameTimer()

    if (not self.pre_game_timer or self.pre_game_timer.started) then
        return
    end

    local delay = self.start_delay

    if (self.pre_game_timer:get() >= delay) then

        self:setSpawns()
        self.pre_game_timer:stop()
        self.pre_game_timer.started = true
        setGodMode(self.players)

        execute_command('sv_map_reset')
        if (self.lock_server) then
            execute_command('sv_password "' .. self.password .. '"')
        end

        -- Start the shrinking timer:
        self.safe_zone_timer = self:new()
        self.safe_zone_timer:start()

        self.game_timer = self:new()
        self.game_timer:start()

        self:spawnLoot(self.looting.objects, 'loot')
        self:spawnLoot(self.looting.crates, 'crates')

        for _, v in pairs(self.players) do
            v.messages.primary = ''
        end
    else
        self:say('Game will start in ' .. timeRemaining(delay, self.pre_game_timer) .. ' seconds!', true)
    end
end

function timer:phaseCheck(quit, player)

    if (self.post_game_carnage_report) then
        return
    end

    player = (player and self.players[player]) or nil

    local count = tonumber(get_var(0, '$pn'))
    count = (quit and count - 1) or count

    local required_players = self.required_players
    local game_started = (self.pre_game_timer and self.pre_game_timer.started)

    -- Enough players have joined the game, start the pre-game timer:
    if (count >= required_players and not self.pre_game_timer) then
        self.pre_game_timer = self:new()
        self.pre_game_timer:start()


        -- Player has joined mid-game:
    elseif (not quit and player and count >= required_players and game_started) then
        if (self.new_player_spectate) then
            player.spectator = true
            player:setSpectatorBits()
            player:newMessage('You have joined mid-game, you will be able to play next round', 5)
        end


        -- A player has quit the game before the pre-game timer has elapsed. Reset the timer:
    elseif (quit and self.pre_game_timer and not self.pre_game_timer.started) then
        self.pre_game_timer = nil


        -- The game has started but there is only one player left, end the game:
    elseif (quit and count == 1 and game_started) then
        execute_command('sv_map_next')
        print('[VICTORY] Game ended - last player wins!')
    end
end

return timer