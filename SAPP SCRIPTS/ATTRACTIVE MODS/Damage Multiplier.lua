--[[
--=====================================================================================================--
Script Name: Damage Multiplier, for SAPP (PC & CE)
Description: Set the damage multiplier of any player.
             Command Syntax: /damage [id] [range]
             * Use '-1' for the range definition to reset someone's multiplier.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

-- config starts --
-- Custom command:
-- Syntax: /damage [player id] [range]
--
local command = 'damage'

-- Damage range must be between these min/max values:
--
local min_max = { 0, 100 }

-- Permission level required to execute /command:
--
local permission_level = 4

-- config ends --

local players = { }

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], 'OnDamage')
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

local function stringSplit(s)
    local t = { }
    for arg in s:gmatch('([^%s]+)') do
        t[#t + 1] = arg:lower()
    end
    return t
end

local function hasPermission(Ply)
    local lvl = tonumber(get_var(Ply, '$lvl'))
    return (lvl >= permission_level)
end

function OnCommand(Ply, CMD)

    local args = stringSplit(CMD)
    if (args[1] == command) then

        if hasPermission(Ply) then

            local min = min_max[1]
            local max = min_max[2]

            local tid = (args[2] and args[2]:match('%d+') and tonumber(args[2]))
            local range = (args[3] and args[3]:match('%d+') and tonumber(args[3]))
            local p = players[tid]

            if (not tid) then
                rprint(Ply, 'Invalid player id. Please enter a number between 1-16')
                return false
            elseif (not player_present(tid)) then
                rprint(Ply, 'Player #' .. tid .. ' is not online.')
                return false
            elseif (range == -1) then
                p.mult = 0
                rprint(Ply, 'Resetting ' .. p.name .. "'s damage multiplier")
                return false
            elseif not (range >= min and range <= max) then
                rprint(Ply, 'Invalid range. Please enter a number between ' .. min .. '/' .. max)
                return false
            end

            p.mult = range
            rprint(Ply, 'Setting ' .. p.name .. "'s damage multiplier to " .. range .. 'x')
        else
            rprint(Ply, 'You do not have permission to execute that command.')
        end

        return false
    end
end

function OnJoin(Ply)
    players[Ply] = {
        mult = 0,
        name = get_var(Ply, '$name')
    }
end

function OnQuit(Ply)
    players[Ply] = nil
end

function OnDamage(_, Killer, _, Damage)

    local k = tonumber(Killer)
    k = players[k]

    if (k and k.mult ~= 0) then
        return true, Damage * k.mult
    end
end

function OnScriptUnload()
    -- N/A
end