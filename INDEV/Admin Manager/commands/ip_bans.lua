local command = {
    name = 'ip_bans',
    description = 'Command ($cmd) | List all ip-bans.',
    permission_level = 6,
    help = 'Syntax: /$cmd>'
}

function command:run(id, args)

    local admin = self.players[id]
    if admin:hasPermission(self.permission_level, args[1]) then

    end
end

return command