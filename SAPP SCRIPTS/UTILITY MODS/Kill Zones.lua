--[[
--=====================================================================================================--
Script Name: Kill Zones, for SAPP (PC & CE)
Description: When a player enters a kill zone, they have X seconds to exit otherwise they are killed.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
local KillZones = {

    on_enter = 'Warning. Entered $zone. You will be killed in $seconds',

    --[[
        label                =       Zone Label.
        team                 =       Player Team: 'red', 'blue', 'ffa'
                                     Only players on the defined team will trigger the Zone.
        x,y,z radius         =       Zone coordinates.
        seconds until death  =       A player has this many seconds to leave a Zone otherwise they are killed.
    ]]

    ['bloodgulch'] = {

        -- label | team | x,y,z | radius | warning delay | seconds until death
        { 'Zone 1', 'FFA', 33.631, -65.569, 0.370, 10, 15 },
        { 'Zone 2', 'FFA', 41.703, -128.663, 0.247, 10, 15 },
        { 'Zone 3', 'FFA', 50.655, -87.787, 0.079, 10, 15 },
        { 'Zone 4', 'FFA', 101.940, -170.440, 0.197, 10, 15 },
        { 'Zone 5', 'FFA', 81.617, -116.049, 0.486, 10, 15 },
        { 'Zone 6', 'FFA', 78.208, -152.914, 0.091, 10, 15 },
        { 'Zone 7', 'FFA', 64.178, -176.802, 3.960, 10, 15 },
        { 'Zone 8', 'FFA', 102.312, -144.626, 0.580, 10, 15 },
        { 'Zone 9', 'FFA', 86.825, -172.542, 0.215, 10, 15 },
        { 'Zone 10', 'FFA', 65.846, -70.301, 1.690, 10, 15 },
        { 'Zone 11', 'FFA', 28.861, -90.757, 0.303, 10, 15 },
        { 'Zone 12', 'FFA', 46.341, -64.700, 1.113, 10, 15 }

        -- repeat the structure to add more zones for this map
    },

    -- repeat the above structure to add more maps:
    ['ANOTHER_MAP'] = {
        {}
    }
}
-- config ends --

local players

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
end

function KillZones:NewPlayer(o)
    setmetatable(o, self)
    self.__index = self
    return o
end

function KillZones:Load()

    self.ffa = (get_var(0, '$ffa') == '1')

    players = {}
    local map = get_var(0, '$map')
    self.zones = self[map]

    return (self.zones and #self.zones > 0) or nil
end

function KillZones:Warn(z, time)
    local msg = self.on_enter
    msg = msg:gsub('$zone', z):gsub('$seconds', time)
    rprint(self.pid, msg)
end

function KillZones:Kill()
    execute_command('kill ' .. self.pid)
    rprint(self.pid, '')
    rprint(self.pid, '=========================================================')
    rprint(self.pid, 'You were killed for being out of bounds!')
    rprint(self.pid, '=========================================================')
    rprint(self.pid, '')
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        local zones = KillZones:Load()
        if (zones) then
            register_callback(cb['EVENT_TICK'], 'OnTick')
            register_callback(cb['EVENT_JOIN'], 'OnJoin')
            register_callback(cb['EVENT_LEAVE'], 'OnQuit')
            register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
            register_callback(cb['EVENT_TEAM_SWITCH'], 'OnSwitch')
            return
        end

        unregister_callback(cb['EVENT_TICK'])
        unregister_callback(cb['EVENT_JOIN'])
        unregister_callback(cb['EVENT_SPAWN'])
        unregister_callback(cb['EVENT_LEAVE'])
        unregister_callback(cb['EVENT_TEAM_SWITCH'])
    end
end

function OnJoin(P)
    players[P] = KillZones:NewPlayer({
        pid = P,
        team = (KillZones.ffa and 'FFA') or get_var(P, '$team'),
        name = get_var(P, '$name')
    })
end

function OnQuit(P)
    players[P] = nil
end

function OnSwitch(P)
    players[P].team = get_var(P, '$team')
end

function OnSpawn(P)
    local t = players[P]
    if (t) then
        t.start, t.finish = nil, nil -- just in case
    end
end

local function GetPos(dyn)
    local x, y, z
    local crouch = read_float(dyn + 0x50C)
    local vehicle = read_dword(dyn + 0x11C)
    local object = get_object_memory(vehicle)
    if (vehicle == 0xFFFFFFFF) then
        x, y, z = read_vector3d(dyn + 0x5c)
    elseif (object ~= 0) then
        x, y, z = read_vector3d(object + 0x5c)
    end
    return x, y, (crouch == 0 and z + 0.65 or z + 0.35 * crouch)
end

local sqrt = math.sqrt
local function Dist(pX, pY, pZ, zX, zY, zZ)
    return sqrt((pX - zX) ^ 2 + (pY - zY) ^ 2 + (pZ - zZ) ^ 2)
end

local time = os.time
function OnTick()
    for i, v in ipairs(players) do
        local dyn = get_dynamic_player(i)
        if (i and player_present(i) and player_alive(i) and dyn ~= 0) then
            for j = 1, #v.zones do

                local zone = v.zones[j]
                local team = zone[2]
                if (v.team == team) then

                    local label = zone[1]
                    local time_until_death = zone[7]

                    local px, py, pz = GetPos(dyn)
                    local zx, zy, zz, zr = zone[3], zone[4], zone[5], zone[6]

                    if Dist(px, py, pz, zx, zy, zz) <= zr then
                        if (not v.start) then
                            v.start, v.finish = time, time() + time_until_death
                            v:Warn(label, time_until_death)
                        elseif (v.start() >= v.finish) then
                            v:Kill()
                        end
                    elseif (v.start) then
                        v.start, v.finish = nil, nil
                    end
                end
            end
        end
    end
end

function OnScriptUnload()
    -- N/A
end