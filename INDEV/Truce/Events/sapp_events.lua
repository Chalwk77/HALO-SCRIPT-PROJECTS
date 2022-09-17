local Events = { }

local function CMDSplit(s)
    local args = { }

    for arg in s:gmatch('([^%s]+)') do
        args[#args + 1] = arg:lower()
    end

    return args
end

function Events:OnCommand(P, C)
    local args = CMDSplit(C)
    local cmd = args[1]
    if (P > 0 and self.cmds[cmd]) then
        self.cmds[cmd]:Run(args)
        return false
    end
end

function Events:OnJoin(P)

    self.ip_table[P] = get_var(P, '$ip'):match('%d+.%d+.%d+.%d+')

    local id = self:GetCacheIndex(P)
    self.players[id] = self.players[id] or self:NewPlayer({
        name = get_var(P, '$name'),
        team = get_var(P, '$team')
    })
end

function Events:OnQuit(P)
    local id = self:GetCacheIndex(P)
    self.players[id] = (self.expire_on_quit and nil) or self.players[id]
end

function Events:OnSwitch(P)
    local id = self:GetCacheIndex(P)
    self.players[id].team = get_var(P, '$team')
end

return Events