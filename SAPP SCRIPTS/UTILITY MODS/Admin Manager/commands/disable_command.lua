local command = {
    name = 'disable_command',
    description = 'Command ($cmd) | Disables a command.',
    permission_level = 6,
    help = 'Syntax: /$cmd <command>'
}

function command:run(id, args)

    local target_command = args[2]
    local player = self.players[id]

    if player:hasPermission(self.permission_level) then

        if (not target_command) then
            player:send(self.help)
        elseif (args[2] == 'help') then
            player:send(self.description)
        else

            target_command = target_command:lower()
            local level, enabled = self:findCommand(target_command)
            if (level == nil) then
                player:send('Command (' .. target_command .. ') does not exist.')
            elseif (not enabled) then
                player:send('Command (' .. target_command .. ') is already disabled.')
            else
                self.commands[level][target_command] = false
                self:updateCommands()
                player:send('Command (' .. target_command .. ') has been disabled.')
            end
        end
    end

    return false
end

return command