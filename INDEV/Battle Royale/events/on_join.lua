local event = {}
local time = os.time

function event:newPlayer(o)

    setmetatable(o, self)
    self.__index = self

    o.messages = { primary = '' }
    o.lives = self.max_lives

    return o
end

function event:onJoin(id)

    self.players[id] = self:newPlayer({
        id = id,
        name = get_var(id, '$name')
    })

    self:phaseCheck(_, id)
end

register_callback(cb['EVENT_JOIN'], 'OnJoin')

return event