--[[
------------------------------------
Script Name: HCE Spawn Fix
- For FIG Community
--  MAPS THIS SCRIPT FIXES
    --      emt_inverno (DONE)
    --      dioptase (pending)
    --      deadend (pending)
    --      municipality (pending)

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
All Rights Reserved.

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
-----------------------------------
]]-- 
api_version = "1.10.0.0"

BrokenCoords = {
    -- emt_inverno
    -86.68, -16.49, 11.92,
    -- dioptase
    xxxxxxxxxxxxxxxxxxxx,
    -- deadend
    xxxxxxxxxxxxxxxxxxxx,
    -- municipality
    xxxxxxxxxxxxxxxxxxxx
}	

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    if get_var(0, "$gt") ~= "n/a" then
        mapname = get_var(0, "$map")
        gametype = get_var(0, "$mode")
        LoadTables()
        team_play = getteamplay()
    end
end

function OnScriptUnload()

end

function OnNewGame()
    mapname = get_var(0, "$map")
    gametype = get_var(0, "$mode")
    LoadTables()
    team_play = getteamplay()
    Team = get_var(PlayerIndex, "$team")
end

function getteamplay()
    if get_var(0, "$ffa") == "0" then
        return true
    else
        return false
    end
end

function OnPlayerSpawn(PlayerIndex)
    local CurrentCoords = GetPlayerCoords(PlayerIndex)
    local coord = SelectNewCoord()
    local player_obj_id = read_dword(get_player(PlayerIndex) + 0x34)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        if table.match(BrokenCoords, CurrentCoords) then
            if team_play == false then
                if (mapname == "emt_inverno") then
                    moveobject(player_obj_id, emt_inverno_SlayerCoords[coord][1], emt_inverno_SlayerCoords[coord][2], emt_inverno_SlayerCoords[coord][3] + 0.15)
                elseif (mapname == "dioptase") then
                    moveobject(player_obj_id, dioptase_SlayerCoords[coord][1], dioptase_SlayerCoords[coord][2], dioptase_SlayerCoords[coord][3] + 0.15)
                elseif (mapname == "deadend") then
                    moveobject(player_obj_id, deadend_SlayerCoords[coord][1], deadend_SlayerCoords[coord][2], deadend_SlayerCoords[coord][3] + 0.15)
                elseif (mapname == "municipality") then
                    moveobject(player_obj_id, municipality_SlayerCoords[coord][1], municipality_SlayerCoords[coord][2], municipality_SlayerCoords[coord][3] + 0.15)
                end
            end
            if team_play == true then
                if (mapname == "emt_inverno") then
                    if (Team == "red") then
                        moveobject(player_obj_id, emt_inverno_RedCoords[coord][1], emt_inverno_RedCoords[coord][2], emt_inverno_RedCoords[coord][3] + 0.15)
                    elseif (Team == "blue") then
                        moveobject(player_obj_id, emt_inverno_BlueCoords[coord][1], emt_inverno_BlueCoords[coord][2], emt_inverno_BlueCoords[coord][3] + 0.15)
                    end
                elseif (mapname == "dioptase") then
                    if (Team == "red") then
                        moveobject(player_obj_id, dioptase_RedCoords[coord][1], dioptase_RedCoords[coord][2], dioptase_RedCoords[coord][3] + 0.15)
                    elseif (Team == "blue") then
                        moveobject(player_obj_id, dioptase_BlueCoords[coord][1], dioptase_BlueCoords[coord][2], dioptase_BlueCoords[coord][3] + 0.15)
                    end
                elseif (mapname == "deadend") then
                    if (Team == "red") then
                        moveobject(player_obj_id, deadend_RedCoords[coord][1], deadend_RedCoords[coord][2], deadend_RedCoords[coord][3] + 0.15)
                    elseif (Team == "blue") then
                        moveobject(player_obj_id, deadend_BlueCoords[coord][1], deadend_BlueCoords[coord][2], deadend_BlueCoords[coord][3] + 0.15)
                    end
                elseif (mapname == "municipality") then
                    if (Team == "red") then
                        moveobject(player_obj_id, municipality_RedCoords[coord][1], municipality_RedCoords[coord][2], municipality_RedCoords[coord][3] + 0.15)
                    elseif (Team == "blue") then
                        moveobject(player_obj_id, municipality_BlueCoords[coord][1], municipality_BlueCoords[coord][2], municipality_BlueCoords[coord][3] + 0.15)
                    end
                end
            end
        end
    end
end

