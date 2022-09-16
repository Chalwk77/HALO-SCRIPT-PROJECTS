--[[
--=====================================================================================================--
Script Name: Hunter-Prey, for SAPP (PC & CE)
Description: The flag is placed in the middle of the map.
Survive for as long as possible with flag.
When the time is up or when the kill limit is reached, the player that had the flag for the longest time wins.
If both time and kill limit are set to infinity, the winner is the player that had the flag for the longest time upon ending the game.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local HunterPrey = {
    --
    -- Configuration [starts]
    --

    -- The flag will respawn after this many seconds (if dropped):
    --
    respawn_time = 10,

    -- A message relay function temporarily removes the msg_prefix and
    -- restores it to this when done:
    --
    prefix = '**SAPP**',

    -- map settings:
    --
    ["bloodgulch"] = { 65.749, -120.409, 0.118 },
    ["deathisland"] = { -30.282, 31.312, 16.601 },
    ["icefields"] = { -26.032, 32.365, 9.007 },
    ["infinity"] = { 9.631, -64.030, 7.776 },
    ["sidewinder"] = { 2.051, 55.220, -2.801 },
    ["timberland"] = { 1.250, -1.487, -21.264 },
    ["dangercanyon"] = { -0.477, 55.331, 0.239 },
    ["beavercreek"] = { 14.015, 14.238, -0.911 },
    ["boardingaction"] = { 4.374, -12.832, 7.220 },
    ["carousel"] = { 0.033, 0.003, -0.856 },
    ["chillout"] = { 1.392, 4.700, 3.108 },
    ["damnation"] = { -2.002, -4.301, 3.399 },
    ["gephyrophobia"] = { 63.513, -74.088, -1.062 },
    ["hangemhigh"] = { 21.020, -4.632, -4.229 },
    ["longest"] = { -0.84, -14.54, 2.41 },
    ["prisoner"] = { 0.902, 0.088, 1.392 },
    ["putput"] = { -2.350, -21.121, 0.902 },
    ["ratrace"] = { 8.662, -11.159, 0.221 },
    ["wizard"] = { -5.035, -5.064, -2.750 }
}

local timer = {}
local players = {}
local announce_respawn
local clock = os.clock
local format = string.format

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

-- This is the constructor for the timer object.
function timer:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

-- This function starts the timer.
function timer:start()
    self.start_time = clock()
    self.paused_time = 0
    self.paused = false
end

-- This function stops the timer.
function timer:stop()
    self.start_time = nil
    self.paused_time = 0
    self.paused = false
end

-- This function pauses the timer.
function timer:pause()
    if (not self.paused) then
        self.paused_time = clock()
        self.paused = true
    end
end

-- This function resumes the timer.
function timer:resume()
    if (self.paused) then
        self.start_time = self.start_time + (clock() - self.paused_time)
        self.paused_time = 0
        self.paused = false
    end
end

-- This function returns the elapsed time in seconds.
function timer:get()
    if (self.start_time) then
        if (self.paused) then
            return self.paused_time - self.start_time
        else
            return clock() - self.start_time
        end
    end
    return 0
end

-- un/register sapp event callbacks:
local function RegSAPPEvents(f)
    for event, callback in pairs({
        ['EVENT_DIE'] = 'OnDeath',
        ['EVENT_TICK'] = 'OnTick',
        ['EVENT_JOIN'] = 'OnJoin',
        ['EVENT_LEAVE'] = 'OnQuit',
        ['EVENT_GAME_END'] = 'OnEnd',
    }) do
        f(cb[event], callback)
    end
end

-- Constructor for players table.
function HunterPrey:NewPlayer(o)

    setmetatable(o, { __index = self })
    self.__index = self

    return o
end

local function GetTag(Class, Name)
    local tag = lookup_tag(Class, Name)
    return (tag ~= 0 and read_dword(tag + 0xC)) or nil
end

function OnStart()

    local game_type = (get_var(0, '$gt'))
    local ffa = (get_var(0, '$ffa') == '1')
    if (game_type ~= 'n/a' and ffa) then

        announce_respawn = false

        local hp = HunterPrey
        local map = get_var(0, '$map')
        local meta = GetTag('weap', 'weapons\\flag\\flag')

        if (hp[map] and meta) then
            hp.meta = meta
            hp.fx = hp[map][1]
            hp.fy = hp[map][2]
            hp.fz = hp[map][3] + 0.5
            hp:SpawnFlag()
            RegSAPPEvents(register_callback)
            return
        end
    end
    RegSAPPEvents(unregister_callback)
end

function HunterPrey:SpawnFlag()
    local x, y, z = self.fx, self.fy, self.fz
    local flag = spawn_object('', '', x, y, z, 0, self.meta)
    local object = get_object_memory(flag)
    self.flag_object = object
    self.flag_object_memory = object
end

local sqrt = math.sqrt
local function GetDist(x1, y1, z1, x2, y2, z2)
    local dist = ((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2)
    return sqrt(dist)
end

local function Say(Ply, Msg)
    local prefix = HunterPrey.prefix
    if (not Ply) then
        execute_command('msg_prefix ""')
        say_all(Msg)
        execute_command('msg_prefix "' .. prefix .. '"')
        return
    end
    for _ = 1, 25 do
        rprint(Ply, ' ')
    end
    rprint(Ply, '|c' .. Msg)
end

local function FlagHeld()
    for i, v in ipairs(players) do
        local dyn = get_dynamic_player(i)
        if (dyn ~= 0 and player_alive(i) and v.has_flag) then
            return true
        end
    end
    return false
end

local floor = math.floor
function HunterPrey:RespawnFlag()

    local flag_held = FlagHeld()
    if (not flag_held) then

        local flag = self.flag_object_memory
        local fx, fy, fz = read_vector3d(flag + 0x5C)
        local x, y, z = self.fx, self.fy, self.fz
        local dist = GetDist(fx, fy, fz, x, y, z)

        if (dist > 1 and not self.respawn_timer) then
            announce_respawn = true

            self.respawn_timer = timer:new()
            self.respawn_timer:start()

        elseif (dist > 1 and self.respawn_timer) then

            local time = self.respawn_timer:get()
            time = floor(time)

            if (time == self.respawn_time / 2 and announce_respawn) then
                announce_respawn = false
                Say(_, 'Flag will respawn in ' .. self.respawn_time - time .. ' seconds.')
            elseif (time >= self.respawn_time) then
                self.respawn_timer = nil
                write_vector3d(self.flag_object + 0x5C, x, y, z)
                Say(_, 'Flag has respawned.')
            end
        end
    end
end

local function FormatTime(time)
    return format('%.3f', time)
end

function HunterPrey:HasFlag(dyn)
    for i = 0, 3 do

        local weapon = read_dword(dyn + 0x2F8 + 0x4 * i)
        local object = get_object_memory(weapon)
        if (weapon ~= 0xFFFFFFFF and object ~= 0) then

            local tag_address = read_word(object)
            local tag_data = read_dword(read_dword(0x40440000) + tag_address * 0x20 + 0x14)
            if (read_bit(tag_data + 0x308, 3) == 1) then

                if (not self.timer.start_time) then
                    self.timer:start()
                elseif (self.timer.paused) then
                    self.timer:resume()
                end

                self.total_time = self.timer:get()
                Say(i, 'Time with flag: ' .. FormatTime(self.total_time) .. ' seconds.')

                self.has_flag = true
                self.respawn_timer = nil

                goto next
            end
        end
    end

    self.timer:pause()
    self.has_flag = nil

    :: next ::
end

function OnTick()
    local hp = HunterPrey

    for i, v in ipairs(players) do
        local dyn = get_dynamic_player(i)
        if player_alive(i) and dyn ~= 0 then
            for j = 0, 3 do

                local weapon = read_dword(dyn + 0x2F8 + 0x4 * j)
                local object = get_object_memory(weapon)
                if (weapon ~= 0xFFFFFFFF and object ~= 0) then
                    local tag_address = read_word(object)
                    local tag_data = read_dword(read_dword(0x40440000) + tag_address * 0x20 + 0x14)
                    if (read_bit(tag_data + 0x308, 3) == 1) then

                        if (not v.timer.start_time) then
                            v.timer:start()
                        elseif (v.timer.paused) then
                            v.timer:resume()
                        end

                        v.total_time = v.timer:get()
                        for _ = 1, 25 do
                            rprint(i, ' ')
                        end
                        Say(i, 'Time with flag: ' .. floor(v.total_time) .. ' seconds.')

                        v.has_flag = true
                        hp.respawn_timer = nil

                        goto next
                    end
                end
            end
            v.timer:pause()
            v.has_flag = nil -- just in case
            :: next ::
        end
    end

    hp:RespawnFlag()
end

function OnJoin(Ply)
    players[Ply] = HunterPrey:NewPlayer({
        total_time = 0,
        timer = timer:new(),
        name = get_var(Ply, '$name')
    })
end

function OnDeath(Ply)
    local player = players[Ply]
    player.timer:pause()
    player.has_flag = nil
end

function OnQuit(Ply)
    players[Ply] = nil
end

function HunterPrey:GetTop3()
    local top3 = {}
    for _, v in ipairs(players) do
        if (v.total_time > 0) then
            table.insert(top3, v)
        end
    end
    table.sort(top3, function(a, b)
        return a.total_time > b.total_time
    end)
    return top3
end

function OnEnd()

    local winners = HunterPrey:GetTop3()
    if (winners) then

        for i = 1,3 do
            local player = winners[i]
            if (player) then
                local name = player.name
                local time = FormatTime(player.total_time)
                local place = i
                if (place == 1) then
                    place = '1st'
                elseif (place == 2) then
                    place = '2nd'
                elseif (place == 3) then
                    place = '3rd'
                end
                if (place == '1st') then
                    place = place .. ' (Winner)'
                end
                Say(_, place .. ' place: ' .. name .. ' | ' .. time .. ' seconds.')
            end
        end
    end

    players = {}
end

function OnScriptUnload()
    -- N/A
end