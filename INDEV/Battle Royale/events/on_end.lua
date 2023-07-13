local event = {}

function event:onEnd()
    self.game = nil
    self.safe_zone = nil
end

register_callback(cb['EVENT_GAME_END'], 'OnEnd')

return event