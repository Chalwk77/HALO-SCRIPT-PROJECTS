--[[
------------------------------------
Script Name: HCE Spawn Fix
- For FIG Community

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
All Rights Reserved.

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
-----------------------------------
]]-- 

api_version = "1.10.0.0"

NewCoords = { }
NewCoords[1] = { 98.09, - 184.22, 12.13 }
-- NewCoords[2] = {ENTER_NEW_COORDINATE_HERE}
-- NewCoords[3] = {ENTER_NEW_COORDINATE_HERE}
-- NewCoords[4] = {ENTER_NEW_COORDINATE_HERE}
-- NewCoords[5] = {ENTER_NEW_COORDINATE_HERE}

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
end

function OnScriptUnload()

end

function OnNewGame()
    mapname = get_var(0, "$map")
end

function OnPlayerSpawn(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    local coord = SelectNewCoord()
    if (mapname == "bloodgulch") then
        if (player_object ~= 0) then
            -- x,y,z,r (X, Y, Z, <radius>)
            local Teleport1 = Sphere(PlayerIndex, 99.19, -146.67, 0.14, 1.5)
            local Teleport2 = Sphere(PlayerIndex, 91.89, -157.78, 1.7, 1.5)
            local Teleport3 = Sphere(PlayerIndex, 97.29, -163.54, 1.7, 1.5)
            local Teleport4 = Sphere(PlayerIndex, 99.34, -161.35, 1.7, 1.5)
            local Teleport5 = Sphere(PlayerIndex, 96.82, -156.99, 1.7, 1.5)
            if (Teleport1 == true) or (Teleport2 == true) or (Teleport3 == true) or (Teleport4 == true) or (Teleport5 == true) then
                local player_obj_id = read_dword(get_player(PlayerIndex) + 0x34)
                moveobject(player_obj_id, NewCoords[coord][1], NewCoords[coord][2], NewCoords[coord][3] + 0.15)
                cprint("Moving player to new coordinates!", 2 + 8)
            end
        end
    end
end

function SelectNewCoord()
    if #NewCoords > 0 then
        return rand(1, #NewCoords + 1)
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

function OnError(Message)
    print(debug.traceback())
end
