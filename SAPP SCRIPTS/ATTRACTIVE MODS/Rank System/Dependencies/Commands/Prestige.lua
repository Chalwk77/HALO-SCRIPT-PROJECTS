-- Rank System [Prestige File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Command = {
    command_name = 'prestige',
    admin_level = -1,
    help = 'Syntax: /prestige',
    description = 'Prestige and reset your stats',
    no_perm = 'You need to be level -1 or higher to use this command.'
}

function Command:Run(Ply, Args)
    local t = self.players[Ply]
    if (Ply == 0) then
        cprint('Sorry, you cannot execute this command from terminal.', 12)
        return false
    elseif (self.permission(Ply, self.admin_level, self.no_perm)) then

    end
    return false
end

return Command