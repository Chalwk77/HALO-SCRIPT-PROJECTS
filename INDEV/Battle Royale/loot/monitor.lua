local loot = {}

function loot:monitorLoot(objects)

    if (not self.looting.enabled or not objects) then
        return
    end

    for meta_id, v in pairs(objects) do

        local object_memory = get_object_memory(meta_id)
        if (object_memory == 0) then

            if (not v.timer) then
                v.timer = self:new()
                v.timer:start()
                goto next
            elseif (v.timer:get() >= v.delay) then
                v.timer = nil -- just in case

                local tag = v.tag
                local x, y, z = v.x, v.y, v.z

                local object_meta = self:spawn(tag, x, y, z)
                objects[object_meta] = v
                objects[meta_id] = nil
            --else
            --    print('Respawning ' .. v.tag_class .. '/' .. v.tag_name .. ' in ' .. v.delay - v.timer:get() .. ' seconds')
            end
        end
        :: next ::
    end
end

return loot