-- Zombies [Game Tick Event File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = {}

function Event:GameTick()
    for i, v in pairs(self.players) do
        if (i and player_present(i)) then
            v:SetNav()
            v:SetWeapons()
            v:CrouchCamo()
            v:DestroyDrones()
            v:HealthRegeneration()
        end
    end
end

return Event