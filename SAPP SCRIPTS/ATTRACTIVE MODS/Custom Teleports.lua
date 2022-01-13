--[[
--=====================================================================================================--
Script Name: Custom Teleports, for SAPP (PC & CE)
Description: With this script, you input two sets of map coordinates and players can teleport between them.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local Teleports = {

    --[[
        format: {oX, oY, oZ, R, dX, dY, dZ, zOff}
        oX =     origin x
        oY =     origin y
        oZ =     origin z
        R =      origin x,y,z trigger radius
        dX =     destination x coord
        dY =     destination y coord
        dZ =     destination z coord
        zOff =   Extra height above ground at dZ
    ]]

    ["bloodgulch"] = {

        -- RED BASE (health pack to rocket launcher)
        { 98.80, -156.30, 1.70, 0.5, 72.58, -126.33, 1.18, 0 },

        -- BLUE BASE (health pack to rocket launcher)
        { 36.87, -82.33, 1.70, 0.5, 72.58, -126.33, 1.18, 0 },

        --
        -- Repeat the structure to add more portal sets.
        --
    },

    ["deathisland"] = {

    },

    ["icefields"] = {

    },

    ["infinity"] = {

    },

    ["sidewinder"] = {

    },

    ["timberland"] = {

    },

    ["dangercanyon"] = {

    },

    ["beavercreek"] = {

    },

    ["boardingaction"] = {

    },

    ["carousel"] = {

    },

    ["chillout"] = {

    },

    ["damnation"] = {

    },

    ["gephyrophobia"] = {

    },

    ["hangemhigh"] = {

    },

    ["longest"] = {

    },

    ["prisoner"] = {

    },

    ["putput"] = {

    },

    ["ratrace"] = {

    },

    ["wizard"] = {

    },
}

local map

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnStart")
    OnStart()
end

function OnStart()
    if (get_var(0, "$gt") ~= "n/a") then

        map = get_var(0, "$map")
        if (Teleports[map] and #Teleports[map] > 0) then
            register_callback(cb["EVENT_TICK"], "GameTick")
            goto done
        end

        unregister_callback(cb["EVENT_TICK"])
        cprint("[Custom Teleports] " .. map .. " is not configured in Teleports array", 12)

        :: done ::
    end
end

local sqrt = math.sqrt
local function GetDist(x1, y1, z1, x2, y2, z2)
    return sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2)
end

function GameTick()
    for i = 1, 16 do
        local DyN = get_dynamic_player(i)
        if (player_present(i) and player_alive(i) and DyN ~= 0) then
            local VID = read_dword(DyN + 0x11C)
            if (VID == 0xFFFFFFFF) then
                local x, y, z = read_vector3d(DyN + 0x5C)
                for _, v in pairs(Teleports[map]) do
                    local z_off = v[8] -- extra height above ground at destination z-coord
                    local x2, y2, z2 = v[1], v[2], v[3] -- destination x,y,z
                    local trigger_distance = v[4] -- origin x,y,z trigger radius
                    if GetDist(x, y, z, x2, y2, z2) <= trigger_distance then
                        write_vector3d(DyN + 0x5C, v[5], v[6], v[7] + z_off)
                        goto next
                    end
                end
            end
        end
        :: next ::
    end
end

function OnScriptUnload()
    -- N/A
end