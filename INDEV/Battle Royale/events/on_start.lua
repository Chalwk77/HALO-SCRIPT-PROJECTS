local event = {}

function event:onStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        self:initialize()
    end
end

register_callback(cb['EVENT_GAME_START'], 'OnStart')

return event