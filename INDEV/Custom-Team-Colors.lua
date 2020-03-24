--[[
--======================================================================================================--
Script Name: Custom Team Colors (v1.0), for SAPP (PC & CE)
Description: Players can vote for the color their team will use in the next game.

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--======================================================================================================--
]]--

local mod = {}
function mod:LoadSettings()
    -- Configuration [starts] ---------------------------------------------------------------------------
    mod.settings = {

        -- Default colors for each team: (color id or name)
        default_red_team_color = 1,
        default_blue_team_color = 4,

        -- Command Syntax: /votecolor <color id (or name)>
        vote_command = "votecolor",
        vote_list_command = "votelist",

        -- Permission level needed to execute "/vote_command" (all players by default)
        permission_level = 1, -- negative 1 (-1) = all players | 1-4 = admins

        -- All custom output messages:
        messages = {
            on_vote = "You voted for %color_name%", -- e.g: "You voted for Teal"
            on_vote_win = "[Team Color Vote] %color_name% won the vote for your team",
            invalid_syntax = "Incorrect Vote Option. Usage: /%cmd% (color name [string] or ID [number])",
            vote_list_hud = "%id% - %name%",
            vote_list_hud_header = "Color ID | Color Name (Vote Command Syntax: /%cmd% <id> or <name>",
            already_voted = "You have already voted!",
            insufficient_permission = "You do not have permission to execute that command!"
        },

        -- Color Table:
        colors = {
            [1] = { "white" },
            [2] = { "black" },
            [3] = { "red" },
            [4] = { "blue" },
            [5] = { "gray" },
            [6] = { "yellow" },
            [7] = { "green" },
            [8] = { "pink" },
            [9] = { "purple" },
            [10] = { "cyan" },
            [11] = { "cobalt" },
            [12] = { "orange" },
            [13] = { "teal" },
            [14] = { "sage" },
            [15] = { "brown" },
            [16] = { "tan" },
            [17] = { "maroon" },
            [18] = { "salmon" }
        }
    }
    -- Configuration [ends] ---------------------------------------------------------------------------

    -- Do Not Touch --
    local t = mod.settings
    for i = 1, #t.colors do
        t.colors[i].votes = { ["red"] = 0, ["blue"] = 0 }
    end
    local function GetColor(team)

        for k, _ in pairs(t.colors) do
            if (t.default_red_team_color == t.colors[k][1] or t.default_red_team_color == k) and (team == "red") then
                return {
                    highest_votes = 0,
                    color_id = k,
                    color_name = t.colors[k][1]
                }
            elseif (t.default_blue_team_color == t.colors[k][1] or t.default_blue_team_color == k) and (team == "blue") then
                return {
                    highest_votes = 0,
                    color_id = k,
                    color_name = t.colors[k][1]
                }
            end
        end
    end

    t.red_team = t.red_team or GetColor("red")
    t.blue_team = t.blue_team or GetColor("blue")
end

api_version = "1.12.0.0"
local gsub, lower, upper = string.gsub, string.lower, string.upper
local players = {}

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb['EVENT_PRESPAWN'], "OnPlayerPreSpawn")

    if (get_var(0, "$gt") ~= "n/a") then
        mod:LoadSettings()
        for i = 1, 16 do
            if player_present(i) then
                mod:InitPlayer(i, false)
            end
        end
    end
end

function OnScriptUnload()

end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        mod:LoadSettings()
    end
end

function OnGameEnd()
    local results = mod:CalculateVotes()
    local t = mod.settings
    for team, v in pairs(results) do
        if (team == "red") then
            t.red_team = { v.highest_votes, v.color_id, v.color_name }
        elseif (team == "blue") then
            t.blue_team = { v.highest_votes, v.color_id, v.color_name }
        end
    end
end

function OnPlayerConnect(PlayerIndex)
    mod:InitPlayer(PlayerIndex, false)
end

function OnPlayerDisconnect(PlayerIndex)
    mod:InitPlayer(PlayerIndex, true)
end

function OnPlayerPreSpawn(PlayerIndex)
    if (players[PlayerIndex].setcolor) then
        players[PlayerIndex].setcolor = false
        mod:SetColor(PlayerIndex)
    end
end

function mod:InitPlayer(PlayerIndex, Reset)
    if (not Reset) then
        players[PlayerIndex] = { voted = false, setcolor = true }
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
        cls(executor, 25)
        if has_permission() then
            if (not players[executor].voted) then
                players[executor].voted = true

                local vote = args[1]
                local team, valid = get_var(executor, "$team")

                for k, v in pairs(t.colors) do
                    if (tostring(vote) == v[1] or tonumber(vote) == k) then
                        valid = true
                        local msg = gsub(t.messages.on_vote, "%%color_name%%", v[1])
                        rprint(executor, msg)
                        v.votes[team] = v.votes[team] + 1
                        break
                    end
                end

                if (not valid) then
                    local error = gsub(t.messages.invalid_syntax, "%%cmd%%", t.vote_command)
                    rprint(executor, error)
                end
            else
                rprint(executor, t.messages.already_voted)
            end
        end

        return false
    elseif (command == t.vote_list_command) then
        if has_permission() then
            cls(executor, 25)
            for i = 1, #t.colors do
                local msg = gsub(gsub(t.messages.vote_list_hud, "%%id%%", i), "%%name%%", t.colors[i][1])
                rprint(executor, msg)
            end
            local msg = gsub(t.messages.vote_list_hud_header, "%%cmd%%", t.vote_command)
            rprint(executor, msg)
        end
        return false
    end
end

local function getHighestVote(t, fn, team)

    if #t == 0 then
        if (team == "red") then
            return mod.settings.red_team
        else
            return mod.settings.blue_team
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

    local temp = { }
    temp.red, temp.blue = { }, { }

    for k, v in pairs(mod.settings.colors) do
        if (v.votes["red"] > 0) then
            temp.red[#temp.red + 1] = { id = k, name = v, votes = v.votes["red"] }
        end
        if (v.votes["blue"] > 0) then
            temp.blue[#temp.blue + 1] = { id = k, name = v, votes = v.votes["blue"] }
        end
    end

    local red = getHighestVote(temp.red, function(a, b)
        return a < b
    end, "red")

    local blue = getHighestVote(temp.blue, function(a, b)
        return a < b
    end, "blue")

    return {
        ['red'] = red,
        ['blue'] = blue
    }
end

function mod:SetColor(PlayerIndex)
    local player = get_player(PlayerIndex)
    if (player ~= 0) then
        local team = get_var(PlayerIndex, "$team")
        if (team == "red") then
            write_byte(player + 0x60, mod.settings.red_team.color_id)
        elseif (team == "blue") then
            write_byte(player + 0x60, mod.settings.blue_team.color_id)
        end
    end
end

function cls(PlayerIndex, count)
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
