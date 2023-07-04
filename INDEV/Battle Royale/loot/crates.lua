local crates = {}

function crates:crateIntersect()

    if (not self.looting.enabled or not self.loot_crates) then
        return
    end

    local dyn = get_dynamic_player(self.id)
    if (dyn == 0 or not player_alive(self.id)) then
        return
    end

    local px, py, pz = self:getXYZ(dyn)

    for meta_id, v in pairs(self.loot_crates) do

        local object = get_object_memory(meta_id)
        if (object == 0) then
            goto next
        end

        local ox, oy, oz = v.x, v.y, v.z
        local distance = self:getDistance(px, py, pz, ox, oy, oz)
        if (distance <= 1) then
            destroy_object(meta_id)
            self:openCrate()
        end
        :: next ::
    end
end

-- Get a random spoil:
-- @t: table (self.looting.spoils)
local function getSpoils(t)

    local chance = 0
    local chance_table = {}
    for i, _ in pairs(t) do
        if (i ~= 0) then
            chance = chance + i
            chance_table[i] = chance
        end
    end

    local spoil
    local random = rand(1, chance + 1)
    for i, _ in pairs(chance_table) do
        if (random <= chance_table[i]) then
            spoil = t[i]
            break
        end
    end

    return spoil
end

function crates:openCrate()

    local spoils = getSpoils(self.looting.spoils)

    if (not spoils) then
        self:newMessage('Something went wrong. Unable to unlock spoils.', 5)
        return
    end

    self:newMessage('You unlocked ' .. spoils.label, 5)
    self:unlock(spoils)
end

return crates