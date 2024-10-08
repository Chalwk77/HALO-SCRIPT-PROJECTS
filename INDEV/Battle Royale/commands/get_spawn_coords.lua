local Command = {}

local format = string.format
function Command:run(id, args)

    local player = self.players[id] -- admin

    if not player:commandEnabled(self.enabled, self.name) then
        return
    elseif not player:hasPermission(self.level) then
        return
    end

    local dyn = get_dynamic_player(id)
    if (dyn == 0 or not player_alive(id)) then
        player:newMessage('You are dead!')
        return
    end

    local height = tonumber(args[2])
    height = height or 35

    local x, y, z, r = player:getXYZ(dyn)

    x = self:threeDecimal(x)
    y = self:threeDecimal(y)
    z = self:threeDecimal(z)
    r = self:threeDecimal(r)

    local str = format('{%s, %s, %s, %s, %s},', x, y, z, r, height)
    player:newMessage('[POS SET]: ' .. str)
    cprint(str)
end

return Command