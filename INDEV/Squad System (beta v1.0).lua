--[[
--=====================================================================================================--
Script Name: Squad System (beta v1.0), for SAPP (PC & CE)
Description: N/A

Idea taken from: https://opencarnage.net/index.php?/topic/7779-squad-system/

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- ======================= CONFIGURATION STARTS ======================= --
local squad, votes = { }, {
    msg = "[#%id%] %name% (Total Votes: %votes%)",
    timeRemaining_msg = "Vote Time Remaining: [%time%]",
    duration = 30,
}
-- ======================= CONFIGURATION ENDS ======================= --

local coordinates, spawn_coordinates, time_scale = nil, nil, 0.03333333333333333
local sub, gsub, gmatch, format, match = string.sub, string.gsub, string.gmatch, string.format, string.match
local floor = math.floor
local sqrt = math.sqrt

function squad:Load()
    coordinates = get_spawns()
    spawn_coordinates = { }

    squad.blueleader, squad.redleader = nil, nil

    votes.hasVoted, votes.total = { }, { }
    votes.timeRemaining = votes.duration

    votes.pauseDuration = 5
    votes.pauseConsole, votes.pauseTimer = { }, { }
    votes.results = { }

    votes.inProgress, votes.timer = true, 0
end

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_CHAT"], "OnPlayerChat")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    if (get_var(0, "$gt") ~= "n/a") then
        squad:Load()
    end
end

function OnScriptUnload()
    --
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        squad:Load()
    end
end

function OnPlayerConnect(PlayerIndex)
    votes.total[PlayerIndex] = 0
    votes.hasVoted[PlayerIndex] = false

    votes.pauseTimer[PlayerIndex] = 0
    votes.pauseConsole[PlayerIndex] = false
end

function OnPlayerDisconnect(PlayerIndex)
    votes.total[PlayerIndex] = 0
    votes.hasVoted[PlayerIndex] = false

    votes.pauseTimer[PlayerIndex] = 0
    votes.pauseConsole[PlayerIndex] = false
end

function OnTick()

    if (votes.inProgress) and (squad:GetPlayerCount() > 0) then

        votes.timer = votes.timer + time_scale
        local time_factor = ((votes.duration) - (votes.timer))

        local minutes, seconds = select(1, secondsToTime(time_factor)), select(2, secondsToTime(time_factor))
        votes.timeRemaining = seconds
        if (tonumber(seconds) <= 0) then
            votes.timeRemaining = 0
            votes.timer, votes.inProgress = 0, false
            squad:CalculateVotes()
        end
    end

    for i = 1, 16 do
        if player_present(i) and player_alive(i) then

            if (votes.inProgress) then
                if (votes.pauseConsole[i]) then
                    votes.pauseTimer[i] = votes.pauseTimer[i] + time_scale
                    local time_factor = ((votes.pauseDuration) - (votes.pauseTimer[i]))

                    local minutes, seconds = select(1, secondsToTime(time_factor)), select(2, secondsToTime(time_factor))
                    if (tonumber(seconds) <= 0) then
                        squad:UnpauseConsole(i)
                    end
                end
                squad:showHUD(i)
            end

            local PlayerObject = get_dynamic_player(i)
            if (PlayerObject ~= 0) then

                local params = { }

                params.player = i
                params.x, params.y, params.z = read_vector3d(PlayerObject + 0x5C)

                local coords = squad:GetNearestSpawn(params)
                local x = format("%0.3f", coords[1])
                local y = format("%0.3f", coords[2])
                local z = format("%0.3f", coords[3])
                local d = format("%0.3f", coords[4])
                -- cprint("X: " .. x .. ", Y: " .. y .. ", Z: " .. z .. ", D: " .. d, 7+8)
            end
        end
    end
end

local function SendError(p, msg)
    squad:PauseConsole(p)
    rprint(p, msg)
    return false
end

local function isCommand(p, msg)
    if ( sub(msg[1], 1, 1) == "/" or sub(msg[1], 1, 1) == "\\" ) then
        if not votes.hasVoted[player] then
            squad:PauseConsole(p)
        end
        return true
    end
end

function OnPlayerChat(PlayerIndex, Message, Type)
    local response = nil

    if (votes.inProgress) then

        local voter = tonumber(PlayerIndex)
        local msg = stringSplit(Message)

        if (#msg == 0) then
            response = false
        end

        if not isCommand(voter, msg) then
            if (#msg == 1 and match(msg[1], "[0-9]")) then

                local nominee = tonumber(msg[1])

                if (nominee ~= voter) then
                    if (nominee < 17) then
                        squad:UnpauseConsole(voter)

                        local team = get_var(voter, "$team")
                        votes.total[nominee] = votes.total[nominee] + 1

                        votes.results[#votes.results + 1] = {nominee, team}

                        votes.hasVoted[voter] = true
                        response = false
                    else
                        response = SendError(voter, "Please enter a valid Player ID")
                    end
                else
                    response = SendError(voter, "You cannot vote for yourself!")
                end
            else
                response = SendError(voter, "Please enter a valid Player ID")
            end
        end
    end
    return response
end

function squad:PauseConsole(player)
    votes.pauseTimer[player] = 0
    votes.pauseConsole[player] = true
    cls(player, 25)
end

function squad:UnpauseConsole(player)
    votes.pauseTimer[player] = 0
    votes.pauseConsole[player] = false
end

function squad:GetPlayerCount()
    return tonumber(get_var(0, "$pn"))
end

local function MinMax(t, fn, type)
    if #t == 0 then return nil, nil end
    local x, y, z = 0, 0, 0

    local distance = 0
    if (type == "min") then
        distance = t[1][1]
    elseif (type == "max") then
        distance = t[#t][1]
    end

    for i = 2, #t do
        if fn(distance, t[i][1]) then
            distance = t[i][1]
            x, y, z = t[i][2], t[i][3], t[i][4]
        end
    end
    return x, y, z, distance
end

local function distanceFromPlayer(pX, pY, pZ, sX, sY, sZ)
    return sqrt((pX - sX) ^ 2 + (pY - sY) ^ 2 + (pZ - sZ) ^ 2)
end

local function Save(pX, pY, pZ, sX, sY, sZ)
    local distance = distanceFromPlayer(pX, pY, pZ, sX, sY, sZ)
    spawn_coordinates[#spawn_coordinates + 1] = {distance, sX, sY, sZ}
end

function squad:GetNearestSpawn(params)
    local params = params or nil

    if (params ~= nil) then
        local c = coordinates

        local player = params.player
        local pX, pY, pZ = params.x, params.y, params.z
        local team = get_var(player, "$team")
        spawn_coordinates = { }

        for i = 1, #c do
            if (c[i][5] == 0) then
                if (team == "red") then
                    Save(pX, pY, pZ, c[i][1], c[i][2], c[i][3])
                end
            elseif (c[i][5] == 1) then
                if (team == "blue") then
                    Save(pX, pY, pZ, c[i][1], c[i][2], c[i][3])
                end
            end
        end

        local x, y, z, distance = MinMax(spawn_coordinates, function(a, b) return a > b end, "min")
        return {x, y, z, distance}
    end
end

function squad:CalculateVotes()
    local tab = votes.results

    local temp = { }
    temp.red, temp.blue = { }, { }

    for k,v in pairs(tab) do
        if (k) then

            local nominee, nominee_team = v[1], v[2]
            local total = squad:GetVotes(nominee)

            if (nominee_team == "red") then
                temp.red[#temp.red + 1] = {nominee, total}
            elseif (nominee_team == "blue") then
                temp.blue[#temp.blue + 1] = {nominee, total}
            end
        end
    end

    local red = MinMax(temp.red, function(a, b) return a < b end, "min")
    local blue = MinMax(temp.blue, function(a, b) return a < b end, "min")
    return {red = red}
    return {blue = blue}
end

function squad:GetVotes(player)
    return votes.total[player] or 0
end

local function showTimeRemaining(player)
    local timeRemaining = gsub(votes.timeRemaining_msg, "%%time%%", votes.timeRemaining)
    rprint(player, timeRemaining)
end

function squad:showHUD(i)
    local P1Team = get_var(i, '$team')

    for j = 1, 16 do
        if player_present(j) then
            local P2Team = get_var(j, '$team')
            if (i ~= j and P1Team == P2Team) then

                local total_votes = squad:GetVotes(j)
                if (total_votes ~= nil) then

                    local msg = gsub(gsub(gsub(votes.msg, "%%name%%", get_var(j, '$name')),
                    "%%id%%", j), "%%votes%%", total_votes)

                    if not votes.pauseConsole[i] then
                        cls(i, 25)

                        if not votes.hasVoted[i] then
                            rprint(i, "========= [ VOTE FOR YOUR LEADER ] =========")
                        else
                            rprint(i, "========= [ YOU HAVE VOTED ] =========")
                        end

                        rprint(i, msg)
                        rprint(i, " ")

                        if not votes.hasVoted[i] then
                            rprint(i, "Type the Player ID you wish to vote for!")
                            rprint(i, "")
                        end
                        showTimeRemaining(i)
                    end
                end
            end
        end
    end
end

-- Clears the player console:
function cls(player, count)
    local count = count or 25
    for i = 1, count do
        rprint(player, " ")
    end
end

function stringSplit(inp, sep)
    if (sep == nil) then
        sep = "%s"
    end
    local t, i = {}, 1
    for str in gmatch(inp, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function secondsToTime(seconds)
    local seconds = tonumber(seconds)
    if (seconds <= 0) then
        return "00", "00";
    else
        local hours, mins, secs = format("%02.f", floor(seconds / 3600));
        mins = format("%02.f", floor(seconds / 60 - (hours * 60)));
        secs = format("%02.f", floor(seconds - hours * 3600 - mins * 60));
        return mins, secs
    end
end

--[[=====================================================================================================
    Huge credits to Devieth (it300) for the below function.
    It's crucial to making this mod work.
    Devith GitHub: https://github.com/it300/Halo-Lua
    Code obtained from <https://opencarnage.net/index.php?/topic/7732-self-solved-always-random-spawns/>

    This function will save a lot of time having to hard code spawn coordinates for each individual map!
]]--=====================================================================================================

function get_spawns()
    local spawns = { }
    local tag_array = read_dword( 0x40440000 )
    local scenario_tag_index = read_word( 0x40440004 )
    local scenario_tag = tag_array + scenario_tag_index * 0x20
    local scenario_tag_data = read_dword(scenario_tag + 0x14)

    local starting_location_reflexive = scenario_tag_data + 0x354
    local starting_location_count = read_dword(starting_location_reflexive)
    local starting_location_address = read_dword(starting_location_reflexive + 0x4)

    for i = 0, starting_location_count do
        local starting_location = starting_location_address + 52 * i
        local x, y, z = read_vector3d(starting_location)
        local r = read_float(starting_location + 0xC)
        local team = read_word(starting_location + 0x10)
        spawns[#spawns + 1] = {x, y, z, r, team}
    end
    return spawns
end
