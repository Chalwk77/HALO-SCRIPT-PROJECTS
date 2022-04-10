--[[
--=====================================================================================================--
Script Name: 4-weapons (example script), for SAPP (PC & CE)
Description: This is a basic, example script of assigning 4 weapons

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local weapons = {
    'weapons\\pistol\\pistol',
    'weapons\\sniper rifle\\sniper rifle',
    'weapons\\shotgun\\shotgun',
    'weapons\\assault rifle\\assault rifle'
}

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
end

function OnSpawn()
    for i = 1, 16 do

        local dyn = get_dynamic_player(i)
        if player_present(i) and player_alive(i) and (dyn ~= 0) then

            -- delete their inventory:
            execute_command('wdel ' .. i)

            -- get their position vector:
            local x, y, z = read_vector3d(dyn + 0x5C)

            -- loop through weapons table:
            for j = 1, #weapons do

                local weap = weapons[j]

                -- assign primary & secondary weapons:
                if (j == 1 or j == 2) then
                    assign_weapon(spawn_object('weap', weap, x, y, z), i)

                else
                    -- assign tertiary & quaternary weapons 250ms apart:
                    timer(250, 'DelaySecQuat', i, weap, x, y, z)
                end
            end
        end
    end
end

function DelaySecQuat(p, weap, x, y, z)
    assign_weapon(spawn_object('weap', weap, x, y, z), p)
end

function OnScriptUnload()
    -- N/A
end