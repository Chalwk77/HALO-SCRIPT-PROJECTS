local command = {
    name = 'name_ban',
    description = 'Command ($cmd) | Block explicit names.',
    permission_level = 6,
    help = 'Syntax: /$cmd <id> or /$cmd <name> | Type /$cmd help for more information.'
}

function command:run(id, args)

    local admin = self.players[id]
    if admin:hasPermission(self.permission_level, args[1]) then

        local target = args[2]
        local player_id = tonumber(target)

        if (not target) then
            admin:send(self.help)
            return false
        elseif (target == 'help') then
            admin:send(self.description)
            return false
        elseif (player_id and not player_present(player_id)) then
            admin:send('Player #' .. player_id .. ' is not online.')
        elseif (player_id) then
            target = player_id
        end

        admin:nameBan(target)
    end
end

return command