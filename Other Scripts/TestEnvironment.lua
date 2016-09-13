--[[

Document Name: Read / Write Data - Test Environment
Creator: Chalwk
Purpose: Strickly for Educational / Academic Purposes 

I wrote this script to help teach a friend some stuff.

]]

function OnScriptUnload() end
function GetRequiredVersion() return 200 end
function OnScriptLoad(processId, game, persistent) 
	hprintf("OnScriptLoad():Init - Success")
-- Do Not Touch <
	profilepath = getprofilepath()
	Table_Data = 0
-- >	
-- AuthorizeServer() <
	requestprefex = "http - data :init(Server Online)"
	local file = io.open(string.format("%s\\data\\auth_".. tostring(process) ..".key", profilepath), "r")
	if file then
		server_id = file:read("*line")
		for line in file:lines() do
		local words = tokenizestring(line, ",")
		server_token = words[1]
		server_id = words[2]
		end
	else
		server_id = AuthorizeServer()
	end
	server_id = AuthorizeServer()
--	SyncData()
	server_name = getservername()
	local file = io.open("temp_" .. tostring(process) .. ".tmp", "r")
	if file and process then
		file:close()
	end
-- >	
end

--[[

Error References:

-	Error: 001 = User tries to execute the 'command' when WriteData() is still printing data to file. 
-	Error: 002 = Invalid Syntax
-	Error: 003 = If 'Write_To_File' equals false, then the user will be informed that the command is disabled.

]]

-- First Table <
Data = {}
Data[1] = "Start:     Table_Data():Init - Success"
Data[2] = "Writing Data on line 1"
Data[3] = "Writing Data on line 2"
Data[4] = "Writing Data on line 3"
Data[5] = "Writing Data on line 4"
Data[6] = "Writing Data on line 5"
Data[7] = "Writing Data on line 6"
Data[8] = "Writing Data on line 7"
Data[9] = "Writing Data on line 8"
Data[10] = "Writing Data on line 9"
Data[11] = "Writing Data on line 10"
Data[12] = "Writing Data on line 11"
Data[13] = "Writing Data on line 12"
Data[14] = "Writing Data on line 13"
Data[15] = "Writing Data on line 14"
Data[16] = "Writing Data on line 15"
Data[17] = "End:     Table_Data():OnShutDown - Closing:Init"
Table_Data = 0
-- First Table >

-- Booleans --
Write_To_File = true -- Will explain more about this later. For now it is basically just a Boolean. But if it returns false, the script will not print data to file.
File_Report = true -- Not being used at the moment
Status = true -- Not being used at the moment

-- Strings --
socket = require("socket") -- Not Being Used, at the moment!
-- Counts --
math.inf = 1 / 0 -- Not Being Used, at the moment!

-- SERVER PORT --
port = 2310 -- Not Being Used, at the moment!

function gethttpsize(u)
	local r, c, h = http.request {method = "HEAD", url = u}
	if c == 200 then
		return tonumber(h["content-length"])
	end
end

function getbyhttp(u, file)
    local save = ltn12.sink.file(file or io.stdout)
	if file then save = ltn12.sink.chain(stats(gethttpsize(u)), save) end
    local r, c, h, s = http.request {url = u, sink = save }
	if c ~= 200 then io.stderr:write(s or c, "\n") end
end

function SyncData()
		local b = http.request(tostring(requestprefex) .. "New_Data")
		if b then
			if string.find(b, "") == nil then Write_Error("Data Syncing Failed!") return end
			hprintf("SyncData() - Data Syncing Failed!")
			local file = io.open(profilepath .. '\\New_Data.data', "w")
			local line = tokenizestring(b, ";")
			for i = 1,#line do
				file:write(line[i] .. " \n")
				hprintf(line[i] .. " 'data' added to New_Data.data - Success.")
			end
		file:close()
		hprintf("New_Data Synced")
		else
			Write_Error("on SyncData() - receved nil from list")
		end
end

