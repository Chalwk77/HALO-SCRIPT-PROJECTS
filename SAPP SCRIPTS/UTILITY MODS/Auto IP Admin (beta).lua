--[[
--=====================================================================================================--
Script Name: Auto IP Admin (beta), for SAPP (PC & CE)

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

api_version = "1.12.0.0"

-- configuration [starts]
local users = {
    -- IP | PW | LVL
    
    {["127.0.0.1"] = {"test", 4}},
    -- repeat the structure to add more entries 
    {["000.000.000.000"] = {"password", 0}},
    {["000.000.000.000"] = {"password", 0}},
    {["000.000.000.000"] = {"password", 0}},
    {["000.000.000.000"] = {"password", 0}},
    {["000.000.000.000"] = {"password", 0}},
}

-- configuration [ends]

local isadmin = { }

function OnScriptLoad()
    register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerDisconnect")
end

function OnScriptUnload()
    --
end

function OnPlayerJoin(PlayerIndex)
    if isadmin[PlayerIndex] then
        local ip, password = get_var(PlayerIndex, "$ip"):match("(%d+.%d+.%d+.%d+)")
        for key, _ in ipairs(users) do
            local userdata = users[key][ip]
            if (userdata ~= nil) then
                for i = 1,#userdata do
                   password = userdata[1] 
                end
            end
        end
        say(PlayerIndex, 'You are now an IP Admin.')
        say(PlayerIndex, 'Type /login ' .. password)
        cprint(get_var(PlayerIndex, "$name") .. " is now an IP Admin.", 5+8)
    end
end

function OnPlayerDisconnect(PlayerIndex)
    if isadmin[PlayerIndex] then
        execute_command("admin_del " .. PlayerIndex)
    end
end

function OnPlayerPrejoin(PlayerIndex)
    local p = tonumber(PlayerIndex)
    if (tonumber(get_var(p, "$lvl")) == -1) then
        local ip, found, password, level = get_var(p, "$ip"):match("(%d+.%d+.%d+.%d+)")
        for key, _ in ipairs(users) do
            local userdata = users[key][ip]
            if (userdata ~= nil) then
                for i = 1,#userdata do
                   password, level = userdata[1], userdata[2]
                   found = true
                end
            end
        end
        if (found) then
            execute_command("admin_add " .. p .. " " .. password .. " " .. level)
            isadmin[p] = isadmin[p] or {}
            isadmin[p] = true
        end
    end
end
