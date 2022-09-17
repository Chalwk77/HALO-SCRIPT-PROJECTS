local Command = {
    name = 'l',
    description = 'Login to the server',
    help = 'Syntax: /$cmd [type: 1 = hash, 2 = ip or "your password"]'
}

function Command:Run(ply, args)

    local p = self.players[ply]
    if (p:HasPermission()) then

        local admins = self.admins
        local type = args[2]

        if (not type) then
            p:Send(self.help)
        elseif (type == 1) then
            local hash = p.hash
            if (admins.hash_admins[hash]) then
                p.level = admins.hash_admins[hash].level
                p:Send('Successfully logged in as ' .. p.name .. ' (level ' .. p.level .. ')')
            else
                p:Send('You are not a hash-admin.')
            end
        elseif (type == 2) then
            local ip = p.ip
            if (admins.ip_admins[ip]) then
                p.level = admins.ip_admins[ip].level
                p:Send('Successfully logged in as ' .. p.name .. ' (level ' .. p.level .. ')')
            else
                p:Send('You are not an ip-admin.')
            end
        else

            -- these admins have to used sapp's /login command
            local password = table.concat(args, ' ', 2)
            if (password and password ~= '') then
                local username = p.name
                if (admins.password_admins[username]) then
                    if (admins.password_admins[username].password == password) then
                        p.level = admins.password_admins[username].level
                        p:Send('Successfully logged in as ' .. p.name .. ' (level ' .. p.level .. ')')
                    else
                        p:Send('Incorrect username or password.')
                    end
                else
                    p:Send('Incorrect username or password.')
                end
            else
                p:Send('You must specify a password.')
            end
        end
    end

    return false
end

return Command