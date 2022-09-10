--[[
--=====================================================================================================--
Script Name: Attrition, for SAPP (PC & CE)
Description: Revive team mates who have died.
             Crouch over their body to begin the revive process.

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

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_TEAM_SWITCH'], 'OnSwitch')
    OnStart()
end

local function GetTag(Class, Name)
    local tag = lookup_tag(Class, Name)
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

function Attrition:NewTimer()
    return {
        cur = 0,
        finish = self.revival_time
    }
end

local sqrt = math.sqrt
local function GetDist(x1, y1, z1, x2, y2, z2)
    return sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2)
end

local function GetPos(Ply)

    local x, y, z
    local dyn = get_dynamic_player(Ply)
    if (dyn ~= 0) then
        local vehicle = read_dword(dyn + 0x11C)
        local object = get_object_memory(vehicle)
        if (vehicle == 0xFFFFFFFF) then
            x, y, z = read_vector3d(dyn + 0x5C)
        elseif (object ~= 0) then
            x, y, z = read_vector3d(object + 0x5C)
        end
    end

    return x, y, z
end

function Attrition:SpawnOrb()

    local h = self.orb_height_offset
    local x, y, z = GetPos(self.id)

    local orb = spawn_object('', '', x, y, z + h, 0, orb_object)
    local object = get_object_memory(orb)
    if (object ~= 0) then
        self.orbs[orb] = {
            x = x,
            y = y,
            z = z,
            team = self.team
        }
        rprint(self.id, "You have died. Waiting to be revived...")
    end
end

function Attrition:NewPlayer(o)

    setmetatable(o, { __index = self })
    self.__index = self

    o.orbs = {}

    return o
end

local function DeductDeath(Ply)
    local deaths = tonumber(get_var(Ply, '$deaths'))
    execute_command('deaths ' .. Ply .. ' ' .. deaths - 1)
end

local function Say(Ply, Msg)
    local prefix = Attrition.prefix
    if (not Ply) then
        execute_command('msg_prefix ""')
        say_all(Msg)
        execute_command('msg_prefix "' .. prefix .. '"')
        return
    end
    for _ = 1, 25 do
        rprint(Ply, ' ')
    end
    rprint(Ply, Msg)
end

local function ProgressBar(cur, max, revival_time)
    local bar = ''
    for i = 1, revival_time do
        if (i > (cur / max) * revival_time) then
            bar = bar .. '|'
        end
    end
    return bar
end

function Attrition:Revive(victim, orb)

    self.timer.cur = self.timer.cur + 1 / 30

    local cur_time = self.timer.cur
    local finish = self.timer.finish

    local vic_id = victim.id

    if (cur_time >= finish) then
        self.timer = nil
        Say(_, self.name .. ' revived ' .. victim.name .. '!')
        write_dword(get_player(vic_id) + 0x2C, -1 * 33)
        destroy_object(orb)
        DeductDeath(vic_id)
        victim.orbs = {}
        return
    end

    local bar = ProgressBar(cur_time, finish, self.revival_time)
    Say(self.id, 'Reviving ' .. victim.name .. ' [' .. bar .. ']')
    Say(vic_id, 'You are being revived by ' .. self.name .. ' [' .. bar .. ']')
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

    -- update orb physics:
    write_bit(object + 0x10, 0, 0) -- Unset noCollisions bit.
    write_bit(object + 0x10, 5, 0) -- Unset ignorePhysics.
end

function Attrition:OnTick()

    for i, victim in ipairs(players) do

        if (not player_alive(i)) then
            write_dword(get_player(i) + 0x2C, 0.1 * 33)

            for orb_id, orb in pairs(victim.orbs) do

                local object = get_object_memory(orb_id)
                if (object ~= 0) then

                    local h = self.orb_height_offset
                    UpdateVectors(object, orb.x, orb.y, orb.z + h)

                    for j, teammate in ipairs(players) do
                        if (i ~= j and player_alive(j) and teammate.team == orb.team) then

                            local dyn = get_dynamic_player(j)
                            local px, py, pz = GetPos(j)
                            local crouching = read_bit(dyn + 0x208, 0)
                            local distance = GetDist(px, py, pz, orb.x, orb.y, orb.z)

                            if (distance <= self.range and crouching == 1) then
                                if (not teammate.timer) then
                                    teammate.timer = teammate:NewTimer()
                                else
                                    teammate:Revive(victim, orb_id)
                                end
                            else
                                teammate.timer = nil
                            end
                        end
                    end
                end
            end
        end
    end
end

function OnJoin(Ply)
    players[Ply] = Attrition:NewPlayer({
        id = Ply,
        team = get_var(Ply, '$team'),
        name = get_var(Ply, '$name')
    })
end

function OnQuit(Ply)
    players[Ply] = nil
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

function OnSwitch(Ply)
    players[Ply].team = get_var(Ply, '$team')
end

function OnTick()
    Attrition:OnTick()
end

function OnScriptUnload()
    -- N/A
end