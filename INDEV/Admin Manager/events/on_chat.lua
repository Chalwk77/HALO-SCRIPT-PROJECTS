local event = {}

local function isChatCommand(s)
    return s:sub(1, 1) == '/' or s:sub(1, 1) == '\\'
end

function event:onChat(id, message)

    local player = self.players[id]
    if (not player) then
        return
    end

    local chat_command = isChatCommand(message)
    local muted = player:isMuted()

    --- PLAYER IS MUTED:
    if (muted) then
        return false

        --- LOGIN COMMAND OVERRIDE:
    elseif (chat_command) then

        local args = self:stringSplit(message)
        local login = self.management['login']
        if (login and args[1]:sub(2) == 'login') then
            return false, login:run(id, args)
        end

        --- ADMIN CHAT:
    elseif (player.a_chat) then
        player:adminChat(message)
        return false
    end

    return true
end

register_callback(cb['EVENT_CHAT'], 'OnChat')

return event