local event = {}

function event:onStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        self.players = {}
        self.players[0] = self:newPlayer({
            id = 0,
            level = #self.commands,
            name = '_CONSOLE_',
            hash = 'N/A',
            ip = 'localhost'
        })

        -- Just in case the plugin is loaded mid-game:
        for i = 1,16 do
            if player_present(i) then
                self:onJoin(i)
            end
        end
    end
end

register_callback(cb['EVENT_GAME_START'], 'OnStart')

return event