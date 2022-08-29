-- Zombies [Death Event File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = {}

function Event:DeathSwitch(Killer)

    -- Switch victim to the zombie team:
    self:SwitchTeam(self.zombie_team)

    -- Set zombie type to Standard-Zombie:
    self.alpha = false

    -- Check if we need to cure this zombie:
    if (Killer) then
        Killer:Cure()
    end

    -- Check game phase:
    self:PhaseCheck()
end

function Event:Suicide()
    local msg = self.messages.suicide
    self:SayAll(msg:gsub('$victim', self.name))
end

function Event:GenericDeath()
    local msg = self.messages.generic_death
    self:SayAll(msg:gsub('$victim', self.name))
end

function Event:PvP(victim)
    local msg = self.messages.pvp
    self:SayAll(msg:gsub('$killer', self.name):gsub('$victim', victim))
end

function Event:Guardians(victim)
    local msg = self.messages.guardians_death
    self:SayAll(msg:gsub('$killer', self.name):gsub('$victim', victim))
end

function Event:AnnounceZombify(victim)
    local msg = self.messages.on_zombify
    self:SayAll(msg:gsub('$killer', self.name):gsub('$victim', victim))
end

function Event:OnDeath(V, K)

    if (not self.block_death_messages and self.game_started) then

        local victim = tonumber(V)
        local killer = tonumber(K)

        local v = self.players[victim]
        local k = self.players[killer]

        if (v) then

            v:SetRespawn()

            local fell = v:Falling(v.meta)
            local squashed = (killer == 0)
            local guardians = (killer == nil)
            local suicide = (killer == victim)
            local pvp = (k and killer ~= victim)
            local server = (killer == -1 and not v.switched)

            if (pvp) then

                -- zombie vs human:
                if (v.team == self.human_team) then

                    -- If the last man alive was killed by someone who is about to be cured,
                    -- reset last-man status:
                    if (self.last_man == victim) then
                        self.last_man = nil
                    end

                    v:DeathSwitch(k)
                    k:AnnounceZombify(v.name)

                    -- human vs zombie:
                else
                    k:PvP(v.name)
                end
            elseif (suicide) then
                if (v.team == self.human_team) then
                    v:DeathSwitch()
                else
                    v:Suicide()
                end
            elseif (guardians) then
                k:Guardians(v.name)
            elseif (squashed or (server and not fell) and not v.switching) then
                v:GenericDeath()
            elseif (fell) then
                if (v.team == self.human_team) then
                    v:DeathSwitch()
                else
                    v:GenericDeath()
                end
            elseif (not v.switching) then
                v:GenericDeath()
            end

            -- Prepare weapons for deletion:
            if (v.team == self.zombie_team) then
                v:DespawnWeapons()
            end

            v.switching = false
        end
    end
end

return Event