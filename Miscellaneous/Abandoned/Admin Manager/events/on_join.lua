local event = {}

local function getHighest(a, b)
    return (a > b and a or b)
end

local function setLevel(self, admins)

    local ip = self.ip
    local hash = self.hash

    local hash_admins = admins.hash_admins
    local ip_admins = admins.ip_admins

    if (hash_admins[hash] and ip_admins[ip]) then
        self.level = getHighest(hash_admins[hash].level, ip_admins[ip].level)
    elseif (hash_admins[hash]) then
        self.level = hash_admins[hash].level
    elseif (ip_admins[ip]) then
        self.level = ip_admins[ip].level
    else
        self.level = 1 -- public
    end
end

function event:newPlayer(o)

    setmetatable(o, { __index = self })
    self.__index = self

    setLevel(o, self.admins)

    return o
end

function event:onJoin(id)
    self.players[id] = self:newPlayer({
        id = id,
        name = get_var(id, '$name'),
        hash = get_var(id, '$hash'),
        ip = get_var(id, '$ip'):match('%d+.%d+.%d+.%d+')
    })
end

register_callback(cb['EVENT_JOIN'], 'OnJoin')

return event