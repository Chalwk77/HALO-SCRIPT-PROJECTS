-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local IO = {}

local open = io.open

-- Return the contents of a file as a raw string:
--
function IO:ReadFile()
    local file = open(self.database_path, 'r')
    if (file) then
        local contents = file:read('*all')
        file:close()
        return contents
    end
end

-- Convert a Lua table to JSON and write it to a file:
--
function IO:WriteFile(contents)
    local file = open(self.database_path, 'w')
    if (file) then
        contents = self.json:encode_pretty(contents)
        file:write(contents)
        file:close()
    end
end

-- Load the contents of a json file into a Lua table and return it:
--
function IO:LoadFile()
    local contents = self:ReadFile()
    return (contents and (contents == '') and {} or self.json:decode(contents)) or {}
end

return IO