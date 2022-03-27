-- Rank System [Rank Command File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Command = {
    command_name = 'ranks',
    admin_level = -1,
    help = 'Syntax: /ranks',
    description = 'See list of available ranks',
    no_perm = 'You need to be level -1 or higher to use this command.'
}

local function Plural(n)
    return (n > 1 and 's') or ''
end

function Command:Run(Ply, Args)
    if (Ply == 0) then
        cprint('Sorry, you cannot execute this command from terminal.', 12)
        return false
    elseif (self.permission(Ply, self.admin_level, self.no_perm)) then
        local t = self.players[Ply]
        if (not Args[2]) then
            for i = 1, #self.ranks do
                local v = self.ranks[i]
                t:Send('[' .. i .. '] ' .. v.rank .. ' (' .. #v.grade .. ' grade' .. Plural(#v.grade) .. ')', true)
            end
        else
            t:Send(self.help)
        end
    end
    return false
end

return Command