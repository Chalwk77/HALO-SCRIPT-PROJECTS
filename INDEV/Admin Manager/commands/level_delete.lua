local command = {
    name = 'level_delete',
    description = 'Command ($cmd) | Deletes an admin level (requires confirmation).',
    permission_level = 6,
    help = 'Syntax: /$cmd <level>'
}

local time = os.time
function command:run(id, args)

    local level = tonumber(args[2])
    local admin = self.players[id]

    if admin:hasPermission(self.permission_level, args[1]) then
        if (args[2] == 'help') then
            admin:send(self.description)
        elseif (not level) then
            admin:send(self.help)
        elseif (not self.commands[level]) then
            admin:send('Level ' .. level .. ' does not exist.')
        else
            admin:send('Are you sure you want to delete level ' .. level .. '?')
            admin:send('Type /confirm to confirm.')
            admin.confirm = {
                delay = time() + self.confirmation_timeout,
                level = level
            }
        end
    end

    return false
end

return command