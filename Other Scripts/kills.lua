--[[    
Document Name: On Player Kill 
                Version : 1.00
                Creator(s): {ØZ}Çhälwk'
                Xfire : Chalwk77
	Website(s): www.joinoz.proboards.com AND www.phasor.proboards.com
	Gaming Clan: {ØZ} Elite SDTM Clan - on HALO PC.
	Server Name: {OZ}-12 Elite Combat Server - OZ Clan
	Script Status: Completed.

	
		
	 To Do List:
]]--

---------------------------------------------------------------------------
function GetRequiredVersion() return 200 end 			-- Do not touch. --
function OnScriptLoad(processid, game, persistent) end  -- Do not touch. --
function OnScriptUnload() end                           -- Do not touch. --
---------------------------------------------------------------------------
order = {}
order.kills = 5
			
function OnPlayerKill(killer, victim, mode)
					
	if mode == 0 or mode == 1 or mode == 2 or mode == 3 or mode == 4 or mode == 5 or mode == 6 then
		local message = getmessage(killer, order.kills)
		local m_player = getplayer(victim)
		local kills = readword(m_player, 0x9C)
		if message then
		message:append("Kills: " .. kills, true)
			else
				sendconsoletext(killer, "Kills: " .. kills, 5, order.kills)
				end
			end
		end			

function isalive(player)
		local m_player = getplayer(player)
		if m_player then
			local objId = readdword(m_player, 0x34)
			local m_object = getobject(objId)
				if m_object then
			return true
					end
				end
					return false
			end