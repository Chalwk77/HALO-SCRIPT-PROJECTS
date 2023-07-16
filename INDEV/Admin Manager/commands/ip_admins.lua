local command = {
    name = 'ip_admins',
    description = 'Command ($cmd) | Shows a list of ip-admins.',
    permission_level = 6,
    help = 'Syntax: /$cmd'
}

function command:run(id, args)

    local admin = self.players[id]
    if admin:hasPermission(self.permission_level, args[1]) then

        if (args[2] == 'help') then
            return false, admin:send(self.description)
        end

        local ip_admins = self.admins.ip_admins
        local list = {}
        for _, data in pairs(ip_admins) do
            list[#list + 1] = {
                name = data.name,
                level = data.level
            }
        end

        if (#list == 0) then
            return false, admin:send('No IP Admins found.')
        end

        list = self:sort(list)
        admin:send('IP Admins (total ' .. #list .. ')')
        for i = 1, #list do
            local data = list[i]
            admin:send(data.name .. '(' .. data.level .. ')')
        end
        self:log(admin.name .. ' viewed the ip-admin list.', self.logging.management)
    end

    return false
end

return command