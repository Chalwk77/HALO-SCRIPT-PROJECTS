--[[
--=====================================================================================================--
Script Name: Tea Bagging, for SAPP (PC & CE)
Description: Humiliate your friends with this nifty little script.

Crouch over your victims corpse 3 times to trigger a funny message "$name is lap-dancing on $victim's body!".
T-bag any corpse within 60 seconds after they die.

By design, you can Tea-bag any player (even team mates!)

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local TBag = {

    -- config starts --

    -- Message announced when a player is t-bagging:
    --
    on_tbag = "$name is lap-dancing on $victim's body!",


    -- Radius (in w/units) a player must be from a victim's corpse to trigger a t-bag:
    --
    radius = 2.5,


    -- A player's death coordinates expire after this many seconds:
    --
    expiration = 60,


    -- A player must crouch over a victim's corpse this
    -- many times in order to trigger t-bag:
    --
    crouch_count = 3,


    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished:
    server_prefix = "**ADMIN**"
    --

    -- config ends --
}

local players = {}

local time = os.time
local sqrt = math.sqrt

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb["EVENT_SPAWN"], "OnSpawn")
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
end

function TBag:NewPlayer(t)
    t.loc, t.count, t.state = {}, 0, 0
    setmetatable(t, self)
    self.__index = self
    return t
end

function TBag:Announce(msg)
    execute_command("msg_prefix \"\"")
    say_all(msg)
    execute_command("msg_prefix \" " .. self.server_prefix .. "\"")
end

local function GetXYZ(Ply)
    local x, y, z
    local dyn = get_dynamic_player(Ply)
    if (dyn ~= 0) then
        local vehicle = read_dword(dyn + 0x11C)
        local object = get_object_memory(vehicle)
        if (vehicle == 0xFFFFFFFF) then
            x, y, z = read_vector3d(dyn + 0x5c)
        elseif (object ~= 0) then
            x, y, z = read_vector3d(object + 0x5c)
        end
    end
    return x, y, z, dyn
end

local function Dist(x1, y1, z1, x2, y2, z2, r)
    return sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2) <= r
end

function OnTick()
    for _, k in pairs(players) do
        for _, v in pairs(players) do
            if (k and v and k.pid ~= v.pid and #v.loc > 0) then
                for i, pos in pairs(v.loc) do
                    local x1, y1, z1 = pos.x, pos.y, pos.z
                    if (time() >= pos.finish) then
                        v.loc[i] = nil
                    elseif player_alive(k.pid) then
                        local x2, y2, z2, dyn = GetXYZ(k.pid)
                        if (x2 and Dist(x1, y1, z1, x2, y2, z2, k.radius)) then
                            local crouch = read_bit(dyn + 0x208, 0)
                            if (crouch ~= k.state and crouch == 1) then
                                k.count = k.count + 1
                            elseif (k.count >= k.crouch_count) then
                                v.loc[i], k.count = nil, 0
                                k:Announce(k.on_tbag:gsub("$name", k.name):gsub("$victim", v.name))
                            end
                            k.state = crouch
                        end
                    end
                end
            end
        end
    end
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        players = {}
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnDeath(Victim)
    local victim = tonumber(Victim)
    local v = players[victim]
    if (v) then
        local x, y, z = GetXYZ(victim)
        v.loc[#v.loc + 1] = {
            x = x,
            y = y,
            z = z,
            finish = time() + v.expiration
        }
    end
end

function OnJoin(Ply)
    players[Ply] = TBag:NewPlayer({
        pid = Ply,
        name = get_var(Ply, '$name')
    })
end

function OnQuit(Ply)
    players[Ply] = nil
end

function OnSpawn(Ply)
    players[Ply].state = 0
    players[Ply].count = 0
end

function OnScriptUnload()
    -- N/A
end