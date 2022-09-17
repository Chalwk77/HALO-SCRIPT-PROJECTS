local Command = {
    name = 'truce',
    help = 'Syntax: /$cmd <player id> <time>'
}

function Command:Run(Ply, Args)

    local id = self:GetCacheIndex(Ply)
    local p = self.players[id]

    local target = tonumber(Args[2])
    local time = tonumber(Args[3])

    --p:RemoveTruce(player)
    --p:SendTruceRequest(player)
end

return Command