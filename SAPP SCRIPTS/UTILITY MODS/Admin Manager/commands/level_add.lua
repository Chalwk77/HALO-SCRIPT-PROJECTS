local command = {
    name = 'level_add',
    description = 'Command ($cmd) | Adds a new admin level.',
    permission_level = 6,
    help = 'Syntax: /$cmd <level>'
}

function command:run(id, args)

    local level = tonumber(args[2])
    local player = self.players[id]

    if player:hasPermission(self.permission_level) then
        if (args[2] == 'help') then
            player:send(self.description)
        elseif (not level) then
            player:send(self.help)
        elseif (self.commands[level]) then
            player:send('Level ' .. level .. ' already exists.')
        else
            self.commands[level] = {}
            self:updateCommands()
            player:send('Level ' .. level .. ' added.')
        end
    end

    return false
end

return command