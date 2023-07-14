local IO = { }

local open = io.open

function IO:readFile(dir)
    local content = ''
    local path = './' .. dir
    local file = open(path, 'r')
    if (file) then
        content = file:read('*all')
        file:close()
    end
    return content
end

function IO:writeFile(dir, content)
    local path = './' .. dir
    local file = open(path, 'w')
    if (file) then
        file:write(self.json:encode_pretty(content))
        file:close()
    end
end

function IO:setDefaultAdmins()

    local dir = self.directories[1]
    local admins = self:readFile(dir)
    local default_admins = self.default_admins

    admins = self.json:decode(admins)

    -- Merges default admins with existing admins:
    for group,t in pairs(admins) do
        for id,entry in pairs(t) do
            if (not default_admins[group][id]) then
                default_admins[group][id] = entry
            end
        end
    end

    self:writeFile(dir, default_admins)
end

function IO:setDefaultCommands()
    local dir = self.directories[2]
    self:writeFile(dir, self.default_commands)
end

return IO