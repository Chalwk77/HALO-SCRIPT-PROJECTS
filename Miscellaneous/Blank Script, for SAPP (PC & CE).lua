--[[
--=====================================================================================================--
Script Name: Blank Script, for SAPP (PC & CE)
--=====================================================================================================--
]]-- 

api_version = "1.11.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_ECHO'],                 "OnEcho")
    register_callback(cb['EVENT_SNAP'],                 "OnSnap")
    register_callback(cb['EVENT_CAMP'],                 "OnCamp")
    register_callback(cb['EVENT_WARP'],                 "OnWarp")
    register_callback(cb['EVENT_TICK'],                 "OnTick")
    register_callback(cb['EVENT_LOGIN'],                "OnLogin")
    register_callback(cb['EVENT_SCORE'],                "OnScore")
    register_callback(cb['EVENT_BETRAY'],               "OnBetray")
    register_callback(cb['EVENT_SUICIDE'],              "OnSuicide")
    register_callback(cb['EVENT_GAME_END'],             "OnGameEnd")
    register_callback(cb['EVENT_GAME_START'],           "OnNewGame")
    register_callback(cb['EVENT_MAP_RESET'],            "OnMapReset")
    register_callback(cb['EVENT_AREA_EXIT'],            "OnAreaExit")
    register_callback(cb['EVENT_AREA_ENTER'],           "OnAreaEnter")
    register_callback(cb['EVENT_TEAM_SWITCH'],          "OnTeamSwitch")
    register_callback(cb['EVENT_JOIN'],                 "OnPlayerJoin")
    register_callback(cb['EVENT_CHAT'],                 "OnPlayerChat")
    register_callback(cb['EVENT_WEAPON_PICKUP'],        "OnWeaponDrop")
    register_callback(cb['EVENT_KILL'],                 "OnPlayerKill")
    register_callback(cb['EVENT_ALIVE'],                "OnCheckAlive")
    register_callback(cb['EVENT_DIE'],                  "OnPlayerDeath")
    register_callback(cb['EVENT_SPAWN'],                "OnPlayerSpawn")
    register_callback(cb['EVENT_LEAVE'],                "OnPlayerLeave")
    register_callback(cb['EVENT_OBJECT_SPAWN'],         "OnObjectSpawn")
    register_callback(cb['EVENT_VEHICLE_EXIT'],         "OnVehicleExit")
    register_callback(cb['EVENT_WEAPON_DROP'],          "OnWeaponPickup")
    register_callback(cb['EVENT_VEHICLE_ENTER'],        "OnVehicleEntry")
    register_callback(cb['EVENT_COMMAND'],              "OnServerCommand")
    register_callback(cb['EVENT_PREJOIN'],              "OnPlayerPrejoin")
    register_callback(cb['EVENT_PRESPAWN'],             "OnPlayerPrespawn")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'],   "OnDamageApplication")

end

function OnEcho()
    
end

function OnSnap(PlayerIndex, SnapScore) 

end

function OnCamp(PlayerIndex, CampKills) 

end

function OnWarp(PlayerIndex) 

end

function OnLogin(PlayerIndex) 

end

function OnScore(PlayerIndex) 

end

function OnTick() 

end

function OnBetray(PlayerIndex, VictimIndex) 

end

function OnSuicide(PlayerIndex) 

end

function OnGameEnd() 

end

function OnNewGame() 

end

function OnMapReset() 

end

function OnAreaExit(PlayerIndex, AreaName) 

end

function OnAreaEnter(PlayerIndex, AreaName) 

end

function OnTeamSwitch(PlayerIndex) 

end

function OnPlayerJoin(PlayerIndex) 

end

function OnPlayerChat(PlayerIndex, Message, type)

end

function OnWeaponDrop(PlayerIndex, Slot) 

end

function OnPlayerKill(PlayerIndex, VictimIndex) 

end

function OnCheckAlive() 

end

function OnPlayerDeath(PlayerIndex, KillerIndex)

end

function OnPlayerSpawn(PlayerIndex) 

end

function OnPlayerLeave(PlayerIndex) 

end

function OnObjectSpawn() 

end

function OnVehicleExit(PlayerIndex) 

end

function OnWeaponPickup(PlayerIndex, Type, Slot) 

end

function OnVehicleEntry(PlayerIndex, Seat)

end

function OnServerCommand(PlayerIndex, Command, Environment)

end

function OnPlayerPrejoin(PlayerIndex) 

end

function OnPlayerPrespawn(PlayerIndex)

end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)

end

function OnError(Message)
    print(debug.traceback())
end
