local event = {}

function event:onPickup(id)

end

register_callback(cb['EVENT_WEAPON_PICKUP'], 'OnPickup')

return event