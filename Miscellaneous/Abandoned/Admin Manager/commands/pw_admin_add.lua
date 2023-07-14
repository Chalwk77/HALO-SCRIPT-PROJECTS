local command = {
    name = 'pw_admin_add',
    description = 'Add password admin',
    permission_level = 1,
    help = 'Syntax: /$cmd <player> <level> <password>'
}

local date = os.date

function command:run(id, args)

    local target = tonumber(args[2])
    local player = self.players[id]
    local dir = self.directories[1]

    if (not player:hasPermission(self.permission_level)) then
        return false
    end

    local level = args[3]
    local admins = self.admins
    local password = table.concat(args, ' ', 4)

    if (not player or not level) then
        player:send(self.help)
    elseif (not password or password == '') then
        player:send('You must specify a password.')
    elseif (not target) then
        player:send('Invalid Player ID.')
    elseif player_present(target) then

        local target_player = self.players[target]
        local name = target_player.name

        if (not admins.password_admins[name]) then
            target_player.level = tonumber(level)
            admins.password_admins[name] = {
                password = self:encryptPassword(password),
                level = tonumber(level),
                name = name,
                date = 'Added on ' .. date('%m/%d/%Y at %I:%M %p (%z) by ' .. player.name .. ' (' .. player.ip .. ')')
            }
            self:writeFile(dir, admins)
            player:send('Added ' .. name .. ' to the password-admin list.')
        else
            player:send(name .. ' is already a password-admin (level ' .. admins.password_admins[name].level .. ')')
        end
        execute_command('admin_add ' .. target .. ' "' .. password .. '" 4') -- do this regardless (just in case)
    else
        player:send('Player #' .. target .. ' is not present.')
    end

    return false
end

return command