local command = {
    name = 'ip_unban',
    description = 'Command ($cmd) | Unban a player\'s IP address.',
    permission_level = 6,
    help = 'Syntax: /$cmd <ban id>'
}

function command:run(id, args)

    local admin = self.players[id]
    if admin:hasPermission(self.permission_level, args[1]) then

    end
end

return command