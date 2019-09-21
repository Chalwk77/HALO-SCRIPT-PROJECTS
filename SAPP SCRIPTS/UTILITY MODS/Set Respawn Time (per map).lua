--[[
--=====================================================================================================--
Script Name: Set Respawn Time (per map), for SAPP (PC & CE)
Description: This script will allow you to set player respawn time (in seconds) on a per-map/per-gametype basis

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)

- This script is included in the Velocity Multi-Mod with many improvements.
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local map = { }

-- Configuration [starts]...
--                       CTF | SLAYER | TEAM-S | KOTH |   TEAM-KOTH |   ODDBALL |   TEAM-ODDBALL |   RACE |   TEAM-RACE
map["beavercreek"] =    {2.5,  2.5,     2.5,     2.5,     2.5,          2.5,        2.5,             2.5,     2.5}
map["bloodgulch"] =     {2.5,  2.5,     2.5,     2.5,     2.5,          2.5,        2.5,             2.5,     2.5}
map["boardingaction"] = {2.5,  2.5,     2.5,     2.5,     2.5,          2.5,        2.5,             2.5,     2.5}
map["carousel"] =       {2.5,  2.5,     2.5,     2.5,     2.5,          2.5,        2.5,             2.5,     2.5}
map["dangercanyon"] =   {2.5,  2.5,     2.5,     2.5,     2.5,          2.5,        2.5,             2.5,     2.5}
map["deathisland"] =    {2.5,  2.5,     2.5,     2.5,     2.5,          2.5,        2.5,             2.5,     2.5}
map["gephyrophobia"] =  {2.5,  2.5,     2.5,     2.5,     2.5,          2.5,        2.5,             2.5,     2.5}
map["icefields"] =      {2.5,  2.5,     2.5,     2.5,     2.5,          2.5,        2.5,             2.5,     2.5}
map["infinity"] =       {2.5,  2.5,     2.5,     2.5,     2.5,          2.5,        2.5,             2.5,     2.5}
map["sidewinder"] =     {2.5,  2.5,     2.5,     2.5,     2.5,          2.5,        2.5,             2.5,     2.5}
map["timberland"] =     {2.5,  2.5,     2.5,     2.5,     2.5,          2.5,        2.5,             2.5,     2.5}
map["hangemhigh"] =     {2.5,  2.5,     2.5,     2.5,     2.5,          2.5,        2.5,             2.5,     2.5}
map["ratrace"] =        {2.5,  2.5,     2.5,     2.5,     2.5,          2.5,        2.5,             2.5,     2.5}
map["damnation"] =      {2.5,  2.5,     2.5,     2.5,     2.5,          2.5,        2.5,             2.5,     2.5}
map["putput"] =         {2.5,  2.5,     2.5,     2.5,     2.5,          2.5,        2.5,             2.5,     2.5}
map["prisoner"] =       {2.5,  2.5,     2.5,     2.5,     2.5,          2.5,        2.5,             2.5,     2.5}
map["wizard"] =         {2.5,  2.5,     2.5,     2.5,     2.5,          2.5,        2.5,             2.5,     2.5}
map["longest"] =        {2.5,  2.5,     2.5,     2.5,     2.5,          2.5,        2.5,             2.5,     2.5}

-- To add your own maps, simply repeat the structure above, like so:
map["map_name_here"] = {0, 0, 0, 0, 0, 0, 0, 0, 0} -- respawn time in seconds

-- Configuration [ends] <<----------

-- Do not touch anything below unless you know what you're doing.
local _error
local mapname
local spawntime

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], "OnPlayerKill")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
end

function OnScriptUnload()
    --
end

function OnNewGame()
    mapname = get_var(1, "$map")
    if (map[mapname] == nil) then
        _error = true
        error('[RESPAWN SCRIPT] ' .. mapname .. ' is not listed in the map table.')
    else
        local function getSpawnTime()
            local respawn_time
            if (get_var(1, "$gt") == "ctf") then
                respawn_time = map[mapname][1]
            elseif (get_var(1, "$gt") == "slayer") then
                if not getTeamPlay() then
                    respawn_time = map[mapname][2]
                else
                    respawn_time = map[mapname][3]
                end
            elseif (get_var(1, "$gt") == "koth") then
                if not getTeamPlay() then
                    respawn_time = map[mapname][4]
                else
                    respawn_time = map[mapname][5]
                end
            elseif (get_var(1, "$gt") == "oddball") then
                if not getTeamPlay() then
                    respawn_time = map[mapname][6]
                else
                    respawn_time = map[mapname][7]
                end
            elseif (get_var(1, "$gt") == "race") then
                if not getTeamPlay() then
                    respawn_time = map[mapname][8]
                else
                    respawn_time = map[mapname][9]
                end
            end
            return respawn_time
        end
        spawntime = tonumber(getSpawnTime)
    end
end

function OnPlayerKill(PlayerIndex)
    if not (_error) then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, spawntime * 33)
    end
end

function getTeamPlay()
    if (get_var(0, "$ffa") == "0") then
        return true
    else
        return false
    end
end

function OnError(Message)
    print(debug.traceback())
end
