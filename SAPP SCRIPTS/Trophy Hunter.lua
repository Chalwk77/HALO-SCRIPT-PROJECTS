--[[
--=====================================================================================================--
Script Name: Trophy Hunter (slayer), for SAPP (PC & CE)
Implementing API version: 1.11.0.0
Description:    When you kill someone, a skull-trophy will fall at your victim's death location.
                In order to actually score, you have to retrieve the skull.

                -- POINTS --
                Claim your own trophy:                  +1 point
                Steal somebody else's trophy:           +1 point
                Steal someone's kill on yourself:       +1 points
                Death Penalty:                          -2 points
                Suicide Penalty:                        -2 points

* Credits to Kennan for the original Kill Confirmed add-on for Phasor.

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
claim = 1               -- Claim your own trophy
claim_other = 1         -- Steal somebody else's trophy
steal_self = 1          -- Steal someone's trophy on yourself
death_penalty = 2       -- Death Penalty    - PvP
suicide_penalty = 2     -- Suicice Penalty  - Suicide

-- MESSAGE BOARD --
-- Messages are sent to the Console environment
message_board = {
    "Welcome to Trophy Hunter",
    "A trophy will fall at your victim's death location.",
    "Retrieve this trophy to score!",
    "Type /info or @info for more information",
}

info_board = {
    "|l-- POINTS -- ",
    "|lClaim your own trophy:               |r+" .. claim .. " points",
    "|lClaim somebody else's trophy:        |r+" .. claim_other .. " points",
    "|lClaim someone's kill on yourself:    |r+" .. steal_self .. " points",
    "|lDeath Penalty:                       |r-" .. death_penalty .. " points",
    "|lSuicide Penalty:                     |r-" .. suicide_penalty .. " points",
}
    
-- How long should the messages be displayed on screen for? (in seconds)
Welcome_Msg_Duration = 15
Info_Board_Msg_Duration = 15
-- Message Alignment (welcome messages):
-- Left = l,    Right = r,    Center = c,    Tab: t
Alignment = "l"
-- ================================= CONFIGURATION ENDS =================================--

-- tables --
tags = { }
players = { }
new_timer = { }
new_timer2 = { }
info_timer = { }
stored_data = { }
welcome_timer = { }

-- counts --
-- Set initial player count to 0
current_players = 0

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
                stored_data[i] = { }
                current_players = current_players + 1
                local player_id = get_var(i, "$n")
                players[player_id].score = 0
                players[player_id].new_timer = 0
                players[player_id].new_timer2 = 0
            end
        end
    end
end

function OnNewGame()
    if CheckType() == true then
        for i = 1, 16 do
            if player_present(i) then
                stored_data[i] = { }
                -- For all players currently connected to the server, add them to the Current Player Count.
                current_players = current_players + 1
                -- reset table elements --
                local player_id = get_var(i, "$n")
                players[player_id].score = 0
                players[player_id].new_timer = 0
                players[player_id].new_timer2 = 0
            end
        end
        -- Set scorelimit based on total players currently connected to the server
        if current_players >= 1 and current_players <= 5 then
            scorelimit = 15
            execute_command("scorelimit " .. scorelimit)
        elseif current_players >= 5 and current_players <= 10 then
            scorelimit = 30
            execute_command("scorelimit " .. scorelimit)
        elseif current_players >= 10 and current_players <= 16 then
            scorelimit = 50
            execute_command("scorelimit " .. scorelimit)
        end
        game_over = false
        if tonumber(death_penalty) > 1 then character1 = "s" elseif tonumber(death_penalty) == 1 then character1 = "" end
        if tonumber(suicide_penalty) > 1 then character2 = "s" elseif tonumber(suicide_penalty) == 1 then character2 = "" end
    end
end

function OnGameEnd()
    for i = 1, 16 do
        if player_present(i) then
            -- check if player is present
            if player_present(i) then
                -- reset welcome timer --
                welcome_timer[i] = false
                info_timer[i] = false
                -- reset table elements --
                local player_id = get_var(i, "$n")
                players[player_id].score = 0
                players[player_id].new_timer = 0
                players[player_id].new_timer2 = 0
            end
        end
    end
    game_over = true
end

function OnPlayerJoin(PlayerIndex)
    -- initialize welcome timer --
    welcome_timer[PlayerIndex] = true
    info_timer[PlayerIndex] = false
    -- Add new player to Current Player Count
    current_players = current_players + 1
    -- assign elements to new player and set init to zero --
    local player_id = get_var(PlayerIndex, "$n")
    players[player_id] = { }
    players[player_id].score = 0
    players[player_id].new_timer = 0
    players[player_id].new_timer2 = 0
    -- Set scorelimit based on total players currently connected to the server
    if current_players >= 1 and current_players <= 5 then
        scorelimit = 15
        execute_command("scorelimit " .. scorelimit)
    elseif current_players >= 5 and current_players <= 10 then
        scorelimit = 30
        execute_command("scorelimit " .. scorelimit)
    elseif current_players >= 10 and current_players <= 16 then
        scorelimit = 50
        execute_command("scorelimit " .. scorelimit)
    end
end

function OnPlayerLeave(PlayerIndex)
    -- reset welcome timer --
    welcome_timer[PlayerIndex] = false
    info_timer[PlayerIndex] = false
    -- reset table elements --
    local player_id = get_var(PlayerIndex, "$n")
    players[player_id] = { }
    players[player_id].score = 0
    players[player_id].new_timer = 0
    players[player_id].new_timer2 = 0
    -- Deduct player from Current Player Count
    current_players = current_players - 1
    -- If there are no players currently connected to the server, reset the score limit to 15
    if current_players == 0 then
        scorelimit = 15
        execute_command("scorelimit " .. scorelimit)
    end
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            if (welcome_timer[i] == true) then
                -- init new timer --
                local player_id = get_var(i, "$n")
                players[player_id].new_timer = players[player_id].new_timer + 0.030
                -- clear the player's console --
                ConsoleClear(i)
                -- print the contents of "message_board" to the player's console
                for k, v in pairs(message_board) do rprint(i, "|" .. Alignment .. " " .. v) end
                if players[player_id].new_timer >= math.floor(Welcome_Msg_Duration) then
                    -- reset welcome timer --
                    welcome_timer[i] = false
                    players[player_id].new_timer = 0
                end
            end
        end
    end
    for i = 1, 16 do
        if player_present(i) then
            if (info_timer[i] == true) then
                -- init new timer --
                local player_id = get_var(i, "$n")
                players[player_id].new_timer2 = players[player_id].new_timer2 + 0.030
                -- clear the player's console --
                ConsoleClear(i)
                -- print the contents of "message_board" to the player's console
                for k, v in pairs(info_board) do rprint(i, v) end
                if players[player_id].new_timer2 >= math.floor(Info_Board_Msg_Duration) then
                    -- reset welcome timer --
                    info_timer[i] = false
                    players[player_id].new_timer2 = 0
                end
            end
        end
    end
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    local Victim_ID = tonumber(PlayerIndex)
    local Killer_ID = tonumber(KillerIndex)
    
    -- Get Killer/Victim's names
    local Victim_Name = get_var(Victim_ID, "$name")
    local Killer_Name = get_var(Killer_ID, "$name")
    
    -- Check if the player was a killer
    if (Killer_ID > 0) and (Victim_ID ~= Killer_ID) then
        -- Deduct 1 point off the killer's score tally. The only way to score is to pickup a trophy.
        
        if get_var(1, "$gt") == "slayer" then
            execute_command("score " .. Killer_ID .. " -1")
        end
        
        -- Retrieve XYZ coords of victim and spawn a trophy at that location.
        if PlayerInVehicle(tonumber(PlayerIndex)) == false then
            x, y, z  = read_vector3d(get_dynamic_player(PlayerIndex) + 0x5C)
            offset = 0.3
        elseif PlayerInVehicle(tonumber(PlayerIndex)) == true then
            offset = 0.5
            x, y, z = read_vector3d(get_object_memory(read_dword(get_dynamic_player(PlayerIndex) + 0x11C)) + 0x5c)
        end
        
        local object = spawn_object("weap", trophy_tag_id, x, y, z + offset)
        
        -- Get memory address of trophy
        local m_object = get_object_memory(object)
        -- Pin data to trophy that just dropped
        tags[m_object] = get_var(PlayerIndex, "$hash") .. ":" .. get_var(KillerIndex, "$hash") .. ":" .. get_var(PlayerIndex, "$n") .. ":" .. get_var(KillerIndex, "$n") .. ":" .. Victim_Name .. ":" .. Killer_Name
        trophy = m_object
        -- Store tags[m_object] data in a table to prevent undesirable behavior
        stored_data[tags] = stored_data[tags] or { }
        table.insert(stored_data[tags], tostring(tags[m_object]))
        
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
            local weaponId = read_dword(get_dynamic_player(PlayerIndex) + 0x118)
            if weaponId ~= 0 and ObjectTagID(WeaponObject) == trophy_tag_id then
                local weaponId = read_dword(get_dynamic_player(PlayerIndex) + 0x2F8 +(tonumber(WeaponIndex) - 1) * 4)
                destroy_object(weaponId)
            end
        end
    end
end

function OnTagPickup(PlayerIndex, victim_hash, killer_hash, victim_id, killer_id, victim_name, killer_name)
    if tostring(victim_hash) and tostring(killer_hash) and tonumber(victim_id) and tonumber(killer_id) then
        execute_command("msg_prefix \"\"")
        if get_var(PlayerIndex, "$hash") == killer_hash then
            say_all(get_var(PlayerIndex, "$name") .. " claimed " .. tostring(victim_name) .. "'s trophy!")
            updatescore(PlayerIndex, tonumber(claim), true)
        elseif get_var(PlayerIndex, "$hash") ~= killer_hash or get_var(PlayerIndex, "$hash") ~= victim_hash then
            if get_var(PlayerIndex, "$name") ~= get_var(victim_id, "$name") then
                updatescore(PlayerIndex, tonumber(claim_other), true)
                say_all(get_var(PlayerIndex, "$name") .. " stole " .. tostring(killer_name) .. "'s trophy on " .. tostring(victim_name) .. "!")
            end
        end
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
                local player_id = get_var(PlayerIndex, "$n")
                players[player_id].score = tonumber(get_var(PlayerIndex, "$score"))
                if players[player_id].score >= (scorelimit + 1) then
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

function ConsoleClear(PlayerIndex)
    for clear_cls = 1, 25 do
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
