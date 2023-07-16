local command = {
    name = 'name_ban',
    description = 'Command ($cmd) | Block explicit names.',
    permission_level = 6,
    help = 'Syntax: /$cmd <name>'
}

function command:run(id, args)

    local admin = self.players[id]
    if admin:hasPermission(self.permission_level, args[1]) then

    end
end

return command