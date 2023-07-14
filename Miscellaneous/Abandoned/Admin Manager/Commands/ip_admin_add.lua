local command = {
    name = 'ip_admin_add',
    description = 'Add ip admin',
    permission_level = 1,
    help = 'Syntax: /$cmd <player> <level>'
}

local date = os.date
function command:run(id, args)

    local player = self.players[id]
    local dir = self.directories[1]
    local admins = self.admins

    if (not player:hasPermission(self.permission_level)) then
        return false
    end

    local target, level = args[2], args[3]
    if (not target or not level) then
        player:send(self.help)
    elseif (target:match('%d+')) then
        target = tonumber(target)
        if player_present(target) then

            local target_player = self.players[target]
            local ip = target_player.ip
            local name = target_player.name

            if (not admins.ip_admins[ip]) then
                target_player.level = tonumber(level)
                admins.ip_admins[ip] = {
                    level = tonumber(level),
                    name = name,
                    date = 'Added on ' .. date('%m/%d/%Y at %I:%M %p (%z) by ' .. player.name .. ' (' .. player.ip .. ')')
                }
                self:writeFile(dir, admins)
                player:send('Added ' .. name .. ' to the ip-admin list.')
            else
                player:send(name .. ' is already an ip-admin (level ' .. admins.ip_admins[ip].level .. ')')
            end
            execute_command('adminadd ' .. target .. ' 4') -- do this regardless (just in case)
        else
            player:send('Player #' .. target .. ' is not present.')
        end
    end

    return false
end

return command