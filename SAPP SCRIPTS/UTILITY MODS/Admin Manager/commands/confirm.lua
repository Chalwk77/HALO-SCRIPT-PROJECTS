local command = {
    name = 'confirm',
    description = 'Command ($cmd) | Confirms the deletion of a level.',
    permission_level = 6,
    help = 'Syntax: /$cmd'
}

function command:run(id, args)

    local player = self.players[id]

    if player:hasPermission(self.permission_level) then

        if (args[2] == 'help') then
            player:send(self.description)
        elseif (not player.confirm) then
            player:send('You have nothing to confirm.')
        else

            local level = player.confirm.level
            self.commands[level] = nil
            player.confirm = nil

            self:updateCommands()
            player:send('Level (' .. level .. ') has been deleted.')
        end
    end

    return false
end

return command