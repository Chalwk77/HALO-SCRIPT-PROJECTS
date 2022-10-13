-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = { }

-- Setup function called when a new game begins:
function Event:OnStart()

    local map = get_var(0, '$map')
    if (get_var(0, '$gt') == 'n/a' or not self[map]) then
        return
    end

    self.players = {}

    for i = 1, 16 do
        if player_present(i) then
            OnJoin(i)
        end
    end

    local start = self[map].start
    local finish = self[map].finish

    self.starting_line = {
        { -- point A
            x = start[1],
            y = start[2],
            z = start[3]
        },
        { -- point B
            x = start[4],
            y = start[5],
            z = start[6]
        }
    }

    self.finish_line = {
        { -- point A
            x = finish[1],
            y = finish[2],
            z = finish[3]
        },
        { -- point B
            x = finish[4],
            y = finish[5],
            z = finish[6]
        }
    }
end

register_callback(cb['EVENT_GAME_START'], 'OnStart')

return Event