-- Aim Bot scores, by Chalwk.

-- Shows a players Aim Bot scores.
-- Command to show bot scores:
-- Syntax: /command [1-16/me/all/*] [0/1]

--
-- Script concept credit goes to mouseboyx.
-- He made an original version of this and released it on Open Carange.
--
-- This is my version of it.

api_version = '1.12.0.0'

local command = 'botscore'
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
    if get_var(0, '$gt') ~= 'n/a' then
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
        if #data.suspects > 0 then
            data:clear(playerId)
            for _, suspect in ipairs(data.suspects) do
                rprint(playerId, suspect.name .. ': ' .. suspect:score())
            end
        end
    end
end

local function stringSplit(str)
    local args = {}
    for arg in str:gmatch('%S+') do
        args[#args + 1] = arg:lower()
    end
    return args
end

local function hasPermission(playerId)
    return tonumber(get_var(playerId, '$lvl')) >= 1 or (rprint(playerId, 'Insufficient Permission') and false)
end

local function getPlayers(playerId, args)
    local t = {}
    local suspect = args[2]
    if suspect == 'me' and playerId ~= 0 then
        table.insert(t, playerId)
    elseif tonumber(suspect) and player_present(tonumber(suspect)) then
        table.insert(t, tonumber(suspect))
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

local function getShowScores(showScoresArg)
    return showScoresArg == '1' or showScoresArg == nil
end

local function addSuspect(playerId, suspect)
    table.insert(players[playerId].suspects, {
        name = get_var(suspect, '$name'),
        score = function()
            return get_var(suspect, '$botscore') .. (player_alive(suspect) and '' or ' [respawning]')
        end
    })
end

function OnCommand(playerId, cmd)
    local args = stringSplit(cmd)
    if args[1] == command and hasPermission(playerId) then
        local showScores = getShowScores(args[3])
        if not showScores then
            rprint(playerId, 'Hiding bot scores')
            players[playerId].suspects = {}
            return false
        end
        for _, pl in ipairs(getPlayers(playerId, args)) do
            addSuspect(playerId, pl)
        end
    end
end

function OnJoin(playerId)
    players[playerId] = { suspects = {}, clear = function(i) for _ = 1, 25 do rprint(i, ' ') end end }
end

function OnQuit(playerId)
    players[playerId] = nil
end

function OnScriptUnload()
    -- N/A
end