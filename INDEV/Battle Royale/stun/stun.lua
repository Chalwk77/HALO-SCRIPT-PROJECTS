local victim = {}

function victim:stunPlayer()
    if (os.time() > self.stun.interval) then
        self.stun = nil
        return
    end
    execute_command('s ' .. self.id .. ' ' .. self.stun.speed)
end

return victim