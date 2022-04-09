--[[
--=====================================================================================================--
Script Name: Admin Chat, for SAPP (PC & CE)
Description: This is a utility that allows you to chat privately with other admins.
             Command Syntax: /achat

             When Admin Chat is enabled your messages will appear in the rcon console environment.
             Only admins will see these messages.


Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
local AChat = {

    -- This is the custom command used to toggle admin chat on or off:
    -- Command syntax: /command
    --
    command = 'achat',

    -- Minimum permission required to execute /command:
    --
    permission = 1,

    -- If true, admin chat will be enabled for admins by default:
    -- Default: false
    -- Players need to be logged in to see admin messages.
    enabled_by_default = false,

    -- Admin Chat message format:
    --
    output = '[ACHAT] $name: $msg'
}
-- config ends --

local players = {}

api_version = '1.12.0.0'

function OnScriptLoad()

    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_CHAT'], 'ShowMessage')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')

    OnStart()
end

function AChat:NewPlayer(o)

    setmetatable(o, self)
    self.__index = self

    o.lvl = function()
        return tonumber(get_var(o.id, '$lvl'))
    end

    local state = (o.lvl() >= self.permission and self.enabled_by_default)
    o.state = (state or false)

    return o
end

function AChat:Toggle()
    if (self.lvl() >= self.permission) then
        self.state = (not self.state and true or false)
        rprint(self.id, 'Admin Chat ' .. (self.state and 'on' or not self.state and 'off'))
    else
        rprint(self.id, 'Insufficient Permission')
    end
end

function AChat:ShowMessage(M)

    local response = true
    local msg = self.output

    for i = 1, 16 do
        if (player_present(i)) then
            local t = players[i]
            if (t.state) then
                response = false
                rprint(i, msg:gsub('$name', self.name):gsub('$msg', M))
            end
        end
    end

    return response
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        players = { }
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnCommand(P, CMD)
    local t = players[P]
    local cmd = CMD:sub(1, CMD:len()):lower()
    if (t and cmd == t.command) then
        t:Toggle()
        return false
    end
end

local function IsCommand(s)
    return (s:sub(1, 1) == '/' or s:sub(1, 1) == '\\')
end

function ShowMessage(P, M)
    local t = players[P]
    if (not IsCommand(M) and t.state) then
        return t:ShowMessage(M)
    end
end

function OnJoin(P)
    players[P] = AChat:NewPlayer({
        id = P,
        name = get_var(P, '$name')
    })
end

function OnQuit(P)
    players[P] = nil
end

function OnScriptUnload()
    -- N/A
end