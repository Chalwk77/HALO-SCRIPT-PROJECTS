local Command = {
    name = 'pw_admin_add',
    description = 'Add password admin',
    permission_level = 1,
    help = 'Syntax: /$cmd <player> <level> <password>'
}

local date = os.date

function Command:Run(ply, args)

    local player = args[2]

    local p = self.players[ply]
    local dir = self.directories[1]
    if (p:HasPermission(self.permission_level)) then

        local level = args[3]
        local admins = self.admins
        local password = table.concat(args, ' ', 4)

        if (not player or not level) then
            p:Send(self.help)
        elseif (not password or password == '') then
            p:Send('You must specify a password.')
        elseif (player:match('%d+')) then
            player = tonumber(player)
            if player_present(player) then

                player = self.players[player]
                local username = player.name

                if (not admins.password_admins[username]) then
                    admins.password_admins[username] = {
                        password = password,
                        level = tonumber(level),
                        name = player.name,
                        date = 'Added on ' .. date('%m/%d/%Y at %I:%M %p (%z) by ' .. p.name .. ' (' .. p.ip .. ')')
                    }
                    execute_command('admin_add ' .. player.id .. ' "' .. password .. '" 4')
                    player.level = tonumber(level)

                    self:Write(dir, admins)
                    p:Send('Added ' .. player.name .. ' to the password-admin list.')
                else
                    p:Send(player.name .. ' is already a password-admin (level ' .. admins.password_admins[username].level .. ')')
                end
            else
                p:Send('Player ' .. player .. ' is not present.')
            end
        end
    else
        p:Send('Insufficient Permission')
    end

    return false
end

return Command