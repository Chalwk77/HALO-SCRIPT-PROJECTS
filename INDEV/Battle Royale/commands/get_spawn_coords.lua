local Command = {}

local function threeDecimal(s)
    return string.format('%.3f', s)
end

-- Executes this command.
-- @param id = player id (number)
-- @param args (table of command strings)
--
function Command:run(id, args)

    local p = self.players[id] -- admin

    if not p:commandEnabled(self.enabled, self.name) then
        return
    elseif not p:hasPermission(self.level) then
        return
    end

    local dyn = get_dynamic_player(p.id)
    if (dyn == 0 or not player_alive(p.id)) then
        p:say('You are dead!')
        return
    end

    local x, y, z, r = p:getXYZ(dyn)

    x = threeDecimal(x)
    y = threeDecimal(y)
    z = threeDecimal(z)
    r = threeDecimal(r)

    print('{' .. x .. ', ' .. y .. ', ' .. z .. ', ' .. r .. ', 35}')

end

return Command