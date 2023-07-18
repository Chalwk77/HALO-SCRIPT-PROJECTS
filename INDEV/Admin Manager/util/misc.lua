local misc = {}

local _date = os.date
local _sort = table.sort
local _require = require
local _setmetatable = setmetatable
local _pairs = pairs

function misc:setManagementCMDS()
    local t, commands = {}, self.management_commands
    for file, enabled in _pairs(commands) do
        if (enabled) then
            local dir = self.commands_dir
            local command = _require(dir .. file)
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
    -- used by management commands

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
        local case = (i ~= 0 and i ~= self.id)
        if (case and v.spy and v.level >= level) then
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

function misc:showBanList(type, page, number_to_show, admin)

    local bans = convert(self.bans[type])
    local results, total_pages = self:getPageResults(bans, page, number_to_show)
    if (not results or #results == 0) then
        return false
    end

    admin:send(self.header:format(page, total_pages))
    for _, v in pairs(results) do
        local id = v.id
        local offender = v.offender
        local time = v.time
        local pirated = v.pirated
        local result = self:banSTDOUT({
            id = id,
            offender_name = offender,
            expiration = time,
            pirated = pirated
        })
        admin:send(result)
    end

    return true
end

function misc:showAdminList(type, page, number_to_show, admin)

    local admins = convert(self.admins[type])
    local results, total_pages = self:getPageResults(admins, page, number_to_show)
    if (not results or #results == 0) then
        return false
    end

    admin:send(self.header:format(page, total_pages))
    for _, v in pairs(results) do
        admin:send(self.output:format(v.name, v.level))
    end

    return true
end

function misc:showNameBans(page, number_to_show, admin)

    local names = convert(self.bans['name'])

    local results, total_pages = self:getPageResults(names, page, number_to_show)
    if (not results or #results == 0) then
        return false
    end

    admin:send(self.header:format(page, total_pages))
    for _, v in pairs(results) do
        admin:send(self.output:format(v.id, v.name))
    end

    return true
end

function misc:showAliases(args)

    local page = args.page
    local group = args.type
    local admin = args.admin
    local header = args.header
    local target = args.target -- ip or hash
    local number_to_show = args.number_to_show

    local t = self.aliases[group][target]
    if (not t) then
        return false
    end

    local aliases = {}
    for name, v in _pairs(t) do
        aliases[#aliases + 1] = { [name] = v }
    end

    local results, total_pages = self:getPageResults(aliases, page, number_to_show)
    if (not results or #results == 0) then
        return false
    end

    admin:send(header:format(target, page, total_pages))

    -- 'results' is the table entry for this ip/hash:
    for i = 1, #results do

        -- results[i] = table of aliases for this ip/hash
        local result = results[i]
        for name, v in _pairs(result) do
            local level = v.level
            local joined = v.joined
            local last_activity = v.last_activity
            admin:send(self.output
                           :gsub('$name', name)
                           :gsub('$level', level)
                           :gsub('$date_joined', joined)
                           :gsub('$last_activity', last_activity))
        end
    end

    return true
end

function misc:newAlias(parent, child, name)

    local records = self.aliases
    local date = self:getDate(true)

    records[parent][child] = records[parent][child] or {}

    if (not records[parent][child][name]) then
        records[parent][child][name] = { joined = date }
    end

    records[parent][child][name].level = self.level
    records[parent][child][name].last_activity = date
end

function misc:initCachedPwAdmins()
    self.cached_pw_admins = {}
end

return misc