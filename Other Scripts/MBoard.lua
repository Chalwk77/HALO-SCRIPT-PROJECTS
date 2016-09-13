---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[    
Document Name: Multiple Scripts
Version : 1.00
Creator(s): {ØZ}Çhälwk'
Xfire : Chalwk77
Website(s): www.joinoz.proboards.com AND www.phasor.proboards.com
* * E C S M * *
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
															M E S S A G E   B O A R D   O N E
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]--
local timestamp = os.date ("%H:%M:%S:") -- Format: Hours, Minutes, Seconds.
First_Auto_Message = "* * S T A T S * *  |  Type @stats to display your stats."
Second_Auto_Message = "* * E C S M * *  |  He who holds the highest stats will take the lead to victory."
Third_Auto_Message = "* * E C S M * *  |  Next Tournament: (4v4 Rush-Live) on 2 / 06 / 2014  @ 5:00 PM (NZST)"
Fourth_Auto_Message = "* * S T A T S * *  |  Type @stats to display your stats."
Fifth_Auto_Message = "* * PLAYER COMMANDS * *   |  Type @commands to get a list of Player Commands you can use!"
Sixth_Auto_Message = "* * HYPER SPACE * *  |  You can Hyper-Jump by pressing your Flashlight button (q) or (f). But use them wisely. You ony have 5 Hyper-Jumps per life!"
Seventh_Auto_Message = "* * R A N K S * *  |  Type @rank to view your current rank."
Eighth_Auto_Message = "* * M E D A L S * *  |  Type @medals to view your current medals."
Ninth_Auto_Message = "* * E C S M * *  |  Type @weapons to view how many kills you have, (to date), with a particular type of weapon."
Tenth_Auto_Message = "* * E C S M * *  |  Type @sprees to view your sprees."
Eleventh_Auto_Message = "* * C R E D I T S * *  |  You can earn Credits (cR) for capturing flags / killing your opponents.\nThe more you have, the more likely you are to be promoted to the next rank!"
Twelfth_Auto_Message = "* * C R E D I T S * *  |  You can earn rewards for accumulating credits / You must be a Private (PVT) by rank before you can start earning rewards.\nSo get those points!"
Thirteenth_Auto_Message = "* * E C S M * *  |  Next Tournament: (3v3 SnD) on 05 / 07 / 2014  @ 8pm (NZST)"
-- Timed Messages displayed every X seconds.
First_Timer = 160
Second_Timer = 190
Third_Timer = 120
Fourth_Timer = 250
Fifth_Timer = 280
Sixth_Timer = 310
Seventh_Timer = 340
Eighth_Timer = 370
Ninth_Timer = 400
Tenth_Timer = 430
Eleventh_Timer = 460
Thirteenth_Timer = 490
---------------------------------------------------------------------------
function GetRequiredVersion() return 200 end 			-- Do not touch. --
function OnScriptLoad(processid, game, persistent) end  -- Do not touch. --
function OnScriptUnload() end                           -- Do not touch. --
---------------------------------------------------------------------------
function OnNewGame(map)
	AutoMessage_Timer = registertimer(First_Timer*1000,"Auto_Message_One") 			-- For Message One
	AutoMessage_Timer = registertimer(Second_Timer*1000, "Auto_Message_Two") 		-- For Message Two
	AutoMessage_Timer = registertimer(Third_Timer*1000, "Auto_Message_Three")   	-- For Message Three
	AutoMessage_Timer = registertimer(Fourth_Timer*1000, "Auto_Message_Four")   	-- For Message Four
	AutoMessage_Timer = registertimer(Fifth_Timer*1000, "Auto_Message_Five")    	-- For Message Five
	AutoMessage_Timer = registertimer(Sixth_Timer*1000, "Auto_Message_Six")    		-- For Message Six
	AutoMessage_Timer = registertimer(Seventh_Timer*1000, "Auto_Message_Seven") 	-- For Message Seven
	AutoMessage_Timer = registertimer(Eighth_Timer*1000, "Auto_Message_Eight")  	-- For Message Eight
	AutoMessage_Timer = registertimer(Ninth_Timer*1000, "Auto_Message_Nine")    	-- For Message Nine
	AutoMessage_Timer = registertimer(Tenth_Timer*1000, "Auto_Message_Ten")    		-- For Message Ten
	AutoMessage_Timer = registertimer(Eleventh_Timer*1000, "Auto_Message_Eleven")  	-- For Message Eleven
	AutoMessage_Timer = registertimer(Thirteenth_Timer*1000, "Auto_Message_Thirteen") -- For Message Twelve
	hprintf(tostring(getprofilepath())) -- Do not touch.
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
																		-- MESSAGE FUNCTIONS BELOW -- 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Auto_Message_One(id, count) -- MESSAGE ONE
	say(First_Auto_Message, false) -- False to disable " **SERVER** " at the beginning of the message.
	hprintf("* * S T A T S * *  |  Type @stats to display your stats")
	return 1 -- Do not touch 'return'.
