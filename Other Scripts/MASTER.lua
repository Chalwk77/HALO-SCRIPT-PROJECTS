--[[
Document Name: {ØZ}-12 Elite Combat Server / Master Script.


# # INDEX

SCRIPT (1): Weapon Spawns / Line 13
SCRIPT (2): Death Messages / Line 3
]]--


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SCRIPT (1) - Weapon Spawns
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
weapons = {}
weapons[1] = {"weapons\\plasma_cannon\\plasma_cannon", 96.551, -156.756, 1.704} -- Bloodgulch, Red-base.
weapons[2] = {"weapons\\plasma_cannon\\plasma_cannon", 97.567, -158.154, 1.704} -- Bloodgulch, Red-Base.
math.inf = 1 / 0
--------------------------------------------------------------------
function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnScriptUnload() end
--------------------------------------------------------------------
function OnNewGame(map)
	for k,v in pairs(weapons) do
		local tag_id = gettagid("weap", v[1]) -- Get map id of tagname.
		v[1] = tag_id
		v[5] = createobject(tag_id, 0, math.inf, false, v[2],v[3],v[4])
		if getobject(v[5]) == nil then
			hprintf("E R R O R. Weapon failed.. Number: " .. k)
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SCRIPT (2) - Death Messages
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[ 
Document Name: Death Messages
Edited by {ØZ}Çhälwk' for {OZ}-12 Elite Combat Server - OZ Clan
Xfire : Chalwk77
Website(s): www.joinoz.proboards.com AND www.phasor.proboards.com
Gaming Clan: {ØZ} Elite SDTM Clan - on HALO PC.
Server Name: {OZ}-12 Elite Combat Server - OZ Clan
Public IP: 121.73.101.37
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
																D E A T H    M E S S A G E S    S C R I P T
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]	
last_damage = {}
team_change = {} 
-----------------------------------------------------------------

function GetRequiredVersion() return 200 end
function OnScriptLoad(process, game, persistent) --loadtags()
	for i=0,15 do
		if getplayer(i) then
			team_change[i] = false
		end	
	end
	last_damage = {}
	team_change = {}	
end

function OnNewGame(map) --loadtags()
	for i=0,15 do
		if getplayer(i) then
			team_change[i] = false
		end	
	end
	last_damage = {}
	team_change = {}
--[[ Vehicles
banshee_tag_id = gettagid("vehi", "vehicles\\banshee\\banshee_mp")
turret_tag_id = gettagid("vehi", "vehicles\\c gun turret\\c gun turret_mp")
ghost_tag_id = gettagid("vehi", "vehicles\\ghost\\ghost_mp")
rwarthog_tag_id = gettagid("vehi", "vehicles\\rwarthog\\rwarthog")
scorpion_tag_id = gettagid("vehi", "vehicles\\scorpion\\scorpion_mp")
warthog_tag_id = gettagid("vehi", "vehicles\\warthog\\mp_warthog")
]]
end	

function OnGameEnd(stage)
	if stage == 1 then
		if announce then 
			removetimer(announce)
			announce = nil
		end
	end
end	

function OnPlayerJoin(player)
	if getplayer(player) then
		team_change[player] = false
	end	
end
--[[---------------------------------------------------------------------------
function OnDamageApplication(receiving, causing, tagid, hit, backtap)
        if receiving then
                local r_object = getobject(receiving)
                if r_object then
                        local receiver = objectaddrtoplayer(r_object)
                        if receiver then
                            local r_hash = gethash(receiver)
                            local tagname,tagtype = gettaginfo(tagid)
                            last_damage[r_hash] = tagname
say(tostring(tagname))
                        end
                end
        end
end
----------------------------------------------------------------------------]]
function OnDamageApplication(receiving, causing, tagid, hit, backtap)
	if receiving then
		local r_object = getobject(receiving)
		if r_object then
			local receiver = objectaddrtoplayer(r_object)
			if receiver then
				local r_hash = gethash(receiver)
				local tagname,tagtype = gettaginfo(tagid)
				last_damage[r_hash] = tagname
			end
		end
	end
end

