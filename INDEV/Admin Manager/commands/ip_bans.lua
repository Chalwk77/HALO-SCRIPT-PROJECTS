local command = {
    name = 'ip_bans',
    description = 'Command ($cmd) | List all IP-bans.',
    permission_level = 6,
    help = 'Syntax: /$cmd>',
    output = '[$ban_id] [$offender] [Expires: $Y/$m/$d - $H:$M:$S]'
}

local function formatOutput(t)

    local str = t.str

    for k,v in pairs(t) do
        str = str:gsub('%$' .. k, v)
    end

    return str
end

function command:run(id, args)

    local admin = self.players[id]
    if admin:hasPermission(self.permission_level, args[1]) then

        admin:send('[IP-Bans]') -- Header

        local found

        for _, ban in pairs(self.bans['ip']) do
            found = true
            local str = formatOutput({
                ban_id = ban.id,
                offender =  ban.offender,
                str = self.output,
                Y = ban.time.year,
                m = ban.time.month,
                d = ban.time.day,
                H = ban.time.hour,
                M = ban.time.min,
                S = ban.time.sec
            })
            admin:send(str)
        end

        if (not found) then
            admin:send('There are no IP-bans.')
        end
        self:log(admin.name .. ' viewed the ip-ban list.', self.logging.management)
    end

    return false
end

return command