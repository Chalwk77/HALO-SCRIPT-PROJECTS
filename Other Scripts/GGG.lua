team_play = false

function GetRequiredVersion() return 200 end
function OnScriptLoad(process, game, persistent)
	if game == true or game == "PC" then
		GAME = "PC"
		gametype_base = 0x671340
	else
		GAME = "CE"
		gametype_base = 0x5F5498
	end
	Team_Play = readbyte(gametype_base + 0x34)	
    if Team_Play == 1 then
		team_play = true
	else
		team_play = false
	end
end

function OnNewGame(map)
	if GAME == "PC" then
		gametype_base = 0x671340
	elseif GAME == "CE" then
		gametype_base = 0x5F5498
	end
	Team_Play = readbyte(gametype_base + 0x34) 	
    if Team_Play == 1 then
		team_play = true
	else
		team_play = false
	end
end

function OnPlayerSpawn(player, m_objectId)
	if getobject(m_objectId) then
		registertimer(50, "AssignWeapon", player)
	end
end

function AssignWeapon(id, count, player)
	if getplayerobjectid(player) then 
		local m_objectId = getplayerobjectid(player)
		local m_object = getobject(m_objectId)
		for i = 0,3 do
			local weapID = readdword(getobject(m_objectId), 0x2F8 + i*4)
			if weapID ~= 0xFFFFFFFF then
				destroyobject(weapID) 
			end
		end
		local PIST = "weapons\\pistol\\pistol"
		local SNIPE = "weapons\\sniper rifle\\sniper rifle"
		local tag = gettagid("weap", PIST)
		local tag_2 = gettagid("weap", SNIPE)
		local pistol = createobject(tag, 0, 30, false, 0, 0, 0)
		local sniper = createobject(tag_2, 0, 30, false, 0, 0, 0)
		local m_weapon = getobject(pistol)	
		local m_weapon = getobject(sniper)	
		assignweapon(player, pistol)
		assignweapon(player, sniper)
	end
end