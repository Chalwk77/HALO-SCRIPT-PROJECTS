-- Rank System [Death Event File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = {}

function Event:OnDeath(V, K)

    local killer = tonumber(K)
    local victim = tonumber(V)

    local k = self:GetPlayer(killer)
    local v = self:GetPlayer(victim)

    if (v) then

        local server = (killer == -1)
        local jpt = v.damage[v.meta_id]
        local guardians = (killer == nil)
        local suicide = (killer == victim)
        local pvp = (k and v and killer ~= victim)
        local betrayal = (k and v and (not self.ffa) and (v.team == k.team and killer ~= victim))

        if (pvp and not betrayal) then

            k:HeadShot()
            k:MultiKill()
            k:FirstBlood()
            k:KillingSpree()
            k:KilledFromGrave()

            if k:InVehicle() then
                return
            elseif (jpt) then
                k:UpdateCR({ jpt[1], jpt[2] })
            end

        elseif (server) then
            v:UpdateCR({ v.credits.server[1], v.credits.server[2] })
        elseif (guardians) then
            v:UpdateCR({ v.credits.guardians[1], v.credits.guardians[2] })
        elseif (suicide) then
            v:UpdateCR({ v.credits.suicide[1], v.credits.suicide[2] })
        elseif (betrayal) then
            k:UpdateCR({ v.credits.betrayal[1], v.credits.betrayal[2] })
        end
    end
end

return Event