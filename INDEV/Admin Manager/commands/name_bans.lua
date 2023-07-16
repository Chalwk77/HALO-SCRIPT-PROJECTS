local command = {
    name = 'name_bans',
    description = 'Command ($cmd) | List all name-bans.',
    permission_level = 6,
    help = 'Syntax: /$cmd>',
    output = '[%s] [%s]'
}

function command:run(id, args)

    local admin = self.players[id]
    if admin:hasPermission(self.permission_level, args[1]) then
        local header = false
        for name, ban in pairs(self.bans['name']) do
            if (not header) then
                header = true
                admin:send('[Name-Bans]')
            end
            admin:send(self.output:format(ban.id, name))
        end
        if (not header) then
            admin:send('There are no Name-bans.')
        end
        self:log(admin.name .. ' viewed the name-ban list.', self.logging.management)
    end

    return false
end

return command