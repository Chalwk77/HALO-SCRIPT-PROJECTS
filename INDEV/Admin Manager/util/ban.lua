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

            -- The reason may contain spaces, so we need to parse it differently:
            for j = i + 2, #args do
                local next_arg = args[j]
                if (next_arg:sub(1, 1) == '-') then
                    break
                end
                value = value .. ' ' .. next_arg
            end

            if (value:sub(1, 1) == '-' or flag ~= 'reason' and tonumber(value) == nil) then
                self:send('Invalid value for flag: ' .. flag .. ' - ' .. value)
                return false
            elseif (flag == 'reason') then
                value = value:gsub('"', '')
            end

            parsed_args[flag] = (type(value) == 'string' and value or tonumber(value))

        elseif (flag and not value) then
            self:send('Missing value for flag: ' .. flag)
            return false
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

function util:getBanEntryByID(parent, id)

    local t = self.bans[parent]
    for child, entry in pairs(t) do
        if (entry.id == id) then
            return parent, child
        end
    end

    self:send('Ban ID not found.')
    return nil
end

function util:isMuted()
    return self.bans['mute'][self.ip]
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

function util:nameBan(target)

    local name_to_ban = target
    local player_id
    if (type(target) == 'number') then
        name_to_ban = target.name
        player_id = target.id
    elseif (type(target) == 'string') then
        if (name_to_ban:len() > 11) then
            self:send('Name too long. Max 11 characters.')
            return
        end
    end

    if (player_id) then
        execute_command('k ' .. player_id)
    end

    local name = self.name
    local hash = self.hash
    local ip = self.ip

    self.bans['name'][name_to_ban] = {
        added_by = name,
        added_on = self:getDate(),
        ip = ip,
        hash = hash,
        id = self:setBanID('name')
    }

    self:send(format('Added (%s) to the name-ban list.', name_to_ban))
    self:log(format('%s name-banned (%s)', name, name_to_ban), self.logging.management)
    self:updateBans()
end

function util:mute(reason, time, admin)

    local name = self.name
    local ip = self.ip

    self.bans['mute'][ip] = self:newBan(admin.name, name, _, ip, reason, time, 'mute')

    self:updateBans()
end

function util:unban(parent, child, admin)

    local name = self.bans[parent][child].offender
    self.bans[parent][child] = nil

    admin:send(self.output:format(name, child))
    self:updateBans()
end

local function isBanned(self, type, id)
    if (self.bans[type][id]) then
        execute_command('k ' .. self.id)
        return true
    end
    return false
end

function util:rejectPlayer()

    local name = self.name
    local hash = self.hash
    local ip = self.ip
    local log = self.logging.management

    if (isBanned(self, 'hash', hash)) then
        self:log(format('%s tried to join, but is hash-banned.', name), log)
        return true
    elseif (isBanned(self, 'ip', ip)) then
        self:log(format('%s tried to join, but is ip-banned.', name), log)
        return true
    elseif (isBanned(self, 'name', name)) then
        self:log(format('%s tried to join, but is name-banned.', name), log)
        return true
    elseif (self:isMuted()) then
        self:log(format('%s tried to join, but is muted.', name), log)
        return false -- allow muted players to join
    end

    return false
end

return util