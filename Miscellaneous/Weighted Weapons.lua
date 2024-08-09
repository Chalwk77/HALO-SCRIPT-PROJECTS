--[[
--=====================================================================================================--
Script Name: Weighted Weapons, for SAPP (PC & CE)
Description: Your speed will be reduced based on the weight of your inventory.

Credits to "Enclusion" for the concept.
Check out his profile on OC:
https://opencarnage.net/index.php?/profile/2156-enclusion/

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local WeaponWeights = {

    -- Combine weight:
    -- If true, your speed will be the sum of the
    -- combined weight of all the weapons in your inventory.
    -- Otherwise the speed will be based on weight of the weapon currently held.
    --
    combined = true,

    -- Format: ['tag name'] = weight reduction value
    --
    weapons = {

        ['weapons\\flag\\flag'] = 0.028,
        ['weapons\\ball\\ball'] = 0.028,

        ['weapons\\pistol\\pistol'] = 0.036,
        ['weapons\\plasma pistol\\plasma pistol'] = 0.036,

        ['weapons\\needler\\mp_needler'] = 0.042,
        ['weapons\\plasma rifle\\plasma rifle'] = 0.042,

        ['weapons\\shotgun\\shotgun'] = 0.047,
        ['weapons\\assault rifle\\assault rifle'] = 0.061,

        ['weapons\\flamethrower\\flamethrower'] = 0.070,

        ['weapons\\sniper rifle\\sniper rifle'] = 0.073,

        ['weapons\\plasma_cannon\\plasma_cannon'] = 0.095,
        ['weapons\\rocket launcher\\rocket launcher'] = 0.100
    }
}

api_version = '1.12.0.0'

local weight = {}

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
end

local function getTag(class, name)
    local tag = lookup_tag(class, name)
    return (tag ~= 0 and read_dword(tag + 0xC)) or nil
end

local function tagsToID(t)
	for name, speed in pairs(t) do
		local tag = getTag('weap', name)
		if (tag) then
			weight[tag] = speed
		end
	end
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        weight = {}
		tagsToID(WeaponWeights.weapons)
    end
end

local function getWeight(weapon)

    local object = get_object_memory(weapon)
    if (object == 0 or weapon == 0xFFFFFFFFF) then
        return 0
    end

    local meta_id = read_dword(object)
    local weight_to_add = weight[meta_id]
    if (not weight_to_add) then
        return 0
    end

    return weight_to_add
end

local function getSpeed(player)

    local speed = 1
    local dyn = get_dynamic_player(player)
    if (dyn == 0 or not player_alive(player)) then
        return speed
    end

    local weapon_in_hand = read_dword(dyn + 0x118)
    if (not WeaponWeights.combined) then
        return getWeight(weapon_in_hand)
    end

    for i = 0,3 do
        local weapon = read_dword(dyn + 0x2F8 + i * 4)
        speed = speed - getWeight(weapon)
    end
    
    return (speed < 0 and 0 or speed)
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            execute_command('s ' .. i .. ' ' .. getSpeed(i))
        end
    end
end

function OnScriptUnload()
    -- N/A
end