--[[
--=====================================================================================================--
Script Name: Server Logger, for SAPP (PC & CE)
Description: An advanced custom server logger.
             This is intended to replace SAPP's built-in logger.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

local Logger = {

    -- Name of the log file for this server:
    -- File will be auto-generated in the same directory as mapcycle.txt.
    --
    file = 'Server Log.txt',

    -- Timestamp format:
    -- For help with date & time format, refer to this page: www.lua.org/pil/22.1.html
    --
    date_format = '!%a, %d %b %Y %H:%M:%S',

    -- Customizable event messages:
    -- You can enable or disable individual event logs.
    -- Set to false to disable & true to enable.
    -- Some are disabled by default.
    events = {

        -- Script load/unload:
        ['ScriptLoad'] = { '[SCRIPT LOAD] Advanced Logger was loaded', true },
        ['ScriptReload'] = { '[SCRIPT RELOAD] Advanced Logger was re-loaded', true },
        ['ScriptUnload'] = { '[SCRIPT UNLOAD] Advanced Logger was unloaded', true },

        -- Start/Finish
        ['Start'] = { 'A new game has started on [$map] - [$mode]', true },
        ['End'] = { 'Game Ended - Showing Post Game Carnage report', true },

        -- Join/Quit
        ['Join'] = { '[JOIN] $name ID: [$id] IP: [$ip] Hash: [$hash] Total Players: [$total/16]', true },
        ['Quit'] = { '[QUIT] $name ID: [$id] IP: [$ip] Hash: [$hash] Total Players: [$total/16]', true },

        -- Generic:
        ['Spawn'] = { '[SPAWN] $name spawned', false },
        ['Warp'] = { '[WARP] $name is warping', true },
        ['Login'] = { '[LOGIN] $name has logged in', true },
        ['Reset'] = { '[MAP RESET] The map has been reset.', true },
        ['Switch'] = { '[TEAM SWITCH] $name switched teams. New team: [$team]', false },

        -- Command/Message
        ['Command'] = { '[COMMAND] $name: /$cmd [Type: $command_type]', true },
        ['Message'] = { '[MESSAGE] $name: $msg [Type: $message_type]', true },

        -- death:
        ['unknown'] = { '[DEATH] $victim died', false },
        ['pvp'] = { '[DEATH] $victim was killed by $killer', false },
        ['suicide'] = { '[DEATH] $victim committed suicide', false },
        ['fell'] = { '[DEATH] $victim fell and broke their leg', false },
        ['server'] = { '[DEATH] $victim was killed by the server', false },
        ['run_over'] = { '[DEATH] $victim was run over by $killer', false },
        ['betrayal'] = { '[DEATH] $victim was betrayed by $killer', false },
        ['squashed'] = { '[DEATH] $victim was squashed by a vehicle', false },
        ['first_blood'] = { '[DEATH] $killer got first blood on $victim', false },
        ['guardians'] = { '[DEATH] $victim and $killer were killed by the guardians', false },
        ['killed_from_grave'] = { '[DEATH] $victim was killed from the grave by $killer', false },
    },

    -- Messages and commands containing these keywords will not be logged:
    sensitive_content = {
        'login',
        'admin_add',
        'change_password',
        'admin_change_pw',
        'admin_add_manually',
    }
}

local players = {}
local date = os.date
local open = io.open
local ffa, falling, distance, first_blood

function Logger:Format(s)
    for k, v in pairs({

        -- player vars:
        ['$ip'] = self.ip,
        ['$id'] = self.id,
        ['$lvl'] = self.lvl,
        ['$name'] = self.name,
        ['$hash'] = self.hash,
        ['$team'] = self.team,

        -- server vars:
        ['$cmd'] = self.cmd,
        ['$msg'] = self.msg,
        ['$map'] = self.map,
        ['$mode'] = self.mode,
        ['$total'] = self.total,
        ['$victim'] = self.victim,
        ['$killer'] = self.killer,
        ['$command_type'] = self.cmd_type,
        ['$message_type'] = self.msg_type

    }) do
        s = s:gsub(k, v)
    end
    return s
end

function Logger:Write(s)
    if (s[2]) then
        local str = s[1]
        str = self:Format(str)
        local file = open(self.dir, 'a+')
        if (file) then
            file:write('[' .. date(self.date_format) .. '] ' .. str .. '\n')
            file:close()
        end
    end
end

function Logger:NewPlayer(o)

    setmetatable(o, self)
    self.__index = self
    self.total = tonumber(get_var(0, '$pn'))

    o.meta = 0
    o.switched = false

    return o
end

local function Event(E)
    return Logger.events[E]
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

local function Sensitive(s)
    local t = Logger.sensitive_content
    for i = 1, #t do
        if (s:find(t[i])) then
            return true
        end
    end
    return false
end

local function IsCommand(s)
    return (s:sub(1, 1) == '/' or s:sub(1, 1) == '\\')
end

function OnScriptLoad()

    local dir = read_string(read_dword(sig_scan('68??????008D54245468') + 0x1))
    Logger.dir = dir .. '\\sapp\\' .. Logger.file

    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_CHAT'], 'OnChat')
    register_callback(cb['EVENT_WARP'], 'OnWarp')
    register_callback(cb['EVENT_LOGIN'], 'OnLogin')
    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_MAP_RESET'], 'OnReset')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_TEAM_SWITCH'], 'OnSwitch')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], 'OnDeath')

    if (get_var(0, '$gt') == 'n/a') then
        Logger:Write(Event('ScriptLoad'))
    else
        Logger:Write(Event('ScriptReload'))
    end

    OnStart(true)
