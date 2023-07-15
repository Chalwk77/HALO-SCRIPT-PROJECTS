local command = {
    name = 'ip_admins',
    description = 'List ip admins',
    permission_level = 1,
    help = 'Syntax: /$cmd'
}

function command:run(id, args)
    local player = self.players[id]
    if (player:hasPermission(self.permission_level)) then

        local ip_admins = self.admins.ip_admins
        local list = {}
        for _, data in pairs(ip_admins) do
            list[#list + 1] = {
                name = data.name,
                level = data.level
            }
        end

        if (#list == 0) then
            return false, player:send('No IP Admins found.')
        end

        list = self:sort(list)
        player:send('IP Admins (total ' .. #list .. ')')
        for _, data in ipairs(list) do
            player:send(data.name .. '(' .. data.level .. ')')
        end
    end
    return false
end

return command