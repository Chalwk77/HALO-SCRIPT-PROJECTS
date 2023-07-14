local misc = {}

function misc:loadManagementCMDS()
    local t = {}
    local cmds = self.management_commands
    for file, enabled in pairs(cmds) do
        if (enabled) then
            local command = require(self.commands_dir .. file)
            local cmd = command.name
            t[cmd] = command
            t[cmd].help = command.help:gsub('$cmd', cmd)
            setmetatable(t[cmd], { __index = self })
        end
    end
    return t
end

function misc:hasPermission(level)

    local id = self.id
    level = level or -1

    local lvl = tonumber(get_var(id, '$lvl'))
    if (id == 0 or lvl >= level) then
        return true
    end

    self:send('Insufficient Permission.')
    return false
end

function misc:send(msg)
    return (self.id == 0 and cprint(msg) or rprint(self.id, msg))
end

function misc:encryptPassword(raw_password)

    local password = raw_password
    local len = string.len(password)
    local t = {}
    for i = 1, len do
        t[i] = string.byte(password, i)
    end

    local encrypted = ''
    for i = 1, len do
        encrypted = encrypted .. string.format('%02X', t[i])
    end

    return encrypted
end

function misc:decryptPassword(encrypted_password)
    local password = encrypted_password

    local len = string.len(password)
    local t = {}

    for i = 1, len, 2 do
        t[#t + 1] = tonumber('0x' .. password:sub(i, i + 1))
    end

    local decrypted = ''
    for i = 1, #t do
        decrypted = decrypted .. string.char(t[i])
    end

    return decrypted
end

return misc