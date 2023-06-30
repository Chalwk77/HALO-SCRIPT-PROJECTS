local event = {}
local format = string.format

function event:onStart(state)
    if (get_var(0, '$gt') ~= 'n/a') then

        -- pre game timer:
        self.pre_game_timer = nil
        self.post_game_carnage_report = false

        -- players table:
        self.players = {}

        -- safe zone timer and total game time:
        self.total_time = self:getTotalGameTime()

        local h, m, s = self:secondsToTime(self.total_time)
        timer(33, 'pluginLogo', h, m, s, self.end_after * 60)

        -- Just in case the plugin is loaded mid-game:
        for i = 1, 16 do
            if player_present(i) then
                self:onJoin(i)
            end
        end

        local t = {}
        for name, speed in pairs(self.weight.weapons) do
            local tag = self:getTag('weap', name)
            if (tag) then
                t[tag] = speed
            end
        end
        self.weapon_weights = t

        --self:spawnBarrier()
    end
end

function pluginLogo(h, m, s, b)
    cprint('=======================================================================================================================', 10)
    cprint("'||''|.       |     |''||''| |''||''| '||'      '||''''|     '||''|.    ..|''||   '||' '|'     |     '||'      '||''''|", 12)
    cprint(" ||   ||     |||       ||       ||     ||        ||  .        ||   ||  .|'    ||    || |      |||     ||        ||  .", 12)
    cprint(" ||'''|.    |  ||      ||       ||     ||        ||''|        ||''|'   ||      ||    ||      |  ||    ||        ||''|", 12)
    cprint(" ||    ||  .''''|.     ||       ||     ||        ||           ||   |.  '|.     ||    ||     .''''|.   ||        ||", 12)
    cprint(".||...|'  .|.  .||.   .||.     .||.   .||.....| .||.....|    .||.  '|'  ''|...|'    .||.   .|.  .||. .||.....| .||.....|", 12)
    cprint('========================================================================================================================', 10)

    cprint(format("1). This game will end in %s hours, %s minutes and %s seconds", h, m, s), 15)
    cprint(format('Bonus Time: %s', b), 15)
end

register_callback(cb['EVENT_GAME_START'], 'OnStart')

return event