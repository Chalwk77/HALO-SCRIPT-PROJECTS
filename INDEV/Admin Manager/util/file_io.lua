local IO = {
    sha = require('./Admin Manager/util/sha256'),
    json = loadfile('./Admin Manager/util/json.lua')(),
    default = {
        hash_admins = {},
        ip_admins = {},
        password_admins = {}
    }
}

local _open = io.open
local _pairs = pairs
local _tonumber = tonumber
local _tostring = tostring

local function readFile(f)
    local file = _open(f, 'r')
    if (file) then
        local contents = file:read('*all')
        file:close()
        return contents
    end
    return ''
end

local function writeFile(f, contents)
    local file = _open(f, 'w')
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

function IO:loadBans()

    local dir = self.directories[3]
    local bans = loadFile(self, dir)

    self.bans = bans or {
        ip = {},
        hash = {},
        name = {},
        mute = {}
    }
end

-- Converts the keys of a table to numbers or strings:
local function convert(commands, f)
    local t = {}
    for i, v in _pairs(commands) do
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

    self.commands = convert(commands, _tonumber)
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
    commands = convert(commands, _tostring)
    writeFile(self.directories[2], commands)
end

function IO:updateBans()
    local dir = self.directories[3]
    writeFile(dir, self.bans)
end

function IO:log(entry, write)

    if not write then
        return
    end

    local date = self:getDate(true)
    local dir = self.directories[4]
    local logs = loadFile(self, dir)

    logs = logs or {}
    logs[date] = entry

    writeFile(dir, logs)
end

return IO