local command = {
    name = 'confirm',
    description = 'Command ($cmd) | Confirms the deletion of a level.',
    permission_level = 6,
    help = 'Syntax: /$cmd'
}

function command:run(id, args)

    local admin = self.players[id]

    if admin:hasPermission(self.permission_level) then

        if (args[2] == 'help') then
            admin:send(self.description)
        elseif (not player.confirm) then
            admin:send('You have nothing to confirm.')
        else

            local level = admin.confirm.level
            self.commands[level] = nil

            admin.confirm = nil
            admin:send('Level (' .. level .. ') has been deleted.')

            self:updateCommands()
            self:log(admin.name .. ' (' .. admin.ip .. ')  deleted level ' .. level .. ' from (' .. self.directories[2] .. ')')
        end
    end

    return false
end

return command