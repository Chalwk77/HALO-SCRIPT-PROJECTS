local misc = {}

local date = os.date
local sort = table.sort

function misc:setManagementCMDS()
    local t = {}
    for file, enabled in pairs(self.management_commands) do
        if (enabled) then
            local command = require(self.commands_dir .. file)
            local cmd = command.name
            t[cmd] = command
            t[cmd].help = command.help:gsub('$cmd', cmd)
            t[cmd].description = command.description:gsub('$cmd', cmd)
            setmetatable(t[cmd], { __index = self })
        end
    end
    self.management = t
end

function misc:hasPermission(level, command)

    local id = self.id
    local current_level = self.level

    if (id == 0 or current_level >= level) then
        return true
    end

    self:send('Insufficient Permission.')
    self:send('You must be level (' .. level .. ') or higher.')
    self:log(self.name .. ' is attempting to execute (' .. command
            .. ') but is not a high enough level (current level: '
            .. current_level .. ') (Required level: '
            .. level .. ')', self.logging.management)

    return false
end

function misc:send(msg)
    return (self.id == 0 and cprint(msg) or rprint(self.id, msg))
end

function misc:getSHA2Hash(raw_password)
    return self.sha.sha256(raw_password)
end

function misc:sort(t)
    sort(t, function(a, b)
        return a.level > b.level
    end)
    return t
end

function misc:findCommand(command)
    for level, commands in pairs(self.commands) do
        if (commands[command] ~= nil) then
            return level, commands[command]
        end
    end
    return nil
end

function misc:getDate(log)
    return date(log and '%Y/%m/%d %H:%M:%S' or '%Y/%m/%d at %I:%M %p (%z)')
end

return misc