--[[
--=====================================================================================================--
Script Name: Maniac (beta v1.0), for SAPP (PC & CE)
Description: This game is a variation of Juggernaut and Hide and Seek.

-- GAME MECHANICS --

Players will take turns being the "Maniac".
Maniacs are invincible to everything and extremely powerful for a limited time.
You'll want to avoid the maniac at all costs.

1). Maniacs wield 4 weapons with infinite ammo and infinite grenades
2). Ability to go invisible when they crouch
3). Run at lightning speeds

A NAV marker will appear above the Maniacs head if your set the "kill in order" gametype flag to "yes". 
This only works on FFA and Team Slayer gametypes.

The game will end when the first player (as Maniac) reaches the specified kill threshold.
If all players have had their turn and no one has reached the kill threshold, the player with the most kills (as Maniac) wins.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"

local maniac = {}
function maniac:init()
    maniac.settings = {

        -- # Number of players required to set the game in motion (cannot be less than 2)
        required_players = 5,

        -- # Continuous message emitted when there aren't enough players.
        not_enough_players = "%current%/%required% players needed to start the game.",

        -- # Countdown delay (in seconds)
        -- This is a pre-game-start countdown initiated at the beginning of each game.
        delay = 10,

        -- # Duration (in seconds) that players will be the Maniac:
        turn_timer = 15,

        -- DYNAMIC SCORING SYSTEM --
        -- The game will end when a Maniac reaches this scorelimit:
        ['dynamic_scoring'] = {

            enabled = true,
            -- If disabled, the default kill-threshold for Maniacs will be "default_scorelimit":
            default_scorelimit = 15,

            [1] = 10, -- 4 players or less
            [2] = 15, -- 4-8 players
            [3] = 20, -- 8-12 players
            [4] = 25, -- 12-16 players
            txt = "Maniac Kill-Threshold (scorelimit) changed to: %scorelimit%"
        },

        -- # This message is the pre-game broadcast:
        pre_game_message = "Maniac (beta v1.0) will begin in %minutes%:%seconds%",

        -- # This message is broadcast when the game begins:
        on_game_begin = "The game has begun",

        -- # This message is broadcast when the game is over:
        end_of_game = "%name% won the game!",

        -- # This message is broadcast when someone becomes the maniac:
        new_maniac = "%name% is now the maniac!",

        -- # This message is broadcast to the whole server:
        on_timer = "|lManiac:  %name%|cManiac Kills: %kills%/%scorelimit%|rTime until Switch: %minutes%:%seconds%",
        -- If true, the above message will be broadcast server-wide.
        use_timer = true,

        attributes = {
            -- Maniac Health: 0 to 99999 (Normal = 1)
            health = 999999,
            -- Set to 0 to disable (normal speed is 1)
            running_speed = 1.5,
            damage_multiplier = 10, -- (0 to 10) (Normal = 1)
            -- Set to 'false' to disable:
            invisibility_on_crouch = true,
        },

        -- Some functions temporarily remove the server prefix while broadcasting a message.
        -- This prefix will be restored to 'server_prefix' when the message relay is done.
        -- Enter your servers default prefix here:
        server_prefix = "** SERVER **",


        --# Do Not Touch #--
        assign = { },
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
local current_scorelimit
local countdown, init_countdown, print_nep
local gametype_base

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb['EVENT_TICK'], "OnTick")

    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")

    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    register_callback(cb['EVENT_DIE'], 'OnManiacKill')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")

    gametype_base = read_dword(sig_scan("B9360000008BF3BF78545F00") + 0x8)    
    
    if (get_var(0, '$gt') ~= "n/a") then
        write_byte(gametype_base + 0x7E, 1)
        
        maniac:init()
        
        for i = 1, 16 do
            if player_present(i) then
                current_scorelimit = 0
                maniac:gameStartCheck(i)
            end
        end
        
        -- Credits to Kavawuvi for this:
        if(read_dword(0x40440000) > 0x40440000 and read_dword(0x40440000) < 0xFFFFFFFF) then
            maniac:SaveMapWeapons()
        end
        --
    end
end

function OnScriptUnload()
    --
end

