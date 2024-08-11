-- Aim Bot scores, by Chalwk.

-- Shows a players Aim Bot scores.
-- Command to show bot scores:
-- Syntax: /command [1-16/me/all/*] [0/1]

--
-- Script concept credit goes to mouseboyx.
-- He made an original version of this and released it on Open Carange.
--
-- This is my version of it.

local command = 'botscore'

api_version = '1.12.0.0'

local players = {}

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        players = {}
        for playerId = 1, 16 do
            if player_present(playerId) then
                OnJoin(playerId)
            end
        end
    end
end

function OnTick()
    for playerId, data in pairs(players) do
        if playerId and #data.suspects > 0 then
            data:clear(playerId)
            for _, suspect in ipairs(data.suspects) do
                rprint(playerId, suspect.name .. ': ' .. suspect:score())
            end
        end
    end
end

local function stringSplit(str)
    local args = { }
    for arg in str:gmatch('([^%s]+)') do
        args[#args + 1] = arg:lower()
    end
    return args
end

local function hasPermission(playerId)
    local lvl = tonumber(get_var(playerId, '$lvl'))
    return (lvl >= 1 or rprint(playerId, 'Insufficient Permission') and false)
end

local function getPlayers(playerId, args)
    local t = {}
    local suspect = args[2]

    if suspect == 'me' then
        if playerId ~= 0 then
            table.insert(t, playerId)
        else
            rprint(playerId, 'Please enter a number between 1-16.')
        end
    elseif tonumber(suspect) then
        if player_present(tonumber(suspect)) then
            table.insert(t, tonumber(suspect))
        else
            rprint(playerId, 'Player #' .. suspect .. ' is not online')
        end
    elseif suspect == 'all' or suspect == '*' then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(t, i)
            end
        end
    else
        rprint(playerId, 'Invalid Player ID. Usage: /' .. command .. ' [1-16 / me / all / *] [0/1]')
    end
    return t
end

-- Helper function to process showScores argument
local function getShowScores(showScoresArg)
    return showScoresArg == '1' or (showScoresArg == nil and true)
end

-- Function to add a suspect to a player's suspect list
local function addSuspect(playerId, suspect)
    local suspectTable = {
        name = get_var(suspect, '$name'),
        score = function()
            local suffix = player_alive(suspect) and '' or ' [respawning]'
            return get_var(suspect, '$botscore') .. suffix
        end
    }
    table.insert(players[playerId].suspects, suspectTable)
end

function onCommand(playerId, cmd)
    local args = stringSplit(cmd)
    if #args > 0 and args[1] == command and hasPermission(playerId) then
        local showScores = getShowScores(args[3])

        if not showScores then
            rprint(playerId, 'Hiding bot scores')
            players[playerId].suspects = {}
            return false
        end

        local pl = getPlayers(playerId, args)
        if #pl > 0 then
            for i = 1, #pl do
                addSuspect(playerId, pl[i])
            end
        end
    end
end

function OnJoin(playerId)
    players[playerId] = {
        suspects = {},
        clear = function(i)
            for _ = 1, 25 do
                rprint(i, ' ')
            end
            return true
        end
    }
end

function OnQuit(playerId)
    players[playerId] = nil
end

function OnScriptUnload()
    -- N/A
end