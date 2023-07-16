local event = {
    -- note: This variable has global scope.
    output = 'You are muted until: [$years/$months/$days - $hours:$minutes:$seconds]'
}

local function isChatCommand(s)
    return s:sub(1, 1) == '/' or s:sub(1, 1) == '\\'
end

function event:onChat(id, message)

    local player = self.players[id]
    local chat_command = isChatCommand(message)
    local muted = player:isMuted()

    if (player and muted) then
        player:send(self:banViewFormat(muted.id, muted.offender, muted.time))
        return false
    elseif (player and chat_command) then

        local args = self:stringSplit(message)
        local login = self.management['login']

        if (login and args[1]:sub(2) == 'login') then
            return login:run(id, args)
        end
    end

    return true
end

register_callback(cb['EVENT_CHAT'], 'OnChat')

return event