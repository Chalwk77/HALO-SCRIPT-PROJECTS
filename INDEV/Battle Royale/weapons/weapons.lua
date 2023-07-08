local weapons = {}

local function reloading(dynamic_player)
    return (read_byte(dynamic_player + 0x2A4) == 5)
end

function weapons:newWeapon()

    local id = self.id
    local dyn = get_dynamic_player(id)
    if (not self.pre_game_timer or not self.pre_game_timer.started) then
        return
    elseif (self.spectator or not player_alive(id) or dyn == 0) then
        return
    end

    local this_weapon = read_dword(dyn + 0x118)
    local object = get_object_memory(this_weapon)

    if (this_weapon == 0xFFFFFFFF) then
        return
    elseif (object == 0) then
        self.weapons[object] = nil
        return
    end

    -- Constructor for new weapon object:
    if (not self.weapons[object]) then

        self.weapons[object] = {
            weapon = this_weapon, -- weapon tag
            damage_multiplier = 0, -- default damage multiplier
            ammo_type = 1, -- default ammo type
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
-- 1 = normal bullets
-- 2 = armour piercing bullets
-- 3 = explosive bullets
-- 4 = golden bullets (one-shot kill)
-- 5 = grenade launcher
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

function weapons:customAmmo()

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

    weapon = self:getWeapon(object)

    -- normal ammo, ignore:
    if (weapon:getAmmoType() == 1) then
        return
    end

    local primary = read_dword(object + 0x2B8) -- primary
    if (primary == 0 or reloading(dyn)) then
        weapon:setAmmoType(1) -- reset ammo type
        weapon:setAmmoDamage(0) -- reset damage multiplier
        self:newMessage('Ammo returned to normal', 8)
        return
    end
end

function weapons:createProjectile(dyn, weapon)

    local id = self.id
    local px, py, pz = self:getXYZ(dyn)

    local xAim =  math.sin(read_float(dyn + 0x230))
    local yAim =  math.sin(read_float(dyn + 0x234))
    local zAim =  math.sin(read_float(dyn + 0x238))

    local xVel = weapon.velocity * xAim
    local yVel = weapon.velocity * yAim
    local zVel = weapon.velocity * zAim

    local distance = weapon.distance
    local x = px + (distance * xAim)
    local y = py + (distance * yAim)
    local z = pz + (distance * zAim)

    if (weapon.projectile) then

        local rocket = spawn_projectile(weapon.projectile, id, x, y, z)
        local object = get_object_memory(rocket)

        if (rocket and object ~= 0) then
            write_float(object + 0x68, xVel)
            write_float(object + 0x6C, yVel)
            write_float(object + 0x70, zVel)
        end
    end
end

return weapons