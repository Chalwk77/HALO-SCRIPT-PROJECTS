-- Rank System [Create Command File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Command = {
    command_name = 'c',
    admin_level = -1,
    help = 'Syntax: /c [user] [password]',
    description = 'Create a new rank account',
    no_perm = 'You need to be level -1 or higher to use this command.'
}

function Command:Run(Ply, Args)
    if (Ply == 0) then
        cprint('Sorry, you cannot execute this command from terminal.', 12)
        return false
    elseif (self.permission(Ply, self.admin_level, self.no_perm)) then

        local t = self:GetPlayer(Ply)

        local username = Args[2]
        local password = Args[3]

        local ulen = username:len()
        local plen = password:len()
        local umin, umax = self.min_username_length, self.max_username_length
        local pmin, pmax = self.min_password_length, self.max_password_length

        if (ulen < umin or ulen > umax) then
            t:Send('Username must be between ' .. umin .. '-' .. umax .. ' characters.')
            return false
        elseif (plen < pmin or plen > pmax) then
            t:Send('Password must be between ' .. pmin .. '-' .. pmax .. ' characters.')
            return false
        end

        local acc = self.db[username]

        if (#Args > 3) then
            t:Send('Too many arguments!')
            t:Send('Make sure username & password do not contain spaces.')
        elseif (not t.logged_in) then
            if (acc) then
                t:Send('Username already exists.')
            elseif (username and password and username ~= ' ' and password ~= ' ') then
                t:CacheSession(username, password)
                t:Send('Rank account successfully created.')
            else
                t:Send('Please provide a username & password.')
            end
        else
            t:Send('You already have a rank account.')
        end
    end
    return false
end

return Command