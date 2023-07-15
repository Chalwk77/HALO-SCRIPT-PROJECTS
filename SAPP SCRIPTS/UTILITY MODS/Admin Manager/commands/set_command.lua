local command = {
    name = 'set_command',
    description = 'Command (set_command) | Add or set a new/existing command to a new level.',
    permission_level = 6,
    help = 'Syntax: /$cmd <command> <level> (opt 3rd arg: "true" to enable, "false" to disable)'
}

function command:run(id, args)

    local target_command = (args[2] and args[2]:lower())
    local level = tonumber(args[3])
    local enable = args[4]
    local player = self.players[id]

    if player:hasPermission(self.permission_level) then

        if (args[2] == 'help') then
            player:send(self.description)
        elseif (not target_command) then
            player:send(self.help)
        elseif (not level) then
            player:send(self.help)
        elseif (not self.commands[level]) then
            player:send('Admin level (' .. level .. ') does not exist.')
        else

            -- Remove existing command (if any) from its current level:
            local existing_level = self:findCommand(target_command)
            if (existing_level) then
                self.commands[existing_level][target_command] = nil
            end

            enable = (enable and enable:lower() == 'true') or false

            self.commands[level][target_command] = enable
            self:updateCommands()
            player:send('Command (' .. target_command .. ') has been set to level (' .. level .. '). Enabled: ' .. tostring(enable))
        end
    end

    return false
end

return command