local weapons = {}

function weapons:newWeapon()

    self.weapons = self.weapons or {}

    local id = self.id
    local dyn = get_dynamic_player(id)
    if (not player_alive(id) or dyn == 0) then
        return
    end

    local weapon = read_dword(dyn + 0x118)
    local object = get_object_memory(weapon)

    if (weapon == 0xFFFFFFFF) then
        return
    elseif (object == 0) then
        self.weapons[object] = nil
        return
    end

    -- Constructor for new weapon object:
    if (not self.weapons[object]) then

        self.weapons[object] = {
            damage_multiplier = 0, -- default damage multiplier
            ammo_type = 0, -- default ammo type
            object = object,
            timer = self:new(),
            durability = self.weapon_degradation.max_durability, -- 0% = broken, 100% = new
            notify = true
        }

        setmetatable(self.weapons[object], self)
        self.__index = self
    end
end

-- Gets the weapon object:
function weapons:getWeapon(object)
    return self.weapons[object]
end

-- Sets the weapon ammo type:
function weapons:setAmmoType(type)
    self.ammo_type = type
end

-- Gets the weapon ammo type:
function weapons:getAmmoType()
    return self.ammo_type
end

-- Sets the weapon ammo damage multiplier:
function weapons:setAmmoDamage(mult)
    self.damage_multiplier = mult
end

-- Gets the weapon ammo damage multiplier:
function weapons:getAmmoDamage()
    return self.damage_multiplier
end

return weapons