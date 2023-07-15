local command = {
    name = 'l',
    description = 'Command ($cmd) | Login as an admin.',
    help = 'Syntax: /$cmd <password>'
}

function command:run(id, args)

    local player = self.players[id]
    local username = player.name
    local admins = self.admins
    local password = table.concat(args, ' ', 2)

    if (id == 0) then
        player:send('Cannot execute this command from console.')
    elseif (args[2] == 'help') then
        player:send(self.description)
    elseif (password and password == '') then
        player:send(self.help)
    elseif (admins.password_admins[username]) then

        local hashed_password = self:getSHA2Hash(password)
        local password_on_file = admins.password_admins[username].password
        local success = assert(password_on_file == hashed_password)

        if (success) then
            player.password_admin = true
            player.level = admins.password_admins[username].level
            player:send('Successfully logged in as ' .. username .. ' (level ' .. player.level .. ')')
        else
            player:send('Incorrect username or password.')
        end
    else
        player:send('Incorrect username or password.')
    end

    return false
end

return command