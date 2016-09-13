commands_table = {
	"/pl",
}

function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnScriptUnload() end
function OnServerCommand(player, command)
    local response = nil
	local cmd = temp[1]
	if cmd ~= "cls" then
		if "sv_" ~= string.sub(cmd, 0,3) then
			command = "sv_" .. command
		end
	end
	t = tokenizecmdstring(command)
	count = #t
	if t[1] == "sv_players" or t[1] == "sv_pl" then
		response = false
		Command_Players(player, t[1], count)
	end
end

function Command_Players(executor, command, count)

	if count == 1 then
		SendRCMessage("Player Search:", command , executor)
		SendRCMessage("[ ID.    -    Name.    -    Team.    -    IP.    -    Ping. ]", command , executor)
		for i = 0,15 do
			if getplayer(i) then
				local name = getname(i)
				local id = resolveplayer(i)
				local player_team = getteam(i)
				local port = getport(i)
				local ip = getip(i)
				local hash = gethash(i)
				local ping = readword(getplayer(i) + 0xDC) 
                if team_play then
    				if player_team == 0 then
    					player_team = "Red Team"
    				elseif player_team == 1 then
    					player_team = "Blue Team"
    				else
    					player_team = "Hidden"
    				end
                else
                    player_team = "FFA"
                end
				SendRCMessage(" (".. id ..")  " .. name .. "   |   " .. player_team .. "  -  (IP: ".. ip ..")  -  (Ping: "..ping..")", command, executor)
			end
		end
	else
		SendRCMessage("Invalid Syntax: " .. command, command, executor)
	end
end	


function OnServerChat(player, chattype, message)

	AllowChat = nil
	local mlen = #message
    local spcount = 0
    for i=1, #message do
        local c = string.sub(message, i,i)
        if c == ' ' then
            spcount = spcount+1
        end
    end
    if mlen == spcount then
        spcount = 0
        return 0
    end
	
	local t = tokenizestring(message, " ")
	local count = #t
	if t[1] == nil then
		return nil
	end
		if string.sub(t[1], 1, 1) == "/" then
			AllowChat = true
		elseif string.sub(t[1], 1, 1) == "\\" then
			AllowChat = false
		end
		cmd = t[1]:gsub("\\", "/")
		local found1 = cmd:find("/")
		local found2 = cmd:find("/", 2)
		local valid_command
		if found1 and not found2 then
			for k,v in pairs(commands_table) do
				if cmd == v then
					valid_command = true
					break
				end
			end
			if not valid_command then
				SendRCMessage("Error | Invalid Command ", t[1], player)
			end
		end
	if cmd == "/pl" then
	Command_Players(player, t[1], count)
	end
end