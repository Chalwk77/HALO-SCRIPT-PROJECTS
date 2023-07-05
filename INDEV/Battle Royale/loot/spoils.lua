local spoils = {}

-- Gives the player a nuke.
-- This will kill all players within a X world/unit radius.
function spoils:giveNuke(args)
    local label = args.label
    local radius = args.radius
    self:newMessage('You unlocked ' .. label, 5)
end

function spoils:enableAirstrike(args)
    local label = args.label
    self:newMessage('You unlocked ' .. label, 5)
end

function spoils:giveStunGrenades(args)
    local label = args.label
    self:newMessage('You unlocked ' .. label, 5)
end

function spoils:giveGrenadeLauncher(args)
    local label = args.label
    self:newMessage('You unlocked ' .. label, 5)
end

function spoils:giveWeaponParts(args)
    self.weapon_parts = true
    local label = args.label
    self:newMessage('You unlocked ' .. label, 5)
end

function spoils:giveRandomWeapon(args)
    local label = args.label
    self:newMessage('You unlocked ' .. label, 5)
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
    local label = args.label
    self:newMessage('You unlocked ' .. label, 5)
end

function spoils:giveCamo(args)
    local label = args.label
    self:newMessage('You unlocked ' .. label, 5)
end

function spoils:giveOvershield(args)
    local label = args.label
    self:newMessage('You unlocked ' .. label, 5)
end

function spoils:giveHealthBoost(args)
    local label = args.label
    self:newMessage('You unlocked ' .. label, 5)
end

return spoils