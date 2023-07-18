local command = {
    name = 'ip_admin_delete',
    description = 'Command ($cmd) | Deletes an ip-admin.',
    permission_level = 6,
    help = 'Syntax: /$cmd <player>'
}

function command:run(id, args)

    local target = tonumber(args[2])
    local admin = self.players[id]

    if admin:hasPermission(self.permission_level, args[1]) then

        if (args[2] == 'help') then
            admin:send(self.description)
        elseif (not target) then
            admin:send(self.help)
        elseif not player_present(target) then
            admin:send('Player #' .. target .. ' is not present.')
        else

            target = self.players[target]
            local admins = self.admins
            local ip = target.ip

            if (admins.ip_admins[ip]) then
                admins.ip_admins[ip] = nil
                self:updateAdmins(admins)
                admin:send('Removed ' .. target.name .. ' from the ip-admin list.')
                self:log(admin.name .. '(' .. admin.ip .. ') removed ' .. target.name .. '(' .. target.ip .. ') from the ip-admin list.', self.logging.management)
            else
                admin:send(target.name .. ' is not an ip-admin.')
            end
        end
    end
end

return command