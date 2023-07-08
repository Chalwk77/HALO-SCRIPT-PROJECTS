local weapons = {}

local floor = math.floor
local format = string.format

local function isFiring(dynamic_player)
    return (read_float(dynamic_player + 0x490) == 1)
end

local function reloading(dynamic_player)
    return (read_byte(dynamic_player + 0x2A4) == 5)
end

local function meleeButton(dynamic_player)
    return (read_word(dynamic_player + 0x208) == 128)
end

local function overheating(object)
    return (read_bit(object + 0x22C, 0) == 1)
end

local function getAmmunition(object)

    -- non-energy weapons:
    local primary = read_word(object + 0x2B8) -- primary
    local reserve = read_word(object + 0x2B6) -- reserve

    -- energy weapons:
    local battery = read_float(object + 0x240)
    local energy_bullets = floor(battery * 100)

    return {
        primary = primary,
        reserve = reserve,
        energy_bullets = energy_bullets
    }
end

local function checkDurability(weapon, rate, reload)

    if (not weapon.timer:isStarted()) then
        weapon.timer:start()
    end

    local ammunition = getAmmunition(weapon.object)
    local primary = ammunition.primary
    local energy_bullets = ammunition.energy_bullets

    if (not reload and primary == 0 and energy_bullets == 0) then
        return false
    end

    weapon.durability = weapon.durability - (rate / 30)

    local time = weapon.timer:get()
    local durability = weapon.durability
    local frequency = (durability / 100) ^ 2 * 100

    --cprint('Jam when: ' .. time .. ' / ' .. frequency)

    if (time >= frequency) then
        weapon.ammo = ammunition
        weapon.jammed = true
        weapon.timer:restart()
        return true
    end
end

function weapons:notifyDurability(weapon)
    local min = self.weapon_degradation.no_jam_before
    local durability = floor(weapon.durability)
    if (durability >= min) then
        return -- do nothing
    elseif (durability % 10 == 0 and weapon.notify) then
        self:newMessage('This weapon is now at ' .. durability .. '% durability', 8)
        weapon.notify = false
    elseif (durability % 10 ~= 0) then
        weapon.notify = true
    end
end

function weapons:degrade()

    local id = self.id
    local dyn = get_dynamic_player(id)

    if (not self.pre_game_timer or not self.pre_game_timer.started) then
        return
    elseif (not self.weapon_degradation.enabled) then
        return
    elseif (not player_alive(id) or dyn == 0) then
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

    local weapon = self:getWeapon(object)

    local in_vehicle = self:inVehicle(dyn)
    local overheated = overheating(object)
    if (in_vehicle or overheated) then
        return
    elseif (self:jamWeapon(weapon, dyn)) then
        -- only do this if they're not in a vehicle or overheated
        return
    end

    local melee = meleeButton(dyn)
    local is_firing = isFiring(dyn)
    local is_reloading = reloading(dyn)

    if (is_firing or is_reloading or melee) then

        local meta_id = read_dword(object) -- weapon tag id
        local rate = self.decay_rates[meta_id]

        rate = (is_reloading and rate / 5) or rate

        if (weapon.durability <= 0) then
            weapon.durability = 0
            self:newMessage('Your weapon has been destroyed', 8)
            destroy_object(this_weapon)
        elseif (checkDurability(weapon, rate, is_reloading)) then
            self:newMessage('Weapon jammed! Press MELEE to unjam.', 5)
        else
            self:notifyDurability(weapon)
        end
    end
end

function weapons:jamWeapon(weapon, dyn)

    if (not weapon.jammed) then
        return false
    end

    local melee = meleeButton(dyn)
    if (not melee) then
        write_word(weapon.object + 0x2B8, 0) -- primary
        write_word(weapon.object + 0x2B6, 0) -- reserve
        write_float(weapon.object + 0x240, 0) -- battery
        sync_ammo(weapon.weapon)
        return true
    end

    local ammunition = weapon.ammo
    local primary = ammunition.primary
    local reserve = ammunition.reserve
    local battery = ammunition.energy_bullets / 100

    write_word(weapon.object + 0x2B8, primary)
    write_word(weapon.object + 0x2B6, reserve)
    write_float(weapon.object + 0x240, battery)
    sync_ammo(weapon.weapon)

    weapon.jammed = nil
    weapon.ammo = nil

    self:newMessage('Weapon UNJAMMED!', 5)
    return false
end

return weapons