-- Rank System [Rank Command File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Command = {
    command_name = 'toplist',
    admin_level = -1,
    help = 'Syntax: /toplist',
    description = 'View list of top 10 players',
    no_perm = 'You need to be level -1 or higher to use this command.',
    list = 'Rank#: [$pos] $name | Credits: $cr'
}

function Command:Run(Ply, Args)
    local t = self.players[Ply]
    if (Ply == 0) then
        cprint('Sorry, you cannot execute this command from terminal.', 12)
        return false
    elseif (self.permission(Ply, self.admin_level, self.no_perm)) then
        if (not Args[2]) then
            local results = self:SortRanks()
            if (#results > 0) then
                local str = self.list
                for i, v in pairs(results) do
                    if (i > 0 and i < 11) then
                        str = str            :
                        gsub('$pos', i)      :
                        gsub('$name', v.name):
                        gsub('$cr', v.credits)
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