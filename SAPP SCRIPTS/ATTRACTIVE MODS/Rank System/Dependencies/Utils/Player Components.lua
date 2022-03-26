-- Rank System [Player Components File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Player = {}

local function ReadString(Object)
    return read_string(read_dword(read_word(Object) * 32 + 0x40440038))
end

function Player:InVehicle()

    local dyn = get_dynamic_player(self.pid)
    if (dyn ~= 0) then

        local vehicle = read_dword(dyn + 0x11C)
        local object = get_object_memory(vehicle)
        if (vehicle ~= 0 and vehicle ~= 0xFFFFFFFF) then

            local tags = self.credits.tags
            local name = ReadString(object)
            local jpt = tags.damage[self.meta_id]

            for _, v in pairs(self.credits.tags.vehicles) do
                if (name == v[2]) then
                    if (self.meta_id == self.collision) then
                        self:UpdateCR({ v[3], v[4] })
                    else
                        self:UpdateCR({ jpt[1], jpt[2] })
                    end
                end
            end
            return true
        end
    end
    return false
end

function Player:FirstBlood()
    if (self.first_blood) then
        local kills = tonumber(get_var(self.pid, "$kills"))
        if (kills == 1) then
            local t = self.credits.first_blood
            self.first_blood = false
            self:UpdateCR({ t[1], t[2] })
        end
    end
end

function Player:KillingSpree()
    local player = get_player(self.pid)
    if (player ~= 0) then
        local t = self.credits.spree
        local k = read_word(player + 0x96)
        for _, v in pairs(t) do
            if (k == v[1]) or (k >= t[#t][1] and k % 5 == 0) then
                self:UpdateCR({ v[2], v[3] })
            end
        end
    end
end

function Player:MultiKill()
    local player = get_player(self.pid)
    if (player ~= 0) then
        local t = self.credits.multi_kill
        local k = read_word(player + 0x98)
        for _, v in pairs(t) do
            if (k == v[1]) or (k >= t[#t][1] and k % 2 == 0) then
                self:UpdateCR({ v[2], v[3] })
            end
        end
    end
end

function Player:KilledFromGrave()
    if (not player_alive(self.pid)) then
        local t = self.credits.killed_from_the_grave
        self:UpdateCredits(self.pid, { t[1], t[2] })
    end
end

return Player