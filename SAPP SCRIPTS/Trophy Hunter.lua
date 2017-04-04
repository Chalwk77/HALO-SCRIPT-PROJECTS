--[[
Script Name: Trophy Hunter (slayer), for SAPP | (PC|CE)

Description:    When you kill someone, a skull-trophy will fall at your victims death location.
                To claim your kill, you have to retrieve the skull.
                To deny a kill, pick up someone elses skull-trophy.
                The only way to score is to pickup a trophy.

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

-- Full-Spectrum-Vision Cubes will take place of oddballs in a future update.
-- Item to drop on death
tag_item = "weapons\\ball\\ball"

-- Scoring:
-- Confirm your own kill:
confirm_self = 2
-- Claim someone elses kill:
confirm_kill_other = 1
-- Deny someone's kill on yourself:
deny_kill_self = 3
-- Death Penalty (This many points taken away on death) - PvP only
death_penalty = 1

-- If you have issues with weapons being removed, increase this number to between 200-300
drop_delay = 150

-- How long should the message be displayed on screen for? (in seconds) --
Welcome_Msg_Duration = 15
-- Message Alignment:
-- Left = l,    Right = r,    Center = c,    Tab: t
Alignment = "l"

-- SENT TO CONSOLE --
message_board = {
    "Welcome to Trophy Hunter",
    "A skull-trophy will fall at your victims death location.",
    "To confirm your kill and score, you have to retrieve the skull-trophy.",
    "To deny a kill, pick up someone elses trophy.",
    }

tags = { }
players = { }
new_timer = { }
name_table = { }
welcome_timer = { }
function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_WEAPON_PICKUP'], "OnWeaponPickup")
    if (CheckType == true) then
        for i = 1, 16 do
            if player_present(i) then
                name_table[i] = { }
                local player_id = get_var(i, "$n")
                players[player_id].new_timer = 0
                players[player_id].trophies = 0
                players[player_id].kills = 0
            end
        end
    end
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            if (welcome_timer[i] == true) then
                local player_id = get_var(i, "$n")
                players[player_id].new_timer = players[player_id].new_timer + 0.030
                cls(i)
                for k, v in pairs(message_board) do rprint(i, "|" .. Alignment .. " " .. v) end
                if players[player_id].new_timer >= math.floor(Welcome_Msg_Duration) then
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
                name_table[i] = { }
                local player_id = get_var(i, "$n")
                players[player_id].new_timer = 0
                players[player_id].trophies = 0
                players[player_id].kills = 0
            end
        end
    end
end

function OnGameEnd()
    for i = 1, 16 do
        if player_present(i) then
            if player_present(i) then
                welcome_timer[i] = false
                local player_id = get_var(i, "$n")
                players[player_id].new_timer = 0
                players[player_id].trophies = 0
                players[player_id].kills = 0
            end
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    welcome_timer[PlayerIndex] = true
    local player_id = get_var(PlayerIndex, "$n")
    players[player_id] = { }
    players[player_id].trophies = 0
    players[player_id].kills = 0
    players[player_id].new_timer = 0
end

function OnPlayerLeave(PlayerIndex)
    welcome_timer[PlayerIndex] = false
    local player_id = get_var(PlayerIndex, "$n")
    players[player_id] = { }
    players[player_id].trophies = 0
    players[player_id].kills = 0
    players[player_id].new_timer = 0
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    local Victim_ID = tonumber(PlayerIndex)
    local Killer_ID = tonumber(KillerIndex)
    
    local Victim_Name = get_var(Victim_ID, "$name")
    local Killer_Name = get_var(Killer_ID, "$name")
    
    local Victim_Hash = get_var(Victim_ID, "$hash")
    local Killer_Hash = get_var(Killer_ID, "$hash")
    
    
    if (Killer_ID > 0) and (Victim_ID ~= Killer_ID) then
        execute_command("score " .. Killer_ID .. " -1")
        local player_id = get_var(KillerIndex, "$n")
        players[player_id].kills = players[player_id].kills + 1
        local player_object = get_dynamic_player(Victim_ID)
        local x, y, z = read_vector3d(player_object + 0x5C)
        local trophy = spawn_object("weap", tag_item, x, y, z + 0.3)
        name_table[Victim_ID] = name_table[Victim_ID] or { }
        name_table[Killer_ID] = name_table[Killer_ID] or { }
        table.insert(name_table[Victim_ID], tostring(Victim_Name))
        table.insert(name_table[Killer_ID], tostring(Killer_Name))
        m_object = get_object_memory(trophy)
        tags[m_object] = Victim_Hash .. ":" .. Killer_Hash .. ":" .. Victim_ID .. ":" .. Killer_ID .. ":" .. Victim_Name .. ":" .. Killer_Name
        trophy_obj = trophy
        updatescore(PlayerIndex, tonumber(death_penalty), false)
        rprint(PlayerIndex, "Death Penalty: -" .. tonumber(death_penalty) .. " point(s)")
    end
end

function OnWeaponPickup(PlayerIndex, WeaponIndex, Type)
    local PlayerObj = get_dynamic_player(PlayerIndex)
    local WeaponObj = get_object_memory(read_dword(PlayerObj + 0x2F8 + (tonumber(WeaponIndex) -1) * 4))
    local weapon = read_string(read_dword(read_word(WeaponObj) * 32 + 0x40440038))
    if (weapon == tag_item) then
        if tags[m_object] ~= nil then
            if (WeaponObj == m_object) then
                local t = tokenizestring(tostring(tags[m_object]), ":")
                OnTagPickup(PlayerIndex, t[1], t[2], t[3], t[4], t[5], t[6], t[7], t[8])
                timer(drop_delay, "delay_drop", PlayerIndex)
            end
        end
    end
end

function OnTagPickup(PlayerIndex, victim_hash, killer_hash, victim_id, killer_id, victim_name, killer_name)
    local killer = tonumber(killer_id)
    local victim = tonumber(victim_id)
    if (victim_hash and killer_hash) and (victim_id and killer_id) and (killer and victim) then
        if get_var(PlayerIndex, "$hash") == (killer_hash) and get_var(PlayerIndex, "$hash") ~= (victim_hash) then
            AnnounceChat(get_var(killer, "$name") .. " claimed " .. victim_name .. "'s  trophy!", killer, victim)
            execute_command("msg_prefix \"\"")
            say(killer, "You have claimed "  .. victim_name .. "'s trophy")
            say(victim, killer_name .. " claimed your trophy!")
            execute_command("msg_prefix \"** SERVER ** \"")
            updatescore(PlayerIndex, tonumber(confirm_self), true)
            local player_id = get_var(killer, "$n")
            players[player_id].trophies = players[player_id].trophies + tonumber(confirm_self)
            execute_command("msg_prefix \"\"")
            rprint(killer, "[TROPHIES] You have " .. tonumber(math.floor(players[player_id].trophies)) .. " trophy points and " .. tonumber(math.floor(players[player_id].kills)) .. " kills")
            execute_command("msg_prefix \"** SERVER ** \"")
        elseif get_var(PlayerIndex, "$hash") ~= (killer_hash) or get_var(PlayerIndex, "$hash") ~= (victim_hash) then
            if get_var(PlayerIndex, "$name") ~= victim_name and get_var(PlayerIndex, "$name") ~= killer_name then
                AnnounceChat(get_var(victim, "$name") .. " claimed " .. killer_name .. "'s trophy-kill on " .. victim_name .. "!", victim)
                execute_command("msg_prefix \"\"")
                say(victim, "You have claimed " .. killer_name .. "'s trophy-kill on " .. victim_name .. "!")
                execute_command("msg_prefix \"** SERVER ** \"")
                updatescore(PlayerIndex, tonumber(confirm_kill_other), true)
                local player_id = get_var(killer, "$n")
                players[player_id].trophies = players[player_id].trophies + tonumber(confirm_kill_other)
                execute_command("msg_prefix \"\"")
                rprint(killer, "[TROPHIES] You have " .. tonumber(math.floor(players[player_id].trophies)) .. " trophy points and " .. tonumber(math.floor(players[player_id].kills)) .. " kills")
                execute_command("msg_prefix \"** SERVER ** \"")
            end
        end
        if get_var(PlayerIndex, "$hash") == (victim_hash) and get_var(PlayerIndex, "$hash") ~= (killer_hash) then
            AnnounceChat(get_var(victim, "$name") .. " denied " .. killer_name .. "'s trophy-kill on themselves!", victim, killer)
            execute_command("msg_prefix \"\"")
            say(victim, "You have Denied " .. killer_name .. "'s trophy-kill on yourself!")
            say(killer, victim_name .. " denied your trophy-kill on themselves!")
            execute_command("msg_prefix \"** SERVER ** \"")
            updatescore(PlayerIndex, tonumber(deny_kill_self), true)
            local player_id = get_var(killer, "$n")
            players[player_id].trophies = players[player_id].trophies + tonumber(deny_kill_self)
            execute_command("msg_prefix \"\"")
            rprint(killer, "[TROPHIES] You have " .. tonumber(math.floor(players[player_id].trophies)) .. " trophy points and " .. tonumber(math.floor(players[player_id].kills)) .. " kills")
            execute_command("msg_prefix \"** SERVER ** \"")
        end
    end
end

function updatescore(PlayerIndex, number, bool)
    local m_player = get_player(PlayerIndex)
    if m_player then
        if bool ~= nil then
            if (bool == true) then
                execute_command("score " .. PlayerIndex .. " +" .. number)
            elseif (bool == false) then
                execute_command("score " .. PlayerIndex .. " -" .. number)
            end
        end
    end
end

function delay_drop(PlayerIndex)
    drop_weapon(PlayerIndex)
    local item = get_object_memory(trophy_obj)
    destroy_object(trophy_obj)
end

function CheckType()
    if (get_var(1, "$gt") == "ctf") or (get_var(1, "$gt") == "koth") or (get_var(1, "$gt") == "oddball") or (get_var(1, "$gt") == "race") then
        unregister_callback(cb['EVENT_DIE'])
        unregister_callback(cb['EVENT_JOIN'])
        unregister_callback(cb['EVENT_LEAVE'])
        unregister_callback(cb['EVENT_WEAPON_PICKUP'])
        cprint("Kill-Confirmed Error:", 4 + 8)
        cprint("This script doesn't support " .. get_var(1, "$gt"), 4 + 8)
        return false
    else
        return true
    end
end

function AnnounceChat(Message, killer, victim)
    for i = 1, 16 do
        if player_present(i) then
            if (i ~= killer and i ~= victim) then
                execute_command("msg_prefix \"\"")
                say(i, " " .. Message)
                execute_command("msg_prefix \"** SERVER ** \"")
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

function cls(PlayerIndex)
    for clear_cls = 1, 25 do
        rprint(PlayerIndex, " ")
    end
end