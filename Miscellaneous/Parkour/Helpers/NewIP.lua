-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local IP = {}

-- This function returns the IP address of a player.
function IP:NewIP()

    local index = self.client_index_type
    local ip = get_var(self.id, '$ip')
    ip = (index == 1 and ip or ip:match('%d+.%d+.%d+.%d+'))

    self.ip = ip

    return ip
end

return IP