local command = {
    name = 'ip_admin_add',
    description = 'Command ($cmd) | Adds a new ip-admin.',
    permission_level = 6,
    help = 'Syntax: /$cmd <player> <level>'
}

function command:run(id, args)

    local target, level = tonumber(args[2]), tonumber(args[3])
    local player = self.players[id]
    local admins = self.admins

    if player:hasPermission(self.permission_level) then

        if (args[2] == 'help') then
            player:send(self.description)
        elseif (not target or not level) then
            player:send(self.help)
        elseif not player_present(target) then
            player:send('Player #' .. target .. ' is not present.')
        elseif (not self.commands[level]) then
            player:send('Invalid level. Must be between 1 and ' .. #self.commands)
        else

            target = self.players[target]
            local name = target.name
            local ip = target.ip

            if (not admins.ip_admins[ip]) then
                target.level = level
                admins.ip_admins[ip] = {
                    level = level,
                    name = name,
                    date = 'Added on ' .. self:getDate() .. ' by ' .. player.name .. ' (' .. player.ip .. ')'
                }
                self:updateAdmins(admins)
                player:send('Added ' .. name .. ' to the ip-admin list. Level (' .. level .. ').')
            else
                player:send(name .. ' is already an ip-admin (level ' .. admins.ip_admins[ip].level .. ')')
            end
        end
    end

    return false
end

return command