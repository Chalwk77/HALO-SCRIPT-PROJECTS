
--[[    
------------------------------------
Description: HPC Chat Printing Script, Phasor V2+
Copyright © 2016-2017 Jericho Crosby
* Author: Jericho Crosby
* IGN: Chalwk
* Written and Created by Jericho Crosby
-----------------------------------
]]--

	
-- Want a custom looking HaloDed.exe?
-- See details at the bottom of this script.
		
-- REFERENCES: 
		
-- Typing: respond("\"test\"") will print 'test' in Quotes.
-- Typing  .. "\""..message.."\"" .. will print the data associated with the string 'message' in quotes. 
	
-- To Do List: 'cmdsplit()'
----------------------------------------------------------
function GetRequiredVersion() 
return 
200 
end			--
function OnScriptLoad(processid, game, persistent)		--
    profilepath = getprofilepath()						--
end														--
--
function OnScriptUnload() 

end
--
-- Log Server Game Chat in its own file?				--
Write_To_File = true									--
----------------------------------------------------------
function OnServerChat(player, chattype, message)
--[[ 

	Type:
	0 All chat
	1 Team chat
    2 Vehicle chat
    3 Server message
    4 Private server message 
	
]]	
	
-- Un-comment if you want this data printed to the Halo Desktop Console
-- 	local timestamp = os.date ("%H:%M:%S, %d/%m/%Y: ")
    local type = nil
    if chattype == 0 then
        type = "GLOBAL"
    elseif chattype == 1 then
        type = "TEAM"
    elseif chattype == 2 then
        type = "VEHICLE"
--[[

		elseif chattype == 3 then
              type = "SERVER MESSAGE"
		elseif chattype == 4 then
              type = "PRIVATE SERVER MESSAGE"
]]

    end
        
    if string.lower(tostring(message)) == "/pl" or string.lower(tostring(message)) == "\\pl" then 
        return false 
    end
        
    if player ~= nil and type ~= nil then -- Nil Check (Checks to see whether the player exists or not).
        local name = getname(player) -- Retrieves Player Name
        local id = resolveplayer(player) -- Retrieves RCON ID (player id: 0,15)
-- Un-comment if you want this data printed to the Halo Desktop Console
-- 				hprintf(timestamp .. "  C   H   A   T:     " .. name .. " (".. id ..")  ".. type ..":  " .. "\""..message.."\"")
        hprintf("[CHAT] " .. name ..  " (".. id ..")  ".. type ..": " .. "\""..message.."\"")
        -- Logs to Server Chat.txt
        WriteLog(profilepath .. "\\logs\\Server Chat.txt", type .. ":    " .. name .. " (".. id .."):  " .. "\""..message.."\"")
    end     
-- Not Completed!
--[[
 	local type = nil
        if chattype == 0 then
                type = "GLOBAL"
        elseif chattype == 1 then
                type = "TEAM"
        elseif chattype == 2 then
                type = "VEHICLE"
		end
		
		if player ~= nil then
		local name = getname(player)
		local id = resolveplayer(player)
		local cmd, args = cmdsplit(message)
		cmd = string.lower(cmd)
		WriteLog(profilepath .. "\\logs\\Server Chat.txt", "CHAT COMMAND: " .. name ..  " executed " .. "\""..cmd.."\"")
	end
	return true
]]	

end   


-- WriteLog()
-- Logs all Server Chat to 'Server Chat.txt'
function WriteLog(filename, value)
    local file = io.open(filename, "a")
    if Write_To_File == true then
        if file then
            local timestamp = os.date("%H:%M:%S - %d/%m/%Y")
            local line = string.format("%s\t%s\n", timestamp, tostring(value))
            file:write(line)
            file:close()
        end
    end
end


