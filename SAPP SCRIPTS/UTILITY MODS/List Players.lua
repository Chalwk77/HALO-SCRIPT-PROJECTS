--[[
--=====================================================================================================--
Script Name: List Players, for SAPP (PC & CE)
Description: An alternative player list mod (Overrides SAPP's built in /pl command.)

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]

api_version = '1.12.0.0'

-- config starts --
-- Command to show custom player list:
local command = "pls"

-- Minimum level required to execute custom command:
local level = 1

-- config ends --

local ffa
local players = {}

local len = string.len
local lower = string.lower
local match = string.match
local concat = table.concat
local gmatch = string.gmatch

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], "OnJoin")
    register_callback(cb['EVENT_LEAVE'], "OnQuit")
    register_callback(cb['EVENT_COMMAND'], "OnCommand")
    register_callback(cb['EVENT_GAME_START'], "OnStart")
    OnStart()
end

local function InitPlayer(Ply)
    local team = (not ffa and get_var(Ply, "$team") or "FFA")
    players[Ply] = {
        id = Ply,
        team = team,
        name = get_var(Ply, "$name"),
        ip = match(get_var(Ply, "$ip"), "%d+.%d+.%d+.%d+")
    }
end

function OnStart()
    if (get_var(0, "$gt") ~= 'n/a') then
        ffa = (get_var(0, "$ffa") == "1")
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i)
            end
        end
    end
end

function OnJoin(Ply)
    InitPlayer(Ply)
end

function OnQuit(Ply)
    players[Ply] = nil
end

local function Respond(Ply, Msg)
    return (Ply == 0 and cprint(Msg) or rprint(Ply, Msg))
end

local function NoPerm(Ply)
    Respond(Ply, "Such command, much nope.")
    return false
end

local function HasPermission(Ply)
    local lvl = tonumber(get_var(Ply, "$lvl"))
    return (Ply == 0 or lvl >= level or NoPerm(Ply))
end

local function Spaces(str, pos)
    local spaces = ""
    for _ = 1, pos - len(str) do
        spaces = spaces .. " "
    end
    return spaces
end

function OnCommand(Ply, CMD)
    if (CMD:match('([^%s]+)') == command) then
        if HasPermission(Ply) then
            local t = {}
            for i, v in pairs(players) do
                local name = v.name
                local team = v.team
                local ip = v.ip
                t[i] = name .. Spaces(name, 16) .. team .. Spaces(team, 16) .. ip
            end
            local list = (#t > 0 and concat(t, '\n') or Respond(Ply, "No players online"))
            if (list) then
                Respond(Ply, "NAME            TEAM            IP\n")
                Respond(Ply, list)
            end
        end
        return false
    end
end

function OnScriptUnload()
    -- N/A
end