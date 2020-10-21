--[[
--=====================================================================================================--
Script Name: Rage-Quit, for SAPP (PC & CE)
Description: Rage-Quit announcer

Copyright (c) 2016-2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Config Starts --
local rage_quit_message = "%vname% rage quit because of %kname%"

-- A player is considered raging if they quit before "cool_down" elapses, after being killed.
local cool_down = 10

-- ========= TOP RANKED SUPPORT ========= --
--===========================================================================--
-- If you're using my "Top Ranked" script, set this to true:
local rank_system_support = true

-- Credits to deducted for raging:
local penalty = 200

-- Top Ranked script Name: Exact name (without .txt)
local rank_script = "Top Ranked"

-- Do not edit unless you know what you're doing.
-- Refer to config section of Top Ranked script for details on this setting.
local ClientIndexType = 2
--===========================================================================--

-- A message relay function temporarily removes the server prefix
-- and will restore it to this when the relay is finished:
local server_prefix = "**SAPP**"
-- Config Ends --

local players = { }
local gsub = string.gsub

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    if (get_var(0, "$gt") ~= "n/a") then
        players = { }
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, false)
            end
        end
    end
end

local function AnnounceRage(p)
    local str = gsub(gsub(rage_quit_message, "%%vname%%", p.vname), "%%kname%%", p.kname)
    execute_command("msg_prefix \"\"")
    say_all(str)
    execute_command("msg_prefix \" " .. server_prefix .. "\"")
end

function OnTick()
    for i, player in pairs(players) do
        if (i) and (player.killer) then
            player.timer = player.timer - 1 / 30
            if (player.timer > 0) and not player_present(i) then
                AnnounceRage(players[i])
                if (rank_system_support) then
                    execute_command('lua_call "' .. rank_script .. '" UpdateRageQuit ' .. player.ip .. ' ' .. penalty)
                end
                players[i] = nil
            elseif (player.timer <= 0) then
                InitPlayer(i, false)
            end
        end
    end
end

function InitPlayer(Ply, Reset)
    if (Reset) then
        players[Ply] = nil
    else
        players[Ply] = {
            ip = GetIP(Ply),
            timer = cool_down, killer = nil,
            vname = get_var(Ply, "$name"), kname = ""
        }
    end
end

function OnPlayerConnect(Ply)
    InitPlayer(Ply, false)
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    local k, v = tonumber(KillerIndex), tonumber(VictimIndex)
    if (k > 0) and (k ~= v) then
        players[v].kname = get_var(k, "$name")
        players[v].killer = k
    end
end

function GetIP(Ply)
    local IP = get_var(Ply, "$ip")
    if (ClientIndexType == 1) then
        IP = IP:match("%d+.%d+.%d+.%d+")
    end
    return IP
end

function OnScriptUnload()

end