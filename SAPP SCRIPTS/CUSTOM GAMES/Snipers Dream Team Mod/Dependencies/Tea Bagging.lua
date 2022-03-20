-- Snipers Dream Team Mod [Tea Bagging File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local SDTM = {}
local time = os.time

function SDTM:TeaBagging()
    for i, k in pairs(self.players) do
        for j, v in pairs(self.players) do
            if (i ~= j and #v.loc > 0) then

                local dyn = get_dynamic_player(i)
                for id, pos in pairs(v.loc) do
                    if (time() >= pos.finish) then
                        v.loc[id] = nil
                    elseif player_alive(i) then

                        local x1, y1, z1 = pos.x, pos.y, pos.z
                        local x2, y2, z2 = self:GetPos(dyn) -- killer pos

                        if (x2 and self:GetDist(x1, y1, z1, x2, y2, z2) <= k.settings.t_bag_radius) then
                            local crouch = read_bit(dyn + 0x208, 0)
                            if (crouch ~= k.state and crouch == 1) then
                                k.count = k.count + 1
                            elseif (k.count >= k.settings.t_bag_crouch_count) then
                                v.loc[i], k.count = nil, 0
                                k:Broadcast(k.settings.t_bag_message:gsub("$name", k.name):gsub("$victim", v.name))
                            end
                            k.state = crouch
                        end
                    end
                end
            end
        end
    end
end

function SDTM:SaveLoc(Victim, Killer)

    local victim = tonumber(Victim)
    local killer = tonumber(Killer)
    if (killer > 0 and killer ~= victim) then
        local v = self.players[victim]
        local dyn = get_dynamic_player(victim)
        if (v and dyn ~= 0) then
            local x, y, z = self:GetPos(dyn)
            v.loc[#v.loc + 1] = {
                x = x, y = y, z = z,
                finish = time() + v.settings.t_bag_expiration
            }
        end
    end
end

return SDTM