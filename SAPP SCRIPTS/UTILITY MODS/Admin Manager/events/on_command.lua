local event = {}

local function stringSplit(string)
    local t = { }
    for param in string:gmatch('([^%s]+)') do
        t[#t + 1] = param:lower()
    end
    return t
end

function event:onCommand(id, command)

    local args = stringSplit(command)
    local target_command = args[1]:lower()

    command = self.management[target_command] -- management commands
    if (command) then
        return command:run(id, args)
    end

    local player = self.players[id]
    local current_level = player.level

    local required_level, enabled = self:findCommand(target_command)
    if (required_level == nil) then
        player:send('Command (' .. target_command .. ') does not exist.')
        return false
    elseif (not enabled) then
        player:send('Command (' .. target_command .. ') is disabled.')
        return false
    elseif (enabled and current_level < required_level) then
        player:send('Insufficient Permission.')
        player:send('You must be level (' .. required_level .. ') or higher.')
        return false
    end

    if (self.logging) then
        cprint('Command: (' .. target_command .. ') was executed by: ' .. player.name .. ' (' .. id .. ') ' .. '(' .. player.ip .. ')', 10)
    end

    return true
end

register_callback(cb['EVENT_COMMAND'], 'OnCommand')

return event