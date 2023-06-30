local loot = {}

function loot:spawn(object, x, y, z)
    return spawn_object('', '', x, y, z + 0.3, 0, object)
end

-- Picks are random number of loot items to spawn:
-- @t (table) table of coordinates for an object.
-- @return (number) number of items to spawn.
--
local function numberOfItem(t)

    local min = 0
    local max = #t

    return rand(min, max + 1)
end

function loot:spawnLoot()

    if (not self.looting.enabled) then
        return
    end

    local t = {}
    local objects = self.looting.objects
    for tag_class, v in pairs(objects) do
        for tag_name, coordinates in pairs(v) do

            local tag = self:getTag(tag_class, tag_name)
            if (not tag) then
                goto next -- tag not found, skip to next object
            end

            local item_count = numberOfItem(coordinates)
            for i = 1, item_count do

                local coord_table = coordinates[i]
                local delay = coord_table[#coord_table]
                local x, y, z = coord_table[1], coord_table[2], coord_table[3]

                local meta_id = self:spawn(tag, x, y, z)
                if (meta_id) then
                    cprint('Spawning: ' .. tag_class .. ', ' .. tag_name .. ' (' .. i .. ' of ' .. item_count .. ')')
                    t[meta_id] = {
                        tag = tag,
                        x = x,
                        y = y,
                        z = z,
                        delay = delay
                    }
                end
            end
        end

        :: next ::
    end

    self.loot = t
end

return loot