-- Rank System [Set Rank Command File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Command = {
    command_name = 'setrank',
    admin_level = 4,
    help = 'Syntax: /setrank (player [number]) (rank [number]) (grade [number])',
    description = 'Rank a player up or down',
    no_perm = 'You need to be level 4 or higher to use this command.'
}

function Command:Run(Ply, Args)
    if (Ply == 0) then
        cprint('Sorry, you cannot execute this command from terminal.', 12)
        return false
    elseif (self.permission(Ply, self.admin_level, self.no_perm)) then

        local t = self:GetPlayer(Ply)
        local p = Args[2] -- player id
        local r = Args[3] -- rank id
        local g = Args[4] -- grade id

        if (p and p:match('%d+') and r and r:match('%d+') and g and g:match('%d+')) then
            p, r, g = tonumber(p), tonumber(r), tonumber(g)
            if player_present(p) then

                local player = self:GetPlayer(p)
                if (not player.logged_in) then
                    if (player.pid == Ply) then
                        t:Send("Unable to set rank. You're not logged in!")
                    else
                        t:Send(player.name .. ' is not logged into their rank account.')
                        t:Send('Unable to set rank.')
                    end
                    return false
                end

                local rank_table = self.ranks[r]
                if (rank_table) then

                    local grade_table = rank_table.grade[g]
                    if (grade_table) then

                        local rank = player.stats.rank -- current
                        local grade = player.stats.grade -- current
                        local id = self:GetRankID(rank)

                        if (id == r and grade == g) then
                            t:Send(player.name .. ' is already ' .. rank .. ', G' .. grade)
                        else
                            t:Send('Setting ' .. player.name .. ' to ' .. rank_table.rank .. ', G' .. g)
                            t.stats.rank = rank_table.rank
                            t.stats.grade = g
                            self.db[t.username] = t.stats
                            self:Update()
                        end
                    else
                        t:Send('Invalid grade id. Please type a number between 1-' .. #rank_table.grade .. ' for ' .. rank_table.rank)
                    end
                else
                    t:Send('Invalid rank id')
                end
            else
                t:Send('Player #' .. p .. ' not online.')
            end
        else
            t:Send(self.help)
        end
    end
    return false
end

return Command