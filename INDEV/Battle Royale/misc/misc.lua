local misc = {}

local sqrt = math.sqrt
local floor = math.floor
local format = string.format

function misc:secondsToTime(s)

    if (s <= 0) then
        return '00', '00', '00';
    end

    local hours = format('%02.f', floor(s / 3600));
    local mins = format('%02.f', floor(s / 60 - (hours * 60)));
    local secs = format('%02.f', floor(s - hours * 3600 - mins * 60));

    return hours, mins, secs
end

local function cls(id)
    for _ = 1, 25 do
        rprint(id, ' ')
    end
end

function misc:say(message, tick)

    -- global rcon message to all players:
    if (tick) then
        for i, _ in pairs(self.players) do
            cls(i)
            rprint(i, message)
        end
        return

        -- private rcon message:
    elseif (self.id) then
        cls(self.id)
        rprint(self.id, message)
        return
    end

    -- global chat message:
    execute_command('msg_prefix ""')
    say_all(message)
    execute_command('msg_prefix "' .. self.prefix .. '"')
end

-- Sets the player's speed:
function misc:setSpeed()
    local game_started = (self.pre_game_timer and self.pre_game_timer.started)
    if (self.weight.enabled and game_started) then
        local new_speed = self:getSpeed()
        execute_command('s ' .. self.id .. ' ' .. new_speed)
    end
end

-- Gets the player's current coordinates:
function misc:getXYZ(dyn)

    local x, y, z

    local vehicle = read_dword(dyn + 0x11C)
    local object = get_object_memory(vehicle)

    if (vehicle == 0xFFFFFFFF) then
        x, y, z = read_vector3d(dyn + 0x5c)
    elseif (object ~= 0) then
        x, y, z = read_vector3d(object + 0x5c)
    end

    return x, y, z
end

-- Calculates the distance between two sets of coordinates:
function misc:getDistance(x1, y1, z1, x2, y2, z2)

    local dx = x1 - x2
    local dy = y1 - y2
    local dz = z1 - z2

    return sqrt(dx * dx + dy * dy + dz * dz)
end

--- This is not currently being used:
-- Calculates the distance between the player and the edge of the safe zone.
function misc:edgeCheck(px, py, pz, bx, by, bz)
    local x, y, z = px - bx, py - by, pz - bz
    local distance = sqrt(x ^ 2 + y ^ 2 + z ^ 2)
    return distance - self.safe_zone_size
end

function misc:getTag(class, name)
    local tag = lookup_tag(class, name)
    return (tag ~= 0 and read_dword(tag + 0xC)) or nil
end

function misc:disableDeathMessages()
    safe_write(true)
    write_dword(self.death_message_address, 0x03EB01B1)
    safe_write(false)
end

function misc:enableDeathMessages()
    safe_write(true)
    write_dword(self.death_message_address, self.original_death_message_address)
    safe_write(false)
end

-- Checks if a command is enabled/disabled.
-- @param enabled (boolean, -> command file 'enabled' property)
-- @param name (string -> command file name property)
-- @return true/false
--
function misc:commandEnabled(enabled, name)

    if (enabled) then
        return true
    end

    self:say('Sorry, /' .. name .. ' is disabled.')
    return false
end

-- Checks if player has permission to execute a command.
-- @param level (number, -> command file permission level property)
-- @return true/false
--
function misc:hasPermission(level)

    local lvl = tonumber(get_var(self.id, '$lvl'))
    if (lvl >= level) then
        return true
    end

    self:say('Insufficient Permission')
    return false
end

function misc:pluralize(n)
    return (n > 1 and 's' or '')
end

return misc