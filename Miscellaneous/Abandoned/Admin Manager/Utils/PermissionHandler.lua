local Util = {}

function Util:HasPermission(level)
    level = level or -1
    local lvl = tonumber(get_var(self.id, '$lvl'))
    if (self.id == 0 or lvl >= level) then
        return true
    end
    return false
end

return Util