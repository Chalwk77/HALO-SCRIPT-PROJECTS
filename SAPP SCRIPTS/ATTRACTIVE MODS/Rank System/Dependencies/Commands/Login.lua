-- Rank System [Log in Command File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Command = {
    command_name = 'l',
    admin_level = -1,
    help = 'Syntax: /l [user] [password]',
    description = 'Log into a rank account',
    no_perm = 'You need to be level -1 or higher to use this command.'
}

function Command:Run(Ply, Args)
    if (Ply == 0) then
        cprint('Sorry, you cannot execute this command from terminal.', 12)
        return false
    elseif (self.permission(Ply, self.admin_level, self.no_perm)) then

        local t = self:GetPlayer(Ply)

        local name = Args[2]
        local password = Args[3]
        local acc = self.db[name]

        if (#Args > 3) then
            t:Send('Too many arguments!')
            t:Send('Make sure username & password do not contain spaces.')
        elseif (acc) then
            if (t.logged_in) then
                t:Send('You are already logged in.')
            elseif (password == acc.password) then
                t:CacheSession(name, password)
                t:Send('Successfully logged in.')
            else
                t:Send('Invalid password. Please try again.')
            end
        else
            t:Send('Rank account does not exist.')
        end
    end
    return false
end

return Command