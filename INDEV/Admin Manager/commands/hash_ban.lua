local command = {
    name = 'hash_ban',
    description = 'Flags: -y -mo -w -d -h -m -s -r "example reason"',
    permission_level = 6,
    help = 'Syntax: /$cmd <player> <flags> | Type ($cmd help) for more information.',
    output = '%s hash-banned %s for %s for [%s Y, %s MO, %s W, %s D, %s H, %s M, %s S]'
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

                offender = self.players[offender]

                local reason = parsed.reason or '"No reason given."'
                local name = offender.name

                local expiration = self:generateExpiration(parsed)

                offender:hashBan(reason, expiration, admin)
                --local stdout = self:banSTDOUT(admin.name, name, reason, expires)
                --
                --admin:send(stdout)
                --self:log(stdout, self.logging.management)
            else
                admin:send(self.help)
            end
        end
    end

    return false
end

return command