local Misc = {}

function Misc:NewPlayer(o)

    setmetatable(o, { __index = self })
    self.__index = self

    return o
end

function Misc:LoadCommands()
    local path = './Truce/Commands/'
    for file, enabled in pairs(self.commands) do
        if (enabled) then
            local command = require(path .. file)
            local cmd = command.name
            self.cmds[cmd] = command
            self.cmds[cmd].help = self.cmds[cmd].help:gsub('$cmd', cmd)
            setmetatable(self.cmds[cmd], { __index = self })
        end
    end
end

function Misc:GetCacheIndex(p)
    if (self.player_cache_index == 'id') then
        return p
    elseif (halo_type == 'PC') then
        return self.ip_table[p]
    else
        return get_var(p, '$ip'):match('%d+.%d+.%d+.%d+')
    end
end

return Misc