--[[
--======================================================================================================--
Script Name: Custom Team Colors (v1.0), for SAPP (PC & CE)
Description: Players can vote for the color their team will use in the next game.

IN DEV (90% complete)

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--======================================================================================================--
]]--

local mod, red_team, blue_team = {}
function mod:LoadSettings()
    -- Configuration [starts] ---------------------------------------------------------------------------
    mod.settings = {

        -- Default colors for each team: (color id or name)
        default_red_team_color = 7,
        default_blue_team_color = 3,

        -- Command Syntax: /votecolor <color id (or name)>
        vote_command = "votecolor",
        vote_list_command = "votelist",

        -- Permission level needed to execute "/vote_command" (all players by default)
        permission_level = -1, -- negative 1 (-1) = all players | 1-4 = admins

        -- All custom output messages:
        messages = {
            on_vote = "You voted for %color_name%", -- e.g: "You voted for Teal"
            broadcast_vote = "[Team Color Vote] %name% voted for %color%",
            on_vote_win = {
                "Red Team will be %red_color%, Blue Team will be %blue_color%",
                "Vote Stalemate - Red Team will be %red_color%, Blue Team will be %blue_color%",
                "No one voted to change their team color. Colors will remain the same."
            },
            invalid_syntax = "Incorrect Vote Option. Usage: /%cmd% (color name [string] or ID [number])",
            vote_list_hud = "%id% - %name%",
            vote_list_hud_header = "Vote Command Syntax: /%cmd% <id> or <name>",
            already_voted = "You have already voted! (You voted for %color%)",
            insufficient_permission = "You do not have permission to execute that command!"
        },

        -- Color Table:
        colors = {
            ["white"] = { 0 },
            ["black"] = { 1 },
            ["red"] = { 2 },
            ["blue"] = { 3 },
            ["gray"] = { 4 },
            ["yellow"] = { 5 },
            ["green"] = { 6 },
            ["pink"] = { 7 },
            ["purple"] = { 8 },
            ["cyan"] = { 9 },
            ["cobalt"] = { 10 },
            ["orange"] = { 11 },
            ["teal"] = { 12 },
            ["sage"] = { 13 },
            ["brown"] = { 14 },
            ["tan"] = { 15 },
            ["maroon"] = { 16 },
            ["salmon"] = { 17 }
        }
    }
    -- Configuration [ends] ---------------------------------------------------------------------------

    -- Do Not Touch --
    local t = mod.settings
    for _, color in pairs(t.colors) do
        color.votes = { ["red"] = 0, ["blue"] = 0 }
    end

    local function GetColor(TeamColor)
        for name, id in pairs(t.colors) do
            if (TeamColor == id[1] or TeamColor == name) then
                return { highest_votes = 0, color_id = id[1], color_name = name }
            end
        end
    end

    red_team = red_team or GetColor(t.default_red_team_color)
    blue_team = blue_team or GetColor(t.default_blue_team_color)
end

api_version = "1.12.0.0"
local gsub, lower, upper = string.gsub, string.lower, string.upper
local players, ls = {}

function OnScriptLoad()
    -- Register needed event callbacks:
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_TEAM_SWITCH"], "OnTeamSwitch")

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
    red_team = results[1]
    blue_team = results[2]

    local msg = mod.settings.messages.on_vote_win
    for i = 1, 16 do
        if player_present(i) then
            if (red_team.highest_votes == 0 and blue_team.highest_votes == 0) then
                -- no one voted
                say(i, msg[3])
            elseif (red_team.highest_votes > 0 and blue_team.highest_votes == 0) then
                -- red team voted (blue did not)
            elseif (red_team.highest_votes == 0 and blue_team.highest_votes > 0) then
                -- blue team voted (red did not)
            elseif (red_team.highest_votes == red_team.highest_votes) then
                -- stalemate
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

                for k, color in pairs(t.colors) do
                    if (tostring(vote) == k or tonumber(vote) == color[1]) then
                        players[executor].voted, players[executor].voted_for = true, k
                        color.votes[team] = color.votes[team] + 1
                        local msg = gsub(t.messages.on_vote, "%%color_name%%", k)
                        rprint(executor, msg)
                        local broadcast = gsub(gsub(t.messages.broadcast_vote, "%%name%%", players[executor].name), "%%color%%", k)
                        for i = 1, 16 do
                            if player_present(i) and (i ~= executor) then
                                if (get_var(i, "$team") == get_var(executor, "$team")) then
                                    say(i, broadcast)
                                end
                            end
                        end
                        valid = true
                        break
                    end
                end
                if (not valid) then
                    local error = gsub(t.messages.invalid_syntax, "%%cmd%%", t.vote_command)
                    rprint(executor, error)
                end
            else
                local error = gsub(t.messages.already_voted, "%%color%%", players[executor].voted_for)
                rprint(executor, error)
            end
        end

        return false
    elseif (command == t.vote_list_command) then
        if has_permission() then
            mod:cls(executor, 25)
            for k, color in pairs(t.colors) do
                local msg = gsub(gsub(t.messages.vote_list_hud, "%%id%%", color[1]), "%%name%%", k)
                rprint(executor, msg)
            end
            local msg = gsub(t.messages.vote_list_hud_header, "%%cmd%%", t.vote_command)
            rprint(executor, msg)
        end
        return false
    end
end

local function getHighestVote(t, fn, team)
    if (#t == 0) then
        if (team == "red") then
            return red_team
        else
            return blue_team
        end
    end

    local highest_votes, color_id, color_name = 0, 0, ""
    for i = 1, #t do
        if fn(highest_votes, t[i].votes) then
            highest_votes, color_id, color_name = t[i].votes, t[i].id, t[i].name
        end
    end

    return { highest_votes = highest_votes, color_id = color_id, color_name = color_name }
end

function mod:CalculateVotes()

    local t = mod.settings.colors
    local temp = { }
    temp.red, temp.blue = { }, { }

    for k, color in pairs(t) do
        if (color.votes["red"] > 0) then
            temp.red[#temp.red + 1] = { id = color[1], name = k, votes = color.votes["red"] }
        end
        if (color.votes["blue"] > 0) then
            temp.blue[#temp.blue + 1] = { id = color[1], name = k, votes = color.votes["red"] }
        end
    end

    local red = getHighestVote(temp.red, function(a, b)
        return a < b
    end, "red")

    local blue = getHighestVote(temp.blue, function(a, b)
        return a < b
    end, "blue")

    return { red, blue }
end

function mod:SetColor(PlayerIndex)
    local player = get_player(PlayerIndex)
    if (player ~= 0) then
        local team = get_var(PlayerIndex, "$team")
        if (team == "red") then
            write_byte(player + 0x60, tonumber(red_team.color_id))
        elseif (team == "blue") then
            write_byte(player + 0x60, tonumber(blue_team.color_id))
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
