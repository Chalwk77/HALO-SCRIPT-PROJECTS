local command = {
    name = 'ip_unban',
    description = 'Command ($cmd) | Unban a player\'s IP.',
    permission_level = 6,
    help = 'Syntax: /$cmd <ban id>',
    output = 'IP (%s) has been unbanned.',
}

function command:run(id, args)

    local admin = self.players[id]
    local ban_id = tonumber(args[2])

    if admin:hasPermission(self.permission_level, args[1]) then
        if (args[2] == 'help') then
            admin:send(self.description)
        elseif (not ban_id) then
            admin:send(self.help)
        else
            local parent, child = admin:getBanEntryByID('ip', ban_id)
            if (parent) then
                self:unban(parent, child, admin)
            end
        end
    end
    return false
end

return command