--[[
--=====================================================================================================--
Script Name: Kill Zones, for SAPP (PC & CE)
Description: When a player enters a kill zone, they have 15 seconds to exit otherwise they are killed.

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
players = { }
kill_timer = { }
coordinates = { }
warning_timer = { }
kill_init_timer = { }
-- ===================================================== CONFIGURATION STARTS ===================================================== --
local dir = 'sapp\\coordinates.txt'
-- label                =       Kill Zone Label.
-- team                 =       Player Team: "red", "blue" - "ffa" or "all"
-- x,y,z radius         =       Kill Zone coordinates.
-- Warning Delay        =       Amount of time until player is warned after entering kill zone. 0 = warn immediately
-- Seconds until death  =       After entering Kill Zone, they have this many seconds to leave otherwise they are killed.

-- Messages:
--      Warning! You have entered Kill Zone 1
--      You will be killed in 15 seconds if you don't leave this area!
--      You have been killed because you were out of bounds!

-- Labels can be anything you like.
-- Teams:
--      Red, Only players on Red Team will trigger this kill zone.
--      Blue, Only players on Blue Team will trigger this kill zone.
--      FFA, all players will trigger this kill zone

-- To customize your own kill zone coordinates, Type "/coords" in-game to retrieve your current coordinates.
-- This data will be saved to a txt file called coordinates.txt located in "<server root directory>/sapp/coordinates.txt".

--      label            team           x,y,z                radius       Warning Dealy         Seconds until death
coordinates["bloodgulch"] = {
    { "Kill Zone 1",    "FFA", 33.631, - 65.569, 0.370,         5,              0,                      15 },
    { "Kill Zone 2",    "FFA", 41.703, - 128.663, 0.247,        5,              0,                      15 },
    { "Kill Zone 3",    "FFA", 50.655, - 87.787, 0.079,         5,              0,                      15 },
    { "Kill Zone 4",    "FFA", 101.940, - 170.440, 0.197,       5,              0,                      15 },
    { "Kill Zone 5",    "FFA", 81.617, - 116.049, 0.486,        5,              0,                      15 },
    { "Kill Zone 6",    "FFA", 78.208, - 152.914, 0.091,        5,              0,                      15 },
    { "Kill Zone 7",    "FFA", 64.178, - 176.802, 3.960,        5,              0,                      15 },
    { "Kill Zone 8",    "FFA", 102.312, - 144.626, 0.580,       5,              0,                      15 },
    { "Kill Zone 9",    "FFA", 86.825, - 172.542, 0.215,        5,              0,                      15 },
    { "Kill Zone 10",   "FFA", 65.846, - 70.301, 1.690,         5,              0,                      15 },
    { "Kill Zone 11",   "FFA", 28.861, - 90.757, 0.303,         5,              0,                      15 },
    { "Kill Zone 12",   "FFA", 46.341, - 64.700, 1.113,         5,              0,                      15 },
}

-- To add other maps, simply repeat the structure above, like so:
coordinates["mapname_here"] = {
    { "label", "red", x, y, z, radius, warning_delay, seconds_until_death },
    { "label", "red", x, y, z, radius, warning_delay, seconds_until_death },
    { "label", "blue", x, y, z, radius, warning_delay, seconds_until_death },
    { "label", "blue", x, y, z, radius, warning_delay, seconds_until_death },
    { "label", "FFA", x, y, z, radius, warning_delay, seconds_until_death },
}
-- ===================================================== CONFIGURATION ENDS ======================================================= --
function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    TeamPlay = CheckIfTeamPlay()
    for i = 1, 16 do
        if player_present(i) then
            -- reset timers --
            kill_timer[i] = false
            players[get_var(i, "$n")].warning_timer = 0
            players[get_var(i, "$n")].kill_init_timer = 0
        end
    end
end

function OnScriptUnload() end

function OnNewGame()
    mapname = get_var(0, "$map")
    TeamPlay = CheckIfTeamPlay()
    for i = 1, 16 do
        if player_present(i) then
            -- reset timers --
            kill_timer[i] = false
            players[get_var(i, "$n")].warning_timer = 0
            players[get_var(i, "$n")].kill_init_timer = 0
        end
    end
end

function OnGameEnd()
    for i = 1, 16 do
        if player_present(i) then
            -- reset timers --
            kill_timer[i] = false
            players[get_var(i, "$n")].warning_timer = 0
            players[get_var(i, "$n")].kill_init_timer = 0
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    kill_timer[PlayerIndex] = false
    -- create empty table for this player --
    players[get_var(PlayerIndex, "$n")] = { }
    -- set initial counters to 0 --
    players[get_var(PlayerIndex, "$n")].warning_timer = 0
    players[get_var(PlayerIndex, "$n")].kill_init_timer = 0
end

function OnPlayerLeave(PlayerIndex)
    -- reset timers --
    kill_timer[PlayerIndex] = false
    players[get_var(PlayerIndex, "$n")].warning_timer = 0
    players[get_var(PlayerIndex, "$n")].kill_init_timer = 0
end

function OnPlayerSpawn(PlayerIndex)
    -- reset timers --
    kill_timer[PlayerIndex] = false
    players[get_var(PlayerIndex, "$n")].warning_timer = 0
    players[get_var(PlayerIndex, "$n")].kill_init_timer = 0
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    -- reset timers --
    kill_timer[PlayerIndex] = false
    players[get_var(PlayerIndex, "$n")].warning_timer = 0
    players[get_var(PlayerIndex, "$n")].kill_init_timer = 0
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            local player_object = get_dynamic_player(i)
            if (player_object ~= 0) then
                -- validate coordinates table
                if coordinates[mapname] ~= nil then
                    for j = 1, #coordinates[mapname] do
                        if player_alive(i) then
                            -- check if player is in kill zone
                            if GEOinSpherePlayer(i, coordinates[mapname][j][3], coordinates[mapname][j][4], coordinates[mapname][j][5], coordinates[mapname][j][6]) == true then
                                -- Check player's team and varify against table data
                                if getteam(i) == tostring(coordinates[mapname][j][2]) then
                                    -- create new warning timer --
                                    players[get_var(i, "$n")].warning_timer = players[get_var(i, "$n")].warning_timer + 0.030
                                    -- monitor warning timer until it reaches the value of "Warning Dealy" (coordinates[mapname][j][7])
                                    if players[get_var(i, "$n")].warning_timer >= math.floor(coordinates[mapname][j][7]) then
                                        -- clear the player's console to prevent duplicate messages (spam)
                                        ClearConsole(i)
                                        local minutes, seconds = secondsToTime(players[get_var(i, "$n")].warning_timer, 2)
                                        -- initiate kill timer
                                        kill_timer[i] = true
                                        -- send player the warning
                                        rprint(i, "|cWarning! You have entered " .. tostring(coordinates[mapname][j][1]) .. ".")
                                        rprint(i, "|cYou will be killed in " .. coordinates[mapname][j][8] - math.floor(seconds) .. " seconds if you don't leave this area!")
                                        rprint(i, "|c ")
                                        rprint(i, "|c ")
                                        rprint(i, "|c ")
                                        rprint(i, "|c ")
                                        rprint(i, "|c ")
                                    end
                                    if (kill_timer[i] == true) then
                                        -- create new kill timer
                                        players[get_var(i, "$n")].kill_init_timer = players[get_var(i, "$n")].kill_init_timer + 0.030
                                        -- monitor killer timer until it reaches the value of "Seconds until death" (coordinates[mapname][j][8])
                                        if players[get_var(i, "$n")].kill_init_timer >= math.floor(coordinates[mapname][j][8]) then
                                            -- clear the player's console to prevent duplicate messages (spam)
                                            ClearConsole(i)
                                            -- reset timers --
                                            kill_timer[i] = false
                                            players[get_var(i, "$n")].warning_timer = 0
                                            players[get_var(i, "$n")].kill_init_timer = 0
                                            -- kill Player
                                            execute_command("kill " .. i)
                                            -- send player the unfateful message
                                            rprint(i, "|c=========================================================")
                                            rprint(i, "|cYou were killed for being out of bounds!")
                                            rprint(i, "|c=========================================================")
                                            rprint(i, "|c ")
                                            rprint(i, "|c ")
                                            rprint(i, "|c ")
                                            rprint(i, "|c ")
                                            rprint(i, "|c ")
                                        end
                                    end
                                else
                                    -- reset timers --
                                    kill_timer[i] = false
                                    players[get_var(i, "$n")].warning_timer = 0
                                    players[get_var(i, "$n")].kill_init_timer = 0
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function GEOinSpherePlayer(PlayerIndex, posX, posY, posZ, Radius)
    local player_object = get_dynamic_player(PlayerIndex)
    local Xaxis, Yaxis, Zaxis = read_vector3d(player_object + 0x5C)
    if (posX - Xaxis) ^ 2 +(posY - Yaxis) ^ 2 +(posZ - Zaxis) ^ 2 <= Radius then
        return true
    else
        return false
    end
end

function secondsToTime(seconds, places)
    local minutes = math.floor(seconds / 60)
    seconds = seconds % 60
    if places == 2 then
        return minutes, seconds
    end
end

function ClearConsole(PlayerIndex)
    for clear = 1, 25 do
        rprint(PlayerIndex, " ")
    end
end

function CheckIfTeamPlay()
    if get_var(0, "$ffa") == "0" then
        return true
    else
        return false
    end
end

function getteam(PlayerIndex)
    if PlayerIndex ~= nil and PlayerIndex ~= "-1" then
        if TeamPlay then
            if get_var(PlayerIndex, "$team") == "red" then
                team = "red"
            elseif get_var(PlayerIndex, "$team") == "blue" then
                team = "blue"
            end
        else
            team = "FFA" or "ffa" or "ALL" or "all"
        end
        return team
    end
    return nil
end

function OnServerCommand(PlayerIndex, Command)
    local response = nil
    local command = string.lower(Command)
    if (command == "coords") then
        if (tonumber(get_var(PlayerIndex, "$lvl"))) > 0 then
            local posX, posY, posZ = GetObjectCoords(PlayerIndex)
            local team = getteam(PlayerIndex)
            local data =("Map: " .. tostring(mapname) .. ", Team: " .. tostring(team) .. ", Coordinates: " .. tostring(posX) .. ", " .. tostring(posY) .. ", " .. tostring(posZ))
            local file = io.open(dir, "a+")
            if file ~= nil then
                file:write(data .. "\n")
                file:close()
            end
            rprint(PlayerIndex, data)
            cprint(data, 2 + 8)
            response = false
        else
            response = true
        end
    end
    return response
end

function GetObjectCoords(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        local posX, posY, posZ = read_vector3d(get_dynamic_player(PlayerIndex) + 0x5C)
        local VehicleObjID = read_dword(player_object + 0x11C)
        local vehicle = get_object_memory(VehicleObjID)
        if (vehicle ~= 0 and vehicle ~= nil) then
            local VehiPosX, VehiPosY, VehiPosZ = read_vector3d(vehicle + 0x5C)
            posX = posX + VehiPosX
            posY = posY + VehiPosY
            posZ = posZ + VehiPosZ
        end
        return math.round(posX, 2), math.round(posY, 2), math.round(posZ, 2)
    end
    return nil
end
            
function math.round(num, idp)
    return tonumber(string.format("%." ..(idp or 0) .. "f", num))
end

function OnError(Message)
    print(debug.traceback())
end
