-- Rank System [Player Components File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Player = {}

local function ReadString(Object)
    return read_string(read_dword(read_word(Object) * 32 + 0x40440038))
end

function Player:Bonuses(vic)

    -- first blood:
    if (self.first_blood) then
        local kills = tonumber(get_var(self.pid, "$kills"))
        if (kills == 1) then
            local t = self.credits.first_blood
            self.first_blood = false
            self:UpdateCR({ t[1], t[2] })
        end
    end

    local player = get_player(self.pid)
    if (player ~= 0) then

        -- killing spree:
        local t = self.credits.spree
        local spree = read_word(player + 0x96) -- current spree
        for i = 1, #t do
            local v = t[i]
            if (spree == v[1]) or (spree >= t[#t][1] and spree % 5 == 0) then
                self:UpdateCR({ v[2], v[3] })
            end
        end

        -- multi-kill:
        t = self.credits.multi_kill
        local combo = read_word(player + 0x98) -- kill-combo
        for i = 1, #t do
            local v = t[i]
            if (combo == v[1]) or (combo >= t[#t][1] and combo % 2 == 0) then
                self:UpdateCR({ v[2], v[3] })
            end
        end
    end

    -- headshot:
    if (self.headshot) then
        self.headshot = false
        local t = self.credits.head_shot
        self:UpdateCR({ t[1], t[2] })
    end

    -- killed from the grave:
    if (not player_alive(self.pid)) then
        local t = self.credits.killed_from_the_grave
        self:UpdateCR({ t[1], t[2] })
    end

    -- revenge:
    vic.killer = self.pid
    if (self.killer == vic.pid) then
        self.killer = nil
        local t = self.credits.revenge
        self:UpdateCR({ t[1], t[2] })
    end

    -- avenge:
    if (not self.ffa) then
        for _, v in pairs(self.players) do
            if (v.pid and player_alive(v.pid) and v.team == vic.team and v.pid ~= vic.pid) then
                v.avenge[self.pid] = vic.pid
            end
        end
        if (self.avenge[vic.pid]) then
            local t = self.credits.avenge
            self.avenge[vic.pid] = nil
            self:UpdateCR({ t[1], t[2] })
        end
    end

    -- reload this:
    local dyn = get_dynamic_player(vic.pid) -- victim
    if (dyn ~= 0) then
        local reloading = read_byte(dyn + 0x2A4)
        if (reloading == 5) then
            local t = self.credits.reload_this
            self:UpdateCR({ t[1], t[2] })
        end
    end

    -- close call:
    dyn = get_dynamic_player(self.pid) -- killer
    if (dyn ~= 0) then
        local health = read_float(dyn + 0xE0)
        local shields = read_float(dyn + 0xE4)
        if (shields and shields == 0 and health < 1) then
            local t = self.credits.close_call
            self:UpdateCR({ t[1], t[2] })
        end
    end
end

-- Vehicle squash & vehicle weapon kill:
function Player:InVehicle()

    local dyn = get_dynamic_player(self.pid)
    if (dyn ~= 0) then

        local vehicle = read_dword(dyn + 0x11C)
        local object = get_object_memory(vehicle)
        if (vehicle ~= 0 and vehicle ~= 0xFFFFFFFF) then

            local jpt = self.damage[self.meta_id]
            local vehicles = self.credits.tags.vehicles

            vehicle = vehicles[ReadString(object)]
            if (vehicle) then
                if (self.meta_id == self.collision) then
                    self:UpdateCR({ vehicle[1], vehicle[2] })
                elseif (jpt) then
                    self:UpdateCR({ jpt[1], jpt[2] })
                end
                return true
            end
        end
    end
    return false
end

return Player