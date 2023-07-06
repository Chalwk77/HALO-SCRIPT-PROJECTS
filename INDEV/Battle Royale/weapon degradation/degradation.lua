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

        weapon.decay = weapon.decay + rate

        if (weapon.decay >= 100) then
            weapon.decay = 100
            self:newMessage('Your weapon has been destroyed', 5)
            destroy_object(weapon.weapon)
        else

            local ammo = read_word(object + 0x2B8) -- bullets in clip
            if (ammo == 0) then
                return
            end

            local time_elapsed = weapon.timer:get()
            if (time_elapsed >= 0.5) then

                local reserve = read_word(object + 0x2B6) -- reserve bullets
                local bullets = math.floor(weapon.decay / 10)

                if (bullets > 0) then
                    if (ammo > 0) then
                        print('taking ' .. bullets .. ' bullets from clip')
                        execute_command('mag ' .. id .. ' ' .. ammo - bullets)
                    elseif (reserve > 0) then
                        print('taking ' .. bullets .. ' bullets from reserve')
                        execute_command('ammo ' .. id .. ' ' .. reserve - bullets)
                    end
                end
                weapon.timer:restart()
            end

            local decay = math.floor(weapon.decay)
            print('DECAY: ' .. decay)

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