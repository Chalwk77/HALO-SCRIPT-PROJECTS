local command = {
    name = 'ip_admin_add',
    description = 'Command ($cmd) | Adds a new ip-admin.',
    help = 'Syntax: /$cmd <player> <level>'
}

function command:run(id, args)

    local target, level = tonumber(args[2]), tonumber(args[3])
    local admin = self.players[id]
    local admins = self.admins

    if admin:hasPermission(self.permission_level, args[1]) then

        if (args[2] == 'help') then
            admin:send(self.description)
        elseif (not target or not level) then
            admin:send(self.help)
        elseif not player_present(target) then
            admin:send('Player #' .. target .. ' is not present.')
        elseif (not self.commands[level]) then
            admin:send('Invalid level. Must be between 1 and ' .. #self.commands)
        else

            target = self.players[target]
            local name = target.name
            local ip = target.ip

            local admin_table = admins.ip_admins[ip]
            if (not admin_table) then
                target.level = level
                admins.ip_admins[ip] = {
                    level = level,
                    name = name,
                    date = 'Added on ' .. self:getDate() .. ' by ' .. admin.name .. ' (' .. admin.ip .. ')'
                }
                self:updateAdmins()

                admin:send('Added ' .. name .. ' to the ip-admin list. Level (' .. level .. ').')
                self:log(admin.name .. ' (' .. admin.ip .. ') added ' .. name .. ' (' .. ip .. ') to the ip-admin list. Level (' .. level .. ')', self.logging.management)
            else
                admin:send(name .. ' is already an ip-admin (level ' .. admin_table.level .. ')')
            end
        end
    end
end

return command