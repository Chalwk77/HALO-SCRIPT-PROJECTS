local IO = {
    sha = require('./Admin Manager/libraries/sha256'),
    json = loadfile('./Admin Manager/libraries/json.lua')(),
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

local function readFile(f, self)
    local root = self.root_directory
    local file = _open(root .. f, 'r')
    if (file) then
        local contents = file:read('*all')
        file:close()
        return contents
    end
    return ''
end

local function writeFile(f, contents, self)
    local root = self.root_directory
    local file = _open(root .. f, 'w')
    if (file) then
        contents = IO.json:encode_pretty(contents)
        file:write(contents)
        file:close()
    end
end

local function loadFile(f, self)
    local contents = readFile(f, self)

    contents = (contents and (contents == '') and nil
            or self.json:decode(contents)) or nil

    return contents
end

function IO:loadBans()

    local dir = self.files[3]
    local bans = loadFile(dir, self)

    self.bans = bans or {
        ip = {},
        hash = {},
        name = {},
        mute = {
            ip = {},
            hash = {}
        }
    }
end

function IO:loadAliases()

    local dir = self.files[5]
    local aliases = loadFile(dir, self)

    self.aliases = aliases or {
        IP_ALIASES = {},
        HASH_ALIASES = {},
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

    local dir = self.files[2]
    local commands = loadFile(dir, self)
    local default_commands = self.default_commands

    if (not commands) then
        writeFile(dir, default_commands, self)
        commands = default_commands
    end

    self.commands = convert(commands, _tonumber)
end

function IO:setAdmins()

    local dir = self.files[1]
    local admins = loadFile(dir, self)

    if (not admins) then
        writeFile(dir, self.default, self)
    end

    self.admins = admins or self.default
end

function IO:updateAdmins()

    local dir = self.files[1]
    writeFile(dir, self.admins, self)

end

function IO:updateCommands()
    local commands = self.commands
    commands = convert(commands, _tostring)
    writeFile(self.files[2], commands, self)
end

function IO:updateBans()
    local dir = self.files[3]
    writeFile(dir, self.bans, self)
end

function IO:updateAliases()

    for i,v in pairs(self.players) do
        if (i ~= 0) then

            local ip = v.ip
            local name = v.name
            local hash = v.hash
            local level = v.level

            self.aliases['IP_ALIASES'][ip][name].level = level
            self.aliases['HASH_ALIASES'][hash][name].level = level
        end
    end

    local dir = self.files[5]
    writeFile(dir, self.aliases, self)
end

function IO:log(entry, write)

    if not write then
        return
    end

    local date = self:getDate(true)
    local dir = self.files[4]
    local logs = loadFile(dir, self)

    logs = logs or {}
    logs[date] = entry

    writeFile(dir, logs, self)
end

return IO