function OnPlayerSpawnEnd(player, m_objectId)
	if getplayer(player) then
		local hash = gethash(player)
		last_damage[hash] = nil
		team_change[player] = false
	end	
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Death Messages Begin Here.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function OnPlayerKill(killer, victim, mode, m_player)

	local response = false		
	if mode == 0 then -- (Player x) was killed by the server.
		response = false
		
	local killedmsg = generatekilltype(killslang)
	if getplayer(victim) then
		say("**DEATH EATER** " .. getname(victim) .. " was killed by a mysterious force", false) -- On " sv_kill or \kill "
		hprintf(" >>  D  E  A  T  H  <<  | " ..getname(victim) .. " was killed by a mysterious force")
		end
	elseif mode == 1 then -- (Player x) was killed by falling or team-change.
		response = false
		
		if getplayer(victim) then
			local vhash = gethash(victim)
			if not team_change[victim] then
				response = false
				if last_damage[vhash] == "globals\\distance" or last_damage[vhash] == "globals\\falling" then -- Falling
					say("** D E A T H ** "..getname(victim) .. " fell and perished!", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(victim) .. " fell and perished!")
				end	
			else
				response = false
				say(getname(victim) .. " has changed teams!", false) -- (Player x) changed teams.
				hprintf(" >> T E A M  C H A N G E << | " ..getname(victim) .. " has changed teams!")
				team_change[victim] = false		
			end	
		end	
		
	elseif mode == 2 then -- (Player x) was killed by a mysterious force.
		response = false
		
		if getplayer(victim) then
			say("** D E A T H ** "..getname(victim) .. " was killed by a mysterious force... ", false)
			hprintf(" >>  D  E  A  T  H  <<  | " ..getname(victim) .. " was killed by a mysterious force...")
		end	
		
	elseif mode == 3 then -- (Player x) was killed by vehicle.
		response = false
		
		if getplayer(victim) then
			local vhash = gethash(victim)
	--[[if mapid == tank_mapId then
		vehicle_name = "Scorpion Tank"
	elseif mapid ==	turret_mapId then 
		vehicle_name = "Covenant Turret"
	elseif mapid == banshee_mapId then 
		vehicle_name = "Banshee"
	elseif mapid ==	hog_mapId then
		vehicle_name = "Warthog"
	elseif mapid == rhog_mapId then
		vehicle_name = "Rocket Hog"
	elseif mapid == ghost_mapId then
		vehicle_name = "Ghost"]]
			---------------------------------------------------------------------------------------------------
			say("** D E A T H ** " ..getname(victim) .. " was mysteriously squashed by a vehicle", false)
			hprintf(" >>  D  E  A  T  H  <<  | " ..getname(victim) .. " was mysteriously squashed by a vehicle.")
			--say("** D E A T H ** " ..getname(victim) .. " was mysteriously squashed by a " .. tostring(vehicle_name) ..".")
		end	
		
	elseif mode == 4 then -- (Player x) was killed by another player, killer is not always valid, victim is always valid.
		response = false
		local killedmsg = generatekilltype(killslang)
		if getplayer(victim) then
			local vhash = gethash(victim)
			if last_damage[vhash] then
				if getplayer(killer) ~= nil then
					if string.find(last_damage[vhash], "melee") then -- Weapon Meele		
						say("** D E A T H ** "..getname(killer) .. " " .. generatehitslang(hit) .. " " .. getname(victim) .. " in the " .. generateheadslang(head) .. "!", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. generatehitslang(hit) .. " " .. getname(victim) .. " in the " .. generateheadslang(head) .."!")
elseif last_damage[vhash] == "globals\\distance" or last_damage[vhash] == "globals\\falling" then
						say("** D E A T H ** "..getname(victim) .. " fell and perished! ", false) -- Falling
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(victim) .. " fell and perished!")
					
elseif last_damage[vhash] == "globals\\vehicle_collision" then -- On Vehicle Collision
						say("** D E A T H ** "..getname(killer) .. " ran over " .. getname(victim), false) -- Run Over
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " ran over " .. getname(victim))

elseif string.find(last_damage[vhash], "banshee") then -- Banshee (General)
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a banshee. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a banshee.")

