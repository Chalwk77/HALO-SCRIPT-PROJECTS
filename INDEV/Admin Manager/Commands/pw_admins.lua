local Command = {
    name = 'pw_admins',
    description = 'List password admins',
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