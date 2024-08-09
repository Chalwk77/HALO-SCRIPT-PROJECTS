--[[
--=====================================================================================================--
Script Name: Weighted Weapons, for SAPP (PC & CE)
Description: Your speed will be reduced based on the weight of your inventory.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local Weights = {

    -- If true, your speed will be the sum of the
    -- combined weight reduction of all the weapons in your inventory.
    -- Otherwise the speed will be based on weight of the weapon currently held.
    --
    combined_weight = false,

    -- Weapon tags (NOTE: Normal walking speed is 1).
    -- Speed = 1-weapon weight
    -- Format: ['tag name' (string)] = weight reduction [number]

    ['weapons\\flag\\flag'] = 0.025,
    ['weapons\\ball\\ball'] = 0.025,

    ['weapons\\pistol\\pistol'] = 0.035,
    ['weapons\\plasma pistol\\plasma pistol'] = 0.035,

    ['weapons\\needler\\mp_needler'] = 0.040,
    ['weapons\\plasma rifle\\plasma rifle'] = 0.040,

    ['weapons\\shotgun\\shotgun'] = 0.045,
    ['weapons\\assault rifle\\assault rifle'] = 0.055,

    ['weapons\\flamethrower\\flamethrower'] = 0.070,

    ['weapons\\sniper rifle\\sniper rifle'] = 0.073,

    ['weapons\\plasma_cannon\\plasma_cannon'] = 0.075,
    ['weapons\\rocket launcher\\rocket launcher'] = 0.075,
}

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
end

local function GetTagPath(object)
    return (read_string(read_dword(read_word(object) * 32 + 0x40440038)) or 0)
end

local function GetSpeed(Dyn)

    local speed = 1

    if (not Weights.combined_weight) then
        local weapon = read_dword(Dyn + 0x118)
        local object = get_object_memory(weapon)
        if (weapon ~= 0xFFFFFFFFF and object ~= 0) then
            speed = speed - (Weights[GetTagPath(object)])
        end
        --print('combined weight: ', speed)
        return speed
    end

    for i = 0, 3 do
        local weapon = read_dword(Dyn + 0x2F8 + (i * 4))
        local object = get_object_memory(weapon)
        if (weapon ~= 0xFFFFFFFFF and object ~= 0) then
            speed = speed - (Weights[GetTagPath(object)])
        end
    end
    --print('combined weight: ', speed)

    return speed
end

function OnTick()
    for i = 1, 16 do
        local dyn = get_dynamic_player(i)
        if player_present(i) and player_alive(i) and (dyn ~= 0) then
            execute_command('s ' .. i .. ' ' .. GetSpeed(dyn))
        end
    end
end

function OnScriptUnload()
    -- N/A
end