elseif last_damage[vhash] == "vehicles\\banshee\\mp_fuel rod explosion" then -- Fuel Rod Explosion / Banshee
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a Banshee's Fuel Rod. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a Banshee's Fuel Rod.")

elseif last_damage[vhash] == "vehicles\\banshee\\banshee bolt" then	-- Banshee Bolt
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a Banshee's Plasma Guns. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a Banshee's Plasma Guns.")

elseif last_damage[vhash] == "vehicles\\c gun turret\\mp bolt" then -- Turret Bolt
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with the covenant turret. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with the covenant turret.")

elseif last_damage[vhash] == "vehicles\\ghost\\ghost bolt" then -- Ghost Bolt
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with the ghost plasma guns. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with the ghost plasma guns.")

elseif last_damage[vhash] == "vehicles\\scorpion\\bullet" then -- Scorpion Tank Bullet
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with the scorpion guns. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with the scorpion guns.")

elseif last_damage[vhash] == "vehicles\\scorpion\\shell explosion" then -- Scorpion tank Shell Explosion
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with the scorpion cannon. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with the scorpion cannon.")

elseif last_damage[vhash] == "vehicles\\warthog\\bullet" then -- Warthog chain-gun bullet
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a warthog chain-gun. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a warthog chain-gun.")

elseif last_damage[vhash] == "weapons\\assault rifle\\bullet" then -- Assault Rifle Bullet
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with an assault rifle. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with an assault rifle.")

elseif last_damage[vhash] == "weapons\\flamethrower\\burning" or last_damage[vhash] == "weapons\\flamethrower\\explosion" or last_damage[vhash] == "weapons\\flamethrower\\impact damage" then
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a flame-thrower. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a flame-thrower.")

elseif last_damage[vhash] == "weapons\\frag grenade\\explosion" then -- Frag Grenade Explosion
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a frag grenade! ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a frag grenade!")

elseif last_damage[vhash] == "weapons\\needler\\detonation damage" or last_damage[vhash] == "weapons\\needler\\explosion" or last_damage[vhash] == "weapons\\needler\\impact damage" then
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a needler. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a needler.")

elseif last_damage[vhash] == "weapons\\pistol\\bullet" then -- Pistol Bullet
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a pistol. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a pistol.")

elseif last_damage[vhash] == "weapons\\plasma grenade\\attached" or last_damage[vhash] == "weapons\\plasma grenade\\explosion" then
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a plasma grenade. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a plasma grenade.")

elseif last_damage[vhash] == "weapons\\plasma pistol\\bolt" or last_damage[vhash] == "weapons\\plasma rifle\\charged bolt" then
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a plasma pistol. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a plasma pistol.")

elseif last_damage[vhash] == "weapons\\plasma rifle\\bolt" then -- Plasma Rifle Bolt
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a plasma rifle. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a plasma rifle.")

elseif last_damage[vhash] == "weapons\\plasma_cannon\\effects\\plasma_cannon_explosion" or last_damage[vhash] == "weapons\\plasma_cannon\\impact damage" then -- Plasma Cannon Explosion
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a fuel-rod gun. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a fuel-rod gun.")

elseif last_damage[vhash] == "weapons\\rocket launcher\\explosion" then -- Rocket Launcher Explosion
					if isinvehicle(killer) then -- Vehicle Weapon
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a warthog rocket. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a warthog rocket.")

					else
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a rocket launcher. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a rocket launcher.")

					end
elseif last_damage[vhash] == "weapons\\shotgun\\pellet" then -- Shotgun Pellet
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a shotgun. ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a shotgun.")

