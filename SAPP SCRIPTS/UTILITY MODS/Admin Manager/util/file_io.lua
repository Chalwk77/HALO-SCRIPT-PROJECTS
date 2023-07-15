local IO = {
    sha = require('./Admin Manager/util/sha256'),
    json = loadfile('./Admin Manager/util/json.lua')(),
    default = {
        hash_admins = {},
        ip_admins = {},
        password_admins = {}
    }
}
local open = io.open

local function readFile(f)
    local file = open(f, 'r')
    if (file) then
        local contents = file:read('*all')
        file:close()
        return contents
    end
    return ''
end

local function writeFile(f, contents)
    local file = open(f, 'w')
    if (file) then
        contents = IO.json:encode_pretty(contents)
        file:write(contents)
        file:close()
    end
end

local function loadFile(self, f)
    local contents = readFile(f)

    contents = (contents and (contents == '') and nil
            or self.json:decode(contents)) or nil

    return contents
end

-- Converts the keys of a table to numbers or strings:
local function convert(commands, f)
    local t = {}
    for i, v in pairs(commands) do
        t[f(i)] = v
    end
    return t
end

function IO:setDefaultCommands()

    local dir = self.directories[2]
    local commands = loadFile(self, dir)
    local default_commands = self.default_commands

    if (not commands) then
        writeFile(dir, default_commands)
        commands = default_commands
    end

    self.commands = convert(commands, tonumber)
end

function IO:setAdmins()

    local dir = self.directories[1]
    local admins = loadFile(self, dir)

    if (not admins) then
        writeFile(dir, self.default)
    end

    self.admins = admins or self.default
end

function IO:updateAdmins()
    local dir = self.directories[1]
    writeFile(dir, self.admins)
end

function IO:updateCommands()
    local commands = self.commands
    commands = convert(commands, tostring)
    writeFile(self.directories[2], commands)
end

return IO