local event = {}

function event:onEnd()
    self:updateAliases()
end

register_callback(cb['EVENT_GAME_END'], 'OnEnd')

return event