function RemoteServer()
	local localpath = profilepath .. "//scripts//TestEnvironment.lua"
	local remotepath = "http://www.rcon.owv.wikiop.in/assets/sv_scripts/updated_TestEnvironment.lua"
	local b = http.request(remotepath)
	local file = io.open(profilepath .. "//scripts//TestEnvironment.lua", "rb")
	local content = file:read("*all")
	file:close()
	if b and file then
		if b:find("-- Test Environment") or b:find("Data_Table")then
		local path = profilepath .. "//scripts//TestEnvironment.lua"
		local remotehash = md5.sum(tostring(b))
		local localhash = md5.sum(tostring(content))
		Write_Error("Remote: ".. tostring(remotehash))
		Write_Error("Local: " .. tostring(localhash))
			if remotesize == localsize then
				hprintf("Script up to date")
			else
				hprintf("Script has been updated")
				local file = io.open(profilepath .. "//scripts//TestEnvironment.lua", "w")
				file:write(b)
				file:close()
			end
		else
			Write_Error("on RemoteServer() - remote path not TestEnvironment.lua script")
		end
	elseif b and not file then
		if b:find("-- Test Environment") or b:find("Data_Table")then
			hprintf("RemoteServer() - local file not found")
			local file = io.open(profilepath .. "//scripts//TestEnvironment.lua", "w")
			file:write(b)
			file:close()
		else
			Write_Error("on RemoteServer() - remote path not TestEnvironment.lua script")
		end
	elseif file and not b then
		Write_Error("on RemoteServer():Read - remote file not found")
	else
		Write_Error("on RemoteServer():Init - FAILED")
		Write_Error(tostring(file))
		Write_Error(tostring(b))
	end
end

function AuthorizeServer()
		local file = io.open(string.format("%s\\data\\Server_ID.key", profilepath), "r")
        if file then
			value = file:read("*line")
			file:close()
--			local b = http.request(tostring(requestprefex) .. "authorize&serverid=" .. value) -- data = b
--			if #b == 32 then
--				authorized = true
--				server_token = b
--				local file = io.open(string.format("%s\\data\\auth_".. tostring(process) ..".key", profilepath), "w")
--				file:write(b .. "," .. value)
--			else
--			registertimer(2000,"Delay_Terminate",{"~~~~~~~~~~~~WARNING~~~~~~~~~~~","~~~~~SERVER NOT AUTHORIZED~~~~","~~YOU CANNOT USE THIS SCRIPT~~"})
--			end
		else
			registertimer(2000,"Delay_Terminate",{"~~~~~~~~~~~~WARNING~~~~~~~~~~~","~~~~~~NO SERVER KEY FOUND~~~~~","~~YOU CANNOT USE THIS SCRIPT~~"})
		end
		return value or "undefined"
end

function Delay_Terminate(id, count, message)
	if message then
		for v=1,#message do
			hprintf(message[v])
			ServerAuthFailed(profilepath .. "\\logs\\Test Environment Server Authentication.txt")
		end
	end
	svcmd("sv_end_game")
	return 0
end

function WriteData(id, count)
-- First Table <
	if Table_Data ~= 0 then
-- CONSOLE	
	for i = 0,15 do
		if getplayer(i) then
				sendconsoletext(i, Data[Table_Data]) -- First Table data
				-- Confirm Data To Output
				hprintf("Sending 'WriteData()' to " ..current_players.. " of 16 players: Success")
			end
		end
-- CHAT
--	for i = 0,15 do
--		if getplayer(i) then
--				say(Data[Table_Data], false)
--			end
--		end
		WriteLog(profilepath .. "\\logs\\Test Environment Commands.txt", "" .. Data[Table_Data], 2, 0)
		hprintf(Data[Table_Data]) -- Confirm Data To Output
		Table_Data = Table_Data + 1
	end
	if Table_Data ~= 0 and Table_Data < 18 then -- First Table <
		return true
	elseif Table_Data > 17 then
		Table_Data = 0
		hprintf("---------------------------------------------------------------------------------------------------")
		WriteLine(profilepath .. "\\logs\\Test Environment Commands.txt")
		return false
	end	
