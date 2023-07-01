local timer = {}
local floor = math.floor

local function timeRemaining(delay, time)
    return floor(delay - time:get())
end

local function setGodMode(players)
    for _,v in pairs(players) do
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

        -- Start the shrinking timer:
        self.safe_zone_timer = self:new()
        self.safe_zone_timer:start()

        cprint('Spawning Loot: ')
        self:spawnLoot(self.looting.objects, 'loot')
        cprint(' ')
        cprint('Spawning Crates: ')
        self:spawnLoot(self.looting.crates, 'crates')
    else
        self:say('Game will start in ' .. timeRemaining(delay, self.pre_game_timer) .. ' seconds!', true)
    end
end

function timer:phaseCheck(quit)

    if (self.post_game_carnage_report) then
        return
    end

    local count = tonumber(get_var(0, '$pn'))
    count = (quit and count - 1) or count

    local required_players = self.required_players

    if (count >= required_players and not self.pre_game_timer) then
        self.pre_game_timer = self:new()
        self.pre_game_timer:start()
    elseif (count >= required_players and self.pre_game_timer) then
        return
    --elseif (self.pre_game_timer and self.pre_game_timer.started) then
    --    endGame()
    elseif (self.pre_game_timer and not self.pre_game_timer.started) then
        self.pre_game_timer = nil
        return
    end
end

return timer