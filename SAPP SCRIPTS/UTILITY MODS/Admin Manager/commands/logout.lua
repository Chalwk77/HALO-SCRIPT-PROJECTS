local command = {
    name = 'lo',
    description = 'Command ($cmd) | Logout as an admin.',
    help = 'Syntax: /$cmd'
}

function command:run(id, args)
    local player = self.players[id]
    if (id == 0) then
        player:send('Cannot execute this command from console.')
    elseif (args[2] == 'help') then
        player:send(self.description)
    else
        player.level = 1
        player.password_admin = nil
        player:send('Successfully logged out.')
    end
    return false
end

return command