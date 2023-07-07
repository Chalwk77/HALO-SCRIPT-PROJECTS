local weapons = {}

local function isFiring(dynamic_player)
    return (read_float(dynamic_player + 0x490) == 1)
end

local function reloading(dynamic_player)
    return (read_byte(dynamic_player + 0x2A4) == 5)
end

local function meleeButton(dynamic_player)
    return (read_word(dynamic_player + 0x208) == 128)
end

function weapons:getWeapon(object)
    return self.decay[object]
end

function weapons:addWeapon(object, weapon)
    self.decay[object] = self.decay[object] or {
        object = object,
        weapon = weapon,
        timer = self:new(),
        decay = 0, -- out of 100 (100 = completely broken),
        notify = true,
    }
end

function weapons:degrade()

    if (not self.weapon_degradation.enabled) then
        return
    end

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
        self.decay[object] = nil
    end

    self:addWeapon(object, weapon) -- add weapon to decay table

    local is_reloading = reloading(dyn)
    local in_vehicle = self:inVehicle(dyn)

    weapon = self:getWeapon(object)

    local jammed = self:isJammed(weapon, dyn)
    local decay = (not jammed and isFiring(dyn) and not in_vehicle and not is_reloading)

    if (decay) then

        if (not weapon.timer:isStarted()) then
            weapon.timer:start()
        end

        local meta_id = read_dword(object) -- weapon tag id
        local rate = self.decay_rates[meta_id]
        local min = self.weapon_degradation.min
        local max = self.weapon_degradation.max

        weapon.decay = weapon.decay + (rate / 30)

        if (weapon.decay >= max) then
            weapon.decay = 100
            self:newMessage('Your weapon has been destroyed', 8)
            destroy_object(weapon.weapon)
        else

            -- non-energy weapons:
            local ammo = read_word(object + 0x2B8) -- primary
            local mag = read_word(object + 0x2B6) -- reserve
            
            -- energy weapons:
            local battery = read_float(object + 0x240)
            local energy_bullets_left = math.floor(battery * 100)

            if (ammo > 0 or energy_bullets_left > 0) then

                local interval = rand(1, 6)
                local time = weapon.timer:get()
                local offset = rand(min, max + 1) -- random offset

                if (time >= interval and offset <= (weapon.decay / 2)) then
                    weapon.ammo = { ammo, mag, energy_bullets_left}
                    weapon.jammed = true
                    self:newMessage('Weapon jammed! Press MELEE to unjam.', 15)
                    return
                elseif (weapon.decay >= 10) then
                    local current_decay = math.floor(weapon.decay)
                    if (current_decay % 10 == 0 and weapon.notify) then
                        self:newMessage('This weapon is at ' .. current_decay .. '% decay', 8)
                        weapon.notify = false
                    elseif (current_decay % 10 ~= 0) then
                        weapon.notify = true
                    end
                end

                cprint('Decay: ' .. weapon.decay, 12)
            end
        end
    end
end

function weapons:isJammed(weapon, dyn)

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

    write_word(weapon.object + 0x2B8, weapon.ammo[1]) -- primary
    write_word(weapon.object + 0x2B6, weapon.ammo[2]) -- reserve
    write_float(weapon.object + 0x240, weapon.ammo[3] / 100) -- battery
    sync_ammo(weapon.weapon)

    weapon.jammed = nil
    weapon.ammo = nil
    weapon.timer:restart()

    self:newMessage('Weapon UNJAMMED!', 5)
    return false
end

return weapons