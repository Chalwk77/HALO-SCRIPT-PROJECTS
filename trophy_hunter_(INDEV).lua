--[[
Script Name: Trophy Hunter (slayer), for SAPP | (PC|CE)

Description:    When you kill someone, a skull-trophy will fall at your victims death location.
                To claim your kill and score, you have to retrieve the skull.
                To deny a kill, pick up someone else's skull-trophy.

                To Do: [1] CTF Compatibility
                       [2] Full-Spectrum-Vision cubes instead of oddballs
               
This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

* IGN: Chalwk
* This is my extension of Kill Confirmed ~ re-written and converted for SAPP (PC|CE)
* Credits to Kennan for the original Kill Confirmed add-on for Phasor.
* Written by Jericho Crosby (Chalwk)
------------------------------------
]]--

api_version = "1.11.0.0"

--================================= CONFIGURATION STARTS =================================-- 
-- Full-Spectrum-Vision Cubes will take place of oddballs in a future update.
-- Item to drop on death
tag_item = "weapons\\ball\\ball"

-- SCORING -- 
confirm_self = 2        -- Confirm your own kill:
confirm_kill_other = 1  -- Claim someone else's kill:
deny_kill_self = 3      -- Deny someone's kill on yourself:
death_penalty = 1       -- Death Penalty (This many points taken away on death) - PvP only

-- MISCELLANEOUS --
-- If you have issues with weapons being removed when you pick up a trophy, increase this number to between 250-300
drop_delay = 200

-- MESSAGE BOARD --
-- Messages are sent to the Console environment
message_board = {
    "Welcome to Trophy Hunter - IN DEVELOPMENT",
    "A skull-trophy will fall at your victims death location.",
    "To confirm your kill and score, you have to retrieve the skull-trophy.",
    "To deny a kill, pick up someone else's trophy.",
    " ",
    "View Development progress at:",
    "https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS",
    }
    
-- How long should the message be displayed on screen for? (in seconds) --
Welcome_Msg_Duration = 15
-- Message Alignment:
-- Left = l,    Right = r,    Center = c,    Tab: t
Alignment = "l"
--================================= CONFIGURATION ENDS =================================-- 

-- tables --
tags = { }
players = { }
new_timer = { }
stored_data = { }
welcome_timer = { }

-- counts --
current_players = 0

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_WEAPON_PICKUP'], "OnWeaponPickup")
    -- Check if valid gametype.
    if (CheckType == true) then
        for i = 1, 16 do
            if player_present(i) then
                stored_data[i] = { }
                current_players = current_players + 1
                -- reset table elements --
                local player_id = get_var(i, "$n")
                players[player_id].new_timer = 0
                players[player_id].trophies = 0
                players[player_id].kills = 0
                players[player_id].score = 0
            end
        end
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
end

function OnNewGame()
    if (CheckType == true) then
        for i = 1, 16 do
            if player_present(i) then
                stored_data[i] = { }
                current_players = current_players + 1
                -- reset table elements --
                local player_id = get_var(i, "$n")
                players[player_id].new_timer = 0
                players[player_id].trophies = 0
                players[player_id].kills = 0
                players[player_id].score = 0
            end
        end
        game_over = false
    end
end

function OnGameEnd()
    for i = 1, 16 do
        if player_present(i) then
            if player_present(i) then
                -- reset welcome timer --
                welcome_timer[i] = false
                -- reset table elements --
                local player_id = get_var(i, "$n")
                players[player_id].new_timer = 0
                players[player_id].trophies = 0
                players[player_id].kills = 0
                players[player_id].score = 0
            end
        end
        game_over = true
    end
end

