-- Configuration [STARTS]

local DefaultSpeed = 1

local Weapons = {

    -- Tag Type | Tag Name | Blast Radius | Frozen Time | Enabled/Disabled

    -- Grenade Projectiles:
    { "proj", "weapons\\frag grenade\\frag grenade", 10, 0.5, true },
    { "proj", "weapons\\plasma grenade\\plasma grenade", 10, 0.5, true }


}

-- Configuration [ENDS]

api_version = "1.12.0.0"

local game_over
local DeltaTime = 1 / 30
local objects, players = { }, { }

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb["EVENT_OBJECT_SPAWN"], "OnObjectSpawn")
    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamageApplication")
    if (get_var(0, "$gt") ~= "n/a") then
        game_over = false
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        game_over = false
    end
end

function OnGameEnd()
    game_over = true
end

function OnPlayerConnect(PlayerIndex)
    InitPlayer(PlayerIndex, false)
end

function OnPlayerDisconnect(PlayerIndex)
    InitPlayer(PlayerIndex, true)
end

function OnTick()
    if (not game_over) then

        for Object, nuke in pairs(objects) do
            if (Object) then

                if (Object ~= 0) then

                    nuke.x = read_float(Object + 0x68)
                    nuke.y = read_float(Object + 0x6C)
                    nuke.z = read_float(Object + 0x70)

                elseif (Object == 0) then

                    local nX, nY, nZ = nuke.x, nuke.y, nuke.z

                    for player = 1, 16 do
                        if player_present(player) and player_alive(player) then
                            local DynamicPlayer = get_dynamic_player(player)
                            if (DynamicPlayer ~= 0) then

                                local coords = GetXYZ(DynamicPlayer)
                                if (coords) then

                                    local pX, pY, pZ = coords.x, coords.y, coords.z

                                    local in_danger = WithinRange(pX, pY, pZ, nX, nY, nZ, nuke.bR)
                                    if (in_danger) then
                                        players[player].frozen = true
                                        players[player].frozen_time = nuke.fT
                                    end
                                end
                            end
                        end
                    end

                    objects[k] = nil
                end
            end
        end

        FreezePlayers()
    end
end

function FreezePlayers()
    for i = 1, 16 do
        if player_present(i) then
            if (players[i] ~= nil) then
                if (players[i].frozen) then
                    players[i].timer = players[i].timer + DeltaTime
                    if (players[i].timer <= players[i].frozen_time) then
                        execute_command("s " .. i .. " 0")
                    else
                        players[i].timer = 0
                        players[i].frozen = false
                        execute_command("s " .. i .. " " .. tostring(DefaultSpeed))
                    end
                end
            end
        end
    end
end

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID)
    if (PlayerIndex ~= nil and PlayerIndex > 0) then
        for _, Weapon in pairs(Weapons) do
            if (Weapon[#Weapon] and MapID == GetTag(Weapon[1], Weapon[2])) then
                local Object = get_object_memory(ParentID)
                if (Object ~= nil) then
                    objects[Object] = {
                        bR = Weapon[3],
                        fT = Weapon[4],
                        x = 0,
                        y = 0,
                        z = 0
                    }
                end
            end
        end
    end
end

function InitPlayer(PlayerIndex, Reset)
    if (Reset) then
        players[PlayerIndex] = {}
    else
        players[PlayerIndex] = {
            timer = 0,
            frozen = false,
            frozen_time = 0
        }
    end
end

function GetXYZ(DynamicPlayer)
    local coordinates, x, y, z = {}
    local VehicleID = read_dword(DynamicPlayer + 0x11C)
    if (VehicleID == 0xFFFFFFFF) then
        x, y, z = read_vector3d(DynamicPlayer + 0x5c)
        coordinates.invehicle = false
    else
        coordinates.invehicle = true
        x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
    end
    coordinates.x, coordinates.y, coordinates.z = x, y, z
    return coordinates
end

function GetTag(Type, Name)
    local tag = lookup_tag(Type, Name)
    return (tag ~= 0 and read_dword(tag + 0xC)) or nil
end

function WithinRange(pX, pY, pZ, nX, nY, nZ, BlastRadius)
    return tonumber(math.sqrt((pX - nX) * (pX - nX) + (pY - nY) * (pY - nY) + (pZ - nZ) * (pZ - nZ))) <= BlastRadius
end

function OnScriptUnload()

end
