--[[
------------------------------------
Script Name: HCE Spawn Fix
- For FIG Community
-- MAPS THIS SCRIPT FIXES
--      emt_inverno
--      dioptase
--      deadend

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
All Rights Reserved.

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
-----------------------------------
]]-- 
api_version = "1.10.0.0"

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
end

function getteamplay()
    if get_var(0,"$ffa") == "0" then
        return true
	else
        return false
	end
end

function OnPlayerSpawn(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    local coord = SelectNewCoord()
    local Team = get_var(PlayerIndex,"$team")
	local team_play = getteamplay()
    if (player_object ~= 0) then
--      emt_inverno      --
        if (mapname == "emt_inverno") then
            if not team_play then
                local Teleport_Coordinates = Sphere(PlayerIndex, -86.68, -16.49, 11.92, 2.5)
                if (Teleport_Coordinates == true) then
                    local player_obj_id = read_dword(get_player(PlayerIndex) + 0x34)
                    moveobject(player_obj_id, emt_inverno_SlayerCoords[coord][1], emt_inverno_SlayerCoords[coord][2], emt_inverno_SlayerCoords[coord][3] + 0.15)
                end
            end
            if team_play then
                if (Team == "red") then
                    local Teleport_Coordinates = Sphere(PlayerIndex, -86.68, -16.49, 11.92, 2.5)
                    if (Teleport_Coordinates == true) then
                        local player_obj_id = read_dword(get_player(PlayerIndex) + 0x34)
                        moveobject(player_obj_id, emt_inverno_RedCoords[coord][1], emt_inverno_RedCoords[coord][2], emt_inverno_RedCoords[coord][3] + 0.15)
                    end
                elseif (Team == "blue") then
                    local Teleport_Coordinates = Sphere(PlayerIndex, -86.68, -16.49, 11.92, 2.5)
                    if (Teleport_Coordinates == true) then
                        local player_obj_id = read_dword(get_player(PlayerIndex) + 0x34)
                        moveobject(player_obj_id, emt_inverno_BlueCoords[coord][1], emt_inverno_BlueCoords[coord][2], emt_inverno_BlueCoords[coord][3] + 0.15)
                    end
                end
            end
        end
--      dioptase      --
        if (mapname == "dioptase") then
            if not team_play then
                local Teleport_Coordinates = Sphere(PlayerIndex, -86.68, -16.49, 11.92, 2.5)
                if (Teleport_Coordinates == true) then
                    local player_obj_id = read_dword(get_player(PlayerIndex) + 0x34)
                    moveobject(player_obj_id, dioptase_SlayerCoords[coord][1], dioptase_SlayerCoords[coord][2], dioptase_SlayerCoords[coord][3] + 0.15)
                end
            end
            if team_play then
                if (Team == "red") then
                    local Teleport_Coordinates = Sphere(PlayerIndex, -86.68, -16.49, 11.92, 2.5)
                    if (Teleport_Coordinates == true) then
                        local player_obj_id = read_dword(get_player(PlayerIndex) + 0x34)
                        moveobject(player_obj_id, dioptase_RedCoords[coord][1], dioptase_RedCoords[coord][2], dioptase_RedCoords[coord][3] + 0.15)
                    end
                elseif (Team == "blue") then
                    local Teleport_Coordinates = Sphere(PlayerIndex, -86.68, -16.49, 11.92, 2.5)
                    if (Teleport_Coordinates == true) then
                        local player_obj_id = read_dword(get_player(PlayerIndex) + 0x34)
                        moveobject(player_obj_id, dioptase_BlueCoords[coord][1], dioptase_BlueCoords[coord][2], dioptase_BlueCoords[coord][3] + 0.15)
                    end
                end
            end
        end
--      deadend      --
        if (mapname == "deadend") then
            if not team_play then
                local Teleport_Coordinates = Sphere(PlayerIndex, -86.68, -16.49, 11.92, 2.5)
                if (Teleport_Coordinates == true) then
                    local player_obj_id = read_dword(get_player(PlayerIndex) + 0x34)
                    moveobject(player_obj_id, deadend_SlayerCoords[coord][1], deadend_SlayerCoords[coord][2], deadend_SlayerCoords[coord][3] + 0.15)
                end
            end
            if team_play then
                if (Team == "red") then
                    local Teleport_Coordinates = Sphere(PlayerIndex, -86.68, -16.49, 11.92, 2.5)
                    if (Teleport_Coordinates == true) then
                        local player_obj_id = read_dword(get_player(PlayerIndex) + 0x34)
                        moveobject(player_obj_id, emt_inverno_RedCoords[coord][1], emt_inverno_RedCoords[coord][2], emt_inverno_RedCoords[coord][3] + 0.15)
                    end
                elseif (Team == "blue") then
                    local Teleport_Coordinates = Sphere(PlayerIndex, -86.68, -16.49, 11.92, 2.5)
                    if (Teleport_Coordinates == true) then
                        local player_obj_id = read_dword(get_player(PlayerIndex) + 0x34)
                        moveobject(player_obj_id, deadend_BlueCoords[coord][1], deadend_BlueCoords[coord][2], deadend_BlueCoords[coord][3] + 0.15)
                    end
                end
            end
        end
    end
end

function SelectNewCoord()
	local team_play = getteamplay()
    local Team = get_var(PlayerIndex,"$team")
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
    return nil
end

function moveobject(ObjectID, x, y, z)
    local object = get_object_memory(ObjectID)
    if get_object_memory(ObjectID) ~= 0 then
        local veh_obj = get_object_memory(read_dword(object + 0x11C))
        write_vector3d((veh_obj ~= 0 and veh_obj or object) + 0x5C, x, y, z)
    end
end

function Sphere(PlayerIndex, x, y, z, radius)
    if PlayerIndex then
        local player_object = get_dynamic_player(PlayerIndex)
        local obj_x, obj_y, obj_z = read_vector3d(player_object + 0x5C)
        local x_diff = x - obj_x
        local y_diff = y - obj_y
        local z_diff = z - obj_z
        local Distance_From_Center = math.sqrt(x_diff ^ 2 + y_diff ^ 2 + z_diff ^ 2)
        if Distance_From_Center <= radius then
            return true
        end
    end
    return false
end

function math.round(num, idp)
    return tonumber(string.format("%." ..(idp or 0) .. "f", num))
end

function LoadTables()
    -- emt_inverno --
    emt_inverno_RedCoords = {}
    emt_inverno_BlueCoords = {}
    emt_inverno_SlayerCoords = {}

    emt_inverno_RedCoords[1] = {xxxxxxxxxxxxxxxxxxxx}
    emt_inverno_BlueCoords[1] = {xxxxxxxxxxxxxxxxxxxx}
    emt_inverno_SlayerCoords[1] = {xxxxxxxxxxxxxxxxxxxx}

    -- dioptase --
    dioptase_RedCoords = {}
    dioptase_BlueCoords = {}
    dioptase_SlayerCoords = {}

    dioptase_RedCoords[1] = {xxxxxxxxxxxxxxxxxxxx}
    dioptase_BlueCoords[1] = {xxxxxxxxxxxxxxxxxxxx}
    dioptase_SlayerCoords[1] = {xxxxxxxxxxxxxxxxxxxx}

    -- deadend --
    deadend_RedCoords = {}
    deadend_BlueCoords = {}
    deadend_SlayerCoords = {}

    deadend_RedCoords[1] = {xxxxxxxxxxxxxxxxxxxx}
    deadend_BlueCoords[1] = {xxxxxxxxxxxxxxxxxxxx}
    deadend_SlayerCoords[1] = {xxxxxxxxxxxxxxxxxxxx}
end

function OnError(Message)
    print(debug.traceback())
end
