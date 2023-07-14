local Database = { }

function Database:loadAdmins()

    local dir = self.directories[1]
    local admins = self:Read(dir)
    admins = self.json:decode(admins)

    if (not admins) then
        self:Write(dir, {})
    end

    return admins or {}
end

function Database:loadCommands()

    local dir = self.directories[2]
    local commands = self:Read(dir)
    commands = self.json:decode(commands)

    if (not commands) then
        self:Write(dir, {})
    end

    -- Convert an un-ordered string-indexed array into numerically indexed array:
    -- (This is done to preserve the order of the commands in the file)

    local t = { }
    for i, v in pairs(commands) do
        t[tonumber(i)] = v
    end

    return t or {}
end

return Database