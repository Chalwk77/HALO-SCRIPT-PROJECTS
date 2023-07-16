local command = {
    name = 'silence',
    description = 'Command ($cmd) | Silence a player.',
    permission_level = 6,
    help = 'Syntax: /$cmd <player> <flags>'
}

function command:run(id, args)

    local admin = self.players[id]
    if admin:hasPermission(self.permission_level, args[1]) then

    end
end

return command