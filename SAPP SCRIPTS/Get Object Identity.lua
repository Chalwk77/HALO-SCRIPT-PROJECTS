--[[
--=====================================================================================================--
Script Name: Get Object Identity, for SAPP (PC & CE)

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
~ Created by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]

api_version = '1.12.0.0'

portalgun_command = "getidentity"
permission_level = 1

mode = {}
weapon_status = {}

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload()

end

function OnPlayerSpawn(PlayerIndex)
    mode[PlayerIndex] = false
    weapon_status[PlayerIndex] = 0
end

function OnTick()
    for i = 1, 16 do
        if (player_present(i) and player_alive(i)) then
            if (mode[i] == true) then
                local success, target = false, nil
                local player_object = get_dynamic_player(i)
                local playerX, playerY, playerZ = read_float(player_object + 0x230), read_float(player_object + 0x234), read_float(player_object + 0x238)
                local shot_fired
                local couching = read_float(player_object + 0x50C)
                local px, py, pz = read_vector3d(player_object + 0x5c)
                if (couching == 0) then pz = pz + 0.65 else pz = pz + (0.35 * couching) end
                local ignore_player = read_dword(get_player(i) + 0x34)
                local success, a, b, c, target = intersect(px, py, pz, playerX * 1000, playerY * 1000, playerZ * 1000, ignore_player)
                if (success == true and target ~= nil) then
                    shot_fired = read_float(player_object + 0x490)
                    if(shot_fired ~= weapon_status[i] and shot_fired == 1) then
                        local target_object = get_object_memory(target)
                        if target_object ~= 0 then
                            local ObjectType = read_byte(target_object + 0xB4)
                            local ObjectName = read_string(read_dword(read_word(target_object) * 32 + 0x40440038))
                            local ObjectMeta = read_dword(target_object)
                            if (ObjectType == 1) then
                                x, y, z = read_vector3d(target_object + 0x5C)
                            else
                                x, y, z = read_vector3d(target_object + 0x5c)
                            end
                            local yaw = read_float(target_object + 0x76)
                            local pitch = read_float(target_object + 0x7A)
                            local roll = read_float(target_object + 0x7E)
                            local rotation = read_float(target_object + 0x82)
                            if ObjectType == 0 then
                                SendToPlayer(i, "bipd", ObjectName, ObjectMeta, x, y, z, yaw, pitch, roll, rotation)
                            elseif ObjectType == 1 then
                                SendToPlayer(i, "vehi", ObjectName, ObjectMeta, x, y, z, yaw, pitch, roll, rotation)
                            elseif ObjectType == 3 then
                                SendToPlayer(i, "eqip", ObjectName, ObjectMeta, x, y, z, yaw, pitch, roll, rotation)
                            elseif ObjectType == 2 then
                                SendToPlayer(i, "weap", ObjectName, ObjectMeta, x, y, z, yaw, pitch, roll, rotation)
                            end
                        end
                    end
                    weapon_status[i] = shot_fired
                end
            end
        end
    end
end

function SendToPlayer(player, type, ObjectName, ObjectMeta, x, y, z, yaw, pitch, roll, rotation)
    rprint(player, "Type: |r" .. tostring(type))
    rprint(player, "Name: |r" .. tostring(ObjectName))
    rprint(player, "Meta: |r" .. tonumber(ObjectMeta))
    rprint(player, "X,Y,Z: |r" .. math.floor(x) .. ", " .. math.floor(y) .. ", " .. math.floor(z))
    rprint(player, "Y,P,R: |r" .. math.floor(yaw) .. ", " .. math.floor(pitch) .. ", " .. math.floor(roll) .. ", " .. math.floor(rotation))
end

function OnServerCommand(PlayerIndex, Command)
    local UnknownCMD = nil
    local t = tokenizestring(Command)
    if t[1] ~= nil then
        if t[1] == string.lower(portalgun_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level then
                if t[2] ~= nil then
                    if t[2] == "on" or t[2] == "1" or t[2] == "true" then
                        mode[PlayerIndex] = true
                        rprint(PlayerIndex, "GetIdentity Mode enabled.")
                        UnknownCMD = false
                    elseif t[2] == "off" or t[2] == "0" or t[2] == "false" then
                        mode[PlayerIndex] = false
                        rprint(PlayerIndex, "GetIdentity Mode disabled.")
                        UnknownCMD = false
                    end
                else
                    rprint(PlayerIndex, "Invalid Syntax!")
                    UnknownCMD = false
                end
            else
                rprint(PlayerIndex, "You do not have permission to execute that command!")
                UnknownCMD = false
            end
        end
        return UnknownCMD
    end
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = { }; i = 1
for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    t[i] = str
    i = i + 1
end
return t
end