function OnTick()

    local set = maniac.settings
    local active_shooter = set.active_shooter
    local attributes = maniac.settings.attributes
    local player_count = maniac:GetPlayerCount()
    local countdown_begun = (init_countdown == true)

    -- # Continuous message emitted when there aren't enough players to start the game:
    if (print_nep) and (not gamestarted) and (player_count < set.required_players) then
        local msg = gsub(gsub(set.not_enough_players,
                "%%current%%", player_count),
                "%%required%%", set.required_players)
        maniac:rprintAll(msg)
    elseif (countdown_begun) and (not gamestarted) and (set.pregame) then
        maniac:rprintAll(set.pregame)
    end

    if (gamestarted) then
        for _, shooter in pairs(active_shooter) do
            if (shooter) then
                if (shooter.active) and (not shooter.expired) then
                    if player_alive(shooter.id) then
                        local player_object = get_dynamic_player(shooter.id)

                        maniac:CamoOnCrouch(shooter.id)
                        shooter.timer = shooter.timer + 0.03333333333333333

                        local delta_time = ((shooter.duration) - (shooter.timer))
                        local minutes, seconds = select(1, maniac:secondsToTime(delta_time)), select(2, maniac:secondsToTime(delta_time))

                        if (set.use_timer) then
                            local msg = gsub(gsub(gsub(gsub(gsub(set.on_timer, "%%minutes%%", minutes),
                                    "%%seconds%%", seconds),
                                    "%%name%%", shooter.name),
                                    "%%kills%%", shooter.kills),
                                    "%%scorelimit%%", current_scorelimit)
                            maniac:rprintAll(msg)
                        end

                        if (tonumber(seconds) <= 0) then

                            -- Disable Maniac status for this player and select a new Maniac:
                            shooter.active, shooter.expired = false, true
                            execute_command("ungod " .. shooter.id)
                            execute_command("s " .. shooter.id .. " 1")
                            maniac:killPlayer(shooter.id)
                            maniac:SelectManiac()

                        elseif (player_object ~= 0) then

                            maniac:SetNav(shooter.id)

                            -- Set Maniac running speed:
                            if (attributes.running_speed > 0) then
                                execute_command("s " .. shooter.id .. " " .. tonumber(attributes.running_speed))
                            end

                            -- Weapon Assignment logic:
                            local weapons = set.weapons
                            if(#weapons > 0) then
                                if (set.assign[shooter.id]) then
                                
                                    local coords = maniac:getXYZ(shooter.id, player_object)
                                    if (not coords.invehicle) then
                                        set.assign[shooter.id] = false
                                    
              
                                        local picked = 0
                                        local picked_weapons = { }

                                        for _ = 1, 4 do
                                            local index = weapons[rand(1, #weapons)]
                                            if (picked ~= index) then
                                                picked = index
                                                picked_weapons[#picked_weapons + 1] = index
                                            else
                                                while (picked == index) do
                                                    local new_index = weapons[rand(1, #weapons)]
                                                    if (picked ~= new_index) then
                                                        picked = new_index
                                                        picked_weapons[#picked_weapons + 1] = new_index
                                                    end
                                                end
                                            end
                                        end

                                        execute_command("god " .. shooter.id)
                                        execute_command("wdel " .. shooter.id)

                                        for K, V in pairs(picked_weapons) do
                                            if (K == 1 or K == 2) then
                                                assign_weapon(spawn_object("weap","",coords.x,coords.y,coords.z,0,V),shooter.id)
                                                
                                                -- To assign a 3rd and 4 weapon, we have to delay 
                                                -- the tertiary and quaternary assignments by at least 200 ms:
                                            elseif (K == 3 or K == 4) then
                                                timer(200, "DelayAssign", shooter.id, V, coords.x, coords.y, coords.z)
                                            end
                                        end
                                    end
                                end
                                
                                -- Set infinite ammo and grenades:
                                write_word(player_object + 0x31F, 7)
                                write_word(player_object + 0x31E, 0x7F7F)
                                for j = 0, 3 do
                                    local weapon = get_object_memory(read_dword(player_object + 0x2F8 + j * 4))
                                    if (weapon ~= 0) then
                                        write_word(weapon + 0x2B6, 9999)
                                    end
                                end
                            end
                        end
                    else
                        -- The maniac that was just selected is still spawning:
                        maniac:rprintAll("Maniac: " .. shooter.name .. " (AWAITING RESPAWN)")
                    end
                end
            end
        end
    end

    if (countdown_begun) then
        countdown = countdown + 0.03333333333333333

        local delta_time = ((set.delay) - (countdown))
        local minutes, seconds = select(1, maniac:secondsToTime(delta_time)), select(2, maniac:secondsToTime(delta_time))

        set.pregame = set.pregame or ""
        set.pregame = gsub(gsub(set.pre_game_message, "%%minutes%%", minutes), "%%seconds%%", seconds)

        if (tonumber(minutes) <= 0) and (tonumber(seconds) <= 0) then

            gamestarted = true
            maniac:StopTimer()

            for i = 1, 16 do
                if player_present(i) then
                
                    -- Init table values for all players:
                    active_shooter[#active_shooter + 1] = {
                        name = get_var(i, "$name"),
                        id = i,
                        timer = 0,
                        duration = set.turn_timer,
                        active = false, expired = false,
                        kills = 0,
                    }
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

                maniac:SelectManiac()
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, '$gt') ~= "n/a") then
        write_byte(gametype_base + 0x7E, 1)
        
        maniac:init()
        current_scorelimit = 0
        
        local scoreTable = maniac:GetScoreLimit()
        if (scoreTable.enabled) then
            maniac:SetScorelimit(scoreTable[1])
        else
            maniac:SetScorelimit(scoreTable.default_scorelimit)
        end
        
        -- Credits to Kavawuvi for this:
        if(read_dword(0x40440000) > 0x40440000 and read_dword(0x40440000) < 0xFFFFFFFF) then
            maniac:SaveMapWeapons()
        end
        --
    end
end

function OnGameEnd()
    maniac:StopTimer()
    gamestarted = false
end

function maniac:gameStartCheck(p)

    local set = maniac.settings
    local player_count = maniac:GetPlayerCount()
    local required = set.required_players

    maniac:modifyScorelimit()

    -- Game hasn't started yet and there ARE enough players to init the pre-game countdown.
    -- Start the timer:
    if (player_count >= required) and (not init_countdown) and (not gamestarted) then
        maniac:StartTimer()
    
    elseif (player_count >= required) and (print_nep) then
        print_nep = false
    
    -- Not enough players to start the game. Set the "not enough players (print_nep)" flag to true.
    -- This will invoke a continuous message that is broadcast server wide 
    elseif (player_count > 0 and player_count < required) then
        print_nep = true
        
    -- Init table values for this player:
    elseif (game_started) then
        active_shooter[#active_shooter + 1] = {
            name = get_var(p, "$name"),
            id = p,
            timer = 0,
            duration = set.turn_timer,
            active = false, expired = false,
            kills = 0
        }
    end
end

function OnPlayerConnect(p)
    maniac:gameStartCheck(p)
end

function OnPlayerDisconnect(PlayerIndex)

    local p = tonumber(PlayerIndex)

    local set = maniac.settings
    local player_count = maniac:GetPlayerCount()
    player_count = player_count - 1

    maniac:modifyScorelimit()

    if (gamestarted) then

        local active_shooter = maniac.settings.active_shooter
        local wasManiac = maniac:isManiac(PlayerIndex)

        for k, v in pairs(active_shooter) do
            if (v.id == p) then
                active_shooter[k] = nil
                -- Debugging:
                -- cprint(v.name .. " left and is no longer the Maniac")
            end
        end

        if (player_count <= 0) then

            -- Ensure all timer parameters are set to their default values.
            maniac:StopTimer()

            -- One player remains | ends the game.
        elseif (player_count == 1) then
            for i = 1, 16 do
                if (tonumber(i) ~= tonumber(p)) then
                    if player_present(i) then
                        -- Send game over message to the last remaining player:
                        local msg = gsub(set.end_of_game, "%%name%%", get_var(i, "$name"))
                        maniac:broadcast(msg, true)
                        break
                    end
                end
            end
        elseif (wasManiac) then
            maniac:SelectManiac()
        end

        -- Pre-Game countdown was initiated but someone left before the game began.
        -- Stop the timer, reset the countdown and display the continuous
        -- message emitted when there aren't enough players to start the game.
    elseif (not gamestarted) and (init_countdown and player_count < set.required_players) then
        print_nep = true
        countdown, init_countdown = 0, false
    end
end

function OnManiacKill(_, KillerIndex)

    if (gamestarted) then

        local killer = tonumber(KillerIndex)
        if (killer > 0) then

            local isManiac = maniac:isManiac(killer)

            if (isManiac) then
                if (killer ~= victim) then
                    isManiac.kills = isManiac.kills + 1
                else
                    -- Just in case:
                    isManiac.active = false
                    maniac:SelectManiac()
                end

                maniac:endGameCheck(killer, isManiac.kills)
            end
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, _, Damage, _, _)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex and gamestarted) then

        local isManiac = maniac:isManiac(CauserIndex)
        if (isManiac) then
            local attributes = maniac.settings.attributes
            return true, Damage * attributes.damage_multiplier
        end
    end
end

function maniac:killPlayer(PlayerIndex)
    local player = get_player(PlayerIndex)
    if (player ~= 0) then
        local PlayerObject = read_dword(player + 0x34)
        if (PlayerObject ~= nil) then
            destroy_object(PlayerObject)
        end
    end
end

function maniac:isManiac(PlayerIndex)
    local active_shooter = maniac.settings.active_shooter
    for _, shooter in pairs(active_shooter) do
        if (shooter) then
            if (shooter.id == PlayerIndex and shooter.active) and (not shooter.expired) then
                return shooter
            end
        end
    end
    return false
end

function maniac:broadcast(message, gameover)
    execute_command("msg_prefix \"\"")
    say_all(message)
    execute_command("msg_prefix \" " .. maniac.settings.server_prefix .. "\"")
    if (gameover) then
        execute_command("sv_map_next")
    end
end

function maniac:secondsToTime(seconds, bool)
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

function maniac:StartTimer()
    countdown, init_countdown = 0, true
end

function maniac:StopTimer()
    countdown, init_countdown = 0, false
    print_nep = false

    for i = 1, 16 do
        if player_present(i) then
            maniac:cls(i, 25)
        end
    end
end

function maniac:endGameCheck(PlayerIndex, Kills)
    if (Kills >= current_scorelimit) then
        local name = get_var(PlayerIndex, "$name")
        local msg = gsub(set.end_of_game, "%%name%%", name)
        maniac:broadcast(msg, true)
    end
end

function maniac:rprintAll(msg)
    for i = 1, 16 do
        if player_present(i) then
            maniac:cls(i, 25)
            rprint(i, msg)
        end
    end
end

function maniac:cls(PlayerIndex, count)
    local count = count or 25
    for _ = 1, count do
        rprint(PlayerIndex, " ")
    end
end

function maniac:SelectManiac()
    local set = maniac.settings
    local active_shooter = set.active_shooter

    local players = { }

    for i = 1, 16 do
        if player_present(i) then
            for k, v in pairs(active_shooter) do
                if (k) then
                    if (v.id == i) and (not v.active) and (not v.expired) then
                        players[#players + 1] = i
                    end
                end
            end
        end
    end

    if (#players > 0) then

        math.randomseed(os.time())
        math.random();math.random();math.random();
        local random_player = players[math.random(1, #players)]

        for _, v in pairs(active_shooter) do
            if (v.id == random_player) then
                v.active, set.assign[v.id] = true, true
                maniac:broadcast(gsub(set.new_maniac, "%%name%%", v.name), false)
            end
        end
    else

        -- # Determine who won the game:
        local function HighestKills()
            local kills, name = 0, nil
            for _, player in pairs(active_shooter) do
                if (player.kills > kills) then
                    kills = player.kills
                    name = player.name
                end
            end

            if (kills == 0) then
                return nil, nil
            else
                return kills, name
            end
        end

        local kills, name = HighestKills()
        if (kills ~= nil and name ~= nil) then
            local msg = gsub(set.end_of_game, "%%name%%", name)
            maniac:broadcast(msg, true)
        else
            maniac:broadcast("GAME OVER | No one has any kills!", true)
        end
    end
end

function maniac:deleteWeapons(PlayerIndex)
    local PlayerObject = get_dynamic_player(PlayerIndex)
    if (PlayerObject ~= 0) then
        local WeaponID = read_dword(PlayerObject + 0x118)
        if (WeaponID ~= 0) then
            for j = 0, 3 do
                local ObjectID = read_dword(PlayerObject + 0x2F8 + j * 4)
                destroy_object(ObjectID)
            end
        end
    end
end

function maniac:CamoOnCrouch(PlayerIndex)
    local attributes = maniac.settings.attributes
    if (attributes.invisibility_on_crouch) then
        local player_object = get_dynamic_player(PlayerIndex)
        if (player_object ~= 0) then
            local couching = read_float(player_object + 0x50C)
            if (couching == 1) then
                execute_command("camo " .. PlayerIndex .. " 2")
            end
        end
    end
end

function maniac:SetNav(Maniac)
    for i = 1, 16 do
        if player_present(i) then
            local PlayerSM = get_player(i)
            local PTableIndex = to_real_index(i)
            if (PlayerSM ~= 0) then
                if (Maniac ~= nil) then
                    write_word(PlayerSM + 0x88, to_real_index(Maniac))
                else
                    write_word(PlayerSM + 0x88, PTableIndex)
                end
            end
        end
    end
end

function maniac:getChar(input)
    local char = ""
    if (tonumber(input) > 1) then
        char = "s"
    elseif (tonumber(input) <= 1) then
        char = ""
    end
    return char
end

function maniac:GetPlayerCount()
    return tonumber(get_var(0, "$pn"))
end

function DelayAssign(PlayerIndex, WeaponObject, x, y, z)
    assign_weapon(spawn_object("weap","",x,y,z,0,WeaponObject),PlayerIndex)
end

function maniac:modifyScorelimit()
    local player_count = maniac:GetPlayerCount()
    local scoreTable = maniac:GetScoreLimit()

    if (scoreTable.enabled) then
        local msg = nil

        if (player_count <= 4 and current_scorelimit ~= scoreTable[1]) then
            maniac:SetScorelimit(scoreTable[1])
            msg = gsub(gsub(scoreTable.txt, "%%scorelimit%%", scoreTable[1]), "%%s%%", maniac:getChar(scoreTable[1]))

        elseif (player_count > 4 and player_count <= 8 and current_scorelimit ~= scoreTable[2]) then
            maniac:SetScorelimit(scoreTable[2])
            msg = gsub(gsub(scoreTable.txt, "%%scorelimit%%", scoreTable[2]), "%%s%%", maniac:getChar(scoreTable[2]))

        elseif (player_count > 9 and player_count <= 12 and current_scorelimit ~= scoreTable[3]) then
            maniac:SetScorelimit(scoreTable[3])
            msg = gsub(gsub(scoreTable.txt, "%%scorelimit%%", scoreTable[3]), "%%s%%", maniac:getChar(scoreTable[3]))

        elseif (player_count > 12 and current_scorelimit ~= scoreTable[4]) then
            maniac:SetScorelimit(scoreTable[4])
            msg = gsub(gsub(scoreTable.txt, "%%scorelimit%%", scoreTable[4]), "%%s%%", maniac:getChar(scoreTable[4]))
        end

        if (msg ~= nil) then
            say_all(msg)
        end
    else
        maniac:SetScorelimit(scoreTable.default_scorelimit)
    end
end

function maniac:GetScoreLimit()
    local scorelimit = maniac.settings
    return (scorelimit["dynamic_scoring"])
end

function maniac:SetScorelimit(score)
    current_scorelimit = score
end

function maniac:getXYZ(PlayerIndex, PlayerObject)
    local coords, x,y,z = { }
    
    local VehicleID = read_dword(PlayerObject + 0x11C)
    if (VehicleID == 0xFFFFFFFF) then
        coords.invehicle = false
        x, y, z = read_vector3d(PlayerObject + 0x5c)
    else
        coords.invehicle = true
        x, y, z  = read_vector3d(get_object_memory(VehicleID) + 0x5c)
    end
    
    coords.x, coords.y, coords.z = x, y, z + 1
    return coords
end

--========================================================================================--
-- Huge credits to Kavawuvi (002) for all of the code below:
-- Taken from this project: https://opencarnage.net/index.php?/topic/4443-random-weapons/
--========================================================================================--
function maniac:SaveMapWeapons()
    local weapons = maniac.settings.weapons

    local function RandomWeaponsContains(TagID)
        for k,v in pairs(weapons) do
            if(v == TagID) then return true end
        end
        return false
    end

    local function ValidWeapon(TagID)
        if(RandomWeaponsContains(TagID)) then return false end
        local tag_index = bit.band(TagID,0xFFFF)
        local tag_count = read_dword(0x4044000C)
        if(tag_index >= tag_count) then return false end
        local tag_array = read_dword(0x40440000)
        local tag_data = read_dword(tag_array + tag_index * 0x20 + 0x14)
        if(read_word(tag_data) ~= 2) then return false end
        local weapon_flags = read_dword(tag_data + 0x308)
        if(bit.band(weapon_flags,math.pow(2,31-28)) > 0) then return false end
        if(read_word(tag_data + 0x45C) == 0xFFFF) then return false end
        return true
    end

    local function AddWeaponToList(TagID)
        if(ValidWeapon(TagID)) then
            weapons[#weapons + 1] = TagID
        end
    end

    local function ScanNetgameEquipment(TagID)
        local tag_array = read_dword(0x40440000)
        local tag_count = read_dword(0x4044000C)
        local tag_index = bit.band(TagID,0xFFFF)
        if(tag_index >= tag_count) then return false end
        local tag_data = read_dword(tag_array + tag_index * 0x20 + 0x14)
        local permutations_count = read_dword(tag_data + 0)
        local permutations_data = read_dword(tag_data + 4)
        for i=0,permutations_count-1 do
            AddWeaponToList(read_dword(permutations_data + i * 84 + 0x24 + 0xC))
        end
    end

    local tag_array = read_dword(0x40440000)
    local tag_count = read_dword(0x4044000C)

    for i=0,tag_count-1 do
        local tag = tag_array + i * 0x20
        if(read_dword(tag) == 0x6D617467) then
            local tag_name = read_dword(tag + 0x10)
            if(read_string(tag_name) == "globals\\globals") then
                local tag_data = read_dword(tag + 0x14)
                local weapons_list_count = read_dword(tag_data + 0x14C)
                local weapons_list_data = read_dword(tag_data + 0x14C + 4)
                for i=0,weapons_list_count-1 do
                    local weapon_id = read_dword(weapons_list_data + i * 0x10)
                    if(ValidWeapon(weapon_id)) then
                        AddWeaponToList(weapon_id)
                    end
                end
            end
        end
    end

    local scnr_tag_data = read_dword(tag_array + 0x20 * read_word(0x40440004) + 0x14)
    local netgame_equipment_count = read_dword(scnr_tag_data + 0x384)
    local netgame_equipment_address = read_dword(scnr_tag_data + 0x384 + 4)
    
    for i=0,netgame_equipment_count-1 do
        local netgame_equip = read_dword(netgame_equipment_address + i * 144 + 0x50 + 0xC)
        ScanNetgameEquipment(netgame_equip)
    end
    
    local starting_equipment_count = read_dword(scnr_tag_data + 0x390)
    local starting_equipment_address = read_dword(scnr_tag_data + 0x390 + 4)
    
    for i=0,starting_equipment_count-1 do
        ScanNetgameEquipment(read_dword(starting_equipment_address + i * 204 + 0x3C + 0xC))
        ScanNetgameEquipment(read_dword(starting_equipment_address + i * 204 + 0x4C + 0xC))
        ScanNetgameEquipment(read_dword(starting_equipment_address + i * 204 + 0x5C + 0xC))
        ScanNetgameEquipment(read_dword(starting_equipment_address + i * 204 + 0x6C + 0xC))
        ScanNetgameEquipment(read_dword(starting_equipment_address + i * 204 + 0x7C + 0xC))
        ScanNetgameEquipment(read_dword(starting_equipment_address + i * 204 + 0x8C + 0xC))
    end
end
