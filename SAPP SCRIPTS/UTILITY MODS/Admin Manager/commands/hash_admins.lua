local command = {
    name = 'hash_admins',
    description = 'Command ($cmd) | Show a list of hash-admins.',
    permission_level = 6,
    help = 'Syntax: /$cmd'
}

function command:run(id, args)

    local player = self.players[id]
    if player:hasPermission(self.permission_level) then

        if (args[2] == 'help') then
            player:send(self.description)
            return false
        end

        local hash_admins = self.admins.hash_admins
        local list = {}
        for _, data in pairs(hash_admins) do
            list[#list + 1] = {
                name = data.name,
                level = data.level
            }
        end

        if (#list == 0) then
            return false, player:send('No Hash Admins found.')
        end

        list = self:sort(list)
        player:send('Hash Admins (total ' .. #list .. ')')
        for i = 1, #list do
            local data = list[i]
            player:send(data.name .. '(' .. data.level .. ')')
        end
    end

    return false
end

return command