end

function OnStart(script_load)

    if (get_var(0, '$gt') ~= 'n/a') then

        Logger.map = get_var(0, '$map')
        Logger.mode = get_var(0, '$mode')

        players = { }
        first_blood = true
        ffa = (get_var(0, '$ffa') == '1')
        falling = GetTag('jpt!', 'globals\\falling')
        distance = GetTag('jpt!', 'globals\\distance')

        if (not script_load) then
            Logger:Write(Event('Start'))
        end

        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnEnd()
    Logger:Write(Event('End'))
end

function OnJoin(P)

    players[P] = Logger:NewPlayer({
        id = P,
        ip = get_var(P, '$ip'),
        name = get_var(P, '$name'),
        hash = get_var(P, '$hash'),
        team = (not ffa and get_var(P, '$team') or 'FFA')
    })

    players[P]:Write(Event('Join'))
end

function OnQuit(P)
    Logger.total = Logger.total - 1
    players[P]:Write(Event('Quit'))
    players[P] = nil
end

function OnSpawn(P)
    players[P].meta = 0
    players[P].switched = nil
    players[P]:Write(Event('Spawn'))
end

function OnSwitch(P)
    players[P].switched = true
    players[P].team = get_var(P, '$team')
    players[P]:Write(Event('Switch'))
end

function OnWarp(P)
    players[P]:Write(Event('Warp'))
end

function OnReset()
    Logger:Write(Event('Reset'))
end

function OnLogin(P)
    if (players[P]) then
        Logger:Write(Event('Login'))
    end
end

function OnCommand(P, C, E)
    if (not Sensitive(C)) then
        Logger.cmd = C
        Logger.cmd_type = (E == 0 and 'CONSOLE' or E == 1 and 'RCON' or E == 2 and 'CHAT')
        if (players[P]) then
            players[P]:Write(Event('Command'))
        else
            Logger:Write(Event('Command'))
        end
    end
end

function OnChat(P, M, T)
    if (players[P] and not IsCommand(M) and not Sensitive(M)) then
        Logger.msg = M
        Logger.msg_type = (T == 0 and 'GLOBAL' or T == 1 and 'TEAM' or T == 2 and 'VEHICLE')
        players[P]:Write(Event('Message'))
    end
end

local function InVehicle(P)
    local dyn = get_dynamic_player(P)
    return (dyn ~= 0 and read_dword(dyn + 0x11C) ~= 0xFFFFFFFF) or false
end

function OnDeath(Victim, Killer, MetaID)

    local victim = tonumber(Victim)
    local killer = tonumber(Killer)

    local v = players[victim]
    local k = players[killer]

    if (v) then

        -- event_damage_application:
        if (MetaID) then
            v.meta = MetaID
            return true
        end

        v.victim = v.name
        if (k) then
            k.killer = k.name
        end

        -- event_die:
        local squashed = (killer == 0)
        local guardians = (killer == nil)
        local suicide = (killer == victim)
        local pvp = (k and killer ~= victim)
        local server = (killer == -1 and not v.switched)
        local fell = (v.meta == falling or v.meta == distance)
        local betrayal = (k and not ffa and (v.team == k.team and killer ~= victim))

        if (pvp and not betrayal) then

            if (first_blood) then
                first_blood = false
                k:Write(Event('first_blood'))
            end

            if (not player_alive(killer)) then
                k:Write(Event('killed_from_grave'))
                goto done
            elseif (InVehicle(killer)) then
                k:Write(Event('run_over'))
                goto done
            end
            k:Write(Event('pvp'))

        elseif (guardians) then
            v:Write(Event('guardians'))
        elseif (suicide) then
            v:Write(Event('suicide'))
        elseif (betrayal) then
            v:Write(Event('betrayal'))
        elseif (squashed) then
            v:Write(Event('squashed'))
        elseif (fell) then
            v:Write(Event('fell'))
        elseif (server) then
            v:Write(Event('server'))
        elseif (not v.switched) then
            v:Write(Event('unknown'))
        end

        :: done ::
    end
end

function OnScriptUnload()
    Logger:Write(Event('ScriptUnload'))
end