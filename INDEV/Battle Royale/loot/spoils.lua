local spoils = {}

-- Gives the player a nuke.
-- This will kill all players within a X world/unit radius.
function spoils:giveNuke(args)
    local radius = args.radius
    self:newMessage('You unlocked ' .. args.label, 5)
end

function spoils:enableAirstrike(args)
    self:newMessage('You unlocked ' .. args.label, 5)
end

function spoils:giveStunGrenades(args)
    self:newMessage('You unlocked ' .. args.label, 5)
end

function spoils:giveGrenadeLauncher(args)

    local id = self.id

    local dyn = get_dynamic_player(id)
    local this_weapon = read_dword(dyn + 0x118)
    if (this_weapon == 0xFFFFFFFF) then
        self:newMessage('Picked up grenade launcher but no weapon to modify!', 5)
        return true
    end

    local object = get_object_memory(this_weapon)
    if (object ~= 0) then

        local weapon = self:getWeapon(object)
        weapon.velocity = args.velocity
        weapon.distance = args.distance
        weapon.projectile = self.frag_projectile

        weapon:setAmmoType(5)
        weapon:setAmmoDamage(100)

        self:newMessage('You unlocked ' .. args.label)
        return true
    end
    return false
end

function spoils:giveWeaponParts(args)
    self.weapon_parts = true
    self:newMessage('You unlocked ' .. args.label, 5)
    return true
end

function spoils:giveRandomWeapon(args)
    self:newMessage('You unlocked ' .. args.label, 5)
    return true
end

function spoils:giveSpeedBoost(args)

    local label = args.label
    local multipliers = args.multipliers

    local mult = multipliers[rand(1, #multipliers + 1)]
    local speed_multiplier = mult[1]
    local duration = mult[2]

    local new_speed = self.speed.current * speed_multiplier
    self.speed.current = new_speed
    self.speed.duration = duration

    self.speed.timer = self:new()
    self.speed.timer:start()

    new_speed = string.format('%.2f', new_speed)

    label = label:gsub('$speed', new_speed):gsub('$duration', duration)
    self:newMessage('You unlocked ' .. label, 5)
    return true
end

function spoils:giveAmmo(args)

    local id = self.id
    local ammo_types = args.types

    local type = rand(1, #ammo_types + 1)
    local multiplier = ammo_types[type][1]
    local label = ammo_types[type][2]

    local dyn = get_dynamic_player(id)
    local this_weapon = read_dword(dyn + 0x118)
    if (this_weapon == 0xFFFFFFFF) then
        self:newMessage('Picked up custom ammo but no weapon to modify!', 5)
        return true
    end

    local object = get_object_memory(this_weapon)
    if (object ~= 0) then

        local weapon = self:getWeapon(object)

        --- for explosive bullets:
        weapon.velocity = 10
        weapon.distance = 0.5
        weapon.projectile = self.rocket_projectile
        --

        weapon:setAmmoType(type)
        weapon:setAmmoDamage(multiplier)

        local meta_id = read_dword(object) -- weapon tag id
        local clip_size = self.clip_sizes[meta_id]

        write_word(object + 0x2B8, clip_size) -- primary
        write_float(object + 0x240, clip_size) -- battery
        sync_ammo(this_weapon)

        label = label:gsub('$ammo', clip_size)

        self:newMessage('You unlocked ' .. label)
        return true
    end
    return false
end

function spoils:giveCamo(args)
    self:newMessage('You unlocked ' .. args.label, 5)
    return true
end

function spoils:giveOvershield(args)
    self:newMessage('You unlocked ' .. args.label, 5)
    return true
end

function spoils:giveHealthBoost(args)
    self:newMessage('You unlocked ' .. args.label, 5)
    return true
end

return spoils