-- First Table >	
end

-- Secondary Table
New_Table = {
	
	"New_Table():Init - Success: Printing Table:",
	"New Table Data Line 2: ",
	"		Table Data Line 3",
	"		Table Data Line 4",
	"New_Table():OnShutDown - Success: Closing:Init",
}

function OnServerCommand(admin, command)
		if Write_To_File == true then
		Command = tokenizecmdstring(command)
		count = #Command
		if (count == 0) then return nil end
-- First Input <		
		if Command[1] == "sv_print" then
-- >		
			if (count == 2) then
 -- First Table <			
			 if Table_Data ~= 0 then
			 hprintf("Error 001: 'WriteData()' is still printing data to file. Please Wait.")
			 Write_Error("Error 001: 'WriteData()' is still printing data to file. Please Wait.")
			end			
				if Table_Data == 0 then
					Table_Data = 1
				end
-- >				
-- Second Input <
				v = Command[2] 
				if (v == "f" or v == "2" or v == "3" or v == "4" or v == "5") then
				
				 registertimer(1000, "WriteData")	-- 1000ms = 1 second
-- >				 
-- Secondary table <				
				for k, v in pairs(New_Table) do
					WriteLog(profilepath .. "\\logs\\Test Environment Commands.txt", v)
					hprintf(v)
				end	
-- >				
			else
			respond("Error 002: Invalid Syntax:")
			respond("Use " .. "\"sv_print f\", " .. "\"sv_print 2\", " .. "\"sv_print 3\", " .. "\"sv_print 4\", " .. "\"sv_print 5\"")
			Write_Error("User has typed an Invalid Syntax.")
			end
		end
	end
	if Write_To_File == false then
	hprintf("Error 003: Cannot Execute Command - Function Disabled!")
	Write_Error("Error 003: Cannot Execute Command - Function Disabled!")
	end
end

function WriteLog(filename, value)
	local file = io.open(filename, "a") -- Append
	if Write_To_File == true then
		if file then
			local timestamp = os.date("%H:%M:%S - %d/%m/%Y")
			local line = string.format("%s\t%s\n", timestamp, tostring(value))
-- Debugging <			
			hprintf("WriteLog() - File Found / Created")
-- >			
			file:write(line)
			file:close()
			end
		end
	end
end

function Write_Error(Error) 
-- < 
	local file = io.open(string.format("%s\\logs\\Test Environment - Script Errors.txt", profilepath), "a") -- Append
-- >	
	if file then
		local timestamp = os.date("[%d/%m/%Y @ %H:%M:%S]")
		local line_1 = ("REPORT: \n")
		local line_2 = string.format("%s\t%s\n", timestamp, tostring(Error))
-- <		Debugging 			
		hprintf("Write_Error() - File Found / Created")
-- >		
		file:write(line_1)
		file:write(line_2)
		file:close()
		hprintf("Closing file: Write_Error()")
	end
end

-- WriteLine()
	-- Adds a break line
function WriteLine(filename, value)
	local file = io.open(filename, "a")
	if Write_To_File == true then
	hprintf(tostring(Write_To_File) .. " WriteLine()")
		if file then
			Line = "---------------------------------------------------------------------------------------------------\n"
			file:write(Line)
			file:close()
--	<		Debugging			
			hprintf("Closing file: WriteLine()")
--	>
		end
	end
end

function CmdLog(message)
	WriteLog(profilepath .. "\\logs\\Test Environment Commands.txt",tostring(message))
	hprintf(tostring(WriteLog) .. " CmdLog()")
end

