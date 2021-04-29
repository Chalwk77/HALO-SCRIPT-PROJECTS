--[[
--=====================================================================================================--
Script Name: Grenade Launcher, for SAPP (PC & CE)
Description: Turns any hand-held or vehicle weapon into a grenade launcher.
             To toggle Grenade Launcher mode on or off, type /gl on|off

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
local GLauncher = {

    -- This is the custom command used to toggle grenade launcher on/off:
    base_command = "gl", -- short for grenade launcher
    --

    -- Minimum permission required to execute /base_command for yourself
    permission = -1,
    --

    -- Minimum permission required to toggle grenade launcher on/off for other players:
    permission_other = 4,


    -- If true, grenade launcher will be disabled on death:
    disable_on_death = false,
    --

    -- Define grenades that will randomly spawn on a per-map basis;
    ["bloodgulch"] = {"weapons\\frag grenade\\frag grenade"},
    ["deathisland"] = {"weapons\\frag grenade\\frag grenade"},
    ["icefields"] = {"weapons\\frag grenade\\frag grenade"},
    ["infinity"] = {"weapons\\frag grenade\\frag grenade"},
    ["sidewinder"] = {"weapons\\frag grenade\\frag grenade"},
    ["timberland"] = {"weapons\\frag grenade\\frag grenade"},
    ["dangercanyon"] = {"weapons\\frag grenade\\frag grenade"},
    ["beavercreek"] = {"weapons\\frag grenade\\frag grenade"},
    ["boardingaction"] = {"weapons\\frag grenade\\frag grenade"},
    ["carousel"] = {"weapons\\frag grenade\\frag grenade"},
    ["chillout"] = {"weapons\\frag grenade\\frag grenade"},
    ["damnation"] = {"weapons\\frag grenade\\frag grenade"},
    ["gephyrophobia"] = {"weapons\\frag grenade\\frag grenade"},
    ["hangemhigh"] = {"weapons\\frag grenade\\frag grenade"},
    ["longest"] = {"weapons\\frag grenade\\frag grenade"},
    ["prisoner"] = {"weapons\\frag grenade\\frag grenade"},
    ["putput"] = {"weapons\\frag grenade\\frag grenade"},
    ["ratrace"] = {"weapons\\frag grenade\\frag grenade"},
    ["wizard"] = {"weapons\\frag grenade\\frag grenade"},
    ["tsce_multiplayerv1"] = {"cmt\\weapons\\evolved\\human\\frag_grenade\\_frag_grenade_mp\\frag_grenade_mp"},

    -- Grenade Launcher can be used with any of these weapons.
    -- Set to false to disable:
    weapons = {

        -- weapon projectiles --
        ["weapons\\flamethrower\\flame"] = false,
        ["weapons\\needler\\mp_needle"] = false,
        ["weapons\\rocket launcher\\rocket"] = false,
        ["weapons\\pistol\\bullet"] = true,
        ["weapons\\plasma pistol\\bolt"] = true,
        ["weapons\\shotgun\\pellet"] = true,
        ["weapons\\plasma_cannon\\plasma_cannon"] = false,
        ["weapons\\sniper rifle\\sniper bullet"] = false,
        ["weapons\\plasma rifle\\bolt"] = true,
        ["weapons\\assault rifle\\bullet"] = true,
        ["weapons\\plasma rifle\\charged bolt"] = false,

        -- vehicle projectiles --
        ["vehicles\\warthog\\bullet"] = true,
        ["vehicles\\scorpion\\bullet"] = false,
        ["vehicles\\ghost\\ghost bolt"] = true,
        ["vehicles\\scorpion\\tank shell"] = false,
        ["vehicles\\banshee\\banshee bolt"] = true,
        ["vehicles\\c gun turret\\mp gun turret"] = false,
        ["vehicles\\banshee\\mp_banshee fuel rod"] = false,

        -- tsce_multiplayerv1 vehicle projectiles--
        ["cmt\\vehicles\\evolved_h1-spirit\\warthog\\weapons\\warthog_turret\\projectiles\\warthog_turret_bullet"] = true,
        ["cmt\\vehicles\\evolved_h1-spirit\\ghost\\weapons\\ghost_cannon\\projectiles\\ghost_cannon_bolt\\ghost_cannon_bolt"] = true,
        ["cmt\\vehicles\\evolved_h1-spirit\\scorpion\\weapons\\scorpion_cannon\\projectiles\\scorpion_cannon_shell"] = false,
        ["cmt\\vehicles\\evolved_h1-spirit\\scorpion\\weapons\\scorpion_chaingun\\projectiles\\scorpion_chaingun_bullet"] = true,
        -- tsce_multiplayerv1 weapon projectiles--
        ["cmt\\weapons\\evolved_h1-spirit\\rocket_launcher\\projectiles\\rocket_launcher_rocket\\rocket_launcher_rocket"] = false,
        ["cmt\\globals\\evolved\\brute_aoe_hack\\projectiles\\brute_aoe_hack_proj"] = true,
        ["cmt\\globals\\evolved\\wraith_weakspot_hack\\wraith_weakspot_hack"] = false,
        ["cmt\\weapons\\evolved_h1-spirit\\needler\\_needler_mp\\projectiles\\needler_mp_needle"] = false,
        ["cmt\\globals\\evolved\\brute_aoe_hack\\_small\\projectiles\\brute_aoe_hack_small_proj"] = true,
        ["cmt\\weapons\\evolved\\human\\battle_rifle\\projectiles\\battle_rifle_bullet silent"] = true,
        ["cmt\\weapons\\evolved\\human\\battle_rifle\\projectiles\\battle_rifle_bullet"] = true,
        ["cmt\\weapons\\evolved_h1-spirit\\plasma_rifle\\projectiles\\plasma_rifle_bolt"] = true,
        ["cmt\\weapons\\evolved_h1-spirit\\pistol\\projectiles\\pistol_bullet"] = true,
        ["cmt\\weapons\\covenant\\brute_plasma_rifle\\bolt"] = true,
        ["cmt\\weapons\\evolved_h1-spirit\\shotgun\\projectiles\\shotgun_pellet"] = true,
        ["cmt\\weapons\\evolved_h1-spirit\\sniper_rifle\\projectiles\\sniper_rifle_bullet"] = false,
        ["cmt\\weapons\\evolved\\human\\dmr\\projectiles\\dmr_bullet"] = true,
        ["cmt\\weapons\\evolved_h1-spirit\\assault_rifle\\projectiles\\assault_rifle_bullet"] = true,
        ["cmt\\weapons\\evolved\\human\\battle_rifle\\projectiles\\battle_rifle_bullet h2a"] = true,
        ["zteam\\objects\\weapons\\single\\battle_rifle\\h2\\bullet"] = true,
        ["cmt\\weapons\\evolved\\covenant\\carbine\\projectiles\\carbine_bolt"] = true,
        ["cmt\\weapons\\evolved\\human\\frag_grenade\\_frag_grenade_mp\\frag_grenade_mp"] = false,
        ["cmt\\weapons\\evolved\\covenant\\plasma_grenade\\_plasma_grenade_mp\\plasma_grenade_mp"] = false,
    }
}
-- config ends --

api_version = "1.12.0.0"

local script_version = 1.1

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    OnGameStart()
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then

        GLauncher.players = { }

        local map = get_var(0, "$map")
        if (GLauncher[map]) then
            GLauncher.map = map
            register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
            register_callback(cb["EVENT_LEAVE"], "OnPlayerQuit")
            register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
            register_callback(cb["EVENT_OBJECT_SPAWN"], "OnObjectSpawn")
            for i = 1, 16 do
                if player_present(i) then
                    GLauncher:InitPlayer(i, false)
                end
            end
            return
        end

        unregister_callback(cb["EVENT_JOIN"])
        unregister_callback(cb["EVENT_LEAVE"])
        unregister_callback(cb["EVENT_COMMAND"])
        unregister_callback(cb["EVENT_OBJECT_SPAWN"])
    end
end

function OnScriptUnload()
    -- N/A
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return (Tag ~= 0 and read_dword(Tag + 0xC)) or nil
end

function GLauncher:Launch(Ply, ParentID)

    local DyN = get_dynamic_player(Ply)
    local parent_object = get_object_memory(ParentID)
    if (DyN ~= 0 and parent_object ~= 0) then

        local px, py, pz
        local VehicleID = read_dword(DyN + 0x11C)
        local VehicleObject = get_object_memory(VehicleID)

        local distance = 0.5
        if (VehicleID == 0xFFFFFFFF) then
            px, py, pz = read_vector3d(DyN + 0x5c)
        elseif (VehicleObject ~= 0) then
            px, py, pz = read_vector3d(VehicleObject + 0x5c)
            distance = 2
        end

        -- Update Z-Coordinate change when crouching:
        local couching = read_float(DyN + 0x50C)
        if (couching == 0) then
            pz = pz + 0.65
        else
            pz = pz + (0.35 * couching)
        end
        --

        local xAim = math.sin(read_float(DyN + 0x230))
        local yAim = math.sin(read_float(DyN + 0x234))
        local zAim = math.sin(read_float(DyN + 0x238))

        local x = px + (distance * xAim)
        local y = py + (distance * yAim)
        local z = pz + (distance * zAim)


        local n = math.random(1,#self[self.map])
        local tag = GetTag("proj", self[self.map][n])

        if (tag) then

            local frag = spawn_projectile(tag, Ply, x, y, z)
            local frag_object = get_object_memory(frag)

            if (frag and frag_object ~= 0) then
                local velocity = 0.6
                write_float(frag_object + 0x68, velocity * xAim)
                write_float(frag_object + 0x6C, velocity * yAim)
                write_float(frag_object + 0x70, velocity * zAim)
            end
        end
    end
end

function GLauncher:OnObjectSpawn(Ply, MapID, ParentID)
    if (Ply > 0 and player_alive(Ply) and self.players[Ply].enabled) then
        for tag, enabled in pairs(self.weapons) do
            if (MapID == GetTag("proj", tag) and enabled) then
                return false, self:Launch(Ply, ParentID)
            end
        end
    end
end

local function CMDSplit(CMD)
    local Args = { }
    for Params in CMD:gmatch("([^%s]+)") do
        Args[#Args + 1] = Params:lower()
    end
    return Args
end

local function Respond(Ply, Msg, Clear)
    if (Clear) then
        for _ = 1, 25 do
            rprint(Ply, " ")
        end
    end
    rprint(Ply, Msg)
end

function GLauncher:OnServerCommand(Ply, CMD, _, _)
    local Args = CMDSplit(CMD)
    local case = (Args and Args[1])
    if (case and Args[1] == self.base_command) then

        local lvl = tonumber(get_var(Ply, "$lvl"))
        if (lvl >= self.permission) then

            local pl = GetPlayers(Ply, Args)
            if (pl) then
                for i = 1, #pl do
                    local TargetID = tonumber(pl[i])
                    if (lvl < self.permission_other and TargetID ~= Ply) then
                        Respond(Ply, "Cannot toggle for other players! (no permission)")
                    else
                        self:Toggle(Ply, TargetID, Args)
                    end
                end
            end
        else
            Respond(Ply, "You do not have permission to execute that command")
        end
        return false
    end
end

function GLauncher:Toggle(Ply, TID, Args)

    local toggled = (self.players[TID].enabled)
    local name = self.players[TID].name

    local state = Args[2]
    if (not state) then

        state = self.players[TID].enabled
        if (state) then
            state = "activated"
        else
            state = "not activated"
        end

        if (Ply == TID) then
            Respond(Ply, "Grenade Launcher is " .. state)
        else
            Respond(Ply, name .. "'s Grenade Launcher is " .. state)
        end
        return

    elseif (state == "on" or state == "1" or state == "true") then
        state = "enabled"
    elseif (state == "off" or state == "0" or state == "false") then
        state = "disabled"
    else
        state = nil
    end

    if (toggled and state == "enabled" or not toggled and state == "disabled") then
        if (Ply == TID) then
            Respond(Ply, "Grenade Launcher is already " .. state)
        else
            Respond(Ply, name .. "'s Grenade Launcher is already " .. state)
        end
    elseif (state) then

        if (Ply == TID) then
            Respond(Ply, "Grenade Launcher " .. state)
        else
            Respond(Ply, "Grenade Launcher " .. state .. " for " .. name)
        end

        self.players[TID].target_object = nil
        self.players[TID].enabled = (state == "disabled" and false) or (state == "enabled" and true)
    else
        Respond(Ply, "Invalid Command Parameter.")
        Respond(Ply, 'Usage: "on", "1", "true", "off", "0" or "false"')
    end
end

function GetPlayers(Ply, Args)

    local players = { }
    local TID = Args[3]

    if (TID == nil or TID == "me") then
        table.insert(players, Ply)
    elseif (TID == "all" or TID == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(players, i)
            end
        end
    elseif (TID:match("%d+") and tonumber(TID:match("%d+")) > 0) then
        if player_present(TID) then
            table.insert(players, TID)
        else
            Respond(Ply, "Player #" .. TID .. " is not online!")
        end
    else
        Respond(Ply, "Invalid Target ID Parameter")
        Respond(Ply, 'Usage: "me", "all", "*" or [pid between 1-16]')
    end

    return players
end

function GLauncher:InitPlayer(Ply, Reset)
    if (not Reset) then
        self.players[Ply] = {
            enabled = false,
            name = get_var(Ply, "$name"),
        }
        return
    end
    self.players[Ply] = nil
end

function OnPlayerJoin(Ply)
    GLauncher:InitPlayer(Ply, false)
end

function OnPlayerQuit(Ply)
    GLauncher:InitPlayer(Ply, true)
end

function OnServerCommand(P, C)
    return GLauncher:OnServerCommand(P, C)
end

function OnObjectSpawn(P, MID, PID)
    return GLauncher:OnObjectSpawn(P, MID, PID)
end

-- Error Logging --
local function WriteLog(str)
    local file = io.open("Grenade Launcher.errors", "a+")
    if (file) then
        file:write(str .. "\n")
        file:close()
    end
end

-- In the event of an error, the script will trigger
-- these two functions: OnError(), report()
function report(StackTrace, Error)

    cprint(StackTrace, 4 + 8)

    cprint("--------------------------------------------------------", 5 + 8)
    cprint("Please report this error on github:", 7 + 8)
    cprint("https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", 7 + 8)
    cprint("Script Version: " .. script_version, 7 + 8)
    cprint("--------------------------------------------------------", 5 + 8)

    local timestamp = os.date("[%H:%M:%S - %d/%m/%Y]")
    WriteLog(timestamp)
    WriteLog("Please report this error on github:")
    WriteLog("https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues")
    WriteLog("Script Version: " .. script_version)
    WriteLog(Error)
    WriteLog(StackTrace)
    WriteLog("\n")
end

-- This function will return a string with a traceback of the stack call...
-- and call function 'report' after 50 milliseconds.
function OnError(Error)
    timer(50, "report", debug.traceback(), Error)
end