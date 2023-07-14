local command = {
    name = 'ip_admins',
    description = 'List ip admins',
    permission_level = 1,
    help = 'Syntax: /$cmd'
}

function command:run(id, args)
    local player = self.players[id]
    if (player:hasPermission(self.permission_level)) then

    end
    return false
end

return command