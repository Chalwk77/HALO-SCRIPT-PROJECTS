local IO = { }

local open = io.open

function IO:Read(dir)
    local content = ''
    local path = './' .. dir
    local file = open(path, 'r')
    if (file) then
        content = file:read('*all')
        file:close()
    end
    return content
end

function IO:Write(dir, content)
    local path = './' .. dir
    local file = open(path, 'w')
    if (file) then
        file:write(self.json:encode_pretty(content))
        file:close()
    end
end

function IO:WriteDefaultAdmins()
    local dir = self.directories[1]
    local admins = self:Read(dir)
    admins = self.json:decode(admins)
    self:Write(dir, self.default_admins)
end

function IO:WriteDefaultCommands()
    local dir = self.directories[2]
    local commands = self:Read(dir)
    commands = self.json:decode(commands)
    self:Write(dir, self.default_commands)
end

return IO