--[[
--=====================================================================================================--
Script Name: Spawn From Sky, for SAPP (PC & CE)
Description: Read the title!

             The height above the ground can be edited on a per-map basis.
             All vanilla maps have a custom height.
             Maps not listed have a default height above ground of 20 world units.

Copyright (c) 2016-2021, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
--=====================================================================================================--
]]

api_version = "1.12.0.0"
-- config begins --

-- This is the height used if the current map is not listed below:
local default_height = 20

-- Height above ground:
local maps = {
    ["bloodgulch"] = 35,
    ["deathisland"] = 35,
    ["icefields"] = 35,
    ["infinity"] = 35,
    ["sidewinder"] = 35,
    ["timberland"] = 35,
    ["dangercanyon"] = 35,
    ["beavercreek"] = 35,
    ["boardingaction"] = 35,
    ["carousel"] = 35,
    ["chillout"] = 35,
    ["damnation"] = 35,
    ["gephyrophobia"] = 35,
    ["hangemhigh"] = 35,
    ["longest"] = 35,
    ["prisoner"] = 35,
    ["putput"] = 35,
    ["ratrace"] = 35,
    ["wizard"] = 35,

    -- repeat the structure to add more maps (see example below)
    ["your_map_name_here"] = 10,
}
-- config ends --

local rx, ry, rz
local bx, by, bz

local players = { }
local height, ctf_globals

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb['EVENT_SPAWN'], 'OnPlayerSpawn')
    register_callback(cb['EVENT_PRESPAWN'], 'OnPreSpawn')
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    local globals = sig_scan("8B3C85????????3BF9741FE8????????8B8E2C0200008B4610") + 3
    if (globals == 3) then
        return
    end
    ctf_globals = read_dword(globals)

    OnGameStart()
end

function OnTick()
    for i, v in pairs(players) do
        if (i and v.init) then
            local DyN = get_dynamic_player(i)
            if (DyN ~= 0) then
                local state = read_byte(DyN + 0x2A3)
                if (state == 21 or state == 22) then
                    v.init = false
                    execute_command("ungod " .. i)
                end
            end
        end
    end
end

local function InitPlayer(Ply, Reset)
    if (not Reset) then
        players[Ply] = { init = true }
    else
        players[Ply] = nil
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then

        local map = get_var(0, "$map")
        height = maps[map]
        if (not height) then
            height = default_height
        end

        players = { }
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, false)
            end
        end

        rx, ry, rz = read_vector3d(read_dword(ctf_globals))
        bx, by, bz = read_vector3d(read_dword(ctf_globals + 4))

    end
end

function OnPlayerJoin(Ply)
    InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    InitPlayer(Ply, true)
end

function OnPlayerSpawn(Ply)
    if (players[Ply].init) then
        execute_command("god " .. Ply)
    end
end

function OnPreSpawn(Ply)
    if (players[Ply].init) then

        local DyN = get_dynamic_player(Ply)
        if (DyN ~= 0) then
            local x, y, z
            local team = get_var(Ply, "$team")
            if (team == "red") then
                x, y, z = rx, ry, rz
            else
                x, y, z = bx, by, bz
            end
            write_vector3d(DyN + 0x5C, x, y, z + height)
        end
    end
end