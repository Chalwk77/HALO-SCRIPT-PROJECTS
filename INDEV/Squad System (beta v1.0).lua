--[[
--=====================================================================================================--
Script Name: Squad System (beta v1.0), for SAPP (PC & CE)
Description: N/A

IN DEVELOPMENT

Idea taken from: https://opencarnage.net/index.php?/topic/7779-squad-system/

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local squad = { }
local coordinates = nil
-- ======================= CONFIGURATION STARTS ======================= --
-- No setting implemented at this time.
-- ======================= CONFIGURATION ENDS ======================= --

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    if (get_var(0, "$gt") ~= "n/a") then
        --
    end
end

function OnScriptUnload()
    --
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        coordinates = get_spawns()
    end
end

function squad:GetNearestSpawn(PlayerIndex)
    
    local function distanceFromPlayer(pX,pY,pZ,sX,sY,sZ) 
        return math.sqrt((pX - sX) ^ 2 + (pY - sY) ^ 2 + (pZ - sZ) ^ 2) 
    end
    
    local PlayerObject = get_dynamic_player(PlayerIndex)
    local team = get_var(PlayerIndex, "$team")
    local pX,pY,pZ = read_vector3d(PlayerObject)
    
    local temp = {}
    
    local function SaveCoordinates(CoordX,CoordY,CoordZ)
        local distance = distanceFromPlayer(pX,pY,pZ,sX,sY,sZ)
        temp[#temp + 1] = {dist = distance, x = sX, y = sY, z = sZ}
    end
    
    for i = 1,#coordinates do        
        if (coordinates[i][5] == 0) then 
            SaveCoordinates(coordinates[i][1],coordinates[i][2],coordinates[i][3])
        elseif (coordinates[i][5] == 1) then 
            SaveCoordinates(coordinates[i][1],coordinates[i][2],coordinates[i][3])
        end
    end
    
    function min(t, fn)
        if #t == 0 then return nil, nil end
        local x,y,z = 0,0,0
        
        local value = 1, t[1].dist
        
        for i = 2, #t do
            if fn(value, t[i].dist) then
                value = t[i].dist
                x,y,z = t[i].x,t[i].y,t[i].z
            end
        end
        return x, y, z
    end

    local x,y,z = min(temp, function(a,b) return a < b end)
    return {x,y,z}
end

-- Credits to Devieth (it300) for the below function.
-- Devith GitHub: https://github.com/it300/Halo-Lua
-- Code obtained from <https://opencarnage.net/index.php?/topic/7732-self-solved-always-random-spawns/>
function get_spawns()
    local spawns = { }
    local tag_array = read_dword( 0x40440000 )
    local scenario_tag_index = read_word( 0x40440004 )
    local scenario_tag = tag_array + scenario_tag_index * 0x20
    local scenario_tag_data = read_dword(scenario_tag + 0x14)

    local starting_location_reflexive = scenario_tag_data + 0x354
    local starting_location_count = read_dword(starting_location_reflexive)
    local starting_location_address = read_dword(starting_location_reflexive + 0x4)

    for i=0,starting_location_count do
        local starting_location = starting_location_address + 52 * i
		local x,y,z = read_vector3d(starting_location)
		local r = read_float(starting_location + 0xC)
		local team = read_word(starting_location + 0x10)
        spawns[#spawns + 1] = {x,y,z,r,team}
    end
    return spawns
end
