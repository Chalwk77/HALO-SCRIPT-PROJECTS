-- Rank System [Log in Command File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Command = {
    command_name = 'lo',
    admin_level = -1,
    help = 'Syntax: /lo',
    description = 'Log out of your ranked account',
    no_perm = 'You need to be level -1 or higher to use this command.'
}

function Command:Run(Ply, Args)
    if (Ply == 0) then
        cprint('Sorry, you cannot execute this command from terminal.', 12)
        return false
    elseif (self.permission(Ply, self.admin_level, self.no_perm)) then

        local t = self:GetPlayer(Ply)
        local acc = self.db[t.username]

        if (#Args > 1) then
            t:Send('Too many arguments!')
            t:Send(self.help)
        elseif (acc) then
            if (t.logged_in) then
                t.logged_in = false
                t:Send('You have been logged out.')
            elseif (not t.logged_in) then
                t:Send('You are already logged out.')
            end
        else
            t:Send('Account does not exist or you are already logged out.')
        end
    end
    return false
end

return Command