local command = {
    name = 'ip_ban',
    description = 'Flags: -y -mo -w -d -h -m -s -r "example reason"',
    permission_level = 6,
    help = 'Syntax: /$cmd <player> <flags> | Type ($cmd help) for more information.',
    output = '%s ip-banned %s for %s for [%s Y, %s MO, %s W, %s D, %s H, %s M, %s S]'
}

local time = os.time

function command:run(id, args)

    local offender = tonumber(args[2])
    local admin = self.players[id]

    if admin:hasPermission(self.permission_level, args[1]) then

        if (args[2] == 'help') then
            admin:send(self.description)
        elseif (not offender) then
            admin:send(self.help)
        elseif (not player_present(offender)) then
            admin:send('Player #' .. offender .. ' is not online.')
        else

            local parsed = self:syntaxParser(args)
            if (parsed) then

                local y = parsed.years or 0
                local mo = parsed.months or 0
                local w = parsed.weeks or 0
                local d = parsed.days or 0
                local h = parsed.hours or 0
                local m = parsed.minutes or 0
                local s = parsed.seconds or 0
                local r = parsed.reason or '"No reason given."'

                local now = time()
                local duration  = now + (y * 31536000) + (mo * 2592000) + (w * 604800) + (d * 86400) + (h * 3600) + (m * 60) + s

                if (duration < now) then
                    admin:send('Ban duration cannot be in the past.')
                    return false
                end

                offender = self.players[offender]
                local name = offender.name

                offender:ipBan(r, duration, admin)
                local stdout = self:banSTDOUT(admin.name, name, r, y, mo, w, d, h, m, s)

                admin:send(stdout)
                self:log(stdout, self.logging.management)
            else
                admin:send(self.help)
            end
        end
    end

    return false
end

return command