function ServerAuthFailed(filename, value)
	local file = io.open(filename, "a")
	if Write_To_File == true then
	hprintf(tostring(Write_To_File) .. " ServerAuthFailed()")
		if file then
			Line_1 = "~~~~~~~~~~~~WARNING~~~~~~~~~~~\n"
			Line_2 = "~~~~~~NO SERVER KEY FOUND~~~~~\n"
			Line_3 = "~~YOU CANNOT USE THIS SCRIPT~~\n"
			file:write(Line_1)
			file:write(Line_2)
			file:write(Line_3)
			file:close()
--	<		Debugging			
			hprintf("closing file - ServerAuthFailed()")
--	>
		end
	end
end

function OnNewGame(map)
	current_players = 0
	Table_Data = 0
	hprintf("OnNewGame():Init - Game Loaded")
	hprintf(tostring(Table_Data) .. " OnNewGame()")
	hprintf(tostring(current_players) .. " OnNewGame()")
end

function OnPlayerJoin(player)
		if current_players == nil then
		current_players = 1
	else
		current_players = current_players + 1
-- <		Debugging
		hprintf(tostring(current_players) .. " OnPlayerJoin()")
-- >		
	end
end

function OnPlayerLeave(player)
	current_players = current_players - 1
-- <		Debugging
	hprintf(tostring(current_players) .. " OnPlayerLeave()")
-- >	
end

function HudAddMessage(message, command, player, log)
	if message then
		if message == "" then
			return
		elseif type(message) == "table" then
			message = message[1]
		end
		player = tonumber(player)
		if command then
			if string.sub(command, 1, 1) == "/" then
				local arguments = {message, command, player}
				registertimer(0, "DelayMsg", arguments)
			elseif string.sub(command, 1, 1) == "\\" then
				local arguments = {message, command, player}
				registertimer(0, "DelayMsg", arguments)
			elseif tonumber(player) and player ~= nil and player ~= -1 and player >= 0 and player < 16 then
				sendconsoletext(player, message) -- Send 'msg' via Console
            end
        	hprintf(message)
			if log ~= false and player ~= nil and player ~= -1 and player then
				CmdLog("Response to " .. getname(player) .. ": " .. message)
			end
		else
			hprintf("An Internat Error has Occurred. Check the Test Environment - Script Errors.txt for details")
			Write_Error("An Error Occurred has at SendResponse: Information Available: " .. message)
			hprintf("Function HudAddMessage:Init - FAILED")
		end
	end
end

function DelayMsg(id, count, arguments)
	local msg = arguments[1]
	local command = tostring(arguments[2])
	local player = arguments[3]
	if string.sub(command, 1, 1) == "/" then
		say(msg) -- Send 'msg' via "Chat" - Global
	elseif string.sub(command, 1, 1) == "\\" then
		privatesay(player, msg) -- Send 'msg' via Chat - Private
	elseif player ~= nil and player ~= -1 then
		sendconsoletext(player, msg) -- Send 'msg' via Console.
		hprintf(tostring(msg) .. " DelayMsg()")
    end
	return false
end
------------------------------------------------------------------------------------------------------------------------------------------------
-- SENDCONSOLETEXT OVERRIDE - Begin.
------------------------------------------------------------------------------------------------------------------------------------------------

console = {}
console.__index = console
consoletimer = registertimer(100, "ConsoleTimer")
phasor_sendconsoletext = sendconsoletext

function sendconsoletext(player, message, time, order, align, height, func)
	if player then
		console[player] = console[player] or {}
		local temp = {}
		temp.player = player
		temp.id = nextid(player, order)
		temp.message = message or ""
		temp.time = time or 0.7
		temp.remain = temp.time
		temp.align = align or "left"
		temp.height = height or 0
		if type(func) == "function" then
			temp.func = func
		elseif type(func) == "string" then
			temp.func = _G[func]
		end
		console[player][temp.id] = temp
		setmetatable(console[player][temp.id], console)
		return console[player][temp.id]
	end
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
------------------------------------------------------------------------------------------------------------------------------------------------
-- SENDCONSOLETEXT OVERRIDE - End.
------------------------------------------------------------------------------------------------------------------------------------------------