local Command = {}

-- Executes this command.
-- @param id = player id (number)
-- @param args (table of command strings)
--
function Command:run(id, args)

    local p = self.players[id]

    if not p:commandEnabled(self.enabled, self.name) then
        return
    elseif not p:hasPermission(self.level) then
        return
    end

    if (not p.weapon_parts) then
        p:newMessage("You don't have weapon parts!", 5)
        return
    end

    self:repairsWeapons(p)
end

function Command:repairsWeapons(player)

    local id = player.id
    local dyn = get_dynamic_player(id)
    if (dyn == 0 or not player_alive(id)) then
        self:newMessage('You are dead! Unable to repair weapons.', 5)
        return
    end

    local repaired
    for i = 0, 3 do

        local this_weapon = read_dword(dyn + 0x2F8 + i * 4)
        local object = get_object_memory(this_weapon)

        if (this_weapon ~= 0xFFFFFFFF and object ~= 0) then

            local weapon = self.decay[object]
            local max = self.weapon_degradation.max_durability

            if (weapon and weapon.durability < max) then
                weapon.durability = max
                repaired = true
            end
        end
    end

    player.weapon_parts = nil
    if (repaired) then
        player:newMessage('Weapon repaired!', 5)
    else
        player:newMessage('Nothing was repaired!', 5)
    end
end

return Command