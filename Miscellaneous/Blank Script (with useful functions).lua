--[[
--=====================================================================================================--
Script Name: Blank Script, for SAPP (PC & CE)
--=====================================================================================================--
]]-- 

api_version = "1.12.0.0"

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
    register_callback(cb['EVENT_WEAPON_DROP'],          "OnWeaponDrop")
    register_callback(cb['EVENT_JOIN'],                 "OnPlayerJoin")
    register_callback(cb['EVENT_CHAT'],                 "OnPlayerChat")
    register_callback(cb['EVENT_KILL'],                 "OnPlayerKill")
    register_callback(cb['EVENT_ALIVE'],                "OnCheckAlive")
    register_callback(cb['EVENT_DIE'],                  "OnPlayerDeath")
    register_callback(cb['EVENT_SPAWN'],                "OnPlayerSpawn")
    register_callback(cb['EVENT_LEAVE'],                "OnPlayerLeave")
    register_callback(cb['EVENT_OBJECT_SPAWN'],         "OnObjectSpawn")
    register_callback(cb['EVENT_VEHICLE_EXIT'],         "OnVehicleExit")
    register_callback(cb['EVENT_WEAPON_PICKUP'],        "OnWeaponPickup")
    register_callback(cb['EVENT_VEHICLE_ENTER'],        "OnVehicleEntry")
    register_callback(cb['EVENT_COMMAND'],              "OnServerCommand")
    register_callback(cb['EVENT_PREJOIN'],              "OnPlayerPrejoin")
    register_callback(cb['EVENT_PRESPAWN'],             "OnPlayerPrespawn")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'],   "OnDamageApplication")
end

function OnScriptUnload()

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

function OnPlayerChat(PlayerIndex, Message, Type)

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

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID) 

end

function OnVehicleExit(PlayerIndex) 

end

function OnWeaponPickup(PlayerIndex, WeaponIndex, Type)

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

--- USEFUL MISC FUNCTIONS
function OnError(Message)
    print(debug.traceback())
end

function TagInfo(obj_type, obj_name)
    local tag_id = lookup_tag(obj_type, obj_name)
    return tag_id ~= 0 and read_dword(tag_id + 0xC) or nil
end

function tokenizestring(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t = { }; i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function moveobject(ObjectID, x, y, z)
    local object = get_object_memory(ObjectID)
    if get_object_memory(ObjectID) ~= 0 then
        local veh_obj = get_object_memory(read_dword(object + 0x11C))
        write_vector3d((veh_obj ~= 0 and veh_obj or object) + 0x5C, x, y, z)
    end
end

function GetObjectCoords(ObjectID)
    local function round(pos, places)
      local mult = 10^(places or 0)
      return math.floor(pos * mult + 0.5) / mult
    end
    local player = get_dynamic_player(PlayerIndex)
    if (player ~= 0) then
        local posX, posY, posZ = read_vector3d(player + 0x5C)
        local vehicle = get_object_memory(read_dword(player + 0x11C))
        if (vehicle ~= 0 and vehicle ~= nil) then
            local vehiPosX, vehiPosY, vehiPosZ = read_vector3d(vehicle + 0x5C)
            posX = posX + vehiPosX
            posY = posY + vehiPosY
            posZ = posZ + vehiPosZ
        end
        return round(posX, 2), round(posY, 2), round(posZ, 2)
    end
    return nil
end

function secondsToTime(seconds, places)
    local minutes = math.floor(seconds / 60)
    seconds = seconds % 60
    if places == 2 then
        return minutes, seconds
    end
end

function table.match(table, value)
    for k, v in pairs(table) do
        if v == value then
            return k
        end
    end
end

function clear_console(PlayerIndex)
    for i = 1, 30 do
        rprint(PlayerIndex, " ")
    end
end
