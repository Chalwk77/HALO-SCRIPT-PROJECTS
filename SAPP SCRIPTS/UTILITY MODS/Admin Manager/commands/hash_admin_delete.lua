local command = {
    name = 'hash_admin_delete',
    description = 'Command ($cmd) | Deletes a hash-admin.',
    permission_level = 6,
    help = 'Syntax: /$cmd <player>'
}

function command:run(id, args)

    local target = tonumber(args[2])
    local admin = self.players[id]

    if admin:hasPermission(self.permission_level) then

        if (args[2] == 'help') then
            admin:send(self.description)
        elseif (not target) then
            admin:send(self.help)
        elseif not player_present(target) then
            admin:send('Player #' .. target .. ' is not present.')
        else

            target = self.players[target]
            local admins = self.admins
            local hash = target.hash

            if (admins.hash_admins[hash]) then
                admins.hash_admins[hash] = nil
                self:updateAdmins(admins)
                admin:send('Removed ' .. target.name .. ' from the hash-admin list.')
                self:log(admin.name .. '(' .. admin.ip .. ') removed ' .. target.name .. '(' .. target.hash .. ') from the hash-admin list.')
            else
                admin:send(target.name .. ' is not a hash-admin.')
            end
        end
    end

    return false
end

return command