function OnPlayerJoin(PlayerIndex)
    -- initialize welcome timer --
    welcome_timer[PlayerIndex] = true
    
    -- Add new player to Current Player Count
    current_players = current_players + 1
    
    -- assign elements to new player and set init to zero --
    local player_id = get_var(PlayerIndex, "$n")
    players[player_id] = { }
    players[player_id].trophies = 0
    players[player_id].kills = 0
    players[player_id].score = 0
    players[player_id].new_timer = 0
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
    -- reset table elements --
    local player_id = get_var(PlayerIndex, "$n")
    players[player_id] = { }
    players[player_id].trophies = 0
    players[player_id].kills = 0
    players[player_id].score = 0
    players[player_id].new_timer = 0
    current_players = current_players - 1 
    if current_players == 0 then
        -- reset scorelimit to 15 --
        scorelimit = 15 
        execute_command("scorelimit " .. scorelimit)
    end
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    
    local Victim_ID = tonumber(PlayerIndex)
    local Killer_ID = tonumber(KillerIndex)
    
    -- Get Killer/Victim's names
    local Victim_Name = get_var(Victim_ID, "$name")
    local Killer_Name = get_var(Killer_ID, "$name")
    
    -- Get Killer/Victim's cd-hash 
    local Victim_Hash = get_var(Victim_ID, "$hash")
    local Killer_Hash = get_var(Killer_ID, "$hash")
    
    if (Killer_ID > 0) and (Victim_ID ~= Killer_ID) then
        -- Deduct 1 point off the killer's score tally. The only way to score is to pickup a trophy.
        execute_command("score " .. Killer_ID .. " -1")
        -- Keep track of the killer's kill-tally
        local player_id = get_var(KillerIndex, "$n")
        players[player_id].kills = players[player_id].kills + 1
        
        -- Retrieve XYZ coords of victim and spawn a trophy at that location.
        local player_object = get_dynamic_player(Victim_ID)
        local x, y, z = read_vector3d(player_object + 0x5C)
        local trophy = spawn_object("weap", tag_item, x, y, z + 0.3)
        
        -- Get memory address of trophy
        m_object = get_object_memory(trophy)
        trophy_object = trophy
        -- Pin data to trophy that just dropped
        tags[m_object] = Victim_Hash .. ":" .. Killer_Hash .. ":" .. Victim_ID .. ":" .. Killer_ID .. ":" .. Victim_Name .. ":" .. Killer_Name
        
        -- Store tags[m_object] data in a table to prevent undesirable behavior
        stored_data[tags] = stored_data[tags] or { }
        table.insert(stored_data[tags], tostring(tags[m_object]))
        
        -- Deduct the value of "death_penalty" from victim's score
        updatescore(PlayerIndex, tonumber(death_penalty), false)
        rprint(PlayerIndex, "Death Penalty: -" .. tonumber(death_penalty) .. " point(s)")
    end
end

function OnWeaponPickup(PlayerIndex, WeaponIndex, Type)
    local PlayerObj = get_dynamic_player(PlayerIndex)
    local WeaponObject = get_object_memory(read_dword(PlayerObj + 0x2F8 + (tonumber(WeaponIndex) -1) * 4))
    -- Check if weapon picked up was an oddball
    if (ObjectTagID(WeaponObject) == tag_item) then
        -- Validate table data
        if stored_data[tags] ~= nil then
            -- Check if weapon is a trophy
            if (WeaponObject == m_object) then
                local t = tokenizestring(tostring(tags[m_object]), ":")
                OnTagPickup(PlayerIndex, t[1], t[2], t[3], t[4], t[5], t[6])
                timer(drop_delay, "drop_and_destroy", PlayerIndex)
            else
                return nil
            end
        end
    end
end

