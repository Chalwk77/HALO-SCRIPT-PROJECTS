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
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnTick()
    for i, t in pairs(players) do
        if (i and #t.suspects > 0 and t.clear(i)) then
            for s = 1, #t.suspects do
                rprint(i, t.suspects[s].name .. ': ' .. t.suspects[s]:score())
            end
        end
    end
end

local function StrSplit(str)
    local args = { }
    for arg in str:gmatch('([^%s]+)') do
        args[#args + 1] = arg:lower()
    end
    return args
end

local function HasPermission(Ply)
    local lvl = tonumber(get_var(Ply, '$lvl'))
    return (lvl >= 1 or rprint(Ply, 'Insufficient Permission') and false)
end

local function Getplayers(Ply, Arg)

    local pl = { }
    local suspect = Arg[2]

    if (suspect == 'me') then
        if (Ply ~= 0) then
            pl[#pl + 1] = Ply
        else
            rprint(Ply, 'Please enter a number between 1-16.')
        end
    elseif (suspect ~= nil and suspect:match('%d+')) then
        if player_present(suspect) then
            pl[#pl + 1] = suspect
        else
            rprint(Ply, 'Player #' .. suspect .. ' is not online')
        end
    elseif (suspect == 'all' or suspect == '*') then
        for i = 1, 16 do
            if player_present(i) then
                pl[#pl + 1] = i
            end
        end
    else
        rprint(Ply, 'Invalid Player ID. Usage: /' .. command .. ' [1-16 / me / all / *] [0/1]')
    end
    return pl
end

function OnCommand(Ply, CMD)
    local args = StrSplit(CMD)
    if (#args > 0 and args[1] == command and HasPermission(Ply)) then

        if (not args[3]:match('[10]')) then
            rprint(Ply, 'Invalid syntax. Use 1 for ON and 0 for OFF')
            return false
        elseif (args[3]:match('0')) then
            rprint(Ply, 'Hiding bot scores')
            players[Ply].suspects = {}
            return false
        end

        local pl = Getplayers(Ply, args)
        if (#pl > 0) then
            for i = 1, #pl do
                table.insert(players[Ply].suspects, {
                    name = get_var(pl[i], '$name'),
                    score = function()
                        local suffix = (not player_alive(pl[i]) and ' [respawning]' or '')
                        return get_var(pl[i], '$botscore') .. suffix
                    end
                })
            end
        end
        return false
    end
end

function OnJoin(Ply)
    players[Ply] = {
        suspects = {},
        clear = function(i)
            for _ = 1, 25 do
                rprint(i, ' ')
            end
            return true
        end
    }
end

function OnQuit(Ply)
    players[Ply] = nil
end

function OnScriptUnload()
    -- N/A
end