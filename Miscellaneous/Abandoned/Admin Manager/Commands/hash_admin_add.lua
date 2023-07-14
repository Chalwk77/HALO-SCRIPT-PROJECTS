local command = {
    name = 'hash_admin_add',
    description = 'Add hash admin',
    permission_level = 1,
    help = 'Syntax: /$cmd <player> <level (1-6)>'
}

local date = os.date
function command:run(id, args)

    local player = self.players[id]
    local dir = self.directories[1]
    local admins = self.admins

    if (not player:hasPermission(self.permission_level)) then
        return false
    end

    local target, level = tonumber(args[2]), tonumber(args[3])

    if (not target or not level) then
        player:send(self.help)
    elseif player_present(target) then

        local target_player = self.players[target]
        local name = target_player.name
        local hash = target_player.hash

        if (not admins.hash_admins[hash]) then
            target_player.level = tonumber(level)
            admins.hash_admins[hash] = {
                level = tonumber(level),
                name = name,
                date = 'Added on ' .. date('%m/%d/%Y at %I:%M %p (%z) by ' .. player.name .. ' (' .. player.ip .. ')')
            }
            self:writeFile(dir, admins)
            player:send('Added ' .. name .. ' to the hash-admin list.')
        else
            player:send(name .. ' is already a hash-admin (level ' .. admins.hash_admins[hash].level .. ')')
        end
        execute_command('adminadd ' .. target .. ' 4') -- do this regardless (just in case)
    else
        player:send('Player #' .. target .. ' is not present.')
    end

    return false
end

return command