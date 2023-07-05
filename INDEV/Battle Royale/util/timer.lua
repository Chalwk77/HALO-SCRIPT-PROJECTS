local timer = {}
local clock = os.clock

function timer:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function timer:start()
    self.start_time = clock()
end

function timer:stop()
    self.start_time = nil
end

function timer:isStarted()
    return (self.start_time ~= nil)
end

--weapon.timer:set(time)
function timer:set(time)
    self.start_time = clock() - time
end

function timer:restart()
    self:start()
end

function timer:get()
    if (self.start_time) then
        return clock() - self.start_time
    end
    return 0
end

return timer