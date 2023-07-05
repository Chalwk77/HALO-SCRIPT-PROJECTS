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

    local total = 0
    for k, _ in pairs(t) do
        total = total + k
    end

    local index = 0
    local random = rand(1, total + 1)

    for k, v in pairs(t) do
        index = index + k
        if (random <= index) then
            return k, v
        end
    end
end

function crates:openCrate()

    local _, spoils = getSpoils(self.looting.spoils)

    if (not spoils) then
        self:newMessage('Something went wrong. Unable to unlock spoils.', 5)
        return
    end

    self[spoils._function_](self, spoils)
end

-- Test the loot system:
function crates:testLoot()

    local iterations = 1000

    local chances = {}
    for _ = 1, iterations do

        local _, spoils = getSpoils(self.looting.spoils)
        local label = spoils.label

        if (not chances[label]) then
            chances[label] = 0
        end

        chances[label] = chances[label] + 1
    end

    print(' ')
    for k, v in pairs(chances) do

        -- k = label
        -- v = how many times the loot was chosen out of 'iterations'

        print('Label: ' .. k, 'Chosen: ' .. v .. ' times')
    end

    -- Get the one that was chosen the most:
    print(' ')
    local max, label = 0, nil
    for k, v in pairs(chances) do
        if (v > max) then
            max = v
            label = k
        end
    end
    print('Most chosen: ' .. label .. ' (' .. max .. ' times)')
end

return crates