sendwelcomemessage = false
welcome_message = "Show Passenger Names is Enabled\nType \"disablenames\" to disable and \"enablenames\" to re-enable."
vehicles = {}
sendmessage = {}

function GetRequiredVersion() return 200 end
function OnScriptLoad(processId, game, persistent) 

	main_timer = registertimer(4000, "MainTimer")
end

function OnNewGame(map)
	ghost_mapId = gettagid("vehi", "vehicles\\ghost\\ghost_mp")
	rhog_mapId = gettagid("vehi", "vehicles\\rwarthog\\rwarthog")
	hog_mapId = gettagid("vehi", "vehicles\\warthog\\mp_warthog")
	banshee_mapId = gettagid("vehi", "vehicles\\banshee\\banshee_mp")
	turret_mapId = gettagid("vehi", "vehicles\\c gun turret\\c gun turret_mp")
	tank_mapId = gettagid("vehi", "vehicles\\scorpion\\scorpion_mp")
end

function OnPlayerJoin(player)

	sendmessage[player] = true
	if sendwelcomemessage == true then
		privatesay(player, welcome_message)
	end
end

function OnPlayerLeave(player)

	sendmessage[player] = false
end

function OnServerChat(player, type, message)

	local msg = string.lower(message)
	if player ~= nil then
		if msg == "disablenames" then
			if sendmessage[player] == true then
				sendmessage[player] = false
				privatesay(player, "Passenger names has been disabled!")
			else
				privatesay(player, "Passenger names is already disabled!")
			end
			return false
		elseif msg == "enablenames" then
			if sendmessage[player] == false then
				sendmessage[player] = true
				privatesay(player, "Passenger names has been enabled!")
			else
				privatesay(player, "Passenger names is already enabled!")
			end
			return false
		end
	end
end

function MainTimer(id, count)

	for player = 0, 15 do
		if getplayer(player) then
			if sendmessage[player] == true then
				if isplayerinvehicle(player) == true then
					local m_objectId = getplayerobjectid(player)
					if m_objectId then 
						local m_object = getobject(m_objectId)
						local vehicleId = readdword(m_object + 0x11C)
						local seat = readword(m_object + 0x2F0)
						if seat == 0 then
							CheckPassenger(vehicleId, player)
							CheckGunner(vehicleId, player)
						elseif seat == 1 then
							CheckDriver(vehicleId, player)
							CheckGunner(vehicleId, player)
						elseif seat == 2 then
							CheckDriver(vehicleId, player)
							CheckPassenger(vehicleId, player)
						end
					end
				end
			end
		end
	end
	return true
end

function CheckPassenger(vehicle, player)

	if vehicles[vehicle].one ~= "Empty" then
		sendconsoletext(player, "PASSENGER: " .. vehicles[vehicle].one)
	end
end

function CheckDriver(vehicle, player)

	if vehicles[vehicle].zero ~= "Empty" then
		sendconsoletext(player, "DRIVER: " .. vehicles[vehicle].zero)
	end	
end

function CheckGunner(vehicle, player)	

	if vehicles[vehicle].two ~= "Empty" then
		sendconsoletext(player, "GUNNER: " .. vehicles[vehicle].two)
	end		
end	
 
function OnGameEnd(stage)

	if stage == 1 then
		if main_timer then
			removetimer(main_timer)
		end
	end
end

function OnVehicleEntry(player, vehiId, seat, mapId, voluntary)

	if vehicles[vehiId] == nil then
		vehicles[vehiId] = {}
		vehicles[vehiId].zero = "Empty"
		vehicles[vehiId].one = "Empty"
		vehicles[vehiId].two = "Empty"	
	end
	
	if seat == 0 then -- Drivers Seat
		vehicles[vehiId].zero = getname(player)
	elseif seat == 1 then -- Passengers
		vehicles[vehiId].one = getname(player)
	elseif seat == 2 then -- Gunners
		vehicles[vehiId].two = getname(player)
	end
end

function OnVehicleEject(player, voluntary)

    local m_objectId = getplayerobjectid(player)
    if m_objectId then 
		local m_object = getobject(m_objectId)
        local vehicleId = readdword(m_object + 0x11C)
        if vehicleId then
			local seat = readword(m_object + 0x2F0)
			if seat == 0 then
				vehicles[vehicleId].zero = "Empty"
			elseif seat == 1 then
				vehicles[vehicleId].one = "Empty"
			elseif seat == 2 then
				vehicles[vehicleId].two = "Empty"
			end
		end
	end
end

function isplayerinvehicle(player)

	if isplayerdead(player) == false then
		local m_object = getobject(getplayerobjectid(player))
			if m_object ~= nil then
			local m_vehicleId = readdword(m_object + 0x11C)
			if m_vehicleId == 0xFFFFFFFF then
				return false 
			else
				return true 
			end
		else
			return nil
		end
	else
		return nil
	end
end

function isplayerdead(player)

	local m_objectId = getplayerobjectid(player)
	if m_objectId then
		local m_object = getobject(m_objectId)
		if m_object then
			return false
		else
			return true
		end
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
        temp.time = time or 3
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