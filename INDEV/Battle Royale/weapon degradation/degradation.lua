local weapons = {}

local function isFiring(dyn)
    return (read_float(dyn + 0x490) == 1)
end

local function reloading(dyn)
    return (read_byte(dyn + 0x2A4) == 5)
end

function weapons:getWeapon(object)
    return self.decay[object]
end

function weapons:addWeapon(object, weapon)
    self.decay[object] = self.decay[object] or {
        weapon = weapon,
        timer = self:new(),
        decay = 0, -- out of 100 (100 = completely broken),
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

    local in_vehicle = self:inVehicle(dyn)
    if (in_vehicle) then
        return
    end

    weapon = self:getWeapon(object)
    if (not weapon.timer:isStarted()) then
        weapon.timer:start()
    end

    -- todo: offset for reloading
    
    if not reloading(dyn) and isFiring(dyn) then

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
            print('DECAY: ' .. decay, decay % 15 == 1)

            if (decay >= 15 and decay % 15 == 0) then
                self:newMessage('Your weapon is at ' .. decay .. '% decay', 15)
            end
        end
    end
end

return weapons