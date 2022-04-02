-- Rank System [Quit File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = {}

function Event:Quit(Ply)

    for _, v in pairs(self.players) do
        if (v.pid == Ply and v.logged_in and not self.game_over) then
            local t = self.credits.disconnected
            v:UpdateCR({ t[1], t[2] })
        end
    end

    if (self.update_file_database['OnQuit']) then
        self:Update()
    end
end

return Event