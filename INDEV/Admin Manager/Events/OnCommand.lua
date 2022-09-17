-- Command listener for management commands:

local Message = {}

local function CMDSplit(s)
    local t = { }
    for arg in s:gmatch('([^%s]+)') do
        t[#t + 1] = arg:lower()
    end
    return t
end

function Message:OnCommand(Ply, CMD)

    local args = CMDSplit(CMD)
    local cmd = args[1]

    if (self.cmds[cmd]) then
        return self.cmds[cmd]:Run(Ply, args)
    end

    local p = self.players[Ply]
    local level = p.level

    for l = 1, #self.commands do
        local command_table = self.commands[l]
        if (command_table[cmd] and l > level) then
            p:Send('Insufficient Permission.')
            p:Send('You must be level ' .. l .. ' or higher.')
            return false
        end
    end
end

return Message