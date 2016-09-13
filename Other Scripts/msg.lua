--------------------------------------------------------------------
function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnScriptUnload() end
--------------------------------------------------------------------
OPJM1_Message = "Map Name: Wizard"
OPJM2_Message = "Map Name: Bloodgulch"

function OnNewGame(Mapname)
	map_name = Mapname
		if map_name == "wizard" then
privatesay(player, OPJM1_Message)
hprintf(OPJM1_Message)
		end
end	