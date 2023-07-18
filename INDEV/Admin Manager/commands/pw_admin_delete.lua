local command = {
    name = 'pw_admin_delete',
    description = 'Command (pw_admin_delete) | Deletes a username & password admin.',
    permission_level = 6,
    help = 'Syntax: /$cmd <player>'
}

function command:run(id, args)

    local target = args[2]
    local admin = self.players[id]

    if admin:hasPermission(self.permission_level, args[1]) then

        if (args[2] == 'help') then
            admin:send(self.description)
        elseif (not target) then
            admin:send(self.help)
        elseif not player_present(target) then
            admin:send('Player #' .. target .. ' is not present.')
        else

            local player_index = tonumber(target)
            local is_online = player_index and player_present(player_index)
            local name = is_online and self.players[id].name or target
            local admins = self.admins

            if (admins.password_admins[name]) then
                admins.password_admins[name] = nil
                self:updateAdmins()

                admin:send('Removed ' .. name .. ' from the password-admin list.')
                self:log(admin.name .. ' (' .. admin.ip .. ') removed ' .. name .. ' from the password-admin list.', self.logging.management)
            else
                admin:send(name .. ' is not a password-admin.')
            end
        end
    end
end

return command