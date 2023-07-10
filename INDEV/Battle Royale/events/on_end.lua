local event = {}

function event:onEnd()
    self.game_timer = nil
    self.pre_game_timer = nil
    self.post_game_carnage_report = true
end

register_callback(cb['EVENT_GAME_END'], 'OnEnd')

return event