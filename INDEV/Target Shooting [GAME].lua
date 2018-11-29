--[[
--=====================================================================================================--
Script Name: Target Shooting [GAME], for SAPP (PC & CE)

<in development>

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
~ Created by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]

api_version = '1.12.0.0'
cyborg_coordinates = {}
cyborg_coordinates = {
    { 33.631, -65.569, 0.370 },
    { 41.703, -128.663, 0.247 },
    { 50.655, -87.787, 0.079 },
    { 101.940, -170.440, 0.197 },
    { 81.617, -116.049, 0.486 },
    { 78.208, -152.914, 0.091 },
    { 64.178, -176.802, 3.960 },
    { 102.312, -144.626, 0.580 },
    { 86.825, -172.542, 0.215 },
    { 65.846, -70.301, 1.690 },
    { 28.861, -90.757, 0.303 },
    { 46.341, -64.700, 1.113 }
}

weapon_status = {}

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
end

function OnScriptUnload()

end

function OnNewGame()
    for k, v in pairs(cyborg_coordinates) do
        spawn_object("bipd", "characters\\cyborg_mp\\cyborg_mp", v[1], v[2], v[3])
    end
end

function OnPlayerSpawn(PlayerIndex)
    weapon_status[PlayerIndex] = 0
end

function OnTick()
    for i = 1, 16 do
        if (player_present(i) and player_alive(i)) then
            local success, target = false, nil
            local player_object = get_dynamic_player(i)
            local playerX, playerY, playerZ = read_float(player_object + 0x230), read_float(player_object + 0x234), read_float(player_object + 0x238)
            local shot_fired
            local couching = read_float(player_object + 0x50C)
            local px, py, pz = read_vector3d(player_object + 0x5c)
            if (couching == 0) then
                pz = pz + 0.65
            else
                pz = pz + (0.35 * couching)
            end
            local ignore_player = read_dword(get_player(i) + 0x34)
            local success, a, b, c, target = intersect(px, py, pz, playerX * 1000, playerY * 1000, playerZ * 1000, ignore_player)
            if (success == true and target ~= nil) then
                shot_fired = read_float(player_object + 0x490)
                if (shot_fired ~= weapon_status[i] and shot_fired == 1) then
                    local target_object = get_object_memory(target)
                    if (target_object ~= 0) then
                        local ObjectType = read_byte(target_object + 0xB4)
                        if ObjectType == 0 then
                            local ObjectName = read_string(read_dword(read_word(target_object) * 32 + 0x40440038))
                            if (ObjectName == "characters\\cyborg_mp\\cyborg_mp") then
                                execute_command("msg_prefix \"\"")
                                say(i, "Cyborg has been shot!")
                                execute_command("msg_prefix \" *  * SERVER *  * \"")
                                destroy_object(target)
                            end
                        end
                    end
                end
                weapon_status[i] = shot_fired
            end
        end
    end
end
