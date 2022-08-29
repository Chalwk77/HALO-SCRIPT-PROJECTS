-- Zombies [Set Attributes File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Game = {}

function Game:SetAttributes()
    if (self.game_started) then

        if (self.team == self.zombie_team and not self.alpha) then
            self:PrivateSay(self.messages.new_standard_zombie)
        end

        if (player_alive(self.id)) then

            -- Set Player Health:
            self:SetHealth()

            -- Set Player Speed:
            self:SetSpeed()

            -- Set Grenades:
            self:SetGrenades()
        end
    end
end

function Game:SetWeapons()

    local i = self.id

    local dyn = get_dynamic_player(i)
    if (self.assign and dyn ~= 0 and player_alive(i)) then
        self.assign = false

        -- Get the appropriate weapon array for this player:
        -- If the weapons array is empty, the player will receive default weapons.
        local weapons = self:GetWeaponTable(i)
        if (#weapons > 0) then

            -- Delete inventory:
            execute_command('wdel ' .. i)

            -- Assign Weapons:
            for j = 1, #weapons do

                local weap = weapons[j]
                local weapon = spawn_object('weap', weap, 0, 0, -9999)

                self.drones[#self.drones + 1] = {
                    weapon = weapon,
                    despawn = false
                }

                -- assign primary & secondary weapons:
                if (j == 1 or j == 2) then
                    assign_weapon(weapon, i)
                else
                    -- assign tertiary & quaternary weapons 250ms apart:
                    timer(250, 'DelayTertQuart', i, weapon)
                end
            end
        end
    end
end

function Game:SetHealth()
    local health
    if (self.team == self.zombie_team) then
        if (self.alpha) then
            health = self.attributes['Alpha Zombies'].health
        else
            health = self.attributes['Standard Zombies'].health
        end
    elseif (self.team == self.human_team) then
        health = self.attributes['Humans'].health
        if (self.last_man == self.id) then
            health = self.attributes['Last Man Standing'].health.base
        end
    end
    if (health ~= 0) then
        execute_command_sequence('w8 1;hp ' .. self.id .. ' ' .. health)
    end
end

function Game:SetSpeed()
    local speed
    if (self.team == self.zombie_team) then
        if (self.alpha) then
            speed = self.attributes['Alpha Zombies'].speed
        else
            speed = self.attributes['Standard Zombies'].speed
        end
    elseif (self.team == self.human_team) then
        speed = self.attributes['Humans'].speed
        if (self.last_man == self.id) then
            speed = self.attributes['Last Man Standing'].speed
        end
    end
    if (speed ~= 0) then
        execute_command_sequence('w8 1;s ' .. self.id .. ' ' .. speed)
    end
end

function Game:SetGrenades()
    local grenades
    if (self.team == self.zombie_team) then
        if (self.alpha) then
            grenades = self.attributes['Alpha Zombies'].grenades
        else
            grenades = self.attributes['Standard Zombies'].grenades
        end
    elseif (self.team == self.human_team) then
        grenades = self.attributes['Humans'].grenades
        if (self.last_man == self.id) then
            grenades = self.attributes['Last Man Standing'].grenades
        end
    end
    if (grenades[1]) then
        execute_command('nades ' .. self.id .. ' ' .. grenades[1] .. ' 1')
    end
    if (grenades[2]) then
        execute_command('nades ' .. self.id .. ' ' .. grenades[2] .. ' 2')
    end
end

function Game:HealthRegeneration()

    if (player_alive(self.id) and self.regenerating_health) then

        local p = self.id

        local dyn = get_dynamic_player(self.id)
        local alive = (dyn ~= 0 and player_alive(p))
        local last_man = (self.last_man == self.id)
        local n = self.attributes["Last Man Standing"].health.increment

        local health = read_float(dyn + 0xE0)
        if (alive and last_man and health < 1) then
            write_float(dyn + 0xE0, health + n)
        end
    end
end

function Game:CrouchCamo()
    if (player_alive(self.id) and self.team == self.zombie_team) then

        -- Check if zombie is allowed to use camo:
        local camo
        if (self.alpha) then
            camo = self.attributes["Alpha Zombies"].camo
        else
            camo = self.attributes["Standard Zombies"].camo
        end

        -- Apply Camo:
        if (camo) then
            local dyn = get_dynamic_player(self.id)
            local alive = (dyn ~= 0 and player_alive(self.id))
            local couching = read_float(dyn + 0x50C)
            if (alive and couching == 1) then
                execute_command('camo ' .. self.id .. ' 1')
            end
        end
    end
end

function DelayTertQuart(p, weap)
    assign_weapon(weap, p)
end

return Game
