local function GetTagName(TAG)
    if (TAG ~= nil and TAG ~= 0) then
        return read_string(read_dword(read_word(TAG) * 32 + 0x40440038))
    end
    return nil
end


-- CHECKING FOR SPECIFIC IN-HAND --
-- Make a call to InHand() and pass Player Index [int] and Weapon Tag Name [string] as function arguments.
--
-- It's probably better practise to check if the weapon id doesn't evaluate to 0 in the same function, 
-- but since I do this in GetTagName(), we skip this step.
--
function InHand(Ply, TAG)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        local WeaponID = read_dword(DyN + 0x118)
        local CurrentWeapon = GetTagName(WeaponID)
        if (CurrentWeapon == TAG) then
            return true
        end
    end
    return false
end

-- CHECKING FOR SPECIFIC IN-BACKPACK (checks entire inventory) --
-- Make a call to GetBackpackWeapon() and pass Player Index [int] and Weapon Tag Name [string] as function arguments.
function GetBackpackWeapon(Ply, TAG)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        for i = 0, 3 do
            local weapon_id = read_dword(DyN + 0x2F8 + (i * 4))
            if (weapon_id ~= 0xFFFFFFFFF) then -- returns 0xFFFFFFFFF if the slot is unused
                local weapon_object = get_object_memory(weapon_id)
                local weapon = GetObjectName(weapon_object)
                if (weapon == TAG) then
                    return true
                end
            end
        end
    end
    return false
end
