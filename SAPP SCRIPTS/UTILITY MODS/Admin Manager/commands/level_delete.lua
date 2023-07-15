local command = {
    name = 'level_delete',
    description = 'Command ($cmd) | Deletes an admin level (requires confirmation).',
    permission_level = 6,
    help = 'Syntax: /$cmd <level>'
}

local time = os.time
function command:run(id, args)

    local level = tonumber(args[2])
    local player = self.players[id]

    if player:hasPermission(self.permission_level) then
        if (args[2] == 'help') then
            player:send(self.description)
        elseif (not level) then
            player:send(self.help)
        elseif (not self.commands[level]) then
            player:send('Level ' .. level .. ' does not exist.')
        else
            player:send('Are you sure you want to delete level ' .. level .. '?')
            player:send('Type /confirm to confirm.')
            player.confirm = {
                delay = time() + self.confirmation_delay,
                level = level
            }
        end
    end

    return false
end

return command