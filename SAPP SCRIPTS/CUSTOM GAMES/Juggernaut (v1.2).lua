--[[
--=====================================================================================================--
Script Name: Juggernaut (v1.2), for SAPP (PC & CE)
Description: 

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"

local juggernaut = {}
function juggernaut:init()
    juggernaut.settings = {

        -- # Number of players required to set the game in motion (cannot be less than 2)
        required_players = 2,

        -- # Continuous message emitted when there aren't enough players.
        not_enough_players = "%current%/%required% players needed to start the game.",

        -- # Countdown delay (in seconds)
        -- This is a pre-game-start countdown initiated at the beginning of each game.
        delay = 10,

        -- # Duration (in seconds) that players will be the juggernaut:
        turn_timer = 60,

        -- # This message is the pre-game broadcast:
        pre_game_message = "Juggernaut (v1.2) will begin in %minutes%:%seconds%",

        -- # This message is broadcast when the game begins:
        on_game_begin = "The game has begun",

        -- # This message is broadcast when someone becomes the juggernaut:
        new_juggernaut = "%name% is now the Juggernaut!",

        -- # This message is broadcast to the whole server:
        on_timer = "|lJuggernaut: %name%|cHealth: %health% Shield: %shield%|rTime until Switch: %minutes%:%seconds%",
        -- If true, the above message will be broadcast server-wide.
        use_timer = true,

        attributes = {
            -- Juggernaut Health: (0 to 99999) (Normal = 1)
            health = 10,

            -- Set to 0 to disable (normal speed is 1)
            running_speed = 1.5,

            -- Weapon damage multiplier (0 to 10) (Normal = 1)
            damage_multiplier = 10,

            -- Set to 'false' to disable:
            invisibility_on_crouch = true,

            -- Set to 'false' to disable temporary overshield:
            overshield = true,

            -- (0 to 100) (Normal = 1) (Full overshield = 3)
            shield = 10,

            -- If true, the Juggernaut will have regenerating health:
            regenerating_health = true,

            -- Health will regenerate in chunks of this percent every 30 ticks until they gain maximum health.
            increment = 0.0005,
        },

        -- Some functions temporarily remove the server prefix while broadcasting a message.
        -- This prefix will be restored to 'server_prefix' when the message relay is done.
        -- Enter your servers default prefix here:
        server_prefix = "** SERVER **",


        --# Do Not Touch #--
        active_shooter = { },
        weapons = { },
        --
    }
end

-- Variables for String Library:
local format = string.format
local gsub = string.gsub

-- Variables for Math Library:
local floor = math.floor

-- Game Variables:
local gamestarted
local countdown, init_countdown, print_nep

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb['EVENT_TICK'], "OnTick")

    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")

    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    register_callback(cb['EVENT_DIE'], 'OnJuggernautKill')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")

    if (get_var(0, '$gt') ~= "n/a") then

        juggernaut:init()

        for i = 1, 16 do
            if player_present(i) then
                juggernaut:gameStartCheck(i)
            end
        end

        -- Credits to Kavawuvi for this:
        if (read_dword(0x40440000) > 0x40440000 and read_dword(0x40440000) < 0xFFFFFFFF) then
            juggernaut:SaveMapWeapons()
        end
        --
    end
end

function OnScriptUnload()
    --
end

function OnTick()

    local set = juggernaut.settings
    local active_shooter = set.active_shooter
    local attributes = juggernaut.settings.attributes
    local player_count = juggernaut:GetPlayerCount()
    local countdown_begun = (init_countdown == true)

    -- # Continuous message emitted when there aren't enough players to start the game:
    if (print_nep) and (not gamestarted) and (player_count < set.required_players) then
        local msg = gsub(gsub(set.not_enough_players, "%%current%%", player_count), "%%required%%", set.required_players)
        juggernaut:rprintAll(msg)
    elseif (countdown_begun) and (not gamestarted) and (set.pregame) then
        juggernaut:rprintAll(set.pregame)
    end

    if (gamestarted) then
        for _, shooter in pairs(active_shooter) do
            if (shooter) then
                if (shooter.active) and (not shooter.expired) then
                    if player_alive(shooter.id) then
                        local player_object = get_dynamic_player(shooter.id)

                        shooter.timer = shooter.timer + 0.03333333333333333

                        local delta_time = ((shooter.duration) - (shooter.timer))
                        local minutes, seconds = select(1, juggernaut:secondsToTime(delta_time)), select(2, juggernaut:secondsToTime(delta_time))

                        if (set.use_timer) then
                            local health = format("%0.3f", read_float(player_object + 0xE0))
                            local shield = format("%0.3f", read_float(player_object + 0xE4))

                            local msg = gsub(gsub(gsub(gsub(gsub(set.on_timer,
                                    "%%name%%", shooter.name),
                                    "%%minutes%%", minutes),
                                    "%%seconds%%", seconds),
                                    "%%health%%", health),
                                    "%%shield%%", shield)
                            juggernaut:rprintAll(msg)
                        end

                        juggernaut:CamoOnCrouch(shooter.id, player_object)

                        if (tonumber(seconds) <= 0) then

                            local OldJuggernaut = shooter.id
                            -- Reset this Juggernaut:
                            juggernaut:Set(shooter.id, false)

                            -- Kill this Juggernaut:
                            juggernaut:killPlayer(shooter.id)

                            -- Select new Juggernaut:
                            juggernaut:selectRandomJuggernaut(OldJuggernaut)

                        elseif (player_object ~= 0) then

                            -- Set NAV Market to the current Juggernaut
                            juggernaut:SetNav(shooter.id)

                            -- Set Juggernaut running speed:
                            if (attributes.running_speed > 0) then
                                execute_command("s " .. shooter.id .. " " .. tonumber(attributes.running_speed))
                            end

                            -- Regenerate Juggernaut Health
                            if (attributes.regenerating_health) then
                                local health = read_float(player_object + 0xE0)
                                if (health < 1) then
                                    write_float(player_object + 0xE0, health + attributes.increment)
                                end
                            end

                            -- Weapon Assignment logic:
                            local weapons = set.weapons
                            if (#weapons > 0) then
                                if (shooter.assign) then

                                    local coords = juggernaut:getXYZ(shooter.id, player_object)
                                    if (not coords.invehicle) then
                                        shooter.assign = false

                                        execute_command("hp " .. shooter.id .. " " .. attributes.health)
                                        execute_command("wdel " .. shooter.id)

                                        if (attributes.overshield) then
                                            execute_command("sh " .. shooter.id .. " " .. attributes.shield)
                                        end

                                        local chosen_weapons = { }

                                        local loops = 0
                                        while (true) do
                                            loops = loops + 1
                                            math.random();
                                            math.random();
                                            math.random();
                                            local weapon = weapons[math.random(1, #weapons)]

                                            for i = 1, #chosen_weapons do
                                                if (chosen_weapons[i] == weapon) then
                                                    weapon = nil
                                                    break
                                                end
                                            end
                                            if (weapon ~= nil) then
                                                chosen_weapons[#chosen_weapons + 1] = weapon
                                            end
                                            if (#chosen_weapons == 4 or loops > 500) then
                                                break
                                            end
                                        end

                                        for slot, Weapon in pairs(chosen_weapons) do
                                            if (slot == 1 or slot == 2) then
                                                assign_weapon(spawn_object("null", "null", coords.x, coords.y, coords.z, 0, Weapon), shooter.id)

                                                -- To assign a 3rd and 4 weapon, we have to delay 
                                                -- the tertiary and quaternary assignments by at least 250 ms:
                                            elseif (slot == 3 or slot == 4) then
                                                timer(250, "DelayAssign", shooter.id, Weapon, coords.x, coords.y, coords.z)
                                            end
                                        end
                                    end
                                end

                                -- Set infinite ammo and grenades:
                                write_word(player_object + 0x31F, 7)
                                write_word(player_object + 0x31E, 7)

                                for j = 0, 3 do
                                    local weapon = get_object_memory(read_dword(player_object + 0x2F8 + j * 4))
                                    if (weapon ~= 0) then
                                        write_word(weapon + 0x2B6, 9999)
                                    end
                                end
                            end
                        end
                    else
                        -- The Juggernaut that was just selected is still spawning:
                        juggernaut:rprintAll("Juggernaut: " .. shooter.name .. " (AWAITING RESPAWN)")
                    end
                end
            end
        end
    end

    if (countdown_begun) then
        countdown = countdown + 0.03333333333333333

        local delta_time = ((set.delay) - (countdown))
        local minutes, seconds = select(1, juggernaut:secondsToTime(delta_time)), select(2, juggernaut:secondsToTime(delta_time))

        set.pregame = set.pregame or ""
        set.pregame = gsub(gsub(set.pre_game_message, "%%minutes%%", minutes), "%%seconds%%", seconds)

        if (tonumber(minutes) <= 0) and (tonumber(seconds) <= 0) then

            gamestarted = true
            juggernaut:StopTimer()

            for i = 1, 16 do
                if player_present(i) then
                    juggernaut:initJuggernaut(i)
                end
            end

            if (#active_shooter > 0) then

                -- Remove default death messages (temporarily)
                local kma = sig_scan("8B42348A8C28D500000084C9") + 3
                local original = read_dword(kma)
                safe_write(true)
                write_dword(kma, 0x03EB01B1)
                safe_write(false)

                execute_command("sv_map_reset")

                -- Re enables default death messages
                safe_write(true)
                write_dword(kma, original)
                safe_write(false)

                -- Select random player to become Juggernaut:
                juggernaut:selectRandomJuggernaut(0)
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, '$gt') ~= "n/a") then

        juggernaut:init()

        -- Credits to Kavawuvi for this:
        if (read_dword(0x40440000) > 0x40440000 and read_dword(0x40440000) < 0xFFFFFFFF) then
            juggernaut:SaveMapWeapons()
        end
        --
    end
end

function OnGameEnd()
    juggernaut:StopTimer()
    gamestarted = false
end

function juggernaut:gameStartCheck(p)

    local set = juggernaut.settings
    local player_count = juggernaut:GetPlayerCount()
    local required = set.required_players

    -- Game hasn't started yet and there ARE enough players to init the pre-game countdown.
    -- Start the timer:
    if (player_count >= required) and (not init_countdown) and (not gamestarted) then
        juggernaut:StartTimer()

    elseif (player_count >= required) and (print_nep) then
        print_nep = false

        -- Not enough players to start the game. Set the "not enough players (print_nep)" flag to true.
        -- This will invoke a continuous message that is broadcast server wide
    elseif (player_count > 0 and player_count < required) then
        print_nep = true

        -- Init table values for this player:
    elseif (gamestarted) then
        juggernaut:initJuggernaut(p)
    end
end

function OnPlayerConnect(p)
    juggernaut:gameStartCheck(p)
end

function OnPlayerDisconnect(PlayerIndex)

    local p = tonumber(PlayerIndex)

    local set = juggernaut.settings
    local player_count = juggernaut:GetPlayerCount()
    player_count = player_count - 1

    if (gamestarted) then

        local active_shooter = set.active_shooter
        local wasjuggernaut = juggernaut:isjuggernaut(PlayerIndex)

        for k, v in pairs(active_shooter) do
            if (v.id == p) then
                active_shooter[k] = nil
            end
        end

        if (player_count <= 0) then

            -- Ensure all timer parameters are set to their default values.
            juggernaut:StopTimer()

            -- One player remains | ends the game.
        elseif (player_count == 1) then
            juggernaut:broadcast("You win!", true)
        elseif (wasjuggernaut) then

            -- Select new player to become Juggernaut
            juggernaut:selectRandomJuggernaut(PlayerIndex)
        end

        -- Pre-Game countdown was initiated but someone left before the game began.
        -- Stop the timer, reset the countdown and display the continuous
        -- message emitted when there aren't enough players to start the game.
    elseif (not gamestarted) and (init_countdown and player_count < set.required_players) then
        print_nep = true
        countdown, init_countdown = 0, false
    end
end

function OnJuggernautKill(PlayerIndex, KillerIndex)

    if (gamestarted) then

        local killer = tonumber(KillerIndex)
        if (killer > 0) then

            local victim = tonumber(PlayerIndex)

            -- Victim was Juggernaut | Make Killer Juggernaut
            local isJuggernaut = juggernaut:isjuggernaut(victim)

            if (isJuggernaut) then

                if (killer ~= victim) then
                    juggernaut:Set(victim, false)
                    juggernaut:Set(killer, true)
                else
                    -- Juggernaut committed suicide | Reset them and select someone new!
                    juggernaut:Set(victim, false)
                    juggernaut:selectRandomJuggernaut(victim)
                end

                local player_object = get_dynamic_player(victim)
                local WeaponID = read_dword(player_object + 0x118)
                write_word(player_object + 0x31E, 0)
                write_word(player_object + 0x31F, 0)
                if (WeaponID ~= 0) then
                    for j = 0, 3 do
                        local Weapon = read_dword(player_object + 0x2F8 + j * 4)
                        destroy_object(Weapon)
                    end
                end
            end
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, _, Damage, _, _)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex and gamestarted) then

        local isjuggernaut = juggernaut:isjuggernaut(CauserIndex)

        if (isjuggernaut) then
            local attributes = juggernaut.settings.attributes
            return true, Damage * attributes.damage_multiplier
        end
    end
end

function juggernaut:killPlayer(PlayerIndex)
    local player = get_player(PlayerIndex)
    if (player ~= 0) then
        local PlayerObject = read_dword(player + 0x34)
        if (PlayerObject ~= nil) then
            destroy_object(PlayerObject)
        end
    end
end

function juggernaut:isjuggernaut(PlayerIndex)
    local active_shooter = juggernaut.settings.active_shooter
    for _, shooter in pairs(active_shooter) do
        if (shooter) then
            if (shooter.id == PlayerIndex and shooter.active) then
                return shooter
            end
        end
    end
    return false
end

function juggernaut:broadcast(message, endgame)
    execute_command("msg_prefix \"\"")
    say_all(message)
    execute_command("msg_prefix \" " .. juggernaut.settings.server_prefix .. "\"")
    if (endgame) then
        execute_command("sv_map_next")
    end
end

function juggernaut:secondsToTime(seconds, bool)
    local seconds = tonumber(seconds)
    if (seconds <= 0) and (bool) then
        return "00", "00";
    else
        local hours, mins, secs = format("%02.f", floor(seconds / 3600));
        mins = format("%02.f", floor(seconds / 60 - (hours * 60)));
        secs = format("%02.f", floor(seconds - hours * 3600 - mins * 60));
        return mins, secs
    end
end

function juggernaut:StartTimer()
    countdown, init_countdown = 0, true
end

function juggernaut:StopTimer()
    countdown, init_countdown = 0, false
    print_nep = false

    for i = 1, 16 do
        if player_present(i) then
            juggernaut:cls(i, 25)
        end
    end
end

function juggernaut:rprintAll(msg)
    for i = 1, 16 do
        if player_present(i) then
            juggernaut:cls(i, 25)
            rprint(i, msg)
        end
    end
end

function juggernaut:cls(PlayerIndex, count)
    local count = count or 25
    for _ = 1, count do
        rprint(PlayerIndex, " ")
    end
end

function juggernaut:CamoOnCrouch(PlayerIndex, PlayerObject)
    local attributes = juggernaut.settings.attributes
    if (attributes.invisibility_on_crouch) then
        local couching = read_float(PlayerObject + 0x50C)
        if (couching == 1) then
            execute_command("camo " .. PlayerIndex .. " 2")
        end
    end
end

function juggernaut:SetNav(juggernaut)
    for i = 1, 16 do
        if player_present(i) then
            local PlayerSM = get_player(i)
            local PTableIndex = to_real_index(i)
            if (PlayerSM ~= 0) then
                if (juggernaut ~= nil) then
                    write_word(PlayerSM + 0x88, to_real_index(juggernaut))
                else
                    write_word(PlayerSM + 0x88, PTableIndex)
                end
            end
        end
    end
end

function juggernaut:initJuggernaut(PlayerIndex)
    if (PlayerIndex) then

        local set = juggernaut.settings
        local active_shooter = set.active_shooter

        active_shooter[#active_shooter + 1] = {
            name = get_var(tonumber(PlayerIndex), "$name"),
            id = tonumber(PlayerIndex),
            timer = 0,
            duration = set.turn_timer,
            active = false,
            assign = false
        }
    end
end

function juggernaut:Set(PlayerIndex, State)
    if (PlayerIndex) then
        local set = juggernaut.settings
        local active_shooter = set.active_shooter
        local attributes = set.attributes

        for _, v in pairs(active_shooter) do
            if (v.id == PlayerIndex) then

                if (State == true) then
                    v.timer, v.active, v.assign = 0, true, true
                    juggernaut:broadcast(gsub(set.new_juggernaut, "%%name%%", v.name), false)
                else
                    v.timer, v.active, v.assign = 0, false, false
                    execute_command("s " .. v.id .. " 1")
                end
            end
        end
    end
end

function juggernaut:selectRandomJuggernaut(OldJuggernaut)

    local set = juggernaut.settings
    local active_shooter = set.active_shooter

    local players = { }

    for i = 1, 16 do
        if player_present(i) then
            if (OldJuggernaut ~= i) then
                players[#players + 1] = i
            end
        end
    end

    if (#players > 0) then

        math.randomseed(os.time())
        math.random();
        math.random();
        math.random();
        local RandomPlayer = players[math.random(1, #players)]

        juggernaut:Set(RandomPlayer, true)
    end
end

function juggernaut:GetPlayerCount()
    return tonumber(get_var(0, "$pn"))
end

function DelayAssign(PlayerIndex, Weapon, x, y, z)
    assign_weapon(spawn_object("null", "null", x, y, z, 0, Weapon), PlayerIndex)
end

function juggernaut:getXYZ(PlayerIndex, PlayerObject)
    local coords, x, y, z = { }

    local VehicleID = read_dword(PlayerObject + 0x11C)
    if (VehicleID == 0xFFFFFFFF) then
        coords.invehicle = false
        x, y, z = read_vector3d(PlayerObject + 0x5c)
    else
        coords.invehicle = true
        x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
    end

    coords.x, coords.y, coords.z = x, y, z + 1
    return coords
end

--========================================================================================--
-- Huge credits to Kavawuvi (002) for all of the code below:
-- Taken from this project: https://opencarnage.net/index.php?/topic/4443-random-weapons/
--========================================================================================--
function juggernaut:SaveMapWeapons()
    local weapons = juggernaut.settings.weapons

    local function RandomWeaponsContains(TagID)
        for k, v in pairs(weapons) do
            if (v == TagID) then
                return true
            end
        end
        return false
    end

    local function ValidWeapon(TagID)
        if (RandomWeaponsContains(TagID)) then
            return false
        end
        local tag_index = bit.band(TagID, 0xFFFF)
        local tag_count = read_dword(0x4044000C)
        if (tag_index >= tag_count) then
            return false
        end
        local tag_array = read_dword(0x40440000)
        local tag_data = read_dword(tag_array + tag_index * 0x20 + 0x14)
        if (read_word(tag_data) ~= 2) then
            return false
        end
        local weapon_flags = read_dword(tag_data + 0x308)
        if (bit.band(weapon_flags, math.pow(2, 31 - 28)) > 0) then
            return false
        end
        if (read_word(tag_data + 0x45C) == 0xFFFF) then
            return false
        end
        return true
    end

    local function AddWeaponToList(TagID)
        if (ValidWeapon(TagID)) then
            weapons[#weapons + 1] = TagID
        end
    end

    local function ScanNetgameEquipment(TagID)
        local tag_array = read_dword(0x40440000)
        local tag_count = read_dword(0x4044000C)
        local tag_index = bit.band(TagID, 0xFFFF)
        if (tag_index >= tag_count) then
            return false
        end
        local tag_data = read_dword(tag_array + tag_index * 0x20 + 0x14)
        local permutations_count = read_dword(tag_data + 0)
        local permutations_data = read_dword(tag_data + 4)
        for i = 0, permutations_count - 1 do
            AddWeaponToList(read_dword(permutations_data + i * 84 + 0x24 + 0xC))
        end
    end

    local tag_array = read_dword(0x40440000)
    local tag_count = read_dword(0x4044000C)

    for i = 0, tag_count - 1 do
        local tag = tag_array + i * 0x20
        if (read_dword(tag) == 0x6D617467) then
            local tag_name = read_dword(tag + 0x10)
            if (read_string(tag_name) == "globals\\globals") then
                local tag_data = read_dword(tag + 0x14)
                local weapons_list_count = read_dword(tag_data + 0x14C)
                local weapons_list_data = read_dword(tag_data + 0x14C + 4)
                for i = 0, weapons_list_count - 1 do
                    local weapon_id = read_dword(weapons_list_data + i * 0x10)
                    if (ValidWeapon(weapon_id)) then
                        AddWeaponToList(weapon_id)
                    end
                end
            end
        end
    end

    local scnr_tag_data = read_dword(tag_array + 0x20 * read_word(0x40440004) + 0x14)
    local netgame_equipment_count = read_dword(scnr_tag_data + 0x384)
    local netgame_equipment_address = read_dword(scnr_tag_data + 0x384 + 4)

    for i = 0, netgame_equipment_count - 1 do
        local netgame_equip = read_dword(netgame_equipment_address + i * 144 + 0x50 + 0xC)
        ScanNetgameEquipment(netgame_equip)
    end

    local starting_equipment_count = read_dword(scnr_tag_data + 0x390)
    local starting_equipment_address = read_dword(scnr_tag_data + 0x390 + 4)

    for i = 0, starting_equipment_count - 1 do
        ScanNetgameEquipment(read_dword(starting_equipment_address + i * 204 + 0x3C + 0xC))
        ScanNetgameEquipment(read_dword(starting_equipment_address + i * 204 + 0x4C + 0xC))
        ScanNetgameEquipment(read_dword(starting_equipment_address + i * 204 + 0x5C + 0xC))
        ScanNetgameEquipment(read_dword(starting_equipment_address + i * 204 + 0x6C + 0xC))
        ScanNetgameEquipment(read_dword(starting_equipment_address + i * 204 + 0x7C + 0xC))
        ScanNetgameEquipment(read_dword(starting_equipment_address + i * 204 + 0x8C + 0xC))
    end
end
