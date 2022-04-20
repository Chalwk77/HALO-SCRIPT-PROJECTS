-- Rank System [Top List Command File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Command = {
    command_name = 'toplist',
    admin_level = -1,
    players_to_show = 10,
    help = 'Syntax: /toplist',
    description = 'View list of top 10 players',
    no_perm = 'You need to be level -1 or higher to use this command.',
    list = 'Rank#: [$pos] $name | Credits: $cr'
}

function Command:Run(Ply, Args)
    if (Ply == 0) then
        cprint('Sorry, you cannot execute this command from terminal.', 12)
        return false
    elseif (self.permission(Ply, self.admin_level, self.no_perm)) then
        local t = self:GetPlayer(Ply)
        if (not Args[2]) then
            local results = self:SortRanks()
            if (#results > 0) then
                for i = 1, #results do
                    local res = results[i]
                    if (i <= self.players_to_show) then
                        local str = self.list
                        str = str              :
                        gsub('$pos', i)        :
                        gsub('$name', res.name):-- ign
                        gsub('$cr', res.credits)
                        t:Send(str)
                    end
                end
            else
                t:Send('Nothing to show!')
            end
        else
            t:Send(self.help)
        end
    end
    return false
end

return Command