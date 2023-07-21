local command = {
    name = 'change_admin_password',
    description = 'Command ($cmd) | Change another player\'s password.',
    help = 'Syntax: /$cmd <id / username> <"new password">'
}

local concat = table.concat

function command:run(id, args)

    local target = args[2]
    local new_password = concat(args, ' ', 3)
    local admin = self.players[id]
    local admins = self.admins

    local target_index = tonumber(target)
    local target_is_online = target_index and player_present(target_index)

    if admin:hasPermission(self.permission_level, args[1]) then

        if (args[2] == 'help') then
            admin:send(self.description)
        elseif (not target) then
            admin:send(self.help)
        elseif (not new_password or new_password == '') then
            admin:send('You must specify a password.')
        else

            local min = self.password_length_limit[1]
            local max = self.password_length_limit[2]

            if (new_password:len() < min or new_password:len() > max) then
                admin:send('Password must be ' .. min .. ' to ' .. max .. ' characters')
                return
            end

            local player_target = self.players[target_index]
            local username = target_is_online and player_target.name or target

            local admin_table = admins.password_admins[username]

            if (admin_table) then

                local old_password = admin_table.password
                local new_password_hash = self:getSHA2Hash(new_password)

                if (old_password == new_password_hash) then
                    admin:send('New password cannot be the same as the old password.')
                    return
                end

                admin_table.password = new_password_hash
                admin_table.date = 'Changed on ' .. self:getDate() .. ' by ' .. admin.name .. ' (' .. admin.ip .. ')'
                self:updateAdmins()

                admin:send('Changed ' .. username .. '\'s password.')
                self:log(admin.name .. ' (' .. admin.ip .. ') changed ' .. username .. '\'s password.', self.logging.management)
            else
                admin:send('Username (' .. username .. ') is not a registered admin name.')
            end
        end
    end
end

return command