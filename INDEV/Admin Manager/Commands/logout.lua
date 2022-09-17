local Command = {
    name = 'lo',
    description = 'Logout of the server',
    help = 'Syntax: /$cmd'
}

function Command:Run(ply, args)
    local p = self.players[ply]
    if (p:HasPermission()) then
        p.level = 1
        p:Send('Successfully logged out.')
    else
        p:Send('Insufficient Permission')
    end
    return false
end

return Command