local command = {
    name = 'change_level',
    description = 'Command ($cmd) | Changes a player\'s admin level.',
    help = 'Syntax: /$cmd <player / username> <level> <type (hash/ip/password)>'
}

function command:run(id, args)

    local target = args[2]
    local level = tonumber(args[3])
    local type = args[4]
    local admin = self.players[id]

    local target_index = tonumber(target)
    local target_must_be_online = type == 'hash' or type == 'ip'
    local target_is_online = target_index and player_present(target_index)
    
    if admin:hasPermission(self.permission_level, args[1]) then

        if (args[2] == 'help') then
            admin:send(self.description)
        elseif (not target or not level or not target_index and target_must_be_online) then
            admin:send(self.help)
        elseif (not self.commands[level]) then
            admin:send('Admin level (' .. level .. ') does not exist.')
        elseif (target_must_be_online and not target_is_online) then
            admin:send('Target player is not present.')
        elseif (level == 1) then
            admin:send('You cannot change a player\'s admin level to 1.')
        elseif (target_must_be_online and target_index == id) then
            admin:send('You cannot change your own admin level.')
        else

            local admins = self.admins
            local hash_admins = admins.hash_admins
            local ip_admins = admins.ip_admins
            local password_admins = admins.password_admins
            
            local player_target = self.players[target_index]

            if(target_is_online and player_target.level == 1 ) then
                admin:send(player_target.name  .. ' is either not an admin or isn\'t logged in.')
                return
            end

            local name

            if(target_must_be_online) then
                -- Hash and IP admins case
                local hash = player_target.hash
                local ip = player_target.ip
                name = player_target.name

                if (type == 'hash' and not hash_admins[hash]) then
                    admin:send(name .. ' is not a hash-admin.')
                    return
                elseif (type == 'ip' and not ip_admins[ip]) then
                    admin:send(name .. ' is not an ip-admin.')
                    return
                elseif (type == 'hash') then
                    hash_admins[hash].level = level
                    hash_admins[hash].date = 'Changed on ' .. self:getDate() .. ' by ' .. admin.name .. ' (' .. admin.ip .. ')'
                elseif (type == 'ip') then
                    ip_admins[ip].level = level
                    ip_admins[ip].date = 'Changed on ' .. self:getDate() .. ' by ' .. admin.name .. ' (' .. admin.ip .. ')'
                end
            elseif(type == 'password') then
                -- Password admins case
                if(target_is_online and not player_target.password_admin) then
                    admin:send(name .. ' either not an admin or isn\'t logged in.')
                    return
                elseif (not target_is_online and not password_admins[target]) then
                    admin:send(name .. ' is not a password-admin.')
                    return
                elseif (target_is_online) then
                    name = player_target.name
                else
                    name = target
                end
                password_admins[name].level = level
            else
                admin:send('Invalid type argument. Valid types: hash, ip, password')
                return
            end
            
            if (target_is_online) then
                player_target.level = level
                player_target:setLevelVariable()
            elseif (type == "password") then
                admin:send('Changes will take effect next time ' .. name .. ' logs in.')
            end

            self:updateAdmins()

            admin:send('Changed ' .. name .. '\'s admin level to ' .. level .. ' (' .. type .. ')')
            self:log(admin.name .. ' (' .. admin.ip .. ') changed ' .. name .. '\'s admin level to ' .. level .. ' (' .. type .. ')', self.logging.management)
        end
    end
end

return command