--[[
Script Name: Pussy Patrol

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby (chalwk)
]]--

api_version = "1.11.0.0"
coordinates = { }
new_timer = { }
players = { }
coordinates["bloodgulch"] = {
    -- Red Base
    { 95.688, -159.449, -0.100,     5.5, "red base"},
    -- Blue Base
    { 40.241, -79.123, -0.100,      5.5, "blue base"},
}
function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
end

function OnScriptUnload() end

function OnGameEnd()
    for i = 1, 16 do
        if player_present(i) then
            new_timer[i] = false
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    players[get_var(i, "$n")] = { }
    players[get_var(i, "$n")].Timer = 0
end

function OnPlayerSpawn(PlayerIndex)
    new_timer[PlayerIndex] = true
    players[get_var(PlayerIndex, "$n")].Timer = 0
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            local player_object = get_dynamic_player(i)
            if (player_object ~= 0) then
                if coordinates[mapname] ~= nil then
                    for j = 1, #coordinates[mapname] do
                        if player_alive(i) then
                            if inSphere(i, coordinates[mapname][j][1], coordinates[mapname][j][2], coordinates[mapname][j][3], coordinates[mapname][j][4]) == true then
                                if (new_timer[i] ~= false) then
                                    players[get_var(i, "$n")].Timer = players[get_var(i, "$n")].Timer + 0.030
                                    if (players[get_var(i, "$n")].Timer >= math.floor(1)) then
                                        new_timer[i] = false
                                        execute_command("msg_prefix \"\"")
                                        say_all(get_var(i, "$name") .. " is pussy patrolling the " ..coordinates[mapname][j][3])
                                        execute_command("msg_prefix \"** SERVER ** \"")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function inSphere(player, posX, posY, posZ, Radius)
    local player_object = get_dynamic_player(player)
    local Xaxis, Yaxis, Zaxis = read_vector3d(player_object + 0x5C)
    if (posX - Xaxis) ^ 2 +(posY - Yaxis) ^ 2 +(posZ - Zaxis) ^ 2 <= Radius then
        return true
    else
        return false
    end
end

function OnError(Message)
    print(debug.traceback())
end
