--[[
--=====================================================================================================--
Script Name: Attrition, for SAPP (PC & CE)
Description: A mini-game inspired by Halo: Infinite's Attrition mode.

             Players have limited lives.
             The objective is to deplete the other team's pool of lives.
             When a teammate dies, you can revive them.

             An orb (skull) will float above their body to represent
             that this player can be revived.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts
local Attrition = {

    -- Time (in seconds) it takes to revive a player:
    --
    revival_time = 5,

    -- A player must be within this distance (in world units) to revive a team mate:
    --
    range = 0.5,

    -- Orb object height offset (height above ground):
    --
    orb_height_offset = 1,

    -- A message relay function temporarily disables the 'msg_prefix',
    -- and will restore it to this when done:
    --
    prefix = '**ADMIN**',

    -- The object tag class & name that represents the "orb".
    orb = { 'weap', 'weapons\\ball\\ball' }
}

-----------------
-- config ends --
-----------------


api_version = '1.12.0.0'

local orb_object
local players = {}
local time = os.time

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
    register_callback(cb['EVENT_MAP_RESET'], 'OnStart')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_TEAM_SWITCH'], 'OnSwitch')
    OnStart()
end

local function GetTag(class, name)
    local tag = lookup_tag(class, name)
    return (tag ~= 0 and read_dword(tag + 0xC)) or nil
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        players = {}

        local class, name = Attrition.orb[1], Attrition.orb[2]
        orb_object = GetTag(class, name)

        execute_command('disable_object ' .. '"' .. name .. '" 0')

        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function Attrition:newTimer()
    return {
        start = time,
        finish = time() + self.revival_time
    }
end

function Attrition:newPos(x, y, z)
    return {
        x = x,
        y = y,
        z = z
    }
end

local sqrt = math.sqrt
local function getDistance(x1, y1, z1, x2, y2, z2)
    return sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2)
end

local function getPosition(id)

    local x, y, z
    local dyn = get_dynamic_player(id)
    if (dyn == 0) then
        return nil
    end

    local vehicle = read_dword(dyn + 0x11C)
    local object = get_object_memory(vehicle)
    if (vehicle == 0xFFFFFFFF) then
        x, y, z = read_vector3d(dyn + 0x5C)
    elseif (object ~= 0) then
        x, y, z = read_vector3d(object + 0x5C)
    end

    return x, y, z
end

function Attrition:SpawnOrb()

    local h = self.orb_height_offset
    local x, y, z = getPosition(self.id)
    if (not x) then
        return
    end

    local orb = spawn_object('', '', x, y, z + h, 0, orb_object)
    local object = get_object_memory(orb)
    if (object ~= 0) then

        self.pos = self:newPos()
        self.orbs[orb] = {
            x = x,
            y = y,
            z = z,
            team = self.team
        }
        rprint(self.id, 'Waiting to be revived...')
    end
end

function Attrition:NewPlayer(o)

    setmetatable(o, { __index = self })
    self.__index = self

    o.orbs = {}
    o.revived = false

    return o
end

local function DeductDeath(id)
    local deaths = tonumber(get_var(id, '$deaths'))
    execute_command('deaths ' .. id .. ' ' .. deaths - 1)
end

local function say(id, Msg)
    local prefix = Attrition.prefix
    if (not id) then
        execute_command('msg_prefix ""')
        say_all(Msg)
        execute_command('msg_prefix "' .. prefix .. '"')
        return
    end
    for _ = 1, 25 do
        rprint(id, ' ')
    end
    rprint(id, '|c' .. Msg)
end

local function ProgressBar(start, finish, revival_time)

    local bar = ''
    local time_remaining = finish - start()

    for i = 1, time_remaining do
        if (i > (time_remaining / finish) * revival_time) then
            bar = bar .. '=='
        end
    end

    return bar
end

function Attrition:revive(victim, orb)

    local start = self.timer.start
    local finish = self.timer.finish

    local vic_id = victim.id

    if (start() >= finish) then

        victim.revived = true

        self.timer = nil
        say(vic_id, ' ')
        say(self.id, ' ')
        say(_, self.name .. ' revived ' .. victim.name .. '!')
        write_dword(get_player(vic_id) + 0x2C, -1 * 33)

        destroy_object(orb)
        DeductDeath(vic_id)
        victim.orbs = {}
        return
    end

    local bar = ProgressBar(start, finish, self.revival_time)
    say(self.id, 'Reviving ' .. victim.name .. ' [' .. bar .. ']')
    say(vic_id, 'You are being revived by ' .. self.name .. ' [' .. bar .. ']')
end

local function UpdateVectors(object, x, y, z)

    -- update orb x,y,z map coordinates:
    write_float(object + 0x5C, x)
    write_float(object + 0x60, y)
    write_float(object + 0x64, z)

    -- update orb velocities:
    write_float(object + 0x68, 0) -- x vel
    write_float(object + 0x6C, 0) -- y vel
    write_float(object + 0x70, 0) -- z vel

    -- update orb yaw, pitch, roll
    write_float(object + 0x90, 0) -- yaw
    write_float(object + 0x8C, 0) -- pitch
    write_float(object + 0x94, 0) -- roll
end

function Attrition:onTick()

    for i, victim in pairs(players) do

        if (not player_alive(i)) then
            write_dword(get_player(i) + 0x2C, 0.1 * 33)

            for orb_id, orb in pairs(victim.orbs) do

                local object = get_object_memory(orb_id)
                if (object ~= 0) then

                    orb.team = victim.team -- just in case

                    local h = self.orb_height_offset
                    UpdateVectors(object, orb.x, orb.y, orb.z + h)

                    for j, teammate in pairs(players) do

                        local dyn = get_dynamic_player(j)
                        if (dyn ~= 0) then

                            local px, py, pz = getPosition(j)
                            if (not px) then
                                goto next
                            end

                            local crouching = read_bit(dyn + 0x208, 0)
                            local proceed = (i ~= j and player_alive(j))
                            local distance = getDistance(px, py, pz, orb.x, orb.y, orb.z)

                            if (proceed and teammate.team == orb.team) then
                                if (distance <= self.range and crouching == 1) then
                                    if (not teammate.timer) then
                                        teammate.timer = teammate:newTimer()
                                    else
                                        teammate:revive(victim, orb_id, orb)
                                    end
                                else
                                    teammate.timer = nil
                                end
                            elseif (proceed and teammate.team ~= orb.team) then
                                if (distance <= self.range and crouching == 1) then
                                    say(j, 'You cannot revive this player.')
                                end
                            end
                        end
                    end

                    :: next ::
                end
            end
        end
    end
end

function OnJoin(id)
    players[id] = Attrition:NewPlayer({
        id = id,
        team = get_var(id, '$team'),
        name = get_var(id, '$name')
    })
end

function OnQuit(id)

    local orbs = players[id].orbs

    for obj, _ in pairs(orbs) do
        destroy_object(obj)
    end

    players[id] = nil
end

function OnDeath(Victim, Killer)

    local killer = tonumber(Killer)
    local victim = tonumber(Victim)

    local k = players[killer]
    local v = players[victim]

    local pvp = (killer > 0 and killer ~= victim and k and v)

    if (pvp) then
        v:SpawnOrb()
    end
end

function OnSpawn(id)
    local p = players[id]
    local dyn = get_dynamic_player(id)
    if (p and p.revived and dyn ~= 0) then
        write_vector3d(dyn + 0x5C, p.pos.x, p.pos.y, p.pos.z)
        p.revived = false
    end
end

function OnSwitch(id)
    players[id].team = get_var(id, '$team')
end

function OnTick()
    Attrition:onTick()
end

function OnScriptUnload()
    -- N/A
end