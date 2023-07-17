local command = {
    name = 'admin_chat',
    description = 'Command ($cmd) | Chat privately with other admins.',
    permission_level = 6,
    help = 'Syntax: /$cmd <1/0 (on/off)>'
}

function command:run(id, args)

    local admin = self.players[id]
    local toggle = tonumber(args[2])
    local enabled = (toggle) and (toggle == 1 and true or false)

    if (id == 0) then
        admin:send('You cannot execute this command from console.')
    elseif admin:hasPermission(self.permission_level, args[1]) then
        if (args[2] == 'help') then
            admin:send(self.description)
            return
        elseif (toggle == nil) or (toggle ~= 0 and toggle ~= 1) then
            admin:send(self.help)
            return
        else
            admin:send('Admin Chat: ' .. (enabled and 'Enabled' or 'Disabled'))
        end
        admin.admin_chat = enabled
    end
end

return command