----------------------------------------------------------
function GetRequiredVersion() return 200 end			--
function OnScriptLoad(processid, game, persistent)		--
	profilepath = getprofilepath()						--
end														--
														--
function OnScriptUnload() end							--
														--
-- Enable Logging? 										--
Enable_Logging = true									--
														--
-- Data To OutPut --									--
Line_One = "\n(Data Will Go Here)"						--
----------------------------------------------------------

	
function OnNewGame(Mapname)
	WriteLog(profilepath .. "\\logs\\SUCCESS.txt", Line_One) -- 'Line_One' = Data To OutPut
end

function WriteLog(filename, value)
	local file = io.open(filename, "a")
	if Enable_Logging == true then
		if file then
			local timestamp = os.date("Date: %H:%M:%S - %d/%m/%Y")
			local line = string.format("%s\t%s\n", timestamp, tostring(value))
			file:write(line)
			file:close()
		end
	end
end