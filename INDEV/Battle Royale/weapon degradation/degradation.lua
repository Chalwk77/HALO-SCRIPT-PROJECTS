local weapons = {}

local function isFiring(dynamic_player)
    return (read_byte(dynamic_player + 0x2A5) == 1)
end

local function reloading(dynamic_player)
    return (read_byte(dynamic_player + 0x2A4) == 5)
end

function weapons:getWeapon(object)
    return self.decay[object]
end

function weapons:addWeapon(object, weapon)
    self.decay[object] = self.decay[object] or {
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

    --TODO: table object for this weapon needs to be removed if object == 0.
    if (weapon == 0xFFFFFFFF or object == 0) then
        return
    end

    self:addWeapon(object, weapon)

    local is_reloading = reloading(dyn)
    local in_vehicle = self:inVehicle(dyn)
    if (in_vehicle or is_reloading) then
        return
    end

    weapon = self:getWeapon(object)
    if (not weapon.timer:isStarted()) then
        weapon.timer:start()
    end

    if (isFiring(dyn)) then

        local meta_id = read_dword(object)
        local rate = self.decay_rates[meta_id]

        weapon.decay = weapon.decay + (rate / 30)

        if (weapon.decay >= 100) then
            weapon.decay = 100
            self:newMessage('Your weapon has been destroyed', 5)
            destroy_object(weapon.weapon)
        else

            local time_elapsed = weapon.timer:get()
            if (time_elapsed >= 0.5) then

                --- bullets in non-battery weapon clip:
                local ammo = read_word(object + 0x2B8)

                --- current battery level (0=full, 1=empty):
                local battery = read_float(object + 0x240)

                --- energy bullets in battery:
                local energy_bullets = math.floor(battery * 100)

                --- energy bullets to take:
                local energy_bullets_to_take = math.floor(energy_bullets - (energy_bullets * (weapon.decay / 100)))
                local offset = rand(35, 50 + 1)
                energy_bullets_to_take = energy_bullets_to_take - offset

                if (energy_bullets_to_take > energy_bullets) then
                    energy_bullets_to_take = energy_bullets
                end

                --- Non-battery weapons:
                local bullets = math.floor(weapon.decay / 10)
                if (bullets > 0 and ammo > 0 and ammo - bullets > 0) then
                    --print('taking ' .. bullets .. ' bullets from clip')
                    execute_command('mag ' .. id .. ' ' .. ammo - bullets)
                end

                --- Battery weapons:
                if (energy_bullets_to_take > 0) then
                    --print('taking ' .. energy_bullets_to_take .. ' energy bullets from battery')
                    execute_command('battery ' .. id .. ' ' .. 100 - energy_bullets - energy_bullets_to_take .. ' 0')
                end

                weapon.timer:restart()
            end

            local decay = math.floor(weapon.decay)
            --print('DECAY: ' .. decay)

            if (decay >= 15) then

                local notify = weapon.notify
                local mult_of_15 = (decay % 15 == 0)

                if (notify and mult_of_15) then
                    self:newMessage('Your weapon is at ' .. decay .. '% decay', 10)
                    weapon.notify = false
                elseif (not mult_of_15) then
                    weapon.notify = true
                end
            end
        end
    end
end

return weapons