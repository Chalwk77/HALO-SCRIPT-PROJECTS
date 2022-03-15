-- Account System (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local time = os.time
local date = os.date
local open = io.open
local floor = math.floor
local diff = os.difftime

local Account = { }

function Account:New(t)
    setmetatable(t, self)
    self.__index = self
    t.logged_in = false
    return t
end

function Account:respond(msg)
    rprint(self.pid, msg)
end

function Account:CheckFile(ScriptLoad)

    self.players = { }
    self.database = (ScriptLoad and nil or self.database)

    if (get_var(0, '$gt') ~= 'n/a' and self.database == nil) then
        local content = ''
        local file = open(self.settings.file, 'r')
        if (file) then
            content = file:read('*all')
            file:close()
        end
        local data = self.json:decode(content)
        if (not data) then
            self:Write({})
        end
        self.database = data or {}
    end
end

function Account:Write(t)
    local file = open(self.settings.file, 'w')
    if (file) then
        file:write(self.json:encode_pretty(t))
        file:close()
    end
end

function Account:GetIP(Ply)
    return get_var(Ply, '$ip')
end

function Account:OnJoin(Ply)
    local ip = self:GetIP(Ply)
    local name = get_var(Ply, '$name')
    local team = get_var(Ply, '$team')
    local t = { pid = Ply, team = team, name = name }
    if (self.players[ip]) then
        for k, v in pairs(t) do
            self.players[ip][k] = v
        end
    else
        self.players[ip] = self:New(t)
    end
end

function Account:Expired(acc)
    local day = acc.last_login.day
    local month = acc.last_login.month
    local year = acc.last_login.year
    local reference = time { day = day, month = month, year = year }
    local days_from = diff(time(), reference) / (24 * 60 * 60)
    local whole_days = floor(days_from)
    return (whole_days >= self.settings.stale_account_period)
end

function Account:CheckStale()
    for username, acc in pairs(self.database) do
        if (username and self:Expired(acc)) then
            self.database[username] = nil
        end
    end
end

function Account:Cache(name, password)

    local day = date('*t').day
    local month = date('*t').month
    local year = date('*t').year

    self.username = name
    self.logged_in = true
    self.database[name] = {
        password = password,
        last_login = { day = day, month = month, year = year }
    }

    self:Write(self.database)
end

local function StrSplit(str)
    local args = { }
    for arg in str:gmatch('([^%s]+)') do
        args[#args + 1] = arg
    end
    return args
end

function Account:OnCommand(Ply, CMD)
    if (Ply > 0) then

        local args = StrSplit(CMD)
        if (#args > 0) then

            local ip = self:GetIP(Ply)
            local t = self.players[ip]

            args[1], args[2] = args[1]:lower(), args[2]:lower()

            local management = self.settings.account_management_syntax
            if (args[1] == management[1]) then

                local name = args[3]
                local password = args[4]

                local acc = t.database[name]
                if (args[2] == management[2] and args[3]) then
                    if (#args > 4) then
                        t:respond('Too many arguments!')
                        t:respond('Make sure username & password do not contain spaces.')
                    elseif (not t.logged_in) then
                        if (acc) then
                            t:respond('That account username already exists.')
                        else
                            t:Cache(name, password)
                            t:respond('Account successfully created.')
                        end
                    else
                        t:respond('You already have an account.')
                    end
                elseif (args[2] == management[3] and args[3]) then
                    if (#args > 4) then
                        t:respond('Too many arguments!')
                        t:respond('Make sure username & password do not contain spaces.')
                    elseif (acc) then
                        if (t.logged_in) then
                            t:respond('You are already logged in.')
                        elseif (password == acc.password) then
                            t:Cache(name, password)
                            t:respond('Successfully logged in')
                        else
                            t:respond('Invalid password. Please try again.')
                        end
                    else
                        t:respond('Account username does not exist')
                    end
                end
                return false
            end
        end
    end
end

return Account