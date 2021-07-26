--[[
--=====================================================================================================--
Script Name: Frag Nation, for SAPP (PC & CE)
Description: A grenade only mini-game.

             Each player is given two of each grenade and an empty plasma pistol.
             If you have no grenades, you're limited to melee-combat.
             Every time you kill a player (with a grenade), you get a grenade(s).
             * Refer to config section for more info.

Features:

    1). Set the number of starting grenades (on spawn).
    2). Option to enabled or disable game objects (weapons, vehicles, equipment).
    3). Define primary weapon (default: plasma pistol),

    4). Grenade Bonuses (per kill):
        * frag explosion (+1)
        * plasma explosion (+1)
        * sticky plasma (+5)

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- config beings --
local FragNation = {

    -- Number of {frags, plasmas} on spawn:
    --
    starting_grenades = { 2, 2 },

    -- Grenades rewarded per kill:
    --
    grenades_on_kill = {
        1, -- frag explosion
        1, -- plasma explosion
        5, -- plasmas (sticky)
    },

    -- Primary weapon:
    --
    primary_weapon = 'weapons\\plasma pistol\\plasma pistol',

    -- Game objects that will be disabled:
    objects = {

        -- { tag type, tag name, enabled/disabled }
        -- weapons:
        --
        { 'weap', 'weapons\\pistol\\pistol', false },
        { 'weap', 'weapons\\shotgun\\shotgun', false },
        { 'weap', 'weapons\\needler\\mp_needler', false },
        { 'weap', 'weapons\\flamethrower\\flamethrower', false },
        { 'weap', 'weapons\\plasma rifle\\plasma rifle', false },
        { 'weap', 'weapons\\sniper rifle\\sniper rifle', false },
        { 'weap', 'weapons\\assault rifle\\assault rifle', false },
        { 'weap', 'weapons\\plasma pistol\\plasma pistol', false },
        { 'weap', 'weapons\\plasma_cannon\\plasma_cannon', false },
        { 'weap', 'weapons\\rocket launcher\\rocket launcher', false },

        -- { tag type, tag name, enabled/disabled }
        -- vehicles:
        --
        { 'weap', 'vehicles\\ghost\\ghost_mp', false },
        { 'weap', 'vehicles\\rwarthog\\rwarthog', false },
        { 'weap', 'vehicles\\warthog\\mp_warthog', false },
        { 'weap', 'vehicles\\banshee\\banshee_mp', false },
        { 'weap', 'vehicles\\scorpion\\scorpion_mp', false },
        { 'weap', 'vehicles\\c gun turret\\c gun turret_mp', false },

        -- { tag type, tag name, enabled/disabled }
        -- equipment:
        --
        { "eqip", "powerups\\health pack", "Health Pack", true },
        { "eqip", "powerups\\active camouflage", "Camouflage", true },
        { "eqip", "powerups\\over shield", "Over Shield", true },
        { "eqip", "weapons\\frag grenade\\frag grenade", true },
        { "eqip", "weapons\\plasma grenade\\plasma grenade", true },
    }
}

-- config ends --

function OnScriptLoad()

    -- Register needed event callbacks:
    --
    register_callback(cb["EVENT_DIE"], "OnDeath")
    register_callback(cb["EVENT_TICK"], "OnTick")

    register_callback(cb["EVENT_SPAWN"], "OnSpawn")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")

    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamage")

    OnGameStart()
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return (Tag ~= 0 and read_dword(Tag + 0xC)) or nil
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then

        FragNation.players = { }

        for i = 1, 16 do
            if player_present(i) then
                FragNation:InitPlayer(i, false)
            end
        end

        -- disable game objects:
        --
        for _, v in pairs(FragNation.objects) do
            if not v[3] and GetTag(v[1], v[2]) then
                execute_command("disable_object '" .. v[2] .. "'")
            end
        end
    end
end

local function GetXYZ(Ply)
    local pos = { }
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        local vehicle = read_dword(DyN + 0x11C)
        if (vehicle == 0xFFFFFFFF) then
            pos.x, pos.y, pos.z = read_vector3d(DyN + 0x5c)
        end
    end
    return pos
end

local function SetGrenades(Ply, Type, Amount)
    if (Type == 1) then
        execute_command("nades " .. Ply .. " " .. Amount)
    elseif (Type == 2) then
        execute_command("plasmas " .. Ply .. " " .. Amount)
    end
end

function FragNation:GameTick()
    for i, v in pairs(self.players) do
        if player_alive(i) then
            local pos = GetXYZ(i)
            if (pos and v.assign) then
                v.assign = false

                execute_command("wdel " .. i)

                assign_weapon(spawn_object("weap", self.primary_weapon, pos.x, pos.y, pos.z), i)
                execute_command_sequence("w8 1;battery " .. i .. " 0")

                SetGrenades(i, 1, self.starting_grenades[1])
                SetGrenades(i, 2, self.starting_grenades[2])
            end
        end
    end
end

local function Plural(n)
    return n > 1 and "s" or ""
end

function FragNation:OnDeath(Victim, Killer)
    local v, k = tonumber(Victim), tonumber(Killer)
    if (k > 0 and k ~= v) then

        local DyN = get_dynamic_player(k)
        if (DyN ~= 0 and self.players[k]) then

            local MetaID = self.players[k].metaid
            local frags = tonumber(read_byte(DyN + 0x31E))
            local plasmas = tonumber(read_byte(DyN + 0x31F))

            -- frag explosion:
            --
            if MetaID == GetTag("jpt!", "weapons\\frag grenade\\explosion") then
                SetGrenades(k, 1, frags + self.grenades_on_kill[1])
                rprint(k, "+" .. self.grenades_on_kill[1] .. " frag grenade" .. Plural(self.grenades_on_kill[1]))

                -- plasma explosion:
                --
            elseif MetaID == GetTag("jpt!", "weapons\\plasma grenade\\explosion") then
                SetGrenades(k, 2, plasmas + self.grenades_on_kill[2])
                rprint(k, "+" .. self.grenades_on_kill[2] .. " plasma grenade" .. Plural(self.grenades_on_kill[2]))

                -- plasma (sticky):
                --
            elseif MetaID == GetTag("jpt!", "weapons\\plasma grenade\\attached") then
                SetGrenades(k, 2, plasmas + self.grenades_on_kill[3])
                rprint(k, "+" .. self.grenades_on_kill[3] .. " plasma grenade" .. Plural(self.grenades_on_kill[3]))
            end

            self.players[k].metaid = 0
        end
    end
end

function FragNation:InitPlayer(Ply, Reset)

    if (not Reset) then
        self.players[Ply] = { metaid = 0, assign = false }
        return
    end

    self.players[Ply] = nil
end

function OnDamage(Victim, Causer, MetaID, _, _)
    local v, k = tonumber(Victim), tonumber(Causer)
    if (k > 0 and k ~= v) then
        FragNation.players[Causer].metaid = MetaID
    end
end

function OnPlayerConnect(Ply)
    FragNation:InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    FragNation:InitPlayer(Ply, true)
end

function OnSpawn(Ply)
    FragNation.players[Ply].metaid = 0
    FragNation.players[Ply].assign = true
end

function OnTick()
    return FragNation:GameTick()
end
function OnDeath(V, K)
    return FragNation:OnDeath(V, K)
end

function OnScriptUnload()
    -- N/A
end