end
-------------------------------------------------------
function Auto_Message_Two(id, count) -- MESSAGE TWO
	say(Second_Auto_Message, false) -- False to disable " **SERVER** " at the beginning of the message.
	hprintf("* * E C S M * *  |  He who holds the highest stats will take the lead to victory")
	return 1 -- Do not touch 'return'.
end	
-------------------------------------------------------
function Auto_Message_Three(id, count) -- MESSAGE THREE
	say(Third_Auto_Message, false) -- False to disable " **SERVER** " at the beginning of the message.
	hprintf("**HALO UPDATE** Hooray! There is now a new update for Halo PC. (version 1.10).\nUpdate your game clients so you can continue to play when gamespy shutsdown.")
	return 1 -- Do not touch 'return'.
end	
-----------------------------------------------------
function Auto_Message_Four(id, count) -- MESSAGE FOUR
	say(Fourth_Auto_Message, false) -- False to disable " **SERVER** " at the beginning of the message.
	hprintf("* * S T A T S * *  |  Type @stats to display your stats")
	return 1 -- Do not touch 'return'.
end	
-----------------------------------------------------
function Auto_Message_Five(id, count) -- MESSAGE FIVE
	say(Fifth_Auto_Message, false) -- False to disable " **SERVER** " at the beginning of the message.
	hprintf("* * E C S M * *  |  Type @commands to get a list of Player Commands you can use!")
	return 1 -- Do not touch 'return'.
end	

function Auto_Message_Six(id, count) -- MESSAGE SIX
	say(Sixth_Auto_Message, false) -- False to disable " **SERVER** " at the beginning of the message.
	hprintf("* * HYPER SPACE * *  |  You can Hyper-Jump by pressing your Flashlight button (q) or (f). But use them wisely. You ony have 5 Hyper-Jumps per life")
	return 1 -- Do not touch 'return'.
end	

function Auto_Message_Seven(id, count) -- MESSAGE SEVEN
	say(Seventh_Auto_Message, false) -- False to disable " **SERVER** " at the beginning of the message.
	hprintf("* * R A N K S * *  |  Type @rank to view your current rank")
	return 1 -- Do not touch 'return'.
end	

function Auto_Message_Eight(id, count)  -- MESSAGE EIGHT
	say(Eighth_Auto_Message, false) -- False to disable " **SERVER** " at the beginning of the message.
	hprintf("* * E C S M * *  |  Type @medals to view your current medals")
	return 1 -- Do not touch 'return'.
end	

function Auto_Message_Nine(id, count)  -- MESSAGE NINE
	say(Ninth_Auto_Message, false) -- False to disable " **SERVER** " at the beginning of the message.
	hprintf("* * E C S M * *  |  Type @weapons to view how many kills you have (to date) with a particular type of weapon")
	return 1 -- Do not touch 'return'.
end	

function Auto_Message_Ten(id, count)  -- MESSAGE TEN
	say(Tenth_Auto_Message, false) -- False to disable " **SERVER** " at the beginning of the message.
	hprintf("* * E C S M * *  |  Type @sprees to view your sprees")
	return 1 -- Do not touch 'return'.
end	

function Auto_Message_Eleven(id, count)  -- MESSAGE ELEVEN
	say(Eleventh_Auto_Message, false) -- False to disable " **SERVER** " at the beginning of the message.
	hprintf("* * C R E D I T S * *  |  You can earn Credits (cR) for capturing flags / killing your opponents. The more you have, the more likely you are to be promoted to the next rank")
	return 1 -- Do not touch 'return'.
end	

function Auto_Message_Thirteen(id, count)  -- MESSAGE THIRTEEN
	say(Thirteenth_Auto_Message, false) -- False to disable " **SERVER** " at the beginning of the message.
	hprintf("**HALO UPDATE** Hooray! There is now a new update for Halo PC. (version 1.10).\nUpdate your game clients so you can continue to play when gamespy shutsdown.")
	return 1 -- Do not touch 'return'.
end	
-----------------------------------------------------------
function OnGameEnd(stage)            	-- Do not touch. --
	removetimer(AutoMessage_Timer)  	-- Do not touch. --
end                                  	-- Do not touch. --
-----------------------------------------------------------

