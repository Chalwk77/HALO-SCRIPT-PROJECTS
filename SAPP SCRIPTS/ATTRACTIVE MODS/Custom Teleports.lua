--[[
--=====================================================================================================--
Script Name: Custom Teleports, for SAPP (PC & CE)
Description: With this script, you input two sets of map coordinates and players can teleport between them.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-----------------
-- CONFIG STARTS
-----------------

-- If true, players must crouch to activate a teleport:
-- Default: false
--
local crouch_activated = false

-- Teleport configuration table:
--
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

---------------
-- CONFIG ENDS
---------------

local map

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnStart")
    OnStart()
end

function OnStart()
    if (get_var(0, "$gt") ~= "n/a") then

        map = get_var(0, "$map")
        if (Teleports[map] and #Teleports[map] > 0) then
            register_callback(cb["EVENT_TICK"], "onTick")
            goto done
        end

        unregister_callback(cb["EVENT_TICK"])
        cprint("[Custom Teleports] " .. map .. " is not configured in Teleports array", 12)

        :: done ::
    end
end

local sqrt = math.sqrt
local function getDistance(x1, y1, z1, x2, y2, z2)
    return sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2)
end

local function getXYZ(dyn)

    local crouch = read_float(dyn + 0x50C)
    local x, y, z = read_vector3d(dyn + 0x5C)

    if (crouch_activated) then
        z = (crouch == 0 and z + 0.65)  or (z + 0.35 * crouch)
    end

    return x, y, z
end

function onTick()
    for i = 1, 16 do
        local dyn = get_dynamic_player(i)
        if (player_present(i) and player_alive(i) and dyn ~= 0) then
            local vehicle = read_dword(dyn + 0x11C)
            if (vehicle == 0xFFFFFFFF) then

                local x, y, z = getXYZ(dyn)
                for j = 1, #Teleports[map] do
                    local v = Teleports[map][j]
                    local z_off = v[8] -- extra height above ground at destination z-coord
                    local x2, y2, z2 = v[1], v[2], v[3] -- destination x,y,z
                    local trigger_distance = v[4] -- origin x,y,z trigger radius

                    local distance = getDistance(x, y, z, x2, y2, z2)
                    if (distance <= trigger_distance) then
                        write_vector3d(dyn + 0x5C, v[5], v[6], v[7] + z_off)
                        rprint(i, 'WOOSH!')
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