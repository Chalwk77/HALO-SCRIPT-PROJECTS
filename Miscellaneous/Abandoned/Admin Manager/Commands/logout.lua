local command = {
    name = 'lo',
    description = 'Logout of the server',
    help = 'Syntax: /$cmd'
}

function command:run(id)
    local player = self.players[id]
    if (id == 0) then
        player:send('You cannot logout from the console.')
        return
    elseif (player:hasPermission()) then
        player.level = 1
        player:send('Successfully logged out.')
    end
    return false
end

return command