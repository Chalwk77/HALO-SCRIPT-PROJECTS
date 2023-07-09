local event = {}
local time = os.time

function event:newPlayer(o)

    setmetatable(o, self)
    self.__index = self

    o.messages = { primary = '' }
    o.lives = self.max_lives

    o.speed = {
        current = self.default_running_speed
    }

    return o
end

function event:onJoin(id)

    self.players[id] = self:newPlayer({
        id = id,
        name = get_var(id, '$name')
    })

    self:phaseCheck(_, id)
end

function event:resetPlayer()

    local id = self.id
    local player = self.players[id]

    player.lives = self.max_lives
    player.speed.current = self.default_running_speed
    player.speed.duration = 0
    player.speed.timer = self:new()
    player.speed.timer:start()

    player.messages = { primary = '' }

    player.weapon_parts = nil
    player.stun = nil
    player.can_stun = nil
    player.spectator = nil
end

register_callback(cb['EVENT_JOIN'], 'OnJoin')

return event