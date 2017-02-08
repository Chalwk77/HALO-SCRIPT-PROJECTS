api_version = "1.10.0.0"
team_play = false
loop = 8
local dir = 'sapp\\coordinates.txt'
function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_PRESPAWN'], "OnPlayerPrespawn")
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    if get_var(0, "$gt") ~= "n/a" then
        map_name = get_var(0, "$map")
        game_type = get_var(0, "$gt")
        team_play = getteamplay()
        Load_Tables()
    end
end

function OnNewGame()
    map_name = get_var(0, "$map")
    game_type = get_var(0, "$gt")
    team_play = getteamplay()
    Load_Tables()
    local file = io.open(dir, "a+")
    if file ~= nil then
        file:write("")
        file:close()
    end
end

function OnPlayerChat(PlayerIndex, Message)
    local response = nil
    local Message = string.lower(Message)
    local isadmin = nil
    if (tonumber(get_var(PlayerIndex, "$lvl"))) > 0 then
        isadmin = true
    else
        isadmin = false
    end
    -- Global
    if (Message == "coords") then
        if isadmin == true then
            local player_static = get_player(PlayerIndex)
            local x, y, z = GetPlayerCoords(PlayerIndex)
            local rotation = read_float(player_static + 0x138)
            local map_name = get_var(0, "$map")
            local game_type = get_var(0, "$gt")
            local team = get_var(PlayerIndex, "$team")
            if team_play then
                data = string.format("%s, %s, %s,", "Game Type: " .. tostring(game_type) .. ", Map: " .. tostring(map_name) .. ", Team: " .. tostring(team) .. ", Coordinates: " .. tostring(x), tostring(y), tostring(z) .. ", R: " .. math.round(rotation, 2))
            else
                data = string.format("%s, %s, %s,", "Game Type: " .. tostring(game_type) .. ", Map: " .. tostring(map_name) .. ", Coordinates: " .. tostring(x), tostring(y), tostring(z) .. ", R: " .. math.round(rotation, 2))
            end
            local file = io.open(dir, "a+")
            if file ~= nil then
                file:write(data .. "\n")
                file:close()
            end
            rprint(PlayerIndex, "Coordinates: x: " .. tostring(x) .. ", y: " .. tostring(y) .. ", z: " .. tostring(z) .. ", R: " .. math.round(rotation, 2))
            rprint(PlayerIndex, "Data saved to: <server folder>\\" .. dir)
            cprint(map_name .. ": " .. x .. "  Y: " .. y .. "  Z: " .. z .. "  R: " .. math.round(rotation, 2), 2 + 8)
            response = false
        else
            response = true
        end
    end
    return response
end

