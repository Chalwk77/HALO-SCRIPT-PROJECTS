--[[
--=====================================================================================================--
Script Name: Truce, for SAPP (PC & CE)
Description: N/A

Command Syntax: 
    * /truce [player id]
    * /accept [player id]
    * /deny [player id]
    * /untruce [player id]
    * /trucelist

Copyright (c) 2016-2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

api_version = "1.12.0.0"
-- configuration [starts] -->

local base_command = "truce"

-- # Message Configuration:
local on_request = {
    -- Messages transmitted to the target player
    {"%executor_name% is requesting a truce with you.",
    "To accept, type /accept %executor_id%",
    "To deny this request, type /deny %executor_id%"},
    
    -- Message transmitted to the executor
    {"Request sent to %target_id%"}
}

local on_accept = {
    -- Message transmitted to the target player
    {"You are now in a truce with %executor_name%"},
    -- Message transmitted to the executor
    {"[request accepted] You are now in a truce with %target_name%"}
}

local on_deny = {
    -- Message transmitted to the target player
    {"You denied %target_name%'s truce request"},
    -- Message transmitted to the executor
    {"%executor_name% denied your truce request"}
}


-- configuration [ends] <--

local truce = { }
local gsub = string.gsub

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload()

end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
	local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)
	if (command == string.lower(base_command)) then
        local TargetID = tonumber(args[1])
        if args[1] ~= nil then
            if player_present(TargetID) then
                local players = {}
                players.en = get_var(executor, "$name")
                players.eid = tonumber(get_var(executor, "$id"))
                players.tn = get_var(TargetID, "$name")
                players.tid = tonumber(get_var(TargetID, "$id"))
                truce:sendrequest(players)
            else
                rprint(executor, "Player not online")
            end
        else
            rprint(executor, "Invalid syntax")
        end
        return false
	end
end

function truce:sendrequest(params)
    local params = params or {}
    
    local executor_name = params.en or nil
    local executor_id = params.eid or nil
    
    local target_name = params.tn or nil
    local target_id = params.tid or nil
    
    local msgToSender, msgToReceiver
    
    for key, _ in ipairs(on_request) do
        msgToSender = on_request[key][1]
        msgToReceiver = on_request[key][2]
    end
    
    rprint(executor_id, gsub(msgToSender, "%target_name%", target_name))
    rprint(target_id, gsub(msgToReceiver, "%executor_name%", executor_name))
end

function truce:enable(params)
    local params = params or {}
end

function truce:disable(params)
    local params = params or {}
end

function truce:list(params)
    local params = params or {}
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
