local command = {
    name = 'l',
    description = 'Command ($cmd) | Login as an admin.',
    help = 'Syntax: /$cmd <password>'
}

function command:run(id, args)

    local admin = self.players[id]
    local username = admin.name
    local admins = self.admins
    local password = table.concat(args, ' ', 2)

    if (id == 0) then
        admin:send('Cannot execute this command from console.')
    elseif (args[2] == 'help') then
        admin:send(self.description)
    elseif (password and password == '') then
        admin:send(self.help)
    elseif (admins.password_admins[username]) then

        local hashed_password = self:getSHA2Hash(password)
        local password_on_file = admins.password_admins[username].password
        local success = assert(password_on_file == hashed_password)

        if (success) then
            admin.password_admin = true
            admin.level = admins.password_admins[username].level
            admin:send('Successfully logged in as ' .. username .. ' (level ' .. admin.level .. ')')
            self:log(admin.name .. ' (' .. admin.ip .. ') logged in as ' .. username .. ' Level (' .. admin.level .. ')', self.logging.management)
        else
            admin:send('Incorrect username or password.')
        end
    else
        admin:send('Incorrect username or password.')
    end

    return false
end

return command