elseif last_damage[vhash] == "weapons\\sniper rifle\\sniper bullet" then -- Sniper Rifle
						say("** D E A T H ** "..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a sniper rifle! ", false)
					hprintf(" >>  D  E  A  T  H  <<  | " ..getname(killer) .. " " .. killedmsg .. " " .. getname(victim) .. " with a sniper rifle!")

					end
				end	
			end
		end	
	elseif mode == 5 then -- (Player x) was killed by teammate.
		response = true
		if getplayer(killer) then
			privatesay(killer, " Do not betray your Team mates!")
			hprintf(" >>  B E T R A Y  <<  | " ..killer, " has been warned for betraying team mates.")
		end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
													-- S U I C I D E S -- 
	elseif mode == 6 then
		response = false
		
		if getplayer(victim) then
			local vhash = gethash(victim)
			if last_damage[vhash] then	
				if last_damage[vhash] == "weapons\\frag grenade\\explosion" or last_damage[vhash] == "weapons\\plasma grenade\\attached" or last_damage[vhash] == "weapons\\plasma grenade\\explosion" then
					say(getname(victim) .. " failed to handle the grenade with care.", false) -- Frag Grenade.
					hprintf(">> S U I C I D E << | " ..getname(victim) .. " failed to handle the grenade with care.")
elseif last_damage[vhash] == "weapons\\plasma_cannon\\effects\\plasma_cannon_explosion" or last_damage[vhash] == "weapons\\plasma_cannon\\impact damage" then	
					say(getname(victim) .. " blew himself up with a fuel-rod.", false) -- Plasma Cannon.
					hprintf(">> S U I C I D E << | " ..getname(victim) .. " blew himself up with a fuel-rod.")
elseif last_damage[vhash] == "vehicles\\scorpion\\shell explosion" then	-- Scorpion Tank Shell Explosion
					say(getname(victim) .. " was too close to an object when he fire the tank-gun.", false) -- Plasma Cannon.
					hprintf(">> S U I C I D E << | " ..getname(victim) .. " was too close to an object when he fire the tank-gun.")
--[[elseif last_damage[vhash] == "weapons\\rocket launcher\\explosion" or last_damage[vhash] == "weapons\\rocket launcher\\rocket launcher" then
					say(getname(victim) .. " blew himself up with a Rocket Launcher.", false)
					hprintf(">> S U I C I D E << | " ..getname(victim) .. " blew himself up with a Rocket Launcher.")]]
					end
				end
			say("** R I P **  | "..getname(victim) .. " committed suicide.", false) -- General Suicide. 
			hprintf(" >> S U I C I D E <<  | " .. getname(victim) .. " committed suicide.")
		end	
	end
	return response
end	
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[function OnDamageLookup(receiver, causer, tagData, tagName)
	local cplayer = objecttoplayer(causer)
    local rplayer = objecttoplayer(receiver)
    if rplayer then
        local rhash = gethash(rplayer)
        last_damage[rhash] = tagName
    end
end]]
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function OnTeamChange(player, old_team, new_team, relevant)
	if getplayer(player) then
		team_change[player] = true
		end	
	return nil
end

function generatekilltype(killslang)
	local killcount = #killtype
	local rand_type = getrandomnumber(1, killcount+1)
	local kill_type = string.format("%s",  killtype[rand_type])
	if kill_type then
		return kill_type
	else
		return "killed"
	end
end	

function generateheadslang(head)
	local headcount = #headslang
	local rand_type = getrandomnumber(1, headcount+1)
	local head_type = string.format("%s",  headslang[rand_type])
	if head_type then
		return head_type
	else
		return "head"
	end
end	

function generatehitslang(hit)
	local hitcount = #hitslang
	local rand_type = getrandomnumber(1, hitcount+1)
	local hit_type = string.format("%s",  hitslang[rand_type])
	if hit_type then
		return hit_type
	else
		return "hit"
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Kill Type, Head Slang, and Hit Slang.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
killtype = {"destroyed", "fubared", "disemboweled", "violated", "eviscerated", "assassinated", "slaughtered", "exterminated", "murdered", "mutilated", 
"eradicated", "executed", "snuffed", "eliminated", "liquidated", "dominated", "castrated", "dirt-napped", "ghosted", "hosed", "smeared", "flatlined", "vaporized", "de-boned"}
headslang = {"mouth", "skull", "head", "brains", "noodle", "brain-pan", "cranium", "skull", "noggin"}
hitslang = {"smacked", "punched", "whacked", "clocked", "thumped", "slugged", "smashed", "cuffed", "walloped", "throttled", "pimp-slapped", "hammered", "bopped", "beat", "slapped"}
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------