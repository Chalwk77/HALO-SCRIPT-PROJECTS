local command = {
    name = 'hash_bans',
    description = 'Command ($cmd) | List all hash-bans.',
    permission_level = 6,
    help = 'Syntax: /$cmd> <page>',
    header = '[Hash-Bans] (Page: %s/%s)',
    output = '[$id] $offender [$years/$months/$days-$hours:$minutes:$seconds] [Pirated: $pirated]'
}

function command:run(id, args)
    local admin = self.players[id]
    if admin:hasPermission(self.permission_level, args[1]) then
        local page = tonumber(args[2]) or 1
        local results = self:showResults(self.bans['hash'], page, 5, self.header, admin)
        if (not results) then
            admin:send('There are no hash-bans.')
        end
        self:log(admin.name .. ' viewed the hash-ban list.', self.logging.management)
    end
end

return command