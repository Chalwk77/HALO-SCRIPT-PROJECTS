local util = {
    parser = {
        ['-y'] = 'years',
        ['-mo'] = 'months',
        ['-d'] = 'days',
        ['-h'] = 'hours',
        ['-m'] = 'minutes',
        ['-s'] = 'seconds',
        ['-r'] = 'reason'
    }
}

local time_now = os.time
local date = os.date
local format = string.format

function util:syntaxParser(args)

    local parsed_args = {}
    for i = 1, #args do

        local arg = args[i]
        local flag = self.parser[arg]
        local value = args[i + 1]

        if (flag and value) then
            parsed_args[flag] = (type(value) == 'string' and value or tonumber(value))
        end
    end

    return parsed_args
end

function util:banSTDOUT(...)

    local args = { ... }
    local admin_name = args[1]
    local offender_name = args[2]
    local reason = args[3]

    local expiration = args[4]
    local years = expiration.year
    local months = expiration.month
    local days = expiration.day
    local hours = expiration.hour
    local minutes = expiration.min
    local seconds = expiration.sec

    local placeholders = {
        ['$admin'] = admin_name,
        ['$offender'] = offender_name,
        ['$reason'] = reason,
        ['$years'] = years,
        ['$months'] = months,
        ['$days'] = days,
        ['$hours'] = hours,
        ['$minutes'] = minutes,
        ['$seconds'] = seconds
    }

    local str = self.output
    for k, v in pairs(placeholders) do
        str = str:gsub(k, v)
    end
    return str
end

function util:banViewFormat(...)

    local args = { ... }
    local id = args[1]
    local offender = args[2]

    local expiration = args[3]
    local years = expiration.year
    local months = expiration.month
    local days = expiration.day
    local hours = expiration.hour
    local minutes = expiration.min
    local seconds = expiration.sec

    local placeholders = {
        ['$id'] = id,
        ['$offender'] = offender,
        ['$years'] = years,
        ['$months'] = months,
        ['$days'] = days,
        ['$hours'] = hours,
        ['$minutes'] = minutes,
        ['$seconds'] = seconds
    }

    local str = self.output
    for k, v in pairs(placeholders) do
        str = str:gsub(k, v)
    end

    return str
end

function util:newBan(admin_name, offender_name, hash, ip, reason, time, type)
    return {
        added_on = self:getDate(),
        added_by = admin_name,
        offender = offender_name,
        ip = ip or nil,
        hash = hash or nil,
        reason = reason,
        time = time,
        id = self:setBanID(type)
    }
end

local function noTime(y, mo, d, h, m, s)
    return (y == 0 and mo == 0 and d == 0 and h == 0 and m == 0 and s == 0)
end

local function futureTime(...)
    local args = { ... }
    local time = args[1]
    local time_stamp = args[2]
    local y, mo, d, h, m, s = time_stamp.y, time_stamp.mo, time_stamp.d, time_stamp.h, time_stamp.m, time_stamp.s
    return {
        year = tonumber(date('%Y', time)) + y,
        month = tonumber(date('%m', time)) + mo,
        day = tonumber(date('%d', time)) + d,
        hour = tonumber(date('%H', time)) + h,
        min = tonumber(date('%M', time)) + m,
        sec = tonumber(date('%S', time)) + s
    }
end

function util:generateExpiration(parsed)

    local y = (parsed.years or 0)
    local mo = (parsed.months or 0)
    local d = (parsed.days or 0)
    local h = (parsed.hours or 0)
    local m = (parsed.minutes or 0)
    local s = (parsed.seconds or 0)

    local time_stamp = time_now()
    if (noTime(y, mo, d, h, m, s)) then
        return futureTime(time_stamp, self.default_ban_duration)
    end

    return futureTime(time_stamp, {
        y = y,
        mo = mo,
        d = d,
        h = h,
        m = m,
        s = s
    })
end

function util:setBanID(type)
    local bans = self.bans[type]
    local id = 0
    for _, ban in pairs(bans) do
        if (ban.id > id) then
            id = ban.id
        end
    end
    return id + 1
end

function util:hashBan(reason, time, admin)

    local hash = self.hash
    local name = self.name
    local ip = self.ip
    local id = self.id

    self.bans['hash'][hash] = self:newBan(admin.name, name, _, ip, reason, time, 'hash')

    execute_command('k ' .. id)
    self:updateBans()
end

function util:ipBan(reason, time, admin)

    local name = self.name
    local hash = self.hash
    local ip = self.ip
    local id = self.id

    self.bans['ip'][ip] = self:newBan(admin.name, name, hash, _, reason, time, 'ip')

    execute_command('k ' .. id)
    self:updateBans()
end

function util:rejectPlayer()

    local name = self.name
    local hash = self.hash
    local ip = self.ip
    local id = self.id

    -- Reject banned players:
    local banned = self.bans['hash'][hash] or self.bans['ip'][ip]
    if (banned) then
        execute_command('k ' .. id)
        self:log(format('%s tried to join, but is banned.', name), self.logging.management)
        return true
    elseif (self.bans['name'][name]) then
        execute_command('k ' .. id)
        self:log(format('%s tried to join, but their name is blacklisted.', name), self.logging.management)
        return true
    end

    return false
end

return util