api_version = "1.11.0.0"

function OnScriptLoad()
	register_callback(cb['EVENT_WEAPON_PICKUP'], "OnWeaponPickup")
end

function OnScriptUnload()

end

function OnWeaponPickup(PlayerIndex, WeaponIndex, Type)
	if tonumber(Type) == 1 then
		local PlayerObj = get_dynamic_player(PlayerIndex)
		local WeaponObj = get_object_memory(read_dword(PlayerObj + 0x2F8 + (tonumber(WeaponIndex) - 1) * 4))
		local name = read_string(read_dword(read_word(WeaponObj) * 32 + 0x40440038))
		local MetaIndex = read_dword(WeaponObj)
		local str = string.format("Picked up a %s, MetaIndex: 0x%X Slot: %u", name, MetaIndex, WeaponIndex)
		rprint(PlayerIndex, "Picked up: " .. str)
		cprint(str)
	end
end
