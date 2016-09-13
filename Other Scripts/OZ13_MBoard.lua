-- OZ 4 Snipers Dream Team Mod

---------------------------------------------------------------------------
function GetRequiredVersion() return 200 end 			-- Do not touch. --
function OnScriptLoad(processid, game, persistent) end  -- Do not touch. --
function OnScriptUnload() end                           -- Do not touch. --
---------------------------------------------------------------------------
OPJM1_Message = "Welcome to {OZ}-13 Death Race | Hosted by the (ØZ) - Clan"
OPJM2_Message = "{OZ} Public Site - www.joinoz.tk <|> Want to Join {OZ}? <|> Appeal a Ban? <|> Have any questions? <|> Contact Us!"

function OnPlayerJoin(player)
	privatesay(player, OPJM1_Message, false)
	privatesay(player, OPJM2_Message, false)
end

