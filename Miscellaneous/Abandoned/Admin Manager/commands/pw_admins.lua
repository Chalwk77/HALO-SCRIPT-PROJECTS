local command = {
    name = 'pw_admins',
    description = 'List password admins',
    permission_level = 1,
    help = 'Syntax: /$cmd'
}

function command:run(id, args)
    local player = self.players[id]
    if (player:hasPermission(self.permission_level)) then

        local password_admins = self.admins.password_admins
        local list = {}
        for _, data in pairs(password_admins) do
            list[#list + 1] = {
                name = data.name,
                level = data.level
            }
        end

        if (#list == 0) then
            return false, player:send('No Password Admins found.')
        end

        list = self:sort(list)
        player:send('Password Admins (total ' .. #list .. ')')
        for _, data in ipairs(list) do
            player:send(data.name .. '(' .. data.level .. ')')
        end
    end

    return false
end

return command