function OnTagPickup(PlayerIndex, victim_hash, killer_hash, victim_id, killer_id, victim_name, killer_name)
    if (victim_hash and killer_hash) and (victim_id and killer_id) and (victim_name and killer_name) then
        -- temporarily remove server message prefix --
        execute_command("msg_prefix \"\"")
        -- Check if Player's hash matches the Killer and not Victim's hash
        if get_var(PlayerIndex, "$hash") == (killer_hash) and get_var(PlayerIndex, "$hash") ~= (victim_hash) then
            local player_id = get_var(killer_id, "$n")
            -- Update player score
            updatescore(PlayerIndex, tonumber(confirm_self), true)
            -- Message Handlers
            respond(get_var(killer_id, "$name") .. " claimed " .. victim_name .. "'s  trophy!", tonumber(killer_id), tonumber(victim_id))
            say(killer_id, "You have claimed "  .. victim_name .. "'s trophy")
            say(victim_id, killer_name .. " claimed your trophy!")
        -- Check if Player's hash does not match Killer's hash or victim's hash
        elseif get_var(PlayerIndex, "$hash") ~= (killer_hash) or get_var(PlayerIndex, "$hash") ~= (victim_hash) then
            -- Check if Player's name does not match Victim's Name or Killer's name
            if get_var(PlayerIndex, "$name") ~= victim_name and get_var(PlayerIndex, "$name") ~= killer_name then
                local player_id = get_var(killer_id, "$n")
                -- Update player score
                updatescore(PlayerIndex, tonumber(confirm_kill_other), true)
                -- Message Handlers
                respond(get_var(victim_id, "$name") .. " claimed " .. killer_name .. "'s trophy-kill on " .. victim_name .. "!", tonumber(victim_id))
                say(victim_id, "You have claimed " .. killer_name .. "'s trophy-kill on " .. victim_name .. "!")
            end
        end
        -- Check if Player's hash matches Victim's hash but doesn't match killer's hash
        if get_var(PlayerIndex, "$hash") == (victim_hash) and get_var(PlayerIndex, "$hash") ~= (killer_hash) then
            local player_id = get_var(killer_id, "$n")
            -- Update player score
            updatescore(PlayerIndex, tonumber(deny_kill_self), true)
            -- Message Handlers
            respond(get_var(victim_id, "$name") .. " denied " .. killer_name .. "'s trophy-kill on themselves!", tonumber(killer_id), tonumber(victim_id))
            say(victim_id, "You have Denied " .. killer_name .. "'s trophy-kill on yourself!")
            say(killer_id, victim_name .. " denied your trophy-kill on themselves!")
        end
        -- reset server message prefix --
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
                cprint(tostring(players[player_id].score))
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
                rprint(PlayerIndex, "Trophy points needed to win: " .. tonumber(get_var(PlayerIndex, "$score")) .. "/" .. scorelimit)
            end
        end
    end
end

function drop_and_destroy(PlayerIndex)
    -- force player to drop the trophy --
    drop_weapon(PlayerIndex)
    -- destroy trophy --
    destroy_object(trophy_object)
end

-- Check if gametype is valid. 
-- Currently, this add-on only supports slayer gametype
function CheckType()
    if (get_var(1, "$gt") == "ctf") or (get_var(1, "$gt") == "koth") or (get_var(1, "$gt") == "oddball") or (get_var(1, "$gt") == "race") then
        unregister_callback(cb['EVENT_DIE'])
        unregister_callback(cb['EVENT_TICK'])
        unregister_callback(cb['EVENT_JOIN'])
        unregister_callback(cb['EVENT_LEAVE'])
        unregister_callback(cb['EVENT_GAME_END'])
        unregister_callback(cb['EVENT_WEAPON_PICKUP'])
        cprint("Kill-Confirmed Error:", 4 + 8)
        cprint("This script doesn't support " .. get_var(1, "$gt"), 4 + 8)
        return false
    else
        return true
    end
end

function respond(Message, killer_id, victim_id)
    for i = 1, 16 do
        if player_present(i) then
            if (i ~= killer_id and i ~= victim_id) then
                execute_command("msg_prefix \"\"")
                say(i, " " .. Message)
                execute_command("msg_prefix \"** SERVER ** \"")
            end
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

function read_widestring(address, length)
    local count = 0
    local byte_table = { }
    for i = 1, length do
        if read_byte(address + count) ~= 0 then
            byte_table[i] = string.char(read_byte(address + count))
        end
        count = count + 2
    end
    return table.concat(byte_table)
end

-- clear the player's console --
function ConsoleClear(PlayerIndex)
    for clear_cls = 1, 25 do
        rprint(PlayerIndex, " ")
    end
end

function ObjectTagID(object)--	Gets directory + name of the object
	if(object ~= nil and object ~= 0) then
		return read_string(read_dword(read_word(object) * 32 + 0x40440038))
	else
		return ""
	end
end