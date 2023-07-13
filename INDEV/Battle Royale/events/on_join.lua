local event = {}

function event:hide(player, dyn)
    local x, y, z = self:getXYZ(dyn)
    write_float(player + 0xF8, x - 1000)
    write_float(player + 0xFC, y - 1000)
    write_float(player + 0x100, z - 1000)
end

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

    self:phaseCheck(false, id)
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