--[[--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
							Player Spawn Time, Player Running Speed , OnPlayerJoin Message, Message Board Two.
]]--
Respawn_Time = 0 -- In seconds - (one 'point' five seconds.)
Player_Running_Speed = 1.45 -- Base speed: 1 (one). Note: Any values above 2.5 (two 'point' five) will cause lag. 
OPJM1_Message = "* * E C S M * *  |  Welcome to the {ØZ}-12 Elite Combat Server | Hosted by the (ØZ) - Clan  |  www.joinoz.proboards.com"
OPJM2_Message = "* * E C S M * *  |  Next Tournament: (3v3 SnD) on 05 / 07 / 2014  @ 8pm (NZST)"
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function OnPlayerJoin(player)			
		hprintf("Player Running Speed: " ..Player_Running_Speed)		--												--
 -- local timestamp = os.date ("%H:%M:%S: %d/%m/%Y")					--												--
 -- privatesay(player, "Today's Date and Time: "..timestamp, false)		--		  ------------------------------		--
		privatesay(player, OPJM1_Message, false) 						--												--
		privatesay(player, OPJM2_Message, false)						--		  :		MESSAGE BOARD TWO       :		--	
	registertimer(1000, "Message_Board_Two", player)					--												--
end                                             						--		  ------------------------------		--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
function Message_Board_Two(id, count, player)
	if getplayer(player) == nil then return false end
	if count == (15) then -- (Display message after 'ten' seconds.)
				privatesay(player, "* * I N F O R M A T I O N * * (ØZ) Clan Public Site - www.joinoz.tk  |  Want to Join the ØZ Clan?  |  Want to Appeal a Ban?  |  Contact us!", false)
						   hprintf("* * I N F O R M A T I O N * * (ØZ) Clan Public Site - www.joinoz.tk  |  Want to Join the ØZ Clan?  |  Want to Appeal a Ban?  |  Contact us!") 
elseif count == (25) -- (Display message after 'fifteen' seconds.)
		   then privatesay(player, "* * E C S M * * | {" .. tostring(player) .. "} Type '@commands' to see a list of player commands you can use!", false)
						   hprintf("**SERVER** to | {" .. tostring(player) .. "} Type '@commands' to see a list of player commands you can use!")
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------				
elseif count == (35) -- (Display message after 'twenty one' seconds.)
			then privatesay(player, "{".. tostring(player) .."} | Press your Flashlight Button to Hyper-Jump - but use them wisely!", false)
					hprintf("* * E C S M * * to |  {".. tostring(player) .."}, Press your Flashlight Button to Hyper-Jump - but use them wisely!")
elseif count == (50) 	-- (Display message after 'fifty' seconds.)
			then privatesay(player, "* * E C S M * * Under Heavy Development. Debugging in the process.", false)
					hprintf("**SERVER** to |  {" .. tostring(player) .. "} **SERVER** Under Heavy Development. Debugging in the process.")
--[[elseif count == 23 	-- (Display message after 'twenty three' seconds.)
			then privatesay(player, "", false)
					hprintf("**SERVER** to |  {" .. tostring(player) .. "} ") -- Inactive / sends to the server console.
elseif count == 24  -- (Display message after 'twenty four' seconds.)
			then privatesay(player, "", false)
					hprintf("**SERVER** to |  {" .. tostring(player) .. "} ") -- Inactive / sends to the server console.
elseif count == 25  -- (Display message after 'twenty five' seconds.)
			then privatesay(player, "", false)
					hprintf("**SERVER** to |  {" .. tostring(player) .. "} ") -- Inactive / sends to the server console.	
elseif count == 28  -- (Display message after 'twenty eight' seconds.)
			then privatesay(player, "", false)
					hprintf("**SERVER** to |  {" .. tostring(player) .. "} ") -- Inactive / sends to the server console.
elseif count == 30  -- (Display message after 'thirty seconds' seconds.)
			then privatesay(player, "", false)
					hprintf("**SERVER** to |  {" .. tostring(player) .. "} ") -- Inactive / sends to the server console.		
elseif count == 31  -- (Display message after 'thirty one' seconds.)
			then privatesay(player, "", false)
					hprintf("**SERVER** to |  {" .. tostring(player) .. "} ") -- Inactive / sends to the server console.
elseif count == 33  -- (Display message after 'thirty three' seconds.)
			then privatesay(player, "", false)
					hprintf("**SERVER** to |  {" .. tostring(player) .. "} ") -- Inactive / sends to the server console.						
elseif count == 35  -- (Display message after 'thirty five' seconds.)
			then privatesay(player, "", false)
					hprintf("**SERVER** to |  {" .. tostring(player) .. "} ") -- Inactive / sends to the server console.
]]
			return false -- Ends the loop for the joining player
		end
	return true -- keeps the counter going and restarts when the next player joins
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function OnPlayerSpawnEnd(player, m_objectId)												--
	if getplayer(player) then 																--
		setspeed(player, Player_Running_Speed)												--
	end																						--
end																							--
----------------------------------------------------------------------------------------------
function OnPlayerKill(killer, victim, mode)													--
	if victim then																			--
		if Respawn_Time then																--
			writedword(getplayer(victim) + 0x2c, Respawn_Time * 33)							--
		end																					--
	end																						--
end																							--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FILE - CLOSE.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------