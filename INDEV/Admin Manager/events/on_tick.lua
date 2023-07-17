local event = {}
local _time = os.time
local _pairs = pairs
local _difftime = os.difftime

function event:onTick()

    local update
    for group, v in _pairs(self.bans) do

        for ID, entry in _pairs(v) do
            local expiration = entry.time
            if (expiration) then

                local expired = _difftime(_time(), _time {
                    year = expiration.year,
                    month = expiration.month,
                    day = expiration.day,
                    hour = expiration.hour,
                    min = expiration.min,
                    sec = expiration.sec
                })

                if (expired >= 0) then
                    update = true
                    self.bans[group][ID] = nil
                    cprint('Ban expired: ' .. ID .. ' (' .. entry.offender .. ') (' .. entry.ip .. ')', 12)
                end
            end
        end
    end

    if (update) then
        self:updateBans()
    end

    -- Level delete confirmation timeout:
    for _, v in _pairs(self.players) do
        if (v.confirm and _time() > v.confirm.timeout) then
            v.confirm = nil
            v:send('Admin level deletion timed out.')
        end
    end
end

register_callback(cb['EVENT_TICK'], 'OnTick')

return event