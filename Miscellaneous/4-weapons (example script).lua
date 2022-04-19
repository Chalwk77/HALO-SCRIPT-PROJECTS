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

function OnSpawn(p)
    local dyn = get_dynamic_player(p)
    if (dyn ~= 0) then

        -- delete their inventory:
        execute_command('wdel ' .. p)

        -- loop through weapons table:
        for j = 1, #weapons do

            local weap = weapons[j]

            -- assign primary & secondary weapons:
            if (j == 1 or j == 2) then
                AssignWeapon(p, weap)
            else
                -- assign tertiary & quaternary weapons 250ms apart:
                timer(250, 'AssignWeapon', p, weap)
            end
        end
    end
end

function AssignWeapon(p, w)
    assign_weapon(spawn_object('weap', w, 0, 0, 0), p)
end

function OnScriptUnload()
    -- N/A
end