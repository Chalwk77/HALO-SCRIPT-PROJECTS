local command = {
    name = 'l',
    description = 'Login to the server',
    help = 'Syntax: /$cmd [type: 1 = hash, 2 = ip or "your password"]'
}

function command:run(id, args)

    local player = self.players[id]
    if (not player:hasPermission()) then
        return false
    end

    local ip = player.ip
    local name = player.name
    local hash = player.hash

    local admins = self.admins
    local type = args[2]

    if (not type) then
        player:send(self.help)
    elseif (type == 1) then
        if (admins.hash_admins[hash]) then
            player.level = admins.hash_admins[hash].level
            player:send('Successfully logged in as ' .. name .. ' (level ' .. player.level .. ')')
        else
            player:send('You are not a hash-admin.')
        end
    elseif (type == 2) then
        if (admins.ip_admins[ip]) then
            player.level = admins.ip_admins[ip].level
            player:send('Successfully logged in as ' .. name .. ' (level ' .. player.level .. ')')
        else
            player:send('You are not an ip-admin.')
        end
    else

        -- these admins have to used sapp's /login command first
        local password = table.concat(args, ' ', 2)
        if (password and password ~= '') then
            if (admins.password_admins[name]) then

                password = self:decryptPassword(password)
                if (admins.password_admins[name].password == password) then
                    player.level = admins.password_admins[name].level
                    player:send('Successfully logged in as ' .. name .. ' (level ' .. player.level .. ')')
                else
                    player:send('Incorrect username or password.')
                end
            else
                player:send('Incorrect username or password.')
            end
        else
            player:Send('You must specify a password.')
        end
    end

    return false
end

return command