--[[
--=====================================================================================================--
Script Name: Spawn From Sky, for SAPP (PC & CE)
Description: This mod will spawn the player from the sky.
             The player will have 7s of invulnerability.

~ requested by RhaegarTargaryen on opencarnage.net

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
~ Created by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]

api_version = '1.12.0.0'

-- Configuration [starts]
local height_from_ground = 35
local invulnerability_time = 9

base_loc = { }
base_loc["bloodgulch"] = {
    -- red x,y,z
    { 95.687797546387, -159.44900512695, -0.10000000149012 },
    -- blue x,y,z
    { 40.240600585938, -79.123199462891, -0.10000000149012 }
}
base_loc["deathisland"] = {
    { -26.576030731201, -6.9761986732483, 9.6631727218628 },
    { 29.843469619751, 15.971487045288, 8.2952880859375 }
}
base_loc["icefields"] = {
    { 24.85000038147, -22.110000610352, 2.1110000610352 },
    { -77.860000610352, 86.550003051758, 2.1110000610352 }
}
base_loc["infinity"] = {
    { 0.67973816394806, -164.56719970703, 15.039022445679 },
    { -1.8581243753433, 47.779975891113, 11.791272163391 }
}
base_loc["sidewinder"] = {
    { -32.038200378418, -42.066699981689, -3.7000000476837 },
    { 30.351499557495, -46.108001708984, -3.7000000476837 }
}
base_loc["timberland"] = {
    { 17.322099685669, -52.365001678467, -17.751399993896 },
    { -16.329900741577, 52.360000610352, -17.741399765015 }
}
base_loc["dangercanyon"] = {
    { -12.104507446289, -3.4351840019226, -2.2419033050537 },
    { 12.007399559021, -3.4513700008392, -2.2418999671936 }
}
base_loc["beavercreek"] = {
    { 29.055599212646, 13.732000350952, -0.10000000149012 },
    { -0.86037802696228, 13.764800071716, -0.0099999997764826 }
}
base_loc["boardingaction"] = {
    { 1.723109960556, 0.4781160056591, 0.60000002384186 },
    { 18.204000473022, -0.53684097528458, 0.60000002384186 }
}
base_loc["carousel"] = {
    { 5.6063799858093, -13.548299789429, -3.2000000476837 },
    { -5.7499198913574, 13.886699676514, -3.2000000476837 }
}
base_loc["chillout"] = {
    { 7.4876899719238, -4.49059009552, 2.5 },
    { -7.5086002349854, 9.750340461731, 0.10000000149012 }
}
base_loc["damnation"] = {
    { 9.6933002471924, -13.340399742126, 6.8000001907349 },
    { -12.17884349823, 14.982703208923, -0.20000000298023 }
}
base_loc["gephyrophobia"] = {
    { 26.884338378906, -144.71551513672, -16.049139022827 },
    { 26.727857589722, 0.16621616482735, -16.048349380493 }
}
base_loc["hangemhigh"] = {
    { 13.047902107239, 9.0331249237061, -3.3619771003723 },
    { 32.655700683594, -16.497299194336, -1.7000000476837 }
}
base_loc["longest"] = {
    { -12.791899681091, -21.6422996521, -0.40000000596046 },
    { 11.034700393677, -7.5875601768494, -0.40000000596046 }
}
base_loc["prisoner"] = {
    { -9.3684597015381, -4.9481601715088, 5.6999998092651 },
    { 9.3676500320435, 5.1193399429321, 5.6999998092651 }
}
base_loc["putput"] = {
    { -18.89049911499, -20.186100006104, 1.1000000238419 },
    { 34.865299224854, -28.194700241089, 0.10000000149012 }
}
base_loc["ratrace"] = {
    { -4.2277698516846, -0.85564690828323, -0.40000000596046 },
    { 18.613000869751, -22.652599334717, -3.4000000953674 }
}
base_loc["wizard"] = {
    { -9.2459697723389, 9.3335800170898, -2.5999999046326 },
    { 9.1828498840332, -9.1805400848389, -2.5999999046326 }
}
-- Configuration [ends] -------------------------

players = {}
init_timer = {}
first_join = {}

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_PRESPAWN'], 'OnPlayerPrespawn')
end

function OnScriptUnload()
    --
end

function OnPlayerJoin(PlayerIndex)
    players[get_var(PlayerIndex, "$name")] = { }
    players[get_var(PlayerIndex, "$name")].timer = 0
    
    init_timer[PlayerIndex] = true
    first_join[PlayerIndex] = true
end

function OnPlayerLeave(PlayerIndex)
    if init_timer == true then init_timer[PlayerIndex] = false end
    if first_join == true then first_join[PlayerIndex] = false end
    players[get_var(PlayerIndex, "$name")].timer = 0
end

function OnTick()
    for i = 1,16 do 
        if player_present(i) then
            if (init_timer[i] == true) then
                timeUntilRestore(i)
            end
        end
    end
end

function timeUntilRestore(PlayerIndex)
    players[get_var(PlayerIndex, "$name")].timer = players[get_var(PlayerIndex, "$name")].timer + 0.030
    if (players[get_var(PlayerIndex, "$name")].timer >= (invulnerability_time)) then
        players[get_var(PlayerIndex, "$name")].timer = 0
        init_timer[tonumber(PlayerIndex)] = false
        execute_command("ungod " .. tonumber(PlayerIndex))
    end
end

function OnPlayerPrespawn(PlayerIndex)
    if (first_join[PlayerIndex] == true) then
        first_join[PlayerIndex] = false
        
        local team = get_var(PlayerIndex, "$team")
        if (team == "red") then
            Teleport(PlayerIndex, 1)
        elseif (team == "blue") then
            Teleport(PlayerIndex, 2)
        end
        
    end
end

function Teleport(PlayerIndex, TableIndex)
    local map = get_var(0, "$map")
    write_vector3d(get_dynamic_player(PlayerIndex) + 0x5C, 
        base_loc[map][tonumber(TableIndex)][1], 
        base_loc[map][tonumber(TableIndex)][2], 
        base_loc[map][tonumber(TableIndex)][3] + math.floor(height_from_ground))
    execute_command("god " .. tonumber(PlayerIndex))
end