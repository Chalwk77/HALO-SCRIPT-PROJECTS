--[[
--=====================================================================================================--
Script Name: Timer Library, for SAPP (PC & CE)
Description: This script provides a simple timer library for use in other scripts.

Simply require this script in your script and use the following functions:
timer:new()
timer:start()
timer:stop()
timer:pause()
timer:resume()
timer:get()

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--


local timer = {}
local clock = os.clock

-- This is the constructor for the timer object.
function timer:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

-- This function starts the timer.
function timer:start()
    self.start_time = clock()
    self.paused_time = 0
    self.paused = false
end

-- This function stops the timer.
function timer:stop()
    self.start_time = nil
    self.paused_time = 0
    self.paused = false
end

-- This function pauses the timer.
function timer:pause()
    if (not self.paused) then
        self.paused_time = clock()
        self.paused = true
    end
end

-- This function resumes the timer.
function timer:resume()
    if (self.paused) then
        self.start_time = self.start_time + (clock() - self.paused_time)
        self.paused_time = 0
        self.paused = false
    end
end

-- This function returns the elapsed time in seconds.
function timer:get()
    if (self.start_time) then
        if (self.paused) then
            return self.paused_time - self.start_time
        else
            return clock() - self.start_time
        end
    end
    return 0
end

return timer