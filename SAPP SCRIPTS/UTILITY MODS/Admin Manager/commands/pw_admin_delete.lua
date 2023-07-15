local command = {
    name = 'pw_admin_delete',
    description = 'Command (pw_admin_delete) | Deletes a username & password admin.',
    permission_level = 6,
    help = 'Syntax: /$cmd <player>'
}

function command:run(id, args)

    local target = tonumber(args[2])
    local player = self.players[id]

    if player:hasPermission(self.permission_level) then

        if (args[2] == 'help') then
            player:send(self.description)
        elseif (not target) then
            player:send(self.help)
        elseif not player_present(target) then
            player:send('Player #' .. target .. ' is not present.')
        else

            target = self.players[target]
            local admins = self.admins
            local name = target.name

            if (admins.password_admins[name]) then
                admins.password_admins[name] = nil
                self:updateAdmins(admins)
                player:send('Removed ' .. target.name .. ' from the password-admin list.')
            else
                player:send(target.name .. ' is not a password-admin.')
            end
        end
    end

    return false
end

return command