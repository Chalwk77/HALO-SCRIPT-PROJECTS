time = 8 -- Time (in seconds) between each incremental increase of health.
Maximum_Health = 1 -- Maximum health for each Player
Maximum_Health_Regen = Maximum_Health -- Maximum health that will be regenerated.
Maximum_Regenerations = nil -- Number of Regenerations a player has per live. (nil to disable)
Regen_Count = nil
Increment = 0.1 -- Increments in which Health is regenerated. 
 
Regenerations = {}
Regening = {}
Count = {}
 
function GetRequiredVersion() return 200 end
function OnScriptLoad(process, game, persistent)
    Set_Regenerations = registertimer(time * 1000, "Regenerator")
end
 
function OnGameEnd(stage)
    if stage == 1 then
        removetimer(Set_Regenerations)
    end
end
 
function OnPlayerSpawn(player)
    Regenerations[player] = 0
    Regening[player] = false
	Count[player] = 0
    writefloat(getobject(getplayerobjectid(player)) + 0xE0, Maximum_Health)
end
 
function OnDamageApplication(receiving, causing, tagid, hit, backtap)
        if receiving then
                local r_player = objectidtoplayer(receiving)
                if r_player then
                    Count[r_player] = 0
                end
        end
end
 
function Regenerator(id, c)
        for player = 0,15 do
                if getplayer(player) then
                        local bool = true
                        local m_playerObjId = getplayerobjectid(player)
                        if m_playerObjId then
                                local m_object = getobject(m_playerObjId)
                                local player_health = round(readfloat(m_object + 0xE0),1)
                                if tonumber(Maximum_Regenerations) then
                                        if Regening[player] and player_health == Maximum_Health_Regen then
                                                Regening[player] = false
                                                Regenerations[player] = (Regenerations[player] or 0) + 1
                                        end
                                        if (Regenerations[player] or 0) >= Maximum_Regenerations then
												bool = false
                                        end
                                end
                                if tonumber(Regen_Count) and (Count[player] or 0) >= Regen_Count then
                                        bool = false
                                end
                                if bool and player_health < Maximum_Health_Regen then
                                        Regening[player] = true
                                        Count[player] = (Count[player] or 0) + 1
                                        writefloat(m_object + 0xE0, player_health + Increment)
										sendconsoletext(player, "(+) H E A L T H   R E G E N E R A T I N G...")
										hprintf("Server to |  {" .. tostring(player) .. "} (+) H E A L T H   R E G E N E R A T I N G...")
                                        if player_health > Maximum_Health then
                                                writefloat(m_object + 0xE0, Maximum_Health)
                                        end
                                end
                        end
                end
        end
    return true    
end
function round(val, decimal)
        return math.floor((val * 10^(decimal or 0)) + 0.5) / (10^(decimal or 0))
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SEND CONSOLE TEXT OVERRIDE --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		console = {}
console.__index = console
registertimer(100, "ConsoleTimer")
phasor_sendconsoletext = sendconsoletext
math.inf = 1 / 0

function sendconsoletext(player, message, time, order, func)
--function sendconsoletext(player, message, time, order, align, func)

	console[player] = console[player] or {}
	
	local temp = {}
	temp.player = player
	temp.id = nextid(player, order)
	temp.message = message or ""
	temp.time = time or 3
	temp.remain = temp.time
	--temp.align = align or "center"
	
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

function ConsoleTimer(id, Count)

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
	local Count = 1
	return function()
		if table.unpack(keys) then
			local key = keys[Count]
			local value = t[key]
			Count = Count + 1
			return key,value
		end
	end
end

function table.len(t)

	local Count = 0
	for k,v in pairs(t) do
		Count = Count + 1
	end
	
	return Count
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	