local event = {}

function event:onQuit(id)

    self:phaseCheck(true, id)
    self.players[id] = nil

end

register_callback(cb['EVENT_LEAVE'], 'OnQuit')

return event