-- Zombies [Miscellaneous Functions File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Misc = {}

function Misc:SwitchTeam(NewTeam)
    self.switching = true
    execute_command('st ' .. self.id .. ' ' .. NewTeam)
end

-- This function cures a zombie when they have >= self.cure_threshold kills:
-- @param Ply (player index) [number]
--
function Misc:Cure()
    if (self.cure_threshold > 1) then

        local streak = tonumber(get_var(self.id, '$streak'))
        if (streak >= self.cure_threshold) then

            self:DespawnWeapons(self.id)

            -- Switch zombie to the human team:
            self:SwitchTeam(self.human_team)

            -- Announce that this player has been cured:
            local msg = self.messages.on_cure
            self:SayAll(msg:gsub('$name', self.name))
        end
    end
end

-- This function returns the number of players in each team:
-- @return humans [number], zombies [number]
--
function Misc:GetTeamCounts()

    local human_team = self.human_team
    local zombie_team = self.zombie_team

    local humans, zombies
    if (human_team == 'red' and zombie_team == 'blue') then
        humans = get_var(0, '$reds')
        zombies = get_var(0, '$blues')
    elseif (human_team == 'blue' and zombie_team == 'red') then
        humans = get_var(0, '$blues')
        zombies = get_var(0, '$reds')
    end

    return tonumber(humans), tonumber(zombies)
end

--
-- Returns the team type (red = human, blue = zombie):
-- @param Ply (player index) [number]
-- @return player team type [string]
function Misc:GetTeamType()
    return (self.team == self.human_team and 'human') or 'zombie'
end

-- Used to pluralize a string based on whether n>0.
-- @param n (time remaining) [number]
-- @return char n [string]
function Misc:Plural(n)
    return (n > 0 and 's') or ''
end

function Misc:PrivateSay(msg)
    execute_command('msg_prefix ""')
    say(self.id, msg)
    execute_command('msg_prefix "' .. self.server_prefix .. '"')
end

function Misc:SayAll(msg)
    execute_command('msg_prefix ""')
    say_all(msg)
    execute_command('msg_prefix "' .. self.server_prefix .. '"')
end

function Misc:GameObjects(state)

    if (state) then
        state = "disable_object"
    else
        state = "enable_object"
    end

    -- Disable game objects:
    for _, v in pairs(self.objects) do
        if (v[2] ~= nil) then
            execute_command(state .. ' "' .. v[1] .. '" ' .. v[2])
        end
    end
end

function Misc:CleanUpDrones(assign)
    if (self.team == self.zombie_team) then
        for _, v in pairs(self.drones) do
            local object = get_object_memory(v.weapon)
            if (object ~= 0 and object ~= 0xFFFFFFF) then
                destroy_object(v.weapon)
            end
        end
        self.drones = {}
        self.assign = assign
    end
end

-- Removes Ammo and Grenades from zombie weapons:
--
function Misc:RemoveAmmo()
    if (self.game_started and self.team == self.zombie_team) then
        local dyn = get_dynamic_player(self.id)
        if (dyn ~= 0) then
            for i = 0, 3 do
                local weapon = read_dword(dyn + 0x2F8 + (i * 4))
                if (weapon ~= 0xFFFFFFFF) then
                    local object = get_object_memory(weapon)
                    if (object ~= 0) then
                        write_word(object + 0x2B8, 0)
                        write_word(object + 0x2B6, 0)
                        execute_command_sequence('w8 1; battery ' .. self.id .. ' 0 ' .. i)
                        sync_ammo(weapon)
                    end
                end
            end
        end
    end
end

-- Set respawn time:
--
function Misc:SetRespawn()
    if (self.game_started) then
        local time = self:GetRespawnTime(self.id)
        local player = get_player(self.id)
        if (player ~= 0) then
            write_dword(player + 0x2C, time * 33)
        end
    end
end

-- This function returns the relevant respawn time for this player:
-- @param Ply (player index) [number]
-- @param return (respawn time) [number]
--
function Misc:GetRespawnTime()
    local time = 3
    if (self.team == self.zombie_team) then
        if (self.alpha) then
            time = self.attributes['Alpha Zombies'].respawn_time
        else
            time = self.attributes['Standard Zombies'].respawn_time
        end
    elseif (self.team == self.human_team) then
        time = self.attributes['Humans'].respawn_time
        if (self.last_man == self.id) then
            time = self.attributes['Last Man Standing'].respawn_time
        end
    end
    return time
end

-- Returns the appropriate weapon table for a given player:
-- @param Ply (player index) [number]
-- @return, weapon table [table]
--
function Misc:GetWeaponTable()
    if (self.team == self.zombie_team) then
        if (self.alpha) then
            return self.attributes['Alpha Zombies'].weapons
        else
            return self.attributes['Standard Zombies'].weapons
        end
    elseif (self.team == self.human_team) then
        if (self.last_man == nil) then
            return self.attributes['Humans'].weapons
        else
            return self.attributes['Last Man Standing'].weapons
        end
    end
end

function Misc:SetNav()
    local player = get_player(self.id)
    if (self.last_man and self.id ~= self.last_man) then
        write_word(player + 0x88, to_real_index(self.last_man))
    else
        write_word(player + 0x88, to_real_index(self.id))
    end
end

function Misc:DestroyDrones()
    for k, drone in pairs(self.drones) do
        if (k and drone.despawn and not player_alive(self.id)) then
            local object = get_object_memory(drone.weapon)
            if (object ~= 0) then
                destroy_object(drone.weapon)
            else
                self.drones[k] = nil
            end
        end
    end
end

function Misc:DespawnWeapons()
    execute_command('nades ' .. self.id .. ' 0')
    for _, weapon in ipairs(self.drones) do
        weapon.despawn = true
    end
end

function Misc:EndTheGame(team)
    team = team or ''
    local msg = self.messages.end_of_game
    self:SayAll(msg:gsub('$team', team))
    execute_command('sv_map_next')
end

function Misc:Falling(M)
    return (M == self.fall_damage or M == self.distance_damage)
end

function Misc:GetPlayer(P)
    return self.players[P]
end

return Misc