--[[
--=====================================================================================================--
Script Name: Weighted Weapons with Stamina System, for SAPP (PC & CE)
Description: Your speed will be reduced based on the weight of your inventory.
An optional stamina system affects speed based on weight as well. Players will see a stamina bar showing their current stamina.

Copyright (c) 2022-2024, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

-- Table to store weapon weights and configuration
local WeaponWeights = {
    default_speed = 1.0,
    combined = false,
    stamina_enabled = true,
    max_stamina = 100,
    stamina_depletion_rate = 0.5, -- Decrease in stamina per tick
    stamina_regen_rate = 0.5, -- Stamina recovery per tick (adjusted)
    current_stamina = 100, -- Current stamina
    weapons = {
        ['weapons\\flag\\flag'] = 0.056,
        ['weapons\\ball\\ball'] = 0.056,
        ['weapons\\pistol\\pistol'] = 0.072,
        ['weapons\\plasma pistol\\plasma pistol'] = 0.072,
        ['weapons\\needler\\mp_needler'] = 0.084,
        ['weapons\\plasma rifle\\plasma rifle'] = 0.084,
        ['weapons\\shotgun\\shotgun'] = 0.094,
        ['weapons\\assault rifle\\assault rifle'] = 0.122,
        ['weapons\\flamethrower\\flamethrower'] = 0.140,
        ['weapons\\sniper rifle\\sniper rifle'] = 0.146,
        ['weapons\\plasma_cannon\\plasma_cannon'] = 0.190,
        ['weapons\\rocket launcher\\rocket launcher'] = 0.200
    }
}

-- Table to store weapon weights
local weight = {}

-- Function called when the script is loaded
function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
end

-- Function to get the tag ID of a weapon
local function getTag(class, name)
    local tag = lookup_tag(class, name)
    return (tag ~= 0 and read_dword(tag + 0xC)) or nil
end

-- Function to map weapon tags to their respective weights
local function tagsToID(t)
    for name, speed in pairs(t) do
        local tag = getTag('weap', name)
        if tag then
            weight[tag] = speed
        end
    end
end

-- Function called when the game starts
function OnStart()
    if get_var(0, '$gt') ~= 'n/a' then
        weight = {}
        tagsToID(WeaponWeights.weapons)
    end
end

-- Function to get the weight of a weapon
local function getWeight(weapon)
    local object = get_object_memory(weapon)
    if object == 0 or weapon == 0xFFFFFFFFF then
        return 0
    end
    return weight[read_dword(object)] or 0
end

-- Function to get the speed of a player
local function getSpeed(player)
    local dyn = get_dynamic_player(player)
    if dyn == 0 or not player_alive(player) then
        return WeaponWeights.default_speed
    end

    local speed = WeaponWeights.default_speed
    -- If combined is false, only use the weapon in the player's hand
    if not WeaponWeights.combined then
        speed = speed - getWeight(read_dword(dyn + 0x118))
    else
        -- Use all weapons in the player's inventory
        for i = 0, 3 do
            speed = speed - getWeight(read_dword(dyn + 0x2F8 + i * 4))
        end
    end

    -- Apply stamina effects if enabled
    if WeaponWeights.stamina_enabled and WeaponWeights.current_stamina <= 0 then
        return math.max(speed - 0.2, 0) -- Reduced speed when out of stamina
    end

    return math.max(speed, 0)
end

-- Function to display stamina bar
local function displayStaminaBar(player)
    local stamina_percentage = (WeaponWeights.current_stamina / WeaponWeights.max_stamina) * 100
    local bar_length = 20 -- Length of the stamina bar
    local filled_length = math.floor(bar_length * (stamina_percentage / 100))
    local empty_length = bar_length - filled_length

    for _ = 1, 25 do
        rprint(player, " ")
    end

    -- Create the stamina bar display
    local stamina_bar = "|" .. string.rep("=", filled_length) .. string.rep(" ", empty_length) .. "| " .. math.floor(stamina_percentage) .. "%"
    rprint(player, "Stamina: " .. stamina_bar) -- Print the stamina bar for the player
end

-- Function called on each tick event
function OnTick()
    for i = 1, 16 do
        local dyn = get_dynamic_player(i)
        if player_present(i) and player_alive(i) and dyn ~= 0 then
            local speed = getSpeed(i)
            execute_command('s ' .. i .. ' ' .. speed)

            -- Update stamina
            if WeaponWeights.stamina_enabled then
                WeaponWeights.current_stamina = math.max(0, WeaponWeights.current_stamina - WeaponWeights.stamina_depletion_rate)
                displayStaminaBar(i) -- Display stamina bar for the player
            end
        end
    end

    -- Regenerate stamina
    if WeaponWeights.stamina_enabled then
        WeaponWeights.current_stamina = math.min(WeaponWeights.max_stamina, WeaponWeights.current_stamina + WeaponWeights.stamina_regen_rate)
    end
end

-- Function called when the script is unloaded
function OnScriptUnload()
    -- N/A
end