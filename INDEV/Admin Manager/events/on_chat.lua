local event = {
    -- note: This variable has global scope.
    output = 'You are muted until: [$years/$months/$days - $hours:$minutes:$seconds]'
}

local _pairs = pairs

local function isChatCommand(s)
    return s:sub(1, 1) == '/' or s:sub(1, 1) == '\\'
end

local function adminChat(self, str)
    for i, v in _pairs(self.players) do
        if (i ~= 0 and v.level >= self.level) then
            v:send('[A-CHAT] ' .. self.name .. ': ' .. str)
        end
    end
end

function event:onChat(id, message)

    local player = self.players[id]
    local chat_command = isChatCommand(message)
    local muted = player:isMuted()

    --- PLAYER IS MUTED:
    if (player and muted) then
        player:send(self:banViewFormat(muted.id, muted.offender, muted.time))
        return false

        --- LOGIN COMMAND OVERRIDE:
    elseif (player and chat_command) then

        local args = self:stringSplit(message)
        local login = self.management['login']
        if (login and args[1]:sub(2) == 'login') then
            return login:run(id, args)
        end

        --- ADMIN CHAT:
    elseif (player and player.admin_chat) then
        adminChat(player, message)
        return false
    end

    return true
end

register_callback(cb['EVENT_CHAT'], 'OnChat')

return event