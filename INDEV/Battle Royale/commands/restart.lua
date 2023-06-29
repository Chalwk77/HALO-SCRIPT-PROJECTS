local Command = {}

-- Executes this command.
-- @param id = player id (number)
-- @param args (table of command strings)
--
function Command:run(id, args)

    local p = self.players[id] -- admin

    if not p:commandEnabled(self.enabled, self.name) then
        return
    elseif not p:hasPermission(self.level) then
        return
    end

end

return Command