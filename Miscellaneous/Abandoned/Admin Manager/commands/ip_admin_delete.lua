local command = {
    name = 'ip_admin_delete',
    description = 'Delete ip admin',
    permission_level = 1,
    help = 'Syntax: /$cmd <player>'
}

function command:run(id, args)

    local target = args[2]
    local player = self.players[target]

    if (player:hasPermission(self.permission_level)) then

    end
    return false
end

return command