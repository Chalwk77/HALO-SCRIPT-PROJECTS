local hud = {}
local floor = math.floor

function hud:showHUD(HUD, distance)

    -- Show the primary HUD
    if (HUD == 'primary') then
        self:say('Safe Zone: ' .. floor(distance) .. ' / ' .. self.safe_zone_size .. ' w/units')
        return
    end

    -- Show the warning HUD
    if (HUD == "warning") then
        self:say("You are outside the safe zone!")
        return
    end
end

return hud