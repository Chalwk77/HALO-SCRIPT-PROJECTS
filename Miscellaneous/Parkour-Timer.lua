--[[
--=====================================================================================================--
Script Name: Parkour, for SAPP (PC & CE)
Description: This script will record how long it takes a player to complete the parkour course.

[!] Do not touch anything in this file [!]

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local Parkour = {

    json = loadfile('./Parkour/Utils/json.lua')(),
    timer = loadfile('./Parkour/Utils/timer.lua')(),

    dependencies = {
        ['./Parkour/'] = { 'settings' },
        ['./Parkour/Utils/'] = { 'FileIO' },
        ['./Parkour/Helpers/'] = {
            'AnchorCheckpoints',
            'GetBestTime',
            'GetTimeFormat',
            'LineIntersection',
            'NewIP',
            'ReachedCheckpoint',
            'SaveTime'
        },
        ['./Parkour/Hud/'] = { 'HeadsUpDisplay' },
        ['./Parkour/Events/'] = {
            'OnDeath',
            'OnJoin',
            'OnPreSpawn',
            'OnQuit',
            'OnSpawn',
            'OnStart',
            'OnTick'
        }
    }
}

api_version = '1.12.0.0'

function Parkour:LoadDependencies()

    local s = self
    for path, t in pairs(self.dependencies) do
        for _, file in pairs(t) do
            local f = loadfile(path .. file .. '.lua')()
            setmetatable(s, { __index = f })
            s = f
        end
    end

    self.database = self:LoadFile()
end

function OnScriptLoad()
    Parkour:LoadDependencies()
    Parkour:OnStart()
end

function OnTick()
    Parkour:OnTick()
end

function OnStart()
    Parkour:OnStart()
end

function OnJoin(p)
    Parkour:OnJoin(p)
end

function OnDeath(p)
    Parkour.players[p]:OnDeath()
end

function OnQuit(p)
    Parkour:OnQuit(p)
end

function OnSpawn(p)
    Parkour.players[p]:OnSpawn()
end

function OnPreSpawn(p)
    Parkour.players[p]:OnPreSpawn()
end

function OnScriptUnload()
    -- N/A
end