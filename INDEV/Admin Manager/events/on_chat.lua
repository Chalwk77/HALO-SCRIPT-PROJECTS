local event = {}

local function isChatCommand(s)
    return s:sub(1, 1) == '/' or s:sub(1, 1) == '\\'
end

local overrides = {
    'login',
    'change_password',
}

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

        --- COMMAND OVERRIDES:
    elseif (chat_command) then

        local args = self:stringSplit(message)
        for i = 1,#overrides do
            local command = self.management[overrides[i]]
            if (args[1]:sub(2) == overrides[i]) then
                return false, command:run(id, args)
            end
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