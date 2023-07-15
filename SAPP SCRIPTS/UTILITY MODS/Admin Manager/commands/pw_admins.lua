local command = {
    name = 'pw_admins',
    description = 'Command (pw_admins) | Shows a list of username & password admins.',
    permission_level = 6,
    help = 'Syntax: /$cmd'
}

function command:run(id, args)

    local player = self.players[id]
    if (player:hasPermission(self.permission_level)) then

        if (args[2] == 'help') then
            player:send(self.description)
            return false
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
            return false, player:send('No Password Admins found.')
        end

        list = self:sort(list)
        player:send('Password Admins (total ' .. #list .. ')')
        for i = 1, #list do
            local data = list[i]
            player:send(data.username .. '(' .. data.level .. ')')
        end
    end

    return false
end

return command