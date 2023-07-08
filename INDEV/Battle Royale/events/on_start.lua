local event = {}
local format = string.format

function event:loadMapSettings()

    local success, error = pcall(function()
        local map = get_var(0, '$map')
        local map_settings = require('./Battle Royale/map settings/' .. map)
        for k, v in pairs(map_settings) do
            self[k] = v
        end
    end)

    return success, error
end

function event:getClipSizesTable()
    for _,v in pairs(self.looting.spoils) do
        if (v.clip_sizes) then
            return v.clip_sizes
        end
    end
end

function event:onStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        local success, error = self:loadMapSettings()
        if (not success) then
            cprint(error, 12)
            return
        end

        self.death_message_address = sig_scan("8B42348A8C28D500000084C9") + 3
        self.original_death_message_address = read_dword(self.death_message_address)

        -- Disable Full Spectrum Vision:
        execute_command('disable_object "' .. 'powerups\\full-spectrum vision"')

        self.weapons = {}

        self.loot = nil
        self.loot_crates = nil

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

        self.weapon_weights = {}
        for name, speed in pairs(self.weight.weapons) do
            local tag = self:getTag('weap', name)
            if (tag) then
                self.weapon_weights[tag] = speed
            end
        end

        self.decay_rates = {}
        for name, rate in pairs(self.weapon_degradation.decay_rate) do
            local tag = self:getTag('weap', name)
            if (tag) then
                self.decay_rates[tag] = rate
            end
        end

        self.clip_sizes = {}
        for name, size in pairs(self:getClipSizesTable()) do
            local tag = self:getTag('weap', name)
            if (tag) then
                self.clip_sizes[tag] = size
            end
        end

        --self:spawnBarrier()
    end
end

function pluginLogo(h, m, s, b)
    cprint('=======================================================================================================================', 10)
    cprint(" ")
    cprint("'||''|.       |     |''||''| |''||''| '||'      '||''''|     '||''|.    ..|''||   '||' '|'     |     '||'      '||''''|", 12)
    cprint(" ||   ||     |||       ||       ||     ||        ||  .        ||   ||  .|'    ||    || |      |||     ||        ||  .", 12)
    cprint(" ||'''|.    |  ||      ||       ||     ||        ||''|        ||''|'   ||      ||    ||      |  ||    ||        ||''|", 12)
    cprint(" ||    ||  .''''|.     ||       ||     ||        ||           ||   |.  '|.     ||    ||     .''''|.   ||        ||", 12)
    cprint(".||...|'  .|.  .||.   .||.     .||.   .||.....| .||.....|    .||.  '|'  ''|...|'    .||.   .|.  .||. .||.....| .||.....|", 12)
    cprint(" ")
    cprint(format("This game will end in %s hours, %s minutes and %s seconds", h, m, s), 15)
    cprint(format('Crunch time: %s', b / 60 .. ' minutes'), 15)
    cprint('========================================================================================================================', 10)
end

register_callback(cb['EVENT_GAME_START'], 'OnStart')

return event