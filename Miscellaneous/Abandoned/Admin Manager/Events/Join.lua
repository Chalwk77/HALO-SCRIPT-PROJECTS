local Event = {}

function Event:NewPlayer(o)
    setmetatable(o, { __index = self })
    self.__index = self
    return o
end

function Event:OnJoin(Ply)
    self.players[Ply] = self:NewPlayer({
        level = 1, -- default level
        id = Ply,
        name = get_var(Ply, '$name'),
        hash = get_var(Ply, '$hash'),
        ip = get_var(Ply, '$ip'):match('%d+.%d+.%d+.%d+')
    })
end

return Event