local command = {
    name = 'change_level',
    description = 'Command ($cmd) | Changes a player\'s admin level.',
    permission_level = 6,
    help = 'Syntax: /$cmd <player> <level> <type (hash/ip/password)>'
}

function command:run(id, args)

    local target = tonumber(args[2])
    local level = tonumber(args[3])
    local type = args[4]
    local admin = self.players[id]

    if admin:hasPermission(self.permission_level, args[1]) then

        if (args[2] == 'help') then
            admin:send(self.description)
        elseif (not target or not level) then
            admin:send(self.help)
        elseif (not self.commands[level]) then
            admin:send('Admin level (' .. level .. ') does not exist.')
        elseif not player_present(target) then
            admin:send('Player #' .. target .. ' is not present.')
        else

            target = self.players[target]

            local name = target.name
            local hash = target.hash

            local admins = self.admins
            local hash_admins = admins.hash_admins
            local ip_admins = admins.ip_admins
            local password_admins = admins.password_admins

            if (target.level == 1) then
                admin:send(name .. ' is either not an admin or isn\'t logged in.')
                return false
            elseif (type == 'hash' and not hash_admins[hash]) then
                admin:send(name .. ' is not a hash-admin.')
                return false
            elseif (type == 'ip' and not ip_admins[target.ip]) then
                admin:send(name .. ' is not an ip-admin.')
                return false
            elseif (type == 'password' and not target.password_admin) then
                admin:send(name .. ' either not an admin or isn\'t logged in.')
                return false
            elseif (type == 'hash') then
                hash_admins[hash].level = level
                hash_admins[hash].date = 'Changed on ' .. self:getDate() .. ' by ' .. admin.name .. ' (' .. admin.ip .. ')'
            elseif (type == 'ip') then
                ip_admins[target.ip].level = level
                ip_admins[target.ip].date = 'Changed on ' .. self:getDate() .. ' by ' .. admin.name .. ' (' .. admin.ip .. ')'
            elseif (type == 'password') then
                password_admins[name].level = level
            else
                admin:send('Invalid type argument. Valid types: hash, ip, password')
            end

            target.level = level
            self:updateAdmins(admins)
            admin:send('Changed ' .. name .. '\'s admin level to ' .. level .. ' (' .. type .. ')')

            self:log(admin.name .. ' (' .. admin.ip .. ') changed ' .. name .. '\'s admin level to ' .. level .. ' (' .. type .. ')', self.logging.management)
        end
    end
end

return command