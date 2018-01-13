--[[
--=====================================================================================================--
Script Name: Trophy Hunter (slayer), for SAPP (PC & CE)
Implementing API version: 1.11.0.0
Description:    When you kill someone, a trophy will fall at your victim's death location.
                In order to actually score you have to collect the trophy.

* Credits to Kennan for his version of the Kill-Confirmed add-on for Phasor V2. 
* Trophy Hunter (for SAPP) is an adaptation of and inspired by Kill-Confirmed. 

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- ================================= CONFIGURATION STARTS =================================--
-- Item to drop on death
trophy_tag_id = "weapons\\ball\\ball"

-- SCORING -- 
claim = 1               -- Collect your trophy
claim_other = 1         -- Collect somebody else's trophy
steal_self = 1          -- Collect your killer's trophy
death_penalty = 2       -- death penalty [number of points deducted]
suicide_penalty = 2     -- suicide penalty [number of points deducted]

-- MESSAGE BOARD --
-- Messages are sent to the Console environment
message_board = {
    "Welcome to Trophy Hunter",
    "Your victim will drop a trophy when they die!",
    "Collect this trophy to score!",
    "Type /info or @info for more information",
}

info_board = {
    "|l-- POINTS -- ",
    "|lCollect your victims trophy:           |r+" .. claim .. " points",
    "|lCollect somebody else's trophy:        |r+" .. claim_other .. " points",
    "|lCollect your killer's trophy:          |r+" .. steal_self .. " points",
    "|lDeath Penalty:                         |r-" .. death_penalty .. " points",
    "|lSuicide Penalty:                       |r-" .. suicide_penalty .. " points",
    "|lCollecting trophies is the only way to score.",
}
    
-- How long should the messages be displayed on screen for? (in seconds)
welcome_message_duration = 7
info_board_message_duration = 7

-- If a player quits the game and their trophies are still on the playing field, how long until they are removed (destroyed/despawned)?
destroy_duration = 15

scorelimit = 15

-- Message alignment (welcome messages):
-- Left = l,    Right = r,    Center = c,    Tab: t
alignment = "l"
-- ================================= CONFIGURATION ENDS =================================--

-- tables --
tags = { }
players = { }
new_timer = { }
info_board_timer = { }
info_timer = { }
trophy_count = { }
despawn_bool = { }
welcome_timer = { }
destroy_timer = { }
trophy_drone_table = { }
current_players = 0
timer_delay_destroy = 0

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_WEAPON_PICKUP'], "OnWeaponPickup")
    if CheckType() == true then
        for i = 1, 16 do
            if player_present(i) then
                current_players = current_players + 1
                players[get_var(i, "$n")].score = 0
                players[get_var(i, "$n")].new_timer = 0
                players[get_var(i, "$n")].info_board_timer = 0
            end
        end
    end
end

function OnNewGame()
    if CheckType() == true then
        for i = 1, 16 do
            if player_present(i) then
                current_players = current_players + 1
                players[get_var(i, "$n")].score = 0
                players[get_var(i, "$n")].new_timer = 0
                players[get_var(i, "$n")].info_board_timer = 0
            end
        end
        game_over = false
        if tonumber(death_penalty) > 1 then character1 = "s" elseif tonumber(death_penalty) == 1 then character1 = "" end
        if tonumber(suicide_penalty) > 1 then character2 = "s" elseif tonumber(suicide_penalty) == 1 then character2 = "" end
    end
end

function OnGameEnd()
    for i = 1, 16 do
        if player_present(i) then
            if player_present(i) then
                welcome_timer[i] = false
                info_timer[i] = false
                players[get_var(i, "$n")].score = 0
                players[get_var(i, "$n")].new_timer = 0
                players[get_var(i, "$n")].info_board_timer = 0
            end
        end
    end
    game_over = true
end

function OnPlayerJoin(PlayerIndex)
    
    welcome_timer[PlayerIndex] = true
    info_timer[PlayerIndex] = false
    current_players = current_players + 1
    
    players[get_var(PlayerIndex, "$n")] = { }
    players[get_var(PlayerIndex, "$n")].score = 0
    players[get_var(PlayerIndex, "$n")].new_timer = 0
    players[get_var(PlayerIndex, "$n")].info_board_timer = 0
    
    for i = 1,16 do trophy_drone_table[i] = { } end
    trophy_count[PlayerIndex] = 0
end

function OnPlayerLeave(PlayerIndex)
    
    welcome_timer[PlayerIndex] = false
    info_timer[PlayerIndex] = false
    
    players[get_var(PlayerIndex, "$n")] = { }
    players[get_var(PlayerIndex, "$n")].score = 0
    players[get_var(PlayerIndex, "$n")].new_timer = 0
    players[get_var(PlayerIndex, "$n")].info_board_timer = 0
    current_players = current_players - 1
    
    drone_player_id = tonumber(PlayerIndex)
    
    for k, v in pairs(trophy_drone_table[drone_player_id]) do
        if trophy_drone_table[drone_player_id][k] > 0 then
            despawn_bool[PlayerIndex] = true
            destroy_timer[PlayerIndex] = true
            drone_player_id_name = get_var(drone_player_id, "$name")
        else
            despawn_bool[PlayerIndex] = false
            destroy_timer[PlayerIndex] = true
        end
    end
    execute_command("msg_prefix \"\"")
    if despawn_bool[PlayerIndex] == true then
        say_all(get_var(drone_player_id, "$name") .. "'s trophy/trophies will despawn in " .. destroy_duration .. " seconds!")
    end
    execute_command("msg_prefix \"** SERVER ** \"")
end

function OnTick()
    if (destroy_timer[drone_player_id] == true) then
        if trophy_count[victim_drone] == 0 then destroy_timer[drone_player_id] = false end
        timer_delay_destroy = timer_delay_destroy + 0.030
        if timer_delay_destroy >= math.floor(destroy_duration) then
            for k, v in pairs(trophy_drone_table[drone_player_id]) do
                if trophy_drone_table[drone_player_id][k] > 0 then
                    if v then
                        if trophy_drone then
                            destroy_object(v)
                        end
                    end
                    trophy_drone_table[drone_player_id][k] = nil
                end
            end
            execute_command("msg_prefix \"\"")
            say_all(drone_player_id_name .. "'s trophies have despawned!")
            execute_command("msg_prefix \"** SERVER ** \"")
            timer_delay_destroy = 0
            destroy_timer[drone_player_id] = false
        end
    end
    for i = 1, 16 do
        if player_present(i) then
            if (welcome_timer[i] == true) then
                players[get_var(i, "$n")].new_timer = players[get_var(i, "$n")].new_timer + 0.030
                ClearConsole(i)
                for k, v in pairs(message_board) do rprint(i, "|" .. alignment .. " " .. v) end
                if players[get_var(i, "$n")].new_timer >= math.floor(welcome_message_duration) then
                    welcome_timer[i] = false
                    players[get_var(i, "$n")].new_timer = 0
                end
            end
        end
    end
    for j = 1, 16 do
        if player_present(j) then
            if (info_timer[j] == true) then
                players[get_var(j, "$n")].info_board_timer = players[get_var(j, "$n")].info_board_timer + 0.030
                ClearConsole(j)
                for k, v in pairs(info_board) do rprint(j, v) end
                if players[get_var(j, "$n")].info_board_timer >= math.floor(info_board_message_duration) then
                    info_timer[j] = false
                    players[get_var(j, "$n")].info_board_timer = 0
                end
            end
        end
    end
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    
    -- used to handle trophy despawning
    victim_drone = tonumber(PlayerIndex)
    
    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)
    
    local victim_name = get_var(victim, "$name")
    local killer_name = get_var(killer, "$name")
    
    if (killer > 0) and (victim ~= killer) then
        if get_var(1, "$gt") == "slayer" then execute_command("score " .. killer .. " -1") end
        if PlayerInVehicle(tonumber(PlayerIndex)) == false then
            x, y, z  = read_vector3d(get_dynamic_player(PlayerIndex) + 0x5C)
            offset = 0.3
        elseif PlayerInVehicle(tonumber(PlayerIndex)) == true then
            offset = 0.5
            x, y, z = read_vector3d(get_object_memory(read_dword(get_dynamic_player(PlayerIndex) + 0x11C)) + 0x5c)
        end

        local trophy_object = spawn_object("weap", trophy_tag_id, x, y, z + offset)
        trophy_count[victim_drone] = trophy_count[victim_drone] + 1
        
        -- used to handle trophy despawning
        trophy_object_drone = trophy_object
        trophy_drone_table[PlayerIndex] = trophy_drone_table[PlayerIndex] or { }
        table.insert(trophy_drone_table[PlayerIndex], trophy_object)
        trophy_drone = get_object_memory(trophy_object)
        
        -- Get memory address of trophy
        local m_object = get_object_memory(trophy_object)
        -- Pin data to trophy that just spawned
        tags[m_object] = get_var(PlayerIndex, "$hash") .. ":" .. get_var(KillerIndex, "$hash") .. ":" .. get_var(PlayerIndex, "$n") .. ":" .. get_var(KillerIndex, "$n") .. ":" .. victim_name .. ":" .. killer_name
        trophy = m_object
        
        -- Deduct the value of "death_penalty" from victim's score
        updatescore(PlayerIndex, tonumber(death_penalty), false)
        rprint(PlayerIndex, "Death Penalty: -" .. tostring(death_penalty) .. " point" .. tostring(character1))
        
    elseif tonumber(PlayerIndex) == tonumber(KillerIndex) then
        -- Deduct the value of "suicide_penalty" from victim's score
        updatescore(PlayerIndex, tonumber(suicide_penalty), false)
        rprint(PlayerIndex, "Suicide Penalty: -" .. tostring(suicide_penalty) .. " point" .. tostring(character2))
    end
    -- prevent score from going into negatives
    if tonumber(get_var(PlayerIndex, "$score")) <= -1 then execute_command("score " .. PlayerIndex .. " 0") end
end

function OnWeaponPickup(PlayerIndex, WeaponIndex, Type)
    if tonumber(Type) == 1 then
        local WeaponObject = get_object_memory(read_dword(get_dynamic_player(PlayerIndex) + 0x2F8 +(tonumber(WeaponIndex) - 1) * 4))
        if (ObjectTagID(WeaponObject) == trophy_tag_id) then
            local t = tokenizestring(tostring(tags[trophy]), ":")
            OnTagPickup(PlayerIndex, t[1], t[2], t[3], t[4], t[5], t[6])
            local weaponId = read_dword(get_dynamic_player(PlayerIndex) + 0x2F8 +(tonumber(WeaponIndex) - 1) * 4)
            destroy_object(weaponId)
            table.remove(trophy_drone_table[victim_drone], 1)
            trophy_count[victim_drone] = trophy_count[victim_drone] - 1
        end
    end
end

function OnTagPickup(PlayerIndex, victim_hash, killer_hash, victim_id, killer_id, victim_name, killer_name)
    -- PlayerIndex is the player who picked up the victims tag
    if tostring(victim_hash) and tostring(killer_hash) and tonumber(victim_id) and tonumber(killer_id) then
        execute_command("msg_prefix \"\"")
        -- killer claimed their trophy
        if get_var(PlayerIndex, "$hash") == killer_hash then
            say_all(get_var(PlayerIndex, "$name") .. " collected " .. tostring(victim_name) .. "'s trophy!")
            updatescore(PlayerIndex, tonumber(claim), true)
        -- player stole killer's trophy
        elseif get_var(PlayerIndex, "$hash") ~= killer_hash or get_var(PlayerIndex, "$hash") ~= victim_hash then
            if get_var(PlayerIndex, "$name") ~= get_var(victim_id, "$name") then
                updatescore(PlayerIndex, tonumber(claim_other), true)
                say_all(get_var(PlayerIndex, "$name") .. " stole " .. tostring(killer_name) .. "'s trophy on " .. tostring(victim_name) .. "!")
            end
        end
        -- victim claimed killer's trophy on themselves
        if PlayerIndex == tonumber(victim_id) then
            updatescore(PlayerIndex, tonumber(steal_self), true)
            say_all(get_var(PlayerIndex, "$name") .. " stole " .. tostring(killer_name) .. "'s trophy on themselves!")
        end
        execute_command("msg_prefix \"** SERVER ** \"")
    end
end

function updatescore(PlayerIndex, number, bool)
    local m_player = get_player(PlayerIndex)
    if m_player then
        if bool ~= nil then
            if (bool == true) then
                execute_command("score " .. PlayerIndex .. " +" .. number)
                players[get_var(PlayerIndex, "$n")].score = tonumber(get_var(PlayerIndex, "$score"))
                if players[get_var(PlayerIndex, "$n")].score >= (scorelimit + 1) then
                    game_over = true
                    OnWin("--<->--<->--<->--<->--<->--<->--<->--", PlayerIndex)
                    OnWin(get_var(PlayerIndex, "$name") .. " WON THE GAME!", PlayerIndex)
                    OnWin("--<->--<->--<->--<->--<->--<->--<->--", PlayerIndex)
                    OnWin(" ", PlayerIndex)
                    OnWin(" ", PlayerIndex)
                    OnWin(" ", PlayerIndex)
                    rprint(PlayerIndex, "|c-<->-<->-<->-<->-<->-<->-<->")
                    rprint(PlayerIndex, "|cYOU WIN!")
                    rprint(PlayerIndex, "|c-<->-<->-<->-<->-<->-<->-<->")
                    rprint(PlayerIndex, "|c ")
                    rprint(PlayerIndex, "|c ")
                    rprint(PlayerIndex, "|c ")
                    execute_command("sv_map_next")
                end
            elseif (bool == false) then
                execute_command("score " .. PlayerIndex .. " -" .. number)
            end
            if not game_over then
                if tonumber(get_var(PlayerIndex, "$score")) <= -1 then
                    execute_command("score " .. PlayerIndex .. " 0")
                end
                rprint(PlayerIndex, "Trophy points needed to win: " .. tonumber(get_var(PlayerIndex, "$score")) .. "/" .. scorelimit)
            end
        end
    end
end

function CheckType()
    local bool = nil
    if (get_var(1, "$gt") == "ctf") or (get_var(1, "$gt") == "koth") or (get_var(1, "$gt") == "oddball") or (get_var(1, "$gt") == "race") then
        unregister_callback(cb['EVENT_DIE'])
        unregister_callback(cb['EVENT_TICK'])
        unregister_callback(cb['EVENT_JOIN'])
        unregister_callback(cb['EVENT_CHAT'])
        unregister_callback(cb['EVENT_LEAVE'])
        unregister_callback(cb['EVENT_GAME_END'])
        unregister_callback(cb['EVENT_WEAPON_PICKUP'])
        cprint("Trophy Hunter - Error!", 4 + 8)
        cprint("This script doesn't support " .. get_var(1, "$gt"), 4 + 8)
        bool = false
    else
        bool = true
    end
    return bool
end

function PlayerInVehicle(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        local VehicleID = read_dword(player_object + 0x11C)
        if VehicleID == 0xFFFFFFFF then
            return false
        else
            return true
        end
    else
        return false
    end
end

function OnPlayerChat(PlayerIndex, Message, type)
    local Message = string.lower(Message)
    if (Message == "/info") or(Message == "/info ") or(Message == "\\info") or(Message == "\\info ") or(Message == "@info") or(Message == "@info ") then
        if (tonumber(get_var(PlayerIndex, "$lvl"))) >= -1 then
            info_timer[PlayerIndex] = true
            welcome_timer[PlayerIndex] = false
            return false
        end
    end
end

function OnWin(Message, PlayerIndex)
    for i = 1, 16 do
        if player_present(i) then
            if i ~= PlayerIndex then
                rprint(i, "|c" .. Message)
            end
        end
    end
end

function ObjectTagID(object)
    if (object ~= nil and object ~= 0) then
        return read_string(read_dword(read_word(object) * 32 + 0x40440038))
    else
        return ""
    end
end

function ClearConsole(PlayerIndex)
    for clear_cls = 1, 15 do
        rprint(PlayerIndex, " ")
    end
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = { }; i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