-- WriteLine()
-- Adds a break line and announces 'N E W  G A M E'.
function WriteLine(filename, value)
    local file = io.open(filename, "a")
    if Write_To_File == true then
        if file then
            local timestamp = os.date("%H:%M:%S  -  %d/%m/%Y")
            local Line_0 = string.format("%s\t%s\n", timestamp, tostring(value))
            Line_break = " \n"
            Line_0 = (timestamp)
            Line_1 = "\n-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -\n"
            Line_2 = "N E W  G A M E\n"
            Line_3 = "\n"
            file:write(Line_break, Line_0, Line_1, Line_2, Line_3)
            file:close()
        end
    end
end


-- OnNewGame()
-- Calls 'WriteLine() which 'Adds a break line and announces 'N E W   G A M E'. 
function OnNewGame(Mapname)
    WriteLine(profilepath .. "\\logs\\Server Chat.txt")
end	


-- OnPlayerLeave()
-- Announces when a player leaves the game and displays some additional information.
-- Displays: Name, ID, Port, IP, Ping, Hash and 'quit time'.
function OnPlayerLeave(player)

    local timestamp = os.date ("%H:%M:%S, %d/%m/%Y:")
    local name = getname(player)
    local id = resolveplayer(player)
    local port = getport(player)
    local ip = getip(player)
    local ping = readword(getplayer(player) + 0xDC)
    local hash = gethash(player)
			
		
    hprintf("P L A Y E R   Q U I T   T H E   G A M E")	
    hprintf("-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -")
    hprintf(name .. " (" .. id .. ")   -   Quit The Game.")
    hprintf("IP Address: (" .. ip .. ")  Quit Time: (" .. timestamp .. ")  Player Ping: (" .. ping .. ")")
    hprintf("CD Hash: " .. hash)
    hprintf("-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -")
		
end


function cmdsplit(str)

    local subs = {}
    local sub = ""
    local ignore_quote, inquote, endquote
    for i = 1,string.len(str) do
        local bool
        local char = string.sub(str, i, i)
        if char == " " then
            if (inquote and endquote) or (not inquote and not endquote) then
                bool = true
            end
        elseif char == "\\" then
            ignore_quote = true
        elseif char == "\"" then
            if not ignore_quote then
                if not inquote then
                    inquote = true
                else
                    endquote = true
                end
            end
        end
		
        if char ~= "\\" then
            ignore_quote = false
        end
		
        if bool then
            if inquote and endquote then
                sub = string.sub(sub, 2, string.len(sub) - 1)
            end
			
            if sub ~= "" then
                table.insert(subs, sub)
            end
            sub = ""
            inquote = false
            endquote = false
        else
            sub = sub .. char
        end
		
        if i == string.len(str) then
            if string.sub(sub, 1, 1) == "\"" and string.sub(sub, string.len(sub), string.len(sub)) == "\"" then
                sub = string.sub(sub, 2, string.len(sub) - 1)
            end
            table.insert(subs, sub)
        end
    end
	
    local cmd = subs[1]
    local args = subs
    table.remove(args, 1)
	
    return cmd, args
end


--[[

Want a custom looking HaloDed.exe?

Right Click your HaloDed.exe and click properties. Follow the instructions below:


Options Tab
------------

- Cursor Size:
	-- small

Command History:
	-- Buffer Size: 50
	-- Number of Buffers: 4
	-- Discard Old Duplicates (un-ticked)

- Edit Options: 
	-- QuickEdit mode (ticked)
	-- Insert Mode (ticked)


Font Tab
---------
	-- Font = Lucida Console, Size = 12


Layout Tab
-----------

- Screen Buffer Size:
	-- Width: 99
	-- Height: 300

- Window Size:
	-- Width: 99
	-- Height: 59

- Window Position:
	-- Left: 549
	-- Top: 1

	
- Let System Position Window (Un-Ticked)


Colors Tab
------------

- Screen Text:
	-- Red: 94
	-- Green: 113
	-- Blue: 25
	
Run: Normal Window
Shortcut Key: None

]]