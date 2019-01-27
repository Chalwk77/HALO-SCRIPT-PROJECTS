--[[
--=====================================================================================================--
Script Name: Set Respawn Time (per map), for SAPP (PC & CE)
Description: This script will allow you to set player respawn time (in seconds) on a per-map/per-gametype basis

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
map = { }

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
-- Configuration [ends] <<----------

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], "OnPlayerKill")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
end

function OnScriptUnload()
    --
end

function OnNewGame()
    mapname = get_var(1, "$map")

end

function OnPlayerKill(PlayerIndex)
    local player = get_player(PlayerIndex)
    write_dword(player + 0x2C, tonumber(getSpawnTime()) * 33)
end

function getGameType()
    local spawntime
    if (get_var(1, "$gt") == "ctf") then
            spawntime = map[mapname][1]
        elseif (get_var(1, "$gt") == "slayer") then
            if not getTeamPlay() then
                spawntime = map[mapname][2]
            else
                spawntime = map[mapname][3]
            end
        elseif (get_var(1, "$gt") == "koth") then
            if not getTeamPlay() then
                spawntime = map[mapname][4]
            else
                spawntime = map[mapname][5]
            end
        elseif (get_var(1, "$gt") == "oddball") then
            if not getTeamPlay() then
                spawntime = map[mapname][6]
            else
                spawntime = map[mapname][7]
            end
        elseif (get_var(1, "$gt") == "race") then
            if not getTeamPlay() then
                spawntime = map[mapname][8]
            else
                spawntime = map[mapname][9]
            end
        end
    return spawntime
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
