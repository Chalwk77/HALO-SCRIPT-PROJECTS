--[[
------------------------------------
Description: HPC ApplySpeed (On Camo Pickup), Phasor V2+
Copyright (c) 2016-2018
* Author: Jericho Crosby
* IGN: Chalwk
* Written and Created by Jericho Crosby
-----------------------------------
]]--

-- Settings
EQUIPMENT = { }
EQUIPMENT_TAGS = { }
EQUIPMENT[1] = { "powerups\\active camouflage" }
SPEED_POWERUP = (2) -- Scale
SPEED_POWERUP_DURATION = (10) -- Seconds

function GetRequiredVersion()
    return
    200
end

function OnScriptLoad(processid, game, persistent)

end

function OnScriptUnload()

end

function OnNewGame(map)
    for k, v in pairs(EQUIPMENT) do
        local TAG_ID = gettagid("eqip", v[1])
        table.insert(EQUIPMENT_TAGS, TAG_ID)
    end
    Camouflage_Tab_ID = gettagid("eqip", "powerups\\active camouflage")
end

function ApplySpeed(player)
    if player then
        setspeed(player, tonumber(SPEED_POWERUP))
        set = registertimer(SPEED_POWERUP_DURATION * (1000), "ResetSpeed", player)
    end
end

function ResetSpeed(id, count, player)
    setspeed(player, 1.08)
    set = nil
    return false
end

function OnObjectInteraction(player, objId, MapID)
    for i = (0), #EQUIPMENT_TAGS do
        if MapID == EQUIPMENT_TAGS[i] then
            if MapID == Camouflage_Tab_ID then
                ApplySpeed(player)
            end
        end
    end
end