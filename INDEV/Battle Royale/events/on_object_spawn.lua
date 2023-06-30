local event = {}

function event:onObjectSpawn(player, map_id, parent_id, object_id, sapp_spawning)

    if (not sapp_spawning) then

    end

    return true
end

register_callback(cb['EVENT_OBJECT_SPAWN'], 'OnObjectSpawn')

return event