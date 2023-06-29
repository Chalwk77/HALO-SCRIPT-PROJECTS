local event = {}

function event:newPlayer(o)
    setmetatable(o, self)
    self.__index = self
    return o
end

function event:onJoin(id)

    self.players[id] = self:newPlayer({
        id = id,
        name = get_var(id, '$name')
    })

    self:phaseCheck()
end

register_callback(cb['EVENT_JOIN'], 'OnJoin')

return event