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
    for _, v in pairs(self.looting.spoils) do
        if (v.clip_sizes) then
            return v.clip_sizes
        end
    end
end

function event:getStunTags()
    for _, v in pairs(self.looting.spoils) do
        if (v.grenade_tags) then
            return v.grenade_tags
        end
    end
end

function event:getRandomWeaponTags()
    for _, v in pairs(self.looting.spoils) do
        if (v.random_weapons) then
            return v.random_weapons
        end
    end
end

local function getTagData()
    local tag_address = read_dword(0x40440000)
    local tag_count = read_dword(0x4044000C)
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if (tag_class == 1785754657 and tag_name == "weapons\\rocket launcher\\explosion") then
            return read_dword(tag + 0x14)
        end
    end
    return nil
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

        self.loot = nil
        self.loot_crates = nil

        -- pre game timer:
        self.pre_game_timer = nil
        self.post_game_carnage_report = false

        -- players table:
        self.players = {}

        -- weapons table:
        self.weapons = {}

        -- nuke:
        self.nukes = {}

        -- Sets initial radius of the safe zone and the total game time:
        self.total_time = self:setSafeZone()

        self.game_timer = self:new()

        local h, m, s = self:secondsToTime(self.total_time)
        timer(33, 'pluginLogo', h, m, s, self.end_after * 60)

        -- Just in case the plugin is loaded mid-game:
        for i = 1, 16 do
            if player_present(i) then
                self:onJoin(i)
            end
        end

        self.energy_weapons = self:tagsToID(self._energy_weapons_, 'weap')
        self.random_weapons = self:tagsToID(self:getRandomWeaponTags(), 'weap')
        self.weapon_weights = self:tagsToID(self.weight.weapons, 'weap')
        self.decay_rates = self:tagsToID(self.weapon_degradation.decay_rate, 'weap')
        self.clip_sizes = self:tagsToID(self:getClipSizesTable(), 'weap')
        self.stuns = self:tagsToID(self:getStunTags(), 'jpt!')

        -- For explosive bullets and grenade launcher:
        self.rocket_projectile = self:getTag('proj', 'weapons\\rocket launcher\\rocket')
        self.frag_projectile = self:getTag('proj', 'weapons\\frag grenade\\frag grenade')

        -- For nuke:
        self.rocket_launcher = self:getTag('weap', 'weapons\\rocket launcher\\rocket launcher')

        self.rocket_tag_data = getTagData()

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