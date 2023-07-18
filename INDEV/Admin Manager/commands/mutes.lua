local command = {
    name = 'mutes',
    description = 'Command ($cmd) | List all mute-bans.',
    permission_level = 6,
    help = 'Syntax: /$cmd> <page>',
    header = '[Text-Bans] (Page: %s/%s)', -- page (current, total)
    output = '[$id] $offender [$years/$months/$days-$hours:$minutes:$seconds] [Pirated: $pirated]'
}

function command:run(id, args)
    local admin = self.players[id]
    if admin:hasPermission(self.permission_level, args[1]) then

        if (args[2] == 'help') then
            return false, admin:send(self.description)
        end

        local page = tonumber(args[2]) or 1
        local results = self:showBanList(self.bans['mute'], page, 5, self.header, admin)
        if (not results) then
            admin:send('There are no text-bans.')
        end
        self:log(admin.name .. ' viewed the text-ban list.', self.logging.management)
    end
end

return command