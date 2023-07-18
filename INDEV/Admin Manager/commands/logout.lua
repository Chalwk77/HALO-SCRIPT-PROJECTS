local command = {
    name = 'logout',
    description = 'Command ($cmd) | Logout as an admin.',
    help = 'Syntax: /$cmd'
}

function command:run(id, args)
    local admin = self.players[id]
    if (id == 0) then
        admin:send('Cannot execute this command from console.')
    elseif (args[2] == 'help') then
        admin:send(self.description)
    elseif (admin.level == 1) then
        admin:send('You are not logged in.')
    else
        admin.level = 1
        admin:setLevelVariable()
        admin.password_admin = nil
        
        self.cached_pw_admins[admin.socket] = nil

        admin:send('Successfully logged out.')
        self:log(admin.name .. ' (' .. admin.ip .. ') logged out.', self.logging.management)
    end
end

return command