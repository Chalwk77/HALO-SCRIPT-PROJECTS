local command = {
    name = 'pw_admin_add',
    description = 'Command (pw_admin_add) | Adds a new username & password admin.',
    permission_level = 6,
    help = 'Syntax: /$cmd <player> <level> <password>'
}

function command:run(id, args)

    local target, level = tonumber(args[2]), tonumber(args[3])
    local player = self.players[id]
    local admins = self.admins

    if player:hasPermission(self.permission_level) then

        if (args[2] == 'help') then
            player:send(self.description)
        elseif (not target or not level) then
            player:send(self.help)
        elseif not player_present(target) then
            player:send('Player #' .. target .. ' is not present.')
        elseif (not self.commands[level]) then
            player:send('Invalid level. Must be between 1 and ' .. #self.commands)
        else

            local password = table.concat(args, ' ', 4)
            if (not password or password == '') then
                player:send('You must specify a password.')
            else

                target = self.players[target]
                local username = target.name

                if (not admins.password_admins[username]) then

                    local min = self.password_length_limit[1]
                    local max = self.password_length_limit[2]

                    local length = password:len()
                    if (length < min or length > max) then
                        player:send('Password must be ' .. min .. ' to ' .. max .. ' characters')
                        return false
                    end

                    target.level = level
                    admins.password_admins[username] = {
                        password = self:getSHA2Hash(password),
                        level = level,
                        date = 'Added on ' .. self:getDate() .. ' by ' .. player.name .. ' (' .. player.ip .. ')'
                    }
                    target.password_admin = true
                    self:updateAdmins(admins)
                    player:send('Added ' .. username .. ' to the password-admin list. Level (' .. level .. ').')
                else
                    player:send(username .. ' is already a password-admin (level ' .. admins.password_admins[username].level .. ')')
                end
            end
        end
    end

    return false
end

return command