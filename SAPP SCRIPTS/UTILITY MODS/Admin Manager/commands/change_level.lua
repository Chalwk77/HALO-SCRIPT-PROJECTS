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
    local player = self.players[id]

    if player:hasPermission(self.permission_level) then

        if (args[2] == 'help') then
            player:send(self.description)
        elseif (not target or not level) then
            player:send(self.help)
        elseif (not self.commands[level]) then
            player:send('Admin level (' .. level .. ') does not exist.')
        elseif not player_present(target) then
            player:send('Player #' .. target .. ' is not present.')
        else

            target = self.players[target]

            local name = target.name
            local hash = target.hash

            local admins = self.admins
            local hash_admins = admins.hash_admins
            local ip_admins = admins.ip_admins
            local password_admins = admins.password_admins

            if (target.level == 1) then
                player:send(name .. ' is either not an admin or isn\'t logged in (password admin)')
                return false
            elseif (type == 'hash' and not hash_admins[hash]) then
                player:send(name .. ' is not a hash-admin.')
                return false
            elseif (type == 'ip' and not ip_admins[target.ip]) then
                player:send(name .. ' is not an ip-admin.')
                return false
            elseif (type == 'password' and not target.password_admin) then
                player:send(name .. ' either not an admin or isn\'t logged in (password admin)')
                return false
            elseif (type == 'hash') then
                hash_admins[hash].level = level
                hash_admins[hash].date = 'Changed on ' .. self:getDate() .. ' by ' .. player.name .. ' (' .. player.ip .. ')'
            elseif (type == 'ip') then
                ip_admins[target.ip].level = level
                ip_admins[target.ip].date = 'Changed on ' .. self:getDate() .. ' by ' .. player.name .. ' (' .. player.ip .. ')'
            elseif (type == 'password') then
                password_admins[name].level = level
            else
                player:send('Invalid type argument. Valid types: hash, ip, password')
            end

            target.level = level
            self:updateAdmins(admins)
            player:send('Changed ' .. name .. '\'s admin level to ' .. level .. ' (' .. type .. ')')
        end
    end

    return false
end

return command