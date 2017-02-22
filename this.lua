function PlayerInVehicle(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        local VehicleID = read_dword(player_object + 0x11C)
        if VehicleID == 0xFFFFFFFF then
            return false
        else
            return true
        end
    else
        return false
    end
end

function delay_destroy_vehicle(old_vehicle_id)
    if old_vehicle_id then
        destroy_object(old_vehicle_id)
    end
    return 0
end

function moveobject(ObjectID, x, y, z)
    local object = get_object_memory(ObjectID)
    if get_object_memory(ObjectID) ~= 0 then
        local veh_obj = get_object_memory(read_dword(object + 0x11C))
        write_vector3d((veh_obj ~= 0 and veh_obj or object) + 0x5C, x, y, z)
    end
end

function WeaponHandler(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    local X, Y, Z = read_vector3d(player_object + 0x5C)
    -- If already in vehicle when they level up, destroy the old one
    vbool = false
    if PlayerInVehicle(PlayerIndex) then
        vbool = true
        if player_object ~= 0 then
            old_vehicle_id = read_dword(player_object + 0x11C)
            obj_id = get_object_memory(old_vehicle_id)
            VehX, VehY, VehZ = read_vector3d(obj_id + 0x5c)
            exit_vehicle(PlayerIndex)
            timer(0, "delay_destroy_vehicle", old_vehicle_id)
        end
    end
    if (CurrentLevel == 7) or (CurrentLevel == 8) or (CurrentLevel == 9) then
        -- remove weapons --
        local weaponId = read_dword(player_object + 0x118)
        if weaponId ~= 0 then
            for j = 0, 3 do
                local weaponId = read_dword(player_object + 0x2F8 + j * 4)
                destroy_object(weaponId)
            end
        end
        -- enter vehicle --
        if (CurrentLevel == 7) then
            -- Ghost
            vehicleId = spawn_object("vehi", Level[7][1], X, Y, Z + 0.5)
            enter_vehicle(vehicleId, PlayerIndex, 0)
        elseif (CurrentLevel == 8) then
            -- Tank
            if vbool then
                vehicleId = spawn_object("vehi", Level[8][1], X, Y, Z + 0.5)
                enter_vehicle(vehicleId, PlayerIndex, 0) 
                moveobject(vehicleId, VehX, VehY, VehZ + 0.5)
            end
        elseif (CurrentLevel == 9) then
            -- Banshee
            if vbool then
            vehicleId = spawn_object("vehi", Level[9][1], X, Y, Z + 0.5)
                enter_vehicle(vehicleId, PlayerIndex, 0)
                moveobject(vehicleId, VehX, VehY, VehZ + 0.5)
            end
        end
    else
        local weaponId = read_dword(player_object + 0x118)
        if weaponId ~= 0 then
            for j = 0, 3 do
                local weaponId = read_dword(player_object + 0x2F8 + j * 4)
                destroy_object(weaponId)
            end
        end
        if NewLevel == 1 then
            nades_tbl = Level[1][5]
            assign_weapon(spawn_object("weap", tostring(Level[1][1]), X, Y, Z + 0.5), player_object)
        end
        if CurrentLevel == 2 then 
            nades_tbl = Level[2][5]
            assign_weapon(spawn_object("weap", tostring(Level[2][1]), X, Y, Z + 0.5), player_object)
        elseif CurrentLevel == 3 then 
            nades_tbl = Level[3][5]
            assign_weapon(spawn_object("weap", tostring(Level[3][1]), X, Y, Z + 0.5), player_object)
        elseif CurrentLevel == 4 then 
            nades_tbl = Level[4][5]
            assign_weapon(spawn_object("weap", tostring(Level[4][1]), X, Y, Z + 0.5), player_object)
        elseif CurrentLevel == 5 then 
            nades_tbl = Level[5][5]
            assign_weapon(spawn_object("weap", tostring(Level[5][1]), X, Y, Z + 0.5), player_object)
        elseif CurrentLevel == 6 then  
            nades_tbl = Level[6][5]
            assign_weapon(spawn_object("weap", tostring(Level[6][1]), X, Y, Z + 0.5), player_object)
        end
        -- timer(1000*1.500, "SyncAmmo", player_object)
        if nades_tbl then
            -- Plasmas
            write_byte(player_object + 0x31F, nades_tbl[1])
            -- Frags
            write_word(player_object + 0x31E, nades_tbl[2])
        end
    end
end

function SyncAmmo(player_object)
    local weaponId = read_dword(player_object + 0x118)
    local weap_obj = get_object_memory(weaponId)
    if weaponId ~= 0 then
        local unloaded_ammo = read_dword(weap_obj + 0x2B6)
        local loaded_ammo = read_dword(weap_obj + 0x2B8)
        if NewLevel == 1 then
            if tonumber(unloaded_ammo) and tonumber(Level[1][6]) then
                safe_write(true)
                write_dword(weap_obj + 0x2B6, tonumber(unloaded_ammo * tonumber(Level[1][6])))
                sync_ammo(weaponId)
                safe_write(false)
            end
        else
            if tonumber(unloaded_ammo) and tonumber(Level[CurrentLevel][6]) then
                safe_write(true)
                write_dword(weap_obj + 0x2B6, tonumber(unloaded_ammo * tonumber(Level[CurrentLevel][6])))
                sync_ammo(weaponId)
                safe_write(false)
            end 
        end
    end
end
