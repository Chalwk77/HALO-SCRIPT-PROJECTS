local event = {}

function event:onDrop(id)

end

register_callback(cb['EVENT_WEAPON_DROP'], 'OnDrop')

return event