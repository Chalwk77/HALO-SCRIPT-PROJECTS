-- Rank System [Damage Event File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = {}

function Event:OnDamage(V, K, M, _, H)

    local killer = tonumber(K)
    local victim = tonumber(V)

    local k = self:GetPlayer(killer)
    local v = self:GetPlayer(victim)

    if (killer > 0 and k and v) then
        k.meta_id, v.meta_id = M, M
        v.headshot = (H == 'head' or false)
    end
end

return Event