-- Rank System [Load Stats File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Stats = {}

local open = io.open
function Stats:LoadStats()

    self.players = {}
    self.game_over = true
    self.starting_credits = self:GetStartingCredits()

    local content = ''
    local file = open(self.dir, 'r')
    if (file) then
        content = file:read('*all')
        file:close()
    end

    local data = self.json:decode(content)
    if (not data) then
        data = {}
        self:Update(data)
    end

    return data
end

return Stats