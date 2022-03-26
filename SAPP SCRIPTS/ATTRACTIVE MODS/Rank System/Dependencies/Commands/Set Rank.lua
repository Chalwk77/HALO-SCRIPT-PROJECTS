-- Rank System [Rank Up File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Command = {
    command_name = 'setrank',
    admin_level = 4,
    help = 'Syntax: /setrank (player [number]) (rank [number]) (grade [number])',
    description = 'Rank a player up or down',
    no_perm = 'You need to be level 4 or higher to use this command.'
}

function Command:Run(Ply, Args)
    local t = self.players[Ply]
    if (Ply == 0) then
        cprint('Sorry, you cannot execute this command from terminal.', 12)
        return false
    elseif (self.permission(Ply, self.admin_level, self.no_perm)) then

        local p = Args[2] -- player id
        local r = Args[3] -- rank id
        local g = Args[4] -- grade id

        if (p and p:match('%d+') and r and r:match('%d+') and g and g:match('%d+')) then
            p, r, g = tonumber(p), tonumber(r), tonumber(g)
            if player_present(p) then

                local player = self.players[p]
                local rank_table = self.ranks[r]

                if (rank_table) then

                    local grade_table = rank_table.grade[g]
                    if (grade_table) then

                        local rank = player.stats.rank -- current
                        local grade = player.stats.grade -- current
                        local rank_id = self:GetRankID(player.stats.rank)

                        if (rank_id == r and grade == g) then
                            t:Send(player.name .. ' is already ' .. rank .. ', grade ' .. grade)
                        else
                            t:Send('Setting ' .. player.name .. ' to ' .. rank_table.rank .. ', grade ' .. g)
                            player:SetRankOverride(rank_table.rank, r, g)
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