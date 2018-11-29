--[[
--=====================================================================================================--
Script Name: Give Passenger Weapon, for SAPP (PC & CE)
Description: Assigns a custom wepaon when someone enters the passengers seat of a vehicle
~ requested by mdc81 on opencarnage.net

- note, this mod doesn't function correctly.
- The reason for this (I think) is because the player cannot pick up a weapon while they're in a vehicle.
- SAPP needs a PreVehicleEntry event.

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
~ Created by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]

--[[
    -- valid weapon tags
    "weapons\\assault rifle\\assault rifle"
    "weapons\\ball\\ball"
    "weapons\\flag\\flag"
    "weapons\\flamethrower\\flamethrower"
    "weapons\\needler\\mp_needler"
    "weapons\\pistol\\pistol"
    "weapons\\plasma pistol\\plasma pistol"
    "weapons\\plasma rifle\\plasma rifle"
    "weapons\\plasma_cannon\\plasma_cannon"
    "weapons\\rocket launcher\\rocket launcher"
    "weapons\\shotgun\\shotgun"
    "weapons\\sniper rifle\\sniper rifle"
]]

api_version = '1.12.0.0'
-- set 'true' to 'false' to prevent weapon-assignment OnVehicleEntry() (and vice versa)
vehicles = {
    { "vehicles\\rwarthog\\rwarthog", false, "weapons\\rocket launcher\\rocket launcher" },
    { "vehicles\\scorpion\\scorpion_mp", false, "weapons\\plasma_cannon\\plasma_cannon" },
    { "vehicles\\warthog\\mp_warthog", true, "weapons\\sniper rifle\\sniper rifle" },
}

function OnScriptLoad()
    register_callback(cb['EVENT_VEHICLE_ENTER'], 'OnVehicleEntry')
end

function OnScriptUnload()

end

function OnVehicleEntry(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        local vehicle = get_object_memory(read_dword(player_object + 0x11c))
        for i = 1, #vehicles do
            if (vehicles[i] ~= nil) and (vehicle ~= nil and vehicle ~= 0) then
                if read_string(read_dword(read_word(vehicle) * 32 + 0x40440038)) == vehicles[i][1] then
                    if (vehicles[i][2] == true) and (read_word(player_object + 0x2F0) == 1) then
                        local vehiX, vehiY, vehiZ = read_vector3d(vehicle + 0x5C)
                        -- delete all of their weapons...
                        for j = 1, 4 do
                            execute_command("wdel " .. PlayerIndex)
                        end
                        -- assign new weapon
                        assign_weapon(spawn_object("weap", vehicles[i][3], vehiX, vehiY, vehiZ + 0.3), PlayerIndex)
                    end
                end
            end
        end
    end
end
