local spoils = {}

-- Gives the player a nuke.
-- This will kill all players within a X world/unit radius.
function spoils:giveNuke(args)
    local radius = args.radius
end

function spoils:enableAirstrike(args)
    print('Executing spoils:enableAirstrike()', self.name)
end

function spoils:giveStunGrenades(args)
    print('Executing spoils:giveStunGrenades()', self.name)
end

function spoils:giveGrenadeLauncher(args)
    print('Executing spoils:giveGrenadeLauncher()', self.name)
end

function spoils:giveWeaponParts(args)
    print('Executing spoils:giveWeaponParts()', self.name)
end

function spoils:giveRandomWeapon(args)
    print('Executing spoils:giveRandomWeapon()', self.name)
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
end

function spoils:giveAmmo(args)
    print('Executing spoils:giveAmmo()', self.name)
end

function spoils:giveCamo(args)
    print('Executing spoils:giveCamo()', self.name)
end

function spoils:giveOvershield(args)
    print('Executing spoils:giveOvershield()', self.name)
end

function spoils:giveHealthBoost(args)
    print('Executing spoils:giveHealthBoost()', self.name)
end

return spoils