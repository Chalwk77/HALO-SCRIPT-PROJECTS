local command = {
    name = 'hash_bans',
    description = 'Command ($cmd) | List all hash-bans.',
    permission_level = 6,
    help = 'Syntax: /$cmd>',
    output = '[$id] [$offender] [Expires: $years/$months/$days - $hours:$minutes:$seconds]'
}

local _pairs = pairs

function command:run(id, args)

    local admin = self.players[id]
    if admin:hasPermission(self.permission_level, args[1]) then
        local header = false
        for _, ban in _pairs(self.bans['hash']) do
            if (not header) then
                header = true
                admin:send('[Hash-Bans]')
            end
            admin:send(self:banViewFormat(ban.id, ban.offender, ban.time))
        end
        if (not header) then
            admin:send('There are no hash-bans.')
        end
        self:log(admin.name .. ' viewed the hash-ban list.', self.logging.management)
    end

    return false
end

return command