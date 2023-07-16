local command = {
    name = 'mute_list',
    description = 'Command ($cmd) | List all mute-bans.',
    permission_level = 6,
    help = 'Syntax: /$cmd>',
    output = '[$id] [$offender] [Expires: $years/$months/$days - $hours:$minutes:$seconds]'
}

function command:run(id, args)

    local admin = self.players[id]
    if admin:hasPermission(self.permission_level, args[1]) then
        local header = false
        for _, ban in pairs(self.bans['mute']) do
            if (not header) then
                header = true
                admin:send('[Mute-Bans]')
            end
            admin:send(self:banViewFormat(ban.id, ban.offender, ban.time))
        end
        if (not header) then
            admin:send('There are no Mute-bans.')
        end
        self:log(admin.name .. ' viewed the Mute-ban list.', self.logging.management)
    end

    return false
end

return command