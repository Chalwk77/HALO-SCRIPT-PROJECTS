local loot = {}

function loot:monitorLoot()

    if (not self.looting.enabled or not self.loot) then
        return
    end

    for item, v in pairs(self.loot) do

        local object_memory = get_object_memory(item)
        if (object_memory == 0) then

            if (not v.timer) then
                v.timer = self:new()
                v.timer:start()
                goto next
            elseif (v.timer:get() >= v.delay) then
                v.timer = nil -- just in case

                local tag = v.tag
                local x, y, z = v.x, v.y, v.z

                local object = self:spawn(tag, x, y, z)
                if (tag and object) then
                    self.loot[object] = v
                    self.loot[item] = nil
                end
            --else
            --    print('respawning item in ' .. v.delay - v.timer:get() .. ' seconds')
            end
        end
        :: next ::
    end
end

return loot