local event = {}

local time = os.time
function event:onTick()
    for _,v in pairs(self.players) do
        if (v.confirm and time() > v.confirm.delay) then
            v.confirm = nil
            v:send('Level delete cancelled.')
        end
    end
end

register_callback(cb['EVENT_TICK'], 'OnTick')

return event