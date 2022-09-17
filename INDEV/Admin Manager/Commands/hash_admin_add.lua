local Command = {
    name = 'hash_admin_add',
    description = 'Add hash admin',
    permission_level = 1,
    help = 'Syntax: /$cmd <player> <level (1-6)>'
}

local date = os.date
function Command:Run(ply, args)

    local p = self.players[ply]
    local dir = self.directories[1]
    local admins = self.admins

    if (p:HasPermission(self.permission_level)) then

        local player, level = args[2], args[3]
        if (not player or not level) then
            p:Send(self.help)
        elseif (player:match('%d+')) then
            player = tonumber(player)
            if player_present(player) then

                player = self.players[player]

                local hash = player.hash
                if (not admins.hash_admins[hash]) then

                    admins.hash_admins[hash] = {
                        level = tonumber(level),
                        name = player.name,
                        date = 'Added on ' .. date('%m/%d/%Y at %I:%M %p (%z) by ' .. p.name .. ' (' .. p.ip .. ')')
                    }
                    execute_command('adminadd ' .. player.id .. ' 4')

                    self:Write(dir, admins)
                    p:Send('Added ' .. player.name .. ' to the hash-admin list.')
                else
                    p:Send(player.name .. ' is already a hash-admin (level ' .. admins.hash_admins[hash].level .. ')')
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