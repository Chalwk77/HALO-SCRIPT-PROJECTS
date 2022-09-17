local Misc = {}

function Misc:LoadManagementCMDS()
    local cmds = self.management_commands
    for file, enabled in pairs(cmds) do
        if (enabled) then
            local command = require(self.commands_path .. file)
            local cmd = command.name
            self.cmds[cmd] = command
            self.cmds[cmd].help = command.help:gsub('$cmd', cmd)
            setmetatable(self.cmds[cmd], { __index = self })
        end
    end
end

function Misc:Send(msg)
    return (self.id == 0 and cprint(msg) or rprint(self.id, msg))
end

function Misc:GetHighestLevel()

    local ip = self.ip
    local admins = self.admins
    local hash = self.hash

    local t = { [1] = { level = 1 } }

    if (admins.hash_admins[hash]) then
        t[#t + 1] = { level = admins.hash_admins[hash].level }
    end

    if (admins.ip_admins[ip]) then
        t[#t + 1] = { level = admins.ip_admins[ip].level }
    end

    table.sort(t, function(a, b)
        return a.level > b.level
    end)
    print('highest level for ' .. self.name .. ' is ' .. t[1].level)

    return (t[1].level)
end

return Misc