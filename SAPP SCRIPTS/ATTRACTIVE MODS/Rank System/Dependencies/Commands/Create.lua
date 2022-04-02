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

        local name = Args[2]
        local password = Args[3]

        local acc = self.db[name]

        if (#Args > 3) then
            t:Send('Too many arguments!')
            t:Send('Make sure username & password do not contain spaces.')
        elseif (not t.logged_in) then
            if (acc) then
                t:Send('Username already exists.')
            else
                t:CacheSession(name, password)
                t:Send('Rank account successfully created.')
            end
        else
            t:Send('You already have a rank account.')
        end
    end
    return false
end

return Command