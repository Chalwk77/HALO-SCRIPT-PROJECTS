local Command = {
    name = 'ip_admins',
    description = 'List ip admins',
    permission_level = 1,
    help = 'Syntax: /$cmd'
}

function Command:Run(ply, args)
    local p = self.players[ply]
    if (p:HasPermission(self.permission_level)) then

    else
        p:Send('Insufficient Permission')
    end

    return false
end

return Command