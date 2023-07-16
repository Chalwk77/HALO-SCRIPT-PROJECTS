local command = {
    name = 'pw_admins',
    description = 'Command (pw_admins) | Shows a list of username & password admins.',
    permission_level = 6,
    help = 'Syntax: /$cmd'
}

function command:run(id, args)

    local admin = self.players[id]
    if admin:hasPermission(self.permission_level, args[1]) then

        if (args[2] == 'help') then
            return false, admin:send(self.description)
        end

        local password_admins = self.admins.password_admins
        local list = {}
        for username, data in pairs(password_admins) do
            list[#list + 1] = {
                username = username,
                level = data.level
            }
        end

        if (#list == 0) then
            return false, admin:send('No Password Admins found.')
        end

        list = self:sort(list)
        admin:send('Password Admins (total ' .. #list .. ')')
        for i = 1, #list do
            local data = list[i]
            admin:send(data.username .. '(' .. data.level .. ')')
        end
        self:log(admin.name .. ' (' .. admin.ip .. ') viewed the password-admin list.', self.logging.management)
    end

    return false
end

return command