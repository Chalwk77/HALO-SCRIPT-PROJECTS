local command = {
    name = 'lo',
    description = 'Command ($cmd) | Logout as an admin.',
    help = 'Syntax: /$cmd'
}

function command:run(id, args)
    local admin = self.players[id]
    if (id == 0) then
        admin:send('Cannot execute this command from console.')
    elseif (args[2] == 'help') then
        admin:send(self.description)
    else
        admin.level = 1
        admin.password_admin = nil
        admin:send('Successfully logged out.')
        self:log(admin.name .. ' (' .. admin.ip .. ') logged out.', self.logging.management)
    end
    return false
end

return command