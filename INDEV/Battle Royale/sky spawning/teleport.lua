local player = {}

function player:teleport()

    local dyn = get_dynamic_player(self.id)
    if (dyn == 0) then
        return
    end

    local x, y, z = self.spawn[1], self.spawn[2], self.spawn[3]
    local height = self.spawn[4]

    write_vector3d(dyn + 0x5C, x, y, z + height)

    self.god = self:new() -- god mode timer
end

return player