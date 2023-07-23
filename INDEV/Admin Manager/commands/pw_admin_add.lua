local command = {
    name = 'pw_admin_add',
    description = 'Add a new username & password admin.',
    help = 'Syntax: /$cmd <player id/ -u "username"> <-l level> <-p password>'
}

--
-- THIS IS HERE TEMPORARILY:
--
local function getString(args, i)
    local index = i + 1
    local string = args[index]
    local num = tonumber(string)
    if (num) then
        return num
    end
    local j = i + 2
    local end_quote = string:sub(-1)
    while (args[j] and end_quote ~= '"') do
        string = string .. ' ' .. args[j]
        end_quote = args[j]:sub(-1)
        j = j + 1
    end
    index = j - 1
    return string:gsub('"', '')
end

--
-- THIS IS HERE TEMPORARILY:
--
local flags = {
    ['-u'] = 'username',
    ['-p'] = 'password',
    ['-l'] = 'level',
    ['-ip'] = 'ip',
    ['-h'] = 'hash'
}

--
-- THIS IS HERE TEMPORARILY:
--
local function parse(args)
    local parsed = {}
    for i = 1, #args do
        local arg = args[i]
        local flag = flags[arg]
        if (i == 2 and tonumber(arg)) then
            -- This does not need to be quoted.
            parsed['id'] = tonumber(arg)
        elseif (flag == 'hash' or flag == 'ip') then
            -- This does not need to be quoted.
            parsed[flag] = args[i + 1]
        elseif (flag) then
            parsed[flag] = getString(args, i)
            i = i + 1
        end
    end
    return parsed
end

function command:run(id, args)

    local admins = self.admins
    local admin = self.players[id]
    local min = self.password_length_limit[1]
    local max = self.password_length_limit[2]

    if admin:hasPermission(self.permission_level, args[1]) then

        if (args[2] == 'help') then
            admin:send(self.description)
        else

            local parsed = parse(args)

            local target
            local player_id = parsed.id
            local username = parsed.username
            local level = parsed.level
            local password = parsed.password

            if (player_id) then
                if (not player_present(player_id)) then
                    admin:send('Player #' .. player_id .. ' is not present.')
                    return
                end
                target = self.players[player_id]
                username = target.name
            end

            if (not username or not password or not level) then
                admin:send(self.help)
                return
            elseif (username:len() > 11) then
                admin:send('Username must be 11 characters or less.')
                return
            elseif (not self.commands[level]) then
                admin:send('Invalid level. Must be between 1 and ' .. #self.commands)
                return
            elseif (password:len() < min or password:len() > max) then
                admin:send('Password must be ' .. min .. ' to ' .. max .. ' characters')
                return
            end

            local admin_table = admins.password_admins[username]
            if (not admin_table) then

                if (target) then
                    target.level = level
                    target:newAdmin('password_admins', username, admin, password)
                    self.login_session_cache[target.ip] = self:setLoginTimeout()
                else
                    self:newAdmin('password_admins', username, admin, password, {
                        level = level,
                        name = username
                    })
                end

                admin:send('Added ' .. username .. ' to the password-admin list. Level (' .. level .. ').')
                self:log(admin.name .. ' (' .. admin.ip .. ') added (' .. username .. ') to the password-admin list. Level (' .. level .. ')', self.logging.management)
            else
                admin:send(username .. ' is already a password-admin (level ' .. admin_table.level .. ')')
            end
        end
    end
end

return command