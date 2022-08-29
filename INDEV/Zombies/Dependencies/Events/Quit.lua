-- Zombies [Quit Event File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = {}

function Event:OnQuit()

    execute_command('wdel ' .. self.id)

    self:CleanUpDrones()
    self.players[self.id] = nil

    if (self.game_started) then
        local pn = tonumber(get_var(0, '$pn')) - 1
        if (pn <= 0) then
            self:StartStopTimer()
        end
        self:PhaseCheck()
    else
        self:GameStartCheck(true)
    end
end

return Event