local command = {
    name = 'hash_bans',
    description = 'Command ($cmd) | List all hash-bans.',
    permission_level = 6,
    help = 'Syntax: /$cmd>',
    output = '[%s] [%s] [Expires: %s/%s/%s %s:%s:%s]'
}

function command:run(id, args)

    local admin = self.players[id]
    if admin:hasPermission(self.permission_level, args[1]) then

        admin:send('[Hash-Bans]') -- Header

        local found

        for _, ban in pairs(self.bans['hash']) do
            found = true

            local ban_id = ban.id
            local name = ban.offender
            local expires = ban.time

            local y = expires.year
            local mo = expires.month
            local d = expires.day
            local h = expires.hour
            local m = expires.min
            local s = expires.sec

            admin:send(self.output:format(ban_id, name, y, mo, d, h, m, s))
        end

        if (not found) then
            admin:send('There are no hash-bans.')
        end
        self:log(admin.name .. ' viewed the hash-ban list.', self.logging.management)
    end

    return false
end

return command