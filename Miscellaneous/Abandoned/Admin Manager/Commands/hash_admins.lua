local command = {
    name = 'hash_admins',
    description = 'List hash admins',
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