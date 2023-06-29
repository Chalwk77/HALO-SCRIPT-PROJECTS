local event = {}

function event:onQuit(id)

    self.players[id] = nil

    self:phaseCheck(true)
end

register_callback(cb['EVENT_LEAVE'], 'OnQuit')

return event