-- Rank System [Prestige File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Command = {
    command_name = 'prestige',
    admin_level = -1,
    help = 'Syntax: /prestige',
    description = 'Prestige and reset your stats',
    no_perm = 'You need to be level -1 or higher to use this command.'
}

function Command:Run(Ply)
    if (Ply == 0) then
        cprint('Sorry, you cannot execute this command from terminal.', 12)
        return false
    elseif (self.permission(Ply, self.admin_level, self.no_perm)) then
        local t = self.players[Ply]
        if (t.done) then
            t.stats.credits = self.starting_credits
            t.stats.rank = self.starting_rank
            t.stats.grade = self.starting_grade
            t.stats.prestige = t.stats.prestige + 1
            t:Send('You have Prestiged to level ' .. t.stats.prestige)
        else
            t:Send('Sorry, you have not completed all ranks.')
        end
    end
    return false
end

return Command