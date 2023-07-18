local misc = {}

local _date = os.date
local _sort = table.sort
local _require = require
local _setmetatable = setmetatable
local _pairs = pairs

function misc:setManagementCMDS()
    local t = {}
    for file, enabled in _pairs(self.management_commands) do
        if (enabled) then
            local command = _require(self.commands_dir .. file)
            local cmd = command.name
            t[cmd] = command
            t[cmd].help = command.help:gsub('$cmd', cmd)
            t[cmd].description = command.description:gsub('$cmd', cmd)
            _setmetatable(t[cmd], { __index = self })
        end
    end
    self.management = t
end

function misc:hasPermission(level, command)

    local id = self.id
    local current_level = self.level

    if (id == 0 or current_level >= level) then
        return true
    end

    self:send('Insufficient Permission.')
    self:send('You must be level (' .. level .. ') or higher.')
    self:log(self.name .. ' is attempting to execute (' .. command
            .. ') but is not a high enough level (current level: '
            .. current_level .. ') (Required level: '
            .. level .. ')', self.logging.management)

    return false
end

function misc:send(msg)
    if (msg == nil or msg == '') then
        return
    end
    return (self.id == 0 and cprint(msg) or rprint(self.id, msg))
end

function misc:getSHA2Hash(raw_password)
    return self.sha.sha256(raw_password)
end

function misc:sort(t)
    _sort(t, function(a, b)
        return a.level > b.level
    end)
    return t
end

function misc:stringSplit(string)
    local t = { }
    for param in string:gmatch('([^%s]+)') do
        t[#t + 1] = param
    end
    return t
end

function misc:findCommand(command)
    for level, commands in _pairs(self.commands) do
        if (commands[command] ~= nil) then
            return level, commands[command]
        end
    end
    return nil
end

function misc:getDate(log)
    return _date(log and '%Y/%m/%d %H:%M:%S' or '%Y/%m/%d at %I:%M %p (%z)')
end

function misc:kick(reason)
    self:send(reason)
    execute_command('k ' .. self.id)
end

function misc:vipMessages()

    local vip = self.admin_join_messages
    local message_table = vip[self.level]

    if (not vip.enabled or not message_table or (message_table and not message_table[2])) then
        return
    end

    local str = message_table[1]:format(self.name)
    for i, v in pairs(self.players) do
        if (i ~= 0) then
            v:send(str)
        end
    end
end

function misc:commandSpy(command)

    local level = self.level -- their level

    local spy = self.command_spy
    local show = spy[self.level]

    if (self.id == 0 or not spy.enabled or not show) then
        return
    end

    for i, v in _pairs(self.players) do
        if (i ~= 0 and v.spy and level <= v.level and i ~= self.id) then
            v:send('[SPY] ' .. self.name .. ' (' .. command .. ')')
        end
    end
end

local function convert(table)
    local t = {}
    for _, v in _pairs(table) do
        t[#t + 1] = v
    end
    return t
end

function misc:getPageResults(bans, page, number_to_show)
    local total_pages = math.ceil(#bans / number_to_show)
    local start_index = (page - 1) * number_to_show + 1
    local end_index = start_index + number_to_show - 1
    if (start_index > #bans) then
        return false
    elseif (end_index > #bans) then
        end_index = #bans
    end
    local results = {}
    for i = start_index, end_index do
        results[#results + 1] = bans[i]
    end
    return results, total_pages
end

function misc:showBanList(bans, page, number_to_show, header, admin)

    bans = convert(bans)
    local results, total_pages = self:getPageResults(bans, page, number_to_show)
    if (not results or #results == 0) then
        return false
    end

    admin:send(header:format(page, total_pages))
    for _, v in pairs(results) do
        local id = v.id
        local offender = v.offender
        local time = v.time
        local pirated = v.pirated
        local result = self:banViewFormat(id, offender, time, pirated)
        admin:send(result)
    end

    return true
end

function misc:showAdminList(admins, page, number_to_show, header, admin)

    admins = convert(admins)
    local results, total_pages = self:getPageResults(admins, page, number_to_show)
    if (not results or #results == 0) then
        return false
    end

    admin:send(header:format(page, total_pages))
    for _, v in pairs(results) do
        admin:send(self.output:format(v.name, v.level))
    end

    return true
end

function misc:showNameBans(names, page, number_to_show, header, admin)
    names = convert(names)

    local results, total_pages = self:getPageResults(names, page, number_to_show)
    if (not results or #results == 0) then
        return false
    end

    admin:send(header:format(page, total_pages))
    for _, v in pairs(results) do
        admin:send(self.output:format(v.id, v.name))
    end

    return true
end

return misc