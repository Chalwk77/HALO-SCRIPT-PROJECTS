local database = { }

function database:loadAdmins()

    local dir = self.directories[1]
    local admins = self:readFile(dir)
    admins = self.json:decode(admins)

    if (not admins) then
        self:writeFile(dir, {})
    end

    return admins or {}
end

function database:loadCommands()

    local dir = self.directories[2]
    local commands = self:readFile(dir)
    commands = self.json:decode(commands)

    if (not commands) then
        self:writeFile(dir, {})
    end

    -- Converts an un-ordered string-indexed array into numerically indexed array:
    -- (This is done to preserve the order of the commands in the file)

    local t = { }
    for i, v in pairs(commands) do
        t[tonumber(i)] = v
    end

    return t or {}
end

return database