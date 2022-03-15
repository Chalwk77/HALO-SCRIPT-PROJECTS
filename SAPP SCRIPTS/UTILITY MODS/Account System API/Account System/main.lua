-- Account System (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Account = require('./Account System/Account Handler')
setmetatable(Account, { __index = {
    settings = require('./Account System/settings'),
    json = require('./Account System/json')
} })

register_callback(cb['EVENT_GAME_START'], 'OnStart')
register_callback(cb['EVENT_COMMAND'], 'OnCommand')
register_callback(cb['EVENT_JOIN'], 'OnJoin')
register_callback(cb['EVENT_TICK'], 'OnTick')

Account:CheckFile(true)

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        Account:CheckFile(false)
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnTick()
    Account:CheckStale()
end

function OnJoin(Ply)
    Account:OnJoin(Ply)
end

function OnCommand(Ply, CMD)
    return Account:OnCommand(Ply, CMD)
end

return Account