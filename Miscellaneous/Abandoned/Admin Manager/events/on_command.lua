-- Command listener for management commands:

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
    local cmd = args[1]

    command = self.management[cmd] -- management commands
    if (command) then
        return command:run(id, args)
    end

    local commands = self.commands
    local player = self.players[id]
    local current_level = player.level

    for required_level,enabled in pairs(commands) do
        local command_table = commands[required_level][cmd]
        if (command_table) then
            if (not enabled) then
                player:send('Command is disabled.')
                return false
            elseif (current_level >= required_level) then
                return true
            else
                player:send('Insufficient Permission.')
                player:send('You must be level (' .. required_level .. ') or higher.')
                return false
            end
        end
    end

    return false
end

register_callback(cb['EVENT_COMMAND'], 'OnCommand')

return event