function SelectNewCoord()
    if (mapname == "emt_inverno") then
        if not team_play then
            if #emt_inverno_SlayerCoords > 0 then
                return rand(1, #emt_inverno_SlayerCoords + 1)
            end
        end
        if team_play then
            if (Team == "Red") then
                if #emt_inverno_RedCoords > 0 then
                    return rand(emt_inverno_RedCoords)
                end
            elseif (Team == "blue") then
                if #emt_inverno_BlueCoords > 0 then
                    return rand(1, #emt_inverno_BlueCoords + 1)
                end
            end
        end
    end
    if (mapname == "dioptase") then
        if not team_play then
            if #dioptase_SlayerCoords > 0 then
                return rand(1, #dioptase_SlayerCoords + 1)
            end
        end
        if team_play then
            if (Team == "Red") then
                if #dioptase_RedCoords > 0 then
                    return rand(1, #dioptase_RedCoords + 1)
                end
            elseif (Team == "blue") then
                if #dioptase_BlueCoords > 0 then
                    return rand(1, #dioptase_BlueCoords + 1)
                end
            end
        end
    end
    if (mapname == "deadend") then
        if not team_play then
            if #deadend_SlayerCoords > 0 then
                return rand(1, #deadend_SlayerCoords + 1)
            end
        end
        if team_play then
            if (Team == "Red") then
                if #deadend_RedCoords > 0 then
                    return rand(1, #deadend_RedCoords + 1)
                end
            elseif (Team == "blue") then
                if #deadend_BlueCoords > 0 then
                    return rand(1, #deadend_BlueCoords + 1)
                end
            end
        end
    end
    if (mapname == "municipality") then
        if not team_play then
            if #municipality_SlayerCoords > 0 then
                return rand(1, #municipality_SlayerCoords + 1)
            end
        end
        if team_play then
            if (Team == "Red") then
                if #municipality_RedCoords > 0 then
                    return rand(1, #municipality_RedCoords + 1)
                end
            elseif (Team == "blue") then
                if #municipality_BlueCoords > 0 then
                    return rand(1, #municipality_BlueCoords + 1)
                end
            end
        end
    end
    return nil
end

function moveobject(ObjectID, x, y, z)
    local object = get_object_memory(ObjectID)
    if get_object_memory(ObjectID) ~= 0 then
        local veh_obj = get_object_memory(read_dword(object + 0x11C))
        write_vector3d((veh_obj ~= 0 and veh_obj or object) + 0x5C, x, y, z)
    end
end

function GetPlayerCoords(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        local x, y, z = read_vector3d(get_dynamic_player(PlayerIndex) + 0x5C)
        local vehicle_objectid = read_dword(player_object + 0x11C)
        local vehicle_object = get_object_memory(vehicle_objectid)
        if (vehicle_object ~= 0 and vehicle_object ~= nil) then
            local vx, vy, vz = read_vector3d(vehicle_object + 0x5C)
            x = x + vx
            y = y + vy
            z = z + vz
        end
        return math.round(x, 2), math.round(y, 2), math.round(z, 2)
    end
    return nil
end

function math.round(num, idp)
    return tonumber(string.format("%." ..(idp or 0) .. "f", num))
end

function table.match(table, value)
    for k, v in pairs(table) do
        if v == value then
            return k
        end
    end
end

function LoadTables()
    -- emt_inverno --
    emt_inverno_RedCoords = { }
    emt_inverno_BlueCoords = { }
    emt_inverno_SlayerCoords = { }

    emt_inverno_RedCoords[1] = { -102.66, -36.76, -5.89 }
    emt_inverno_BlueCoords[1] = { 12.78, -54.08, 4.4 }
    emt_inverno_SlayerCoords[1] = { 18.57, -34.5, 4.23 }

    -- dioptase --
    dioptase_RedCoords = { }
    dioptase_BlueCoords = { }
    dioptase_SlayerCoords = { }

    dioptase_RedCoords[1] = { xxxxxxxxxxxxxxxxxxxx }
    dioptase_BlueCoords[1] = { xxxxxxxxxxxxxxxxxxxx }
    dioptase_SlayerCoords[1] = { xxxxxxxxxxxxxxxxxxxx }

    -- deadend --
    deadend_RedCoords = { }
    deadend_BlueCoords = { }
    deadend_SlayerCoords = { }

    deadend_RedCoords[1] = { xxxxxxxxxxxxxxxxxxxx }
    deadend_BlueCoords[1] = { xxxxxxxxxxxxxxxxxxxx }
    deadend_SlayerCoords[1] = { xxxxxxxxxxxxxxxxxxxx }
    
    -- municipality --
    municipality_RedCoords = { }
    municipality_BlueCoords = { }
    municipality_SlayerCoords = { }

    municipality_RedCoords[1] = { xxxxxxxxxxxxxxxxxxxx }
    municipality_BlueCoords[1] = { xxxxxxxxxxxxxxxxxxxx }
    municipality_SlayerCoords[1] = { xxxxxxxxxxxxxxxxxxxx }
end

function OnError(Message)
    print(debug.traceback())
end
