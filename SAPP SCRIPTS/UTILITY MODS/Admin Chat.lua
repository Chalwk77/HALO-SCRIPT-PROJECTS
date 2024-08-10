-- CONFIGURATION ----------------------------------------------------------------
-- Admin Chat settings
local AdminChat = {
    -- Command to toggle admin chat
    command = 'AdminChat',

    -- Minimum permission level required to execute the command
    permission = 1,

    -- If true, admin chat will be enabled for admins by default
    enabled_by_default = false,

    -- Admin Chat message format
    output = '[AdminChat] $name: $msg'
}
-- END OF CONFIGURATION ----------------------------------------------------------

local players = {}

api_version = '1.12.0.0'

-- Register event callbacks
function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_CHAT'], 'showMessage')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')

    -- Call OnStart for initial setup
    OnStart()
end

-- Admin Chat player object
function AdminChat:newPlayer(o)

    -- Set player object metatable
    setmetatable(o, self)
    self.__index = self
    
    -- Function to get player level
    o.lvl = function()
        return tonumber(get_var(o.id, '$lvl'))
    end

    -- Set admin chat state based on permission and default state
    local state = (o.lvl() >= self.permission and self.enabled_by_default)
    o.state = (state or false)

    return o
end

-- Toggle admin chat
function AdminChat:Toggle()
    if (self.lvl() >= self.permission) then
        self.state = (not self.state and true or false)
        
        -- Print admin chat status
        rprint(self.id, 'Admin Chat ' .. (self.state and 'on' or not self.state and 'off'))
    else
        -- Print insufficient permission message
        rprint(self.id, 'Insufficient Permission')
    end
end

-- Show admin chat message
function AdminChat:showMessage(M)
    local response = true
    local msg = self.output
    
    -- Iterate through players
    for i = 1, 16 do
        if (player_present(i)) then
            local t = players[i]
            
            -- If admin chat is enabled for the player
            if (t.state) then
                
                -- Set response to false and print admin chat message
                response = false
                rprint(i, msg:gsub('$name', self.name):gsub('$msg', M))
            end
        end
    end
    return response
end

-- Handle game start event
function OnStart()
    
    -- If game type is not 'n/a'
    if (get_var(0, '$gt') ~= 'n/a') then
        
        -- Clear players table
        players = {}
        
        -- Iterate through player IDs
        for i = 1, 16 do
            
            -- If player is present, call OnJoin event
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

-- Handle command event
function OnCommand(P, CMD)
    local t = players[P]
    
    -- Convert command to lowercase
    local cmd = CMD:sub(1, CMD:len()):lower()

    -- If player object exists and command matches the custom command
    if (t and cmd == t.command) then
        
        -- Toggle admin chat and return false to disable default command handling
        t:Toggle()
        return false
    end
end

-- Check if a string is a command
local function isCommand(s)
    
    -- Return true if the string starts with '/' or '\\'
    return (s:sub(1, 1) == '/' or s:sub(1, 1) == '\\')
end

-- Handle chat event
function showMessage(P, M)
    local t = players[P]

    -- If message is not a command and admin chat is enabled for the player
    if (not isCommand(M) and t.state) then
        
        -- Call AdminChat:showMessage and return its result
        return t:showMessage(M)
    end
end

-- Handle player join event
function OnJoin(P)
    players[P] = AdminChat:newPlayer({
        -- Set player object properties
        id = P,
        name = get_var(P, '$name')
    })
end

-- Handle player leave event
function OnQuit(P)
    players[P] = nil
end

-- Handle script unload event
function OnScriptUnload()
    -- No action required
end