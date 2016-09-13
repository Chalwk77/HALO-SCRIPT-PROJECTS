Enable_Logging = true

function log(msg)
	if Enable_Logging == true then
		WriteDataToFile("custom file name here.txt", msg)
	end
end

function WriteDataToFile(filename, value)

	local file = io.open(getprofilepath() .. "\\logs\\" .. filename, "w")
	if file then
		local timestamp = os.date("%Y/%m/%d %H:%M:%S")
		local line = string.format("%s\t%s\n", timestamp, tostring(value))
		file:write(line)
		file:close() 
	end
end





-- ALTERNATIVE

function WriteLog(filename, value)
	local file = io.open(filename, "w")
	if file then
		local timestamp = os.date("%Y/%m/%d %H:%M:%S")
		local line = string.format("%s\t%s\n", timestamp, tostring(value))
		file:write(line)
		file:close()
	end
end

WriteLog(profilepath .. "\\FCData\\success.log" .. message)