----------------------------------------------------------------------------
-- Document Name: MAP NAME
-- Version : 3.00
-- Creator(s): {ØZ}Çhälwk'
-- Xfire : Chalwk77
-- Website(s): www.joinoz.proboards.com  AND  www.phasor.proboards.com
-- Gaming Clan: OZ-Clan, on Halo PC.
----------------------------------------------------------------------------
function OnScriptUnload() end
function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) 
		if GAME == "PC" then
                map_name = readstring(0x698F21)
        elseif GAME == "CE" then
                map_name = readstring(0x61D151)
		end		
end	

function OnNewGame(map)
	map_name = tostring(map)
	Countdown_To_GameStart = registertimer(800, "CountdownToGameStart") -- 700 to 800 milliseconds
        if GAME == "PC" then
                map_name = readstring(0x698F21)
        elseif GAME == "CE" then
                map_name = readstring(0x61D151)
		end

----------------------------------------------------------------------------------------------
--[[		<replace the map name with maps of your choice.>
Vaild Map Names:
(1) | - >  beavercreek
(2) | - > bloodgulch
(3) | - > chillout
(4) | - > damnation
(5) | - > dangercanyon
(6) | - > deathisland
(7) | - > gephyrophobia
(8) | - > hangemhigh
(9) | - > icefields
(10) | - > infinity
(11) | - > longest
(12) | - > prisoner
(13) | - > putput
(14) | - > ratrace
(15) | - > sidewinder
(16) | - > timberland
(17) | - > wizard
-------------------------------------------------------------------------------
Sendconsoletext Format: sendconsoletext(player, message, [time]) 
Where (0) is indicated = <int> Memory Id of a player. 0 is player (one), 1 is player (two), and 2 is player (three) and so on. 

Where (5) is indicated after (Get Ready!",) means that the message will be displayed for 5 second(s) - {edit this as you wish}.
(0 is player one), 1 is player two, and so on.
]]

if map_name == ("wizard") then map = ("(Wizard)") -- |  W I Z A R D
	sendconsoletext(0, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(1, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(2, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(3, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(4, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(5, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(6, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(7, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(8, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(9, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(10, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(11, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(12, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(13, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(14, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(15, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
		hprintf("DATA:  |  Match Loading on " ..map)
	end	
		
	if map_name == ("bloodgulch") then map = ("(Bloodgulch)") -- |  B L O O D G U L C H
	sendconsoletext(0, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(1, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(2, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(3, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(4, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(5, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(6, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(7, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(8, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(9, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(10, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(11, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(12, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(13, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(14, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(15, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
		hprintf("DATA:  |  Match Loading on " ..map)
	end
	
	if map_name == ("ratrace") then map = ("(Ratrace)") -- |  R A T R A C E
	sendconsoletext(0, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(1, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(2, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(3, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(4, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(5, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(6, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(7, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(8, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(9, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(10, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(11, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(12, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(13, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(14, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(15, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
		hprintf("DATA:  |  Match Loading on " ..map)
	end
	
	if map_name == ("hangemhigh") then map = ("(Hang 'Em High)") -- |  H A N G  'E M  H I G H
	sendconsoletext(0, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(1, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(2, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(3, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(4, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(5, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(6, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(7, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(8, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(9, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(10, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(11, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(12, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(13, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(14, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(15, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	hprintf("DATA:  |  Match Loading on " ..map)
	end
	
	if map_name == ("prisoner") then map = ("(Prisoner)") -- |  P R I S O N E R
	sendconsoletext(0, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(1, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(2, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(3, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(4, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(5, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(6, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(7, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(8, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(9, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(10, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(11, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(12, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(13, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(14, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
	sendconsoletext(15, "Votes are in! Match Loading on " ..map.. " | Get Ready!", 5)
		hprintf("DATA:  |  Match Loading on " ..map)
	end
end

function OnGameEnd(stage)
	if stage == (3) then
--[[
Sendconsoletext Format: sendconsoletext(player, message, [time]) 
Where (0) is indicated = <int> Memory Id of a player. 0 is player (one), 1 is player (two), and 2 is player (three) and so on. 

Where (3) is indicated after (Get Ready!",) means that the message will be displayed for 3 second(s) - {edit this as you wish}.
(0 is player one), 1 is player two, and so on.
]]
			sendconsoletext(0, "VOTING IS OPEN!", 3)
			sendconsoletext(1, "VOTING IS OPEN!", 3)
			sendconsoletext(2, "VOTING IS OPEN!", 3)
			sendconsoletext(3, "VOTING IS OPEN!", 3)
			sendconsoletext(4, "VOTING IS OPEN!", 3)
			sendconsoletext(5, "VOTING IS OPEN!", 3)
			sendconsoletext(6, "VOTING IS OPEN!", 3)
			sendconsoletext(7, "VOTING IS OPEN!", 3)
			sendconsoletext(8, "VOTING IS OPEN!", 3)
			sendconsoletext(9, "VOTING IS OPEN!", 3)
			sendconsoletext(10, "VOTING IS OPEN!", 3)
			sendconsoletext(11, "VOTING IS OPEN!", 3)
			sendconsoletext(12, "VOTING IS OPEN!", 3)
			sendconsoletext(13, "VOTING IS OPEN!", 3)
			sendconsoletext(14, "VOTING IS OPEN!", 3)
			sendconsoletext(15, "VOTING IS OPEN!", 3)
				hprintf("VOTING IS OPEN!")
	end
end	

console = {}
console.__index = console
registertimer(100, "ConsoleTimer")
phasor_sendconsoletext = sendconsoletext
math.inf = 1 / 0

function sendconsoletext(player, message, time, order, align, func)
	console[player] = console[player] or {}
	local temp = {}
	temp.player = player
	temp.id = nextid(player, order)
	temp.message = message or ""
	temp.time = time or 5
	temp.remain = temp.time
	temp.align = align or "left"
	
	if type(func) == "function" then
		temp.func = func
	elseif type(func) == "string" then
		temp.func = _G[func]
	end
	
	console[player][temp.id] = temp
	setmetatable(console[player][temp.id], console)
	return console[player][temp.id]
end

function nextid(player, order)

	if not order then
		local x = 0
		for k,v in pairs(console[player]) do
			if k > x + 1 then
				return x + 1
			end
			
			x = x + 1
		end
		
		return x + 1
	else
		local original = order
		while console[player][order] do
			order = order + 0.001
			if order == original + 0.999 then break end
		end
		
		return order
	end
end

function getmessage(player, order)

	if console[player] then
		if order then
			return console[player][order]
		end
	end
end

function getmessages(player)

	return console[player]
end

function getmessageblock(player, order)

	local temp = {}
	
	for k,v in opairs(console[player]) do
		if k >= order and k < order + 1 then
			table.insert(temp, console[player][k])
		end
	end
	
	return temp
end

function console:getmessage()

	return self.message
end

function console:append(message, reset)

	if console[self.player] then
		if console[self.player][self.id] then
			if getplayer(self.player) then
				if reset then
					if reset == true then
						console[self.player][self.id].remain = console[self.player][self.id].time
					elseif tonumber(reset) then
						console[self.player][self.id].time = tonumber(reset)
						console[self.player][self.id].remain = tonumber(reset)
					end
				end
				
				console[self.player][self.id].message = message or ""
				return true
			end
		end
	end
end

function console:shift(order)

	local temp = console[self.player][self.id]
	console[self.player][self.id] = console[self.player][order]
	console[self.player][order] = temp
end

function console:pause(time)

	console[self.player][self.id].pausetime = time or 5
end

function console:delete()

	console[self.player][self.id] = nil
end

function ConsoleTimer(id, count)

	for i,_ in opairs(console) do
		if tonumber(i) then
			if getplayer(i) then
				for k,v in opairs(console[i]) do
					if console[i][k].pausetime then
						console[i][k].pausetime = console[i][k].pausetime - 0.1
						if console[i][k].pausetime <= 0 then
							console[i][k].pausetime = nil
						end
					else
						if console[i][k].func then
							if not console[i][k].func(i) then
								console[i][k] = nil
							end
						end
						
						if console[i][k] then
							console[i][k].remain = console[i][k].remain - 0.1
							if console[i][k].remain <= 0 then
								console[i][k] = nil
							end
						end
					end
				end
				
				if table.len(console[i]) > 0 then
					
					local paused = 0
					for k,v in pairs(console[i]) do
						if console[i][k].pausetime then
							paused = paused + 1
						end
					end
					
					if paused < table.len(console[i]) then
						local str = ""
						for i = 0,30 do
							str = str .. " \n"
						end
						
						phasor_sendconsoletext(i, str)
						
						for k,v in opairs(console[i]) do
							if not console[i][k].pausetime then
								if console[i][k].align == "right" or console[i][k].align == "center" then
									phasor_sendconsoletext(i, consolecenter(string.sub(console[i][k].message, 1, 78)))
								else
									phasor_sendconsoletext(i, string.sub(console[i][k].message, 1, 78))
								end
							end
						end
					end
				end
			else
				console[i] = nil
			end
		end
	end
	
	return true
end

function consolecenter(text)

	if text then
		local len = string.len(text)
		for i = len + 1, 78 do
			text = " " .. text
		end
		
		return text
	end
end

function opairs(t)
	
	local keys = {}
	for k,v in pairs(t) do
		table.insert(keys, k)
	end    
	table.sort(keys, 
	function(a,b)
		if type(a) == "number" and type(b) == "number" then
			return a < b
		end
		an = string.lower(tostring(a))
		bn = string.lower(tostring(b))
		if an ~= bn then
			return an < bn
		else
			return tostring(a) < tostring(b)
		end
	end)
	local count = 1
	return function()
		if table.unpack(keys) then
			local key = keys[count]
			local value = t[key]
			count = count + 1
			return key,value
		end
	end
end

function table.len(t)

	local count = 0
	for k,v in pairs(t) do
		count = count + 1
	end
	
	return count
end