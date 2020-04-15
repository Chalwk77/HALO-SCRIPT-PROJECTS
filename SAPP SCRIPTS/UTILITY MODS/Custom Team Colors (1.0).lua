--[[
--======================================================================================================--
Script Name: Custom Team Colors (v1.0), for SAPP (PC & CE)
Description: Players vote for the color set in the next game.

Commands: 

	* /votelist 
	This command shows a list of all available color sets. 
	
	* /votecolor <set id>
	Use this command to vote for your choice of color set


Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--======================================================================================================--
]]--

local mod, color_table = {}
function mod:LoadSettings()
    -- Configuration [starts] ---------------------------------------------------------------------------
    mod.settings = {

        -- Default color set: (see color table below)
        default_color_set = 2, -- set two (red, blue)

        -- Command Syntax: /votecolor <set id>
        vote_command = "votecolor",
        vote_list_command = "votelist",

        -- Permission level needed to execute "/vote_command" (all players by default)
        permission_level = -1, -- negative 1 (-1) = all players | 1-4 = admins

        -- All custom output messages:
        messages = {
            on_vote = "You voted for SetID [%id%] (%R% - VS - %B%)", -- e.g: "You voted for Teal"
            broadcast_vote = "[Team Color Vote] %name% voted for SetID [%id%] (%R% - VS - %B%)",
            on_game_over = {
                "Red Team will be %red_color%, Blue Team will be %blue_color%",
                "No one voted to change their team color. Colors will remain the same."
            },
            invalid_syntax = "Incorrect Vote Option. Usage: /%cmd% <set id>",
            vote_list_hud = "[%id%] %R% - VS - %B%",
            vote_list_hud_header = "Vote Command Syntax: /%cmd% <set id>",
            already_voted = "You have already voted! (You voted for %R% - vs - %B%)",
            insufficient_permission = "You do not have permission to execute that command!"
        },


		-- 9 sets of choices to vote for
        choices = {
		
            [1] = { -- set 1
				red = {"white", 0},
				blue = {"black", 1},
            },
						
			[2] = { -- set 2
				red = {"red", 2},
				blue = {"blue", 3},
            },
			
            [3] = { -- set 3
				red = {"gray", 4},
				blue = {"yellow", 5},
            },
			
            [4] = { -- set 4
				red = {"green", 6},
				blue = {"pink", 7},
            },
			
            [5] = { -- set 5
				red = {"purple", 8},
				blue = {"cyan", 9},
            },
			
            [6] = { -- set 6
				red = {"cobalt", 10},
				blue = {"orange", 11},
            },
			
            [7] = { -- set 7
				red = {"teal", 12},
				blue = {"sage", 13},
            },
			
            [8] = { -- set 8
				red = {"brown", 14},
				blue = {"tan", 15},
            },
			
            [9] = { -- set 9
				red = {"maroon", 16},
				blue = {"salmon", 17},
            }
        }
    }
    -- Configuration [ends] ---------------------------------------------------------------------------

    -- Do Not Touch --
    local t = mod.settings
    color_table = color_table or t.choices[t.default_color_set]
	for i = 1,#t.choices do
		t.choices[i].votes = 0
	end	
end

api_version = "1.12.0.0"
local gsub, lower, upper = string.gsub, string.lower, string.upper
local players, ls = {}

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_TEAM_SWITCH"], "OnTeamSwitch")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    if (get_var(0, "$gt") ~= "n/a") then
        mod:LoadSettings()
        for i = 1, 16 do
            if player_present(i) then
                mod:InitPlayer(i, false)
            end
        end
    end

    mod:LSS(true)
end

function OnScriptUnload()
    mod:LSS(false)
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        mod:LoadSettings()	
	end
end

function OnGameEnd()
    local results = mod:CalculateVotes()
	local t = mod.settings.messages
	for i = 1,16 do
		if player_present(i) then
			if (results ~= nil) then
				color_table = results
				local R = results.red[1]
				local B = results.blue[1]
				local m = t.on_game_over[1]
				local msg = gsub(gsub(m, "%%red_color%%", R), "%%blue_color%%", B)
				say(i, msg)
			else
				local msg = t.on_game_over[2]
				say(i, msg)
			end
		end
	end
end

function OnPlayerConnect(PlayerIndex)
    mod:InitPlayer(PlayerIndex, false)
    if (players[PlayerIndex].setcolor) then
        players[PlayerIndex].setcolor = false
        mod:SetColor(PlayerIndex)
    end
end

function OnTeamSwitch(PlayerIndex)
    mod:SetColor(PlayerIndex)
end

function OnPlayerDisconnect(PlayerIndex)
    mod:InitPlayer(PlayerIndex, true)
end

