local command = {
    name = 'hash_admins',
    description = 'Command ($cmd) | Show a list of hash-admins.',
    permission_level = 6,
    header = '[Hash-Admins] (Page: %s/%s)', -- page (current, total)
    output = '%s | Level: [%s]', -- name, level
    help = 'Syntax: /$cmd <page>'
}

function command:run(id, args)
    local admin = self.players[id]
    if admin:hasPermission(self.permission_level, args[1]) then

        if (args[2] == 'help') then
            return false, admin:send(self.description)
        end

        local page = tonumber(args[2]) or 1
        local table = self.admins.hash_admins
        local results = self:showAdminList(table, page, 5, self.header, admin)
        if (not results) then
            admin:send('There are no hash-admins.')
        end
        self:log(admin.name .. ' viewed the hash-admin list.', self.logging.management)
    end
end

return command