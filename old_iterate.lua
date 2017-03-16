api_version = "1.11.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnNewGame")
end

function LoadLarge()
    Level = { }
    Level[1] = { "weapons\\shotgun\\shotgun", "Shotgun", "Melee or Nades!", 1, { 6, 6 }, 0 }
    Level[2] = { "weapons\\assault rifle\\assault rifle", "Assualt Rifle", "Aim and unload!", 2, { 2, 2 }, 240 }
    Level[3] = { "weapons\\pistol\\pistol", "Pistol", "Aim for the head", 3, { 2, 1 }, 36 }
    Level[4] = { "weapons\\sniper rifle\\sniper rifle", "Sniper Rifle", "Aim, Exhale and fire!", 4, { 3, 2 }, 12 }
    Level[5] = { "weapons\\rocket launcher\\rocket launcher", "Rocket Launcher", "Blow people up!", 5, { 1, 1 }, 6 }
    Level[6] = { "weapons\\plasma_cannon\\plasma_cannon", "Fuel Rod", "Bombard anything that moves!", 6, { 3, 1 }, 0 }
    Level[7] = { "vehicles\\ghost\\ghost_mp", "Ghost", "Run people down!", 7, { 0, 0 }, 0 }
    Level[8] = { "vehicles\\rwarthog\\rwarthog", "Rocket Hog", "Blow em' up!", 8, { 0, 0 }, 0 }
    Level[9] = { "vehicles\\scorpion\\scorpion_mp", "Tank", "Wreak havoc!", 9, { 0, 0 }, 0 }
    Level[10] = { "vehicles\\banshee\\banshee_mp", "Banshee", "Hurry up and win!", 10, { 0, 0 }, 0 }
    for k, v in pairs(Level) do
        if string.find(v[1], "vehicles") then
            v[11] = v[1]
            v[12] = 1
        else
            v[11] = v[1]
            v[12] = 0
        end
    end
end

function LoadSmall()
    Level = { }
    Level[1] = { "weapons\\shotgun\\shotgun", "Shotgun", "Melee or Nades!", 1, { 6, 6 }, 0 }
    Level[2] = { "weapons\\assault rifle\\assault rifle", "Assualt Rifle", "Aim and unload!", 2, { 2, 2 }, 240 }
    Level[3] = { "weapons\\pistol\\pistol", "Pistol", "Aim for the head", 3, { 2, 1 }, 36 }
    Level[4] = { "weapons\\sniper rifle\\sniper rifle", "Sniper Rifle", "Aim, Exhale and fire!", 4, { 3, 2 }, 12 }
    Level[5] = { "weapons\\rocket launcher\\rocket launcher", "Rocket Launcher", "Blow people up!", 5, { 1, 1 }, 6 }
    Level[6] = { "weapons\\plasma_cannon\\plasma_cannon", "Fuel Rod", "Bombard anything that moves!", 6, { 3, 1 }, 0 }
    for k, v in pairs(Level) do
        if string.find(v[1], "weapons") then
            v[7] = v[1]
            v[8] = 1
        else
            v[7] = v[1]
            v[8] = 0
        end
    end
end

function OnNewGame()
    MAP_NAME = get_var(1, "$map")
    if MAP_NAME == "bloodgulch" or MAP_NAME == "timberland" or MAP_NAME == "sidewinder"
        or MAP_NAME == "dangercanyon" or MAP_NAME == "deathisland" or MAP_NAME == "icefields" or MAP_NAME == "infinity" then
        LargeMapConfiguration = true
        LoadLarge()
    end
    -- gephyrophobia = WIP --
    if MAP_NAME == "beavercreek" or MAP_NAME == "boardingaction" or MAP_NAME == "carousel"
        or MAP_NAME == "chillout" or MAP_NAME == "damnation" or MAP_NAME == "gephyrophobia"
        or MAP_NAME == "hangemhigh" or MAP_NAME == "longest" or MAP_NAME == "prisoner"
        or MAP_NAME == "putput" or MAP_NAME == "ratrace" or MAP_NAME == "wizard" then
        LargeMapConfiguration = false
        LoadSmall()
    end
    for k, v in pairs(EQUIPMENT_TABLE) do
        if string.find(v[1], "powerups") then
            v[11] = v[1]
            v[12] = 1
        else
            v[11] = v[1]
            v[12] = 0
        end
    end
    for k, v in pairs(WEAPON_TABLE) do
        if string.find(v[1], "weapons") then
            v[11] = v[1]
            v[12] = 1
        else
            v[11] = v[1]
            v[12] = 0
        end
    end
end