function mod:InitPlayer(PlayerIndex, Reset)
    if (not Reset) then
        players[PlayerIndex] = {
            name = get_var(PlayerIndex, "$name"),
            voted = false,
            setcolor = true,
            voted_for = ""
        }
    else
        players[PlayerIndex] = {}
    end
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local command, args = mod:CMDSplit(Command)
    local executor = tonumber(PlayerIndex)

    if (command == nil) then
        return
    end
    command = lower(command) or upper(command)

    local t = mod.settings
    local has_permission = function()
        local access = (tonumber(get_var(executor, "$lvl")) >= t.permission_level)
        if (not access) then
            return rprint(executor, t.messages.insufficient_permission)
        end
        return true
    end

    if (command == t.vote_command) then
        mod:cls(executor, 25)
        if has_permission() then
            if (not players[executor].voted) then

                local vote = args[1]
                local team, valid = get_var(executor, "$team")

                for SetID, Choice in pairs(t.choices) do
                    if (tonumber(vote) == SetID) then
											
					
                        players[executor].voted, players[executor].voted_for = true, gsub(gsub(gsub(t.messages.already_voted, 
						"%%id%%", SetID), 
						"%%R%%", Choice.red[1]), 
						"%%B%%", Choice.blue[1])
						
                        Choice.votes = Choice.votes + 1
						valid = true
						
						local msg = gsub(gsub(gsub(t.messages.on_vote, 
						"%%id%%", SetID), 
						"%%R%%", Choice.red[1]), 
						"%%B%%", Choice.blue[1])
                        rprint(executor, msg)
						
						local broadcast = gsub(gsub(gsub(gsub(t.messages.broadcast_vote, 
						"%%name%%", players[executor].name),
						"%%id%%", vote),
						"%%R%%", Choice.red[1]), 
						"%%B%%", Choice.blue[1])
						
						for i = 1, 16 do
                            if player_present(i) and (i ~= executor) then
                                if (get_var(i, "$team") == get_var(executor, "$team")) then
                                    say(i, broadcast)
                                end
                            end
                        end
                    end
                end
				
                if (not valid) then
                    local error = gsub(t.messages.invalid_syntax, "%%cmd%%", t.vote_command)
                    rprint(executor, error)
                end
            else
                rprint(executor, players[executor].voted_for)
            end
        end

        return false
    elseif (command == t.vote_list_command) then
        if has_permission() then
            mod:cls(executor, 25)
			
			-- header (contents):
			for i = 1,#t.choices do
                local msg = gsub(gsub(gsub(t.messages.vote_list_hud, "%%id%%", i), "%%R%%", t.choices[i].red[1]), "%%B%%", t.choices[i].blue[1])
                rprint(executor, msg)		
			end
			
			-- footer:
            local msg = gsub(t.messages.vote_list_hud_header, "%%cmd%%", t.vote_command)
            rprint(executor, msg)
        end
        return false
    end
end

function mod:CalculateVotes()
	local Choices = mod.settings.choices
	
    local highest_votes, tab = 0
    for i = 1, #Choices do
        if (highest_votes < Choices[i].votes) then
            tab = Choices[i]
        end
    end

    return tab
end

function mod:SetColor(PlayerIndex)
    local player = get_player(PlayerIndex)
    if (player ~= 0) then
        local team = get_var(PlayerIndex, "$team")
        if (team == "red") then
            write_byte(player + 0x60, tonumber(color_table.red[2]))
        elseif (team == "blue") then
            write_byte(player + 0x60, tonumber(color_table.blue[2]))
        end
    end
end

function mod:cls(PlayerIndex, count)
    count = count or 25
    for _ = 1, count do
        rprint(PlayerIndex, " ")
    end
end

function mod:CMDSplit(CMD)
    local subs = {}
    local sub = ""
    local ignore_quote, inquote, endquote
    for i = 1, string.len(CMD) do
        local bool
        local char = string.sub(CMD, i, i)
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

        if i == string.len(CMD) then
            if string.sub(sub, 1, 1) == "\"" and string.sub(sub, string.len(sub), string.len(sub)) == "\"" then
                sub = string.sub(sub, 2, string.len(sub) - 1)
            end
            table.insert(subs, sub)
        end
    end

    local cmd, args = subs[1], subs
    table.remove(args, 1)

    return cmd, args
end

--Credits to Kavawuvi for this chunk of code:
function mod:LSS(state)
    if (state) then
        ls = sig_scan("741F8B482085C9750C")
        if (ls == 0) then
            ls = sig_scan("EB1F8B482085C9750C")
        end
        safe_write(true)
        write_char(ls, 235)
        safe_write(false)
    else
        if (ls == 0) then
            return
        end
        safe_write(true)
        write_char(ls, 116)
        safe_write(false)
    end
end
--------------------------------------------

return mod
