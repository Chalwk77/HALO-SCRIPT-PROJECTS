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

        weapon.decay = weapon.decay + (rate / 30)

        if (weapon.decay >= 100) then
            weapon.decay = 100
            self:newMessage('Your weapon has been destroyed', 8)
            destroy_object(weapon.weapon)
        else

            local time = weapon.timer:get()
            local min = 10 -- weapons cannot jam if the decay is below this value
            local max = 101 -- weapons will always jam if the decay is above this value

            local interval = rand(1, 6)

            if (time >= interval and rand(min, max) <= (weapon.decay / 2)) then
                local ammo = read_word(object + 0x2B8) -- clip
                local mag = read_word(object + 0x2B6) -- mag
                if (ammo > 0) then
                    weapon.ammo = { ammo, mag }
                    weapon.jammed = true
                    self:newMessage('Your weapon has jammed. Press reload to unjam.', 15)
                    return
                end
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

function weapons:isJammed(weapon, dyn)

    if (not weapon.jammed) then
        return false
    end

    --todo add support for energy weapons

    local melee = meleeButton(dyn)
    if (not melee) then
        write_word(weapon.object + 0x2B8, 0) -- primary clip
        write_word(weapon.object + 0x2B6, 0) -- reserve ammo
        sync_ammo(weapon.weapon)
        return true
    end

    write_word(weapon.object + 0x2B8, weapon.ammo[1]) -- primary
    write_word(weapon.object + 0x2B6, weapon.ammo[2]) -- reserve
    sync_ammo(weapon.weapon)

    weapon.jammed = nil
    weapon.ammo = nil
    weapon.timer:restart()

    self:newMessage('Weapon unjammed!', 10)
    return false
end

return weapons