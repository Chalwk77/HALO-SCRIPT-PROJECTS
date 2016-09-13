--[[    
Document Name: Portal Messages - (for OZ-12 Bloodgulch map)
Version : 3.00
Creator(s): {ØZ}Çhälwk'
Xfire : Chalwk77
Website(s): www.joinoz.proboards.com  AND  www.phasor.proboards.com
Gaming Clan: {ØZ} Elite SDTM Clan - on HALO PC.
Script Status: NOT COMPLETED.
Percent complete: 75%
 
About:
When a player goes through any portal, the script will send the player a message, telling them the REGION of the map they just teleported to.
 
This script is used on Blood Gulch and eventually Infinite.
Players competing in future Tournaments held on OZ-12 in both the Blood Gulch and Infinite maps will find this feature useful. So we can properly call out / announce information on Team Speak, during Tournaments.
 
I will also include messages shown to a player as they stand infront of a portal, so they don't go through the wrong one. This script will only be run during Tournaments and Pre-Qualifier/practise matches.
]]
-------------------------------------------------------------------------------------------------------------------------------------


function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnNewGame(map) 
	mapname = map   	
end

function PortalSphere(m_objectId, x, y, z, radius)
	if m_objectId then
			local obj_x, obj_y, obj_z = getobjectcoords(m_objectId)
				local x_diff = x - obj_x
				local y_diff = y - obj_y
				local z_diff = z - obj_z
			local Distance_From_Center = math.sqrt(x_diff ^ 2 + y_diff ^ 2 + z_diff ^ 2)
		if Distance_From_Center <= radius then
			return true
		end
	end
	return false
end

function OnClientUpdate(player, count)
	local name = getname(player)
	if mapname == "bloodgulch" then
		local m_objectId = getplayerobjectid(player)
		local m_object = getobject(m_objectId)

-- COVE RED	

		if m_object ~= nil then
			local Teleport1 = PortalSphere(m_objectId, 80.732, -149.864, 1.224, 0.5) -- COVE RED
			if Teleport1 == true then
			 movobjectcoords(m_objectId, 89.859, -140.319, 96.467)
				privatesay(player, "* * S E C R E T  L O C A T I O N * *  |  The Cove (hideout).", false) -- Teleports to the RED COVE using the Portal on top of the Red Base
				hprintf("* * H I D E O U T * * |  "..tostring(name).. "  |  is in the hideout")
			end
		end
	end
end