function OnPlayerPrespawn(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        if team_play then
            local team = get_var(PlayerIndex, "$team")
            if team == "red" then
                local redcoord = SelectRedSpawnCoord()
                if redcoord then
                    write_vector3d(player_object + 0x5C, red_spawn_coord[redcoord][1], red_spawn_coord[redcoord][2], red_spawn_coord[redcoord][3])
                    write_dword(get_player(PlayerIndex) + 0xF0, 0)
                    write_dword(get_player(PlayerIndex) + 0x164, 0)
                    local px, py, pz = GetPlayerCoords(PlayerIndex)
                    local vx = fx - px
                    local vy = fy - py
                    local vz = fz - pz
                    local magnitude = math.sqrt(vx * vx + vy * vy + vz * vz)
                    vx = vx / magnitude
                    vy = vy / magnitude
                    vz = vz / magnitude
                    write_float(player_object + 0x74, vx)
                    write_float(player_object + 0x78, vy)
                    write_float(player_object + 0x7c, vz)
                end
            elseif team == "blue" then
                local blucoord = SelectBluSpawnCoord()
                if blucoord then
                    write_vector3d(player_object + 0x5C, blu_spawn_coord[blucoord][1], blu_spawn_coord[blucoord][2], blu_spawn_coord[blucoord][3])
                    write_dword(get_player(PlayerIndex) + 0xF0, 0)
                    write_dword(get_player(PlayerIndex) + 0x164, 0)
                    local px, py, pz = GetPlayerCoords(PlayerIndex)
                    local vx = fx - px
                    local vy = fy - py
                    local vz = fz - pz
                    local magnitude = math.sqrt(vx * vx + vy * vy + vz * vz)
                    vx = vx / magnitude
                    vy = vy / magnitude
                    vz = vz / magnitude
                    write_float(player_object + 0x74, vx)
                    write_float(player_object + 0x78, vy)
                    write_float(player_object + 0x7c, vz)
                end
            end
        end
        if not team_play then
            local global_coordinates = SelectGlobalSpawnCoord()
            if global_coordinates then
                write_vector3d(player_object + 0x5C, global_spawn_point[global_coordinates][1], global_spawn_point[global_coordinates][2], global_spawn_point[global_coordinates][3])
                write_dword(get_player(PlayerIndex) + 0xF0, 0)
                write_dword(get_player(PlayerIndex) + 0x164, 0)
                local fx, fy, fz = global_rotation[1][1], global_rotation[1][2], global_rotation[1][3]
                local px, py, pz = GetPlayerCoords(PlayerIndex)
                local vx = fx - px
                local vy = fy - py
                local vz = fz - pz
                local magnitude = math.sqrt(vx * vx + vy * vy + vz * vz)
                vx = vx / magnitude
                vy = vy / magnitude
                vz = vz / magnitude
                write_float(player_object + 0x74, vx)
                write_float(player_object + 0x78, vy)
                write_float(player_object + 0x7c, vz)
            end
        end
    end
end
       
function SelectGlobalSpawnCoord()
    if #global_spawn_point > 0 then
        local index = rand(1, #global_spawn_point + 1)
        local coord = global_spawn_point[index]
        if (CheckForDuplicateSpawn(coord) == false) then
            return index
        end
    end
    return nil
end
       
function SelectRedSpawnCoord()
    if #red_spawn_coord > 0 then
        local index = rand(1, #red_spawn_coord + 1)
        local coord = red_spawn_coord[index]
        if (CheckForDuplicateSpawn(coord) == false) then
            return index
        end
    end
    return nil
end
            
function SelectBluSpawnCoord()
    if #blu_spawn_coord > 0 then
        local index = rand(1, #blu_spawn_coord + 1)
        local coord = blu_spawn_coord[index]
        if (CheckForDuplicateSpawn(coord) == false) then
            return index
        end
    end
    return nil
end
            
function CheckForDuplicateSpawn(coord)
    for i = 1, loop do
        local dyn_player = get_dynamic_player(i)
        if (dyn_player ~= 0) then
            local px, py, pz = GetPlayerCoords(i)
            local distance = DistanceFormula(coord[1], coord[2], coord[3], px, py, pz)
            if (distance < 1) then
                return true
            end
        end
    end
    return false
end
            
function DistanceFormula(x1, y1, z1, x2, y2, z2)
    return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end
            
function Load_Tables()
    -- Do not touch --
    red_spawn_coord = { }
    blu_spawn_coord = { }
    global_spawn_point = { }
    red_rotation = { }
    blue_rotation = { }
    global_rotation = { }
    -- ^^^ do not Touch ^^^ --

    --  CAPTURE THE FLAG
    if game_type == "GAME_TYPE_HERE" then
        if map_name == "MAP_NAME_HERE" then
            -- ROTATION
            red_rotation[1] = { PASTE_COORDINATES_HERE }
            blue_rotation[1] = { PASTE_COORDINATES_HERE }
            -- RED COORDINATES
            red_spawn_coord[1] = { PASTE_COORDINATES_HERE }
            red_spawn_coord[2] = { PASTE_COORDINATES_HERE }
            -- BLUE COORDINATES
            blu_spawn_coord[1] = { PASTE_COORDINATES_HERE }
            blu_spawn_coord[2] = { PASTE_COORDINATES_HERE }
            
        elseif map_name == "MAP_NAME_HERE" then
            -- ROTATION
            red_rotation[1] = { PASTE_COORDINATES_HERE }
            blue_rotation[1] = { PASTE_COORDINATES_HERE }
            -- RED COORDINATES
            red_spawn_coord[1] = { PASTE_COORDINATES_HERE }
            red_spawn_coord[2] = { PASTE_COORDINATES_HERE }
            -- BLUE COORDINATES
            blu_spawn_coord[1] = { PASTE_COORDINATES_HERE }
            blu_spawn_coord[2] = { PASTE_COORDINATES_HERE }
            -- Repeat the structure in ascending numerical order, to add more maps.
            -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>|<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--
        end
        --  SLAYER
    elseif game_type == "slayer" then
        if map_name == "MAP_NAME_HERE" then
            -- ROTATION
            global_rotation[1] = { PASTE_COORDINATES_HERE }
            global_spawn_point[1] = { PASTE_COORDINATES_HERE }
        elseif map_name == "MAP_NAME_HERE" then
            -- ROTATION
            global_rotation[1] = { PASTE_COORDINATES_HERE }
            global_spawn_point[1] = { PASTE_COORDINATES_HERE }
            -- Repeat the structure in ascending numerical order, to add more maps.
            -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>|<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--
        end
        --  OTHER
    elseif game_type == "GAME_TYPE_HERE" then
        if map_name == "MAP_NAME_HERE" then
            -- ROTATION
            red_rotation[1] = { PASTE_COORDINATES_HERE }
            blue_rotation[1] = { PASTE_COORDINATES_HERE }
            -- RED COORDINATES
            red_spawn_coord[1] = { PASTE_COORDINATES_HERE }
            red_spawn_coord[2] = { PASTE_COORDINATES_HERE }
            -- BLUE COORDINATES
            blu_spawn_coord[1] = { PASTE_COORDINATES_HERE }
            blu_spawn_coord[2] = { PASTE_COORDINATES_HERE }

        elseif map_name == "MAP_NAME_HERE" then
            -- ROTATION
            red_rotation[1] = { PASTE_COORDINATES_HERE }
            blue_rotation[1] = { PASTE_COORDINATES_HERE }
            -- RED COORDINATES
            red_spawn_coord[1] = { PASTE_COORDINATES_HERE }
            red_spawn_coord[2] = { PASTE_COORDINATES_HERE }
            -- BLUE COORDINATES
            blu_spawn_coord[1] = { PASTE_COORDINATES_HERE }
            blu_spawn_coord[2] = { PASTE_COORDINATES_HERE }
            -- Repeat the structure in ascending numerical order, to add more maps.
            -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>|<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--
        end
    end
end
            
function getteamplay()
    if (get_var(0, "$ffa") == "0") then
        return true
    else
        return false
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
            
function OnError(Message)
    print(debug.traceback())
end            
