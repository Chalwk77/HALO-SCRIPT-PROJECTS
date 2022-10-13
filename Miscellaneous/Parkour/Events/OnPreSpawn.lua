-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = { }

-- Called during pre-spawn event:
function Event:OnPreSpawn()
    local dyn = get_dynamic_player(self.id)
    if (self.x and dyn ~= 0) then
        write_vector3d(dyn + 0x5C, self.x, self.y, self.z)
    end
end

-- Register the event:
register_callback(cb['EVENT_PRESPAWN'], 'OnPreSpawn')

return Event