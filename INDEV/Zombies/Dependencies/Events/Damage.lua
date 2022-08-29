-- Zombies [Damage Event File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = {}

function Event:OnDamage(V, K, M, D)

    local killer = tonumber(K)
    local victim = tonumber(V)

    local v = self.players[victim]
    local k = self.players[killer]

    if (killer > 0 and k and v) then
        k.meta_id, v.meta_id = M, M
        local friendly_fire = (k.team == v.team and killer ~= victim)
        if (self.block_fall_damage and self:Falling(M)) then
            return false
        elseif (friendly_fire) then
            return false

            -- Multiply units of damage by the appropriate damage multiplier property:
            -- zombie vs human:
        elseif (k.team == self.zombie_team) then
            if (k.alpha) then
                return true, D * self.attributes["Alpha Zombies"].damage_multiplier
            else
                return true, D * self.attributes["Standard Zombies"].damage_multiplier
            end
            -- human vs zombie:
        elseif (k.team == self.human_team) then
            if (killer == self.last_man) then
                return true, D * self.attributes["Last Man Standing"].damage_multiplier
            else
                return true, D * self.attributes["Humans"].damage_multiplier
            end
        end
    end
end

return Event