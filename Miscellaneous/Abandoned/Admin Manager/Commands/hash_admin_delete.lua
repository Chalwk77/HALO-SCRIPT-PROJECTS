local Command = {
    name = 'hash_admin_delete',
    description = 'Delete hash admin',
    permission_level = 1,
    help = 'Syntax: /$cmd <player>'
}

function Command:Run(ply, args)

    local player = args[2]
    local p = self.players[player]

    if (p:HasPermission(self.permission_level)) then

    else
        p:Send('Insufficient Permission')
    end

    return false
end

return Command