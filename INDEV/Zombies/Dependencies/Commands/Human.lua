-- Zombies [Set Human command file] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Command = {
    command_name = 'human',
    admin_level = 4,
    help = 'Syntax: /h [player id] [type (n/l)]', -- type n = normal, type l = last man,
    description = 'Sets player as normal human or last man standing',
    no_perm = 'You need to be level 4 or higher to use this command.'
}

function Command:Run(Ply, Args)
    if (Ply == 0) then
        cprint('Sorry, you cannot execute this command from terminal.', 12)
        return false
    elseif (self.permission(Ply, self.admin_level, self.no_perm)) then

        local t = self:GetPlayer(Ply)
        local player = Args[2]
        local type = Args[3]


    end
    return false
end

return Command