-- Invisibility On Crouch

invisibility_time = 10	-- | Time in seconds for duration of invisibility / active-camouflage
crouch = {}

function GetRequiredVersion() return 200 end
function OnScriptLoad(process, game, persistent) end

function OnPlayerCrouch(player)
local name = getname(player) -- Retrieves Player Name
	if getplayer(player) then
		local m_objectId = getplayerobjectid(player)
		if m_objectId then
			if readdword(getobject(m_objectId) + 0x204) ~= 0x51 then
				applycamo(player, invisibility_time)
				--hprintf("**C A M O U F L A G E** " ..tostring(name) .. " has gone invisible for " ..invisibility_time.. " seconds")
			end
		end
	end	
end

function OnClientUpdate(player)
	if getplayer(player) then
		local m_objectId = getplayerobjectid(player)
		if m_objectId then
			local obj_crouch = readbyte(getobject(m_objectId) + 0x2A0)
			local id = resolveplayer(player) -- Retrieves Player ID	
			if obj_crouch == 3 and crouch[id] == nil then
				crouch[id] = OnPlayerCrouch(player) 
			elseif obj_crouch ~= 3 and crouch[id] ~= nil then 
				crouch[id] = nil 
			end
		end
	end	
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------