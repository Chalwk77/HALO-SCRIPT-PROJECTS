-- Rank System [Death Event File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = {}

function Event:OnDeath(V, K)

    local killer = tonumber(K)
    local victim = tonumber(V)

    local k = self.players[killer]
    local v = self.players[victim]

    if (v) then

        local server = (killer == -1)
        local guardians = (killer == nil)
        local suicide = (killer == victim)
        local pvp = (k and v and killer ~= victim)
        local jpt = v.damage[v.meta_id]
        local betrayal = (k and v and not k.ffa and (v.team == k.team and killer ~= victim))

        if (pvp and not betrayal) then

            k:MultiKill()
            k:FirstBlood()
            k:KillingSpree()
            k:KilledFromGrave()
            if k:InVehicle() then
                return
            end
            k:UpdateCR({ jpt[1], jpt[2] })

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