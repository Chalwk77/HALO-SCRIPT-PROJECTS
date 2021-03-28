--[[
--=====================================================================================================--
Script Name: Spawn From Sky, for SAPP (PC & CE)
Description: Read the title!
             The height above the ground can be edited on a per-map basis.

Copyright (c) 2016-2021, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
--=====================================================================================================--
]]

api_version = "1.12.0.0"
-- config begins --

local maps = {

    -- Height above ground:
    ["bloodgulch"] = 50,
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
    ["ratrace"] = 35,

    -- repeat the structure to add more maps (see example below)
    ["your_map_name_here"] = 10,
}
-- config ends --

local rx, ry, rz
local bx, by, bz

local players = { }
local ctf_globals, height

function OnScriptLoad()

    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    local globals = sig_scan("8B3C85????????3BF9741FE8????????8B8E2C0200008B4610") + 3
    if (globals == 3) then
        return
    end
    ctf_globals = read_dword(globals)

    OnGameStart()
end

local function RegisterSAPPEvents(Load)

    players = { }

    if (Load) then
        register_callback(cb["EVENT_TICK"], "OnTick")
        register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
        register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
        register_callback(cb['EVENT_PRESPAWN'], "OnPreSpawn")
    else
        unregister_callback(cb["EVENT_TICK"])
        unregister_callback(cb["EVENT_JOIN"])
        unregister_callback(cb['EVENT_SPAWN'])
        unregister_callback(cb['EVENT_PRESPAWN'])
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then

        local map = get_var(0, "$map")
        height = maps[map]
        if (height) then

            RegisterSAPPEvents(true)

            rx, ry, rz = read_vector3d(read_dword(ctf_globals))
            bx, by, bz = read_vector3d(read_dword(ctf_globals + 4))
        else
            RegisterSAPPEvents(false)
            cprint("[Spawn From Sky] " .. map .. " is not listed!", 12)
        end
    end
end

function OnTick()
    for i, _ in pairs(players) do
        if (i) then
            local DyN = get_dynamic_player(i)
            if (DyN ~= 0) then
                local state = read_byte(DyN + 0x2A3)
                if (state == 21 or state == 22) then
                    execute_command("ungod " .. i)
                    write_word(DyN + 0x104, 0)
                    players[i] = nil
                end
            end
        end
    end
end

local function InitPlayer(Ply)
    players[Ply] = true
end

function OnPlayerJoin(Ply)
    InitPlayer(Ply)
end

function OnPlayerSpawn(Ply)
    if (players[Ply]) then
        execute_command("god " .. Ply)
    end
end

function OnPreSpawn(Ply)
    if (players[Ply]) then

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