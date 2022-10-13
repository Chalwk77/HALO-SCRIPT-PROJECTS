local Time = {}

function Time:getBestTime()
    local data = self.database[self.ip].times
    return data[1] and data[1] or "N/A"
end

return Time