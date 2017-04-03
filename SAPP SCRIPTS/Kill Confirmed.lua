--[[
Script Name: Kill Confirmed (slayer), for SAPP | (PC|CE)

Description:    When you kill someone, a skull-trophy will fall at your victims death location.
                To confirm your kill, you have to retrieve the skull.
                To deny a kill, pick up someone elses skull-trophy.

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

-- If you have issues with weapons being removed, increase this number to between 200-300
drop_delay = 150

tags = { }
function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_WEAPON_PICKUP'], "OnWeaponPickup")
    CheckType()
end

function OnNewGame()
    CheckType()
end

function WelcomeHandler(PlayerIndex)
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    ServerName = read_widestring(network_struct + 0x8, 0x42)
    execute_command("msg_prefix \"\"")
    say(PlayerIndex, "Welcome to " .. ServerName)
    say(PlayerIndex, "When you kill someone, a skull-trophy will fall at your victims death location.")
    say(PlayerIndex, "To confirm your kill, you have to retrieve the skull-trophy.")
    say(PlayerIndex, "To deny a kill, pick up someone elses skull-trophy")
    execute_command("msg_prefix \"** SERVER ** \"")
end

function OnPlayerJoin(PlayerIndex)
    timer(1000 * 6, "WelcomeHandler", PlayerIndex)
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)
    if (killer > 0) and (victim ~= killer) then
        local player_object = get_dynamic_player(victim)
        local x, y, z = read_vector3d(player_object + 0x5C)
        local trophy = spawn_object("weap", tag_item, x, y, z + 0.3)
        m_object = get_object_memory(trophy)
        tags[m_object] = get_var(victim, "$hash") .. ":" .. get_var(killer, "$hash") .. ":" .. get_var(victim, "$n") .. ":" .. get_var(killer, "$n")
        trophy_obj = trophy
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
                OnTagPickup(PlayerIndex, t[1], t[2], t[3], t[4])
                timer(drop_delay, "delay_drop", PlayerIndex)
            end
        end
    end
end

function OnTagPickup(PlayerIndex, victim_hash, killer_hash, victim_id, killer_id)
    local killer = get_var(killer_id, "$n")
    local victim = get_var(victim_id, "$n")
    if (victim_hash and killer_hash) and (victim_id and killer_id) and (killer and victim) then
        if get_var(PlayerIndex, "$hash") == (killer_hash) and get_var(PlayerIndex, "$hash") ~= (victim_hash) then
            AnnounceChat(get_var(PlayerIndex, "$name") .. " confirmed their kill on " .. get_var(victim, "$name") .. "!", PlayerIndex)
            say(PlayerIndex, "Kill Confirmed on "  .. get_var(victim, "$name"))
            updatescore(PlayerIndex, tonumber(confirm_self), true)
        elseif get_var(PlayerIndex, "$hash") ~= (killer_hash) or get_var(PlayerIndex, "$hash") ~= (victim_hash) then
            if get_var(PlayerIndex, "$name") ~= get_var(victim, "$name") and get_var(PlayerIndex, "$name") ~= get_var(killer, "$name") then
                AnnounceChat(get_var(PlayerIndex, "$name") .. " confirmed " .. get_var(killer, "$name") .. "'s kill on " .. get_var(victim, "$name") .. "!", PlayerIndex)
                say(PlayerIndex, "You have confirmed " .. get_var(killer, "$name") .. "'s kill on " .. get_var(victim, "$name") .. "!")
                updatescore(PlayerIndex, tonumber(confirm_kill_other), true)
            end
        end
        if get_var(PlayerIndex, "$hash") == (victim_hash) and get_var(PlayerIndex, "$hash") ~= (killer_hash) then
            AnnounceChat(get_var(PlayerIndex, "$name") .. " denied " .. get_var(killer, "$name") .. "'s kill on themselves!", PlayerIndex)
            say(PlayerIndex, "Denied " .. get_var(killer, "$name") .. "'s kill on you!")
            updatescore(PlayerIndex, tonumber(deny_kill_self), true)
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
    end
end

function AnnounceChat(Message, PlayerIndex)
    for i = 1, 16 do
        if player_present(i) then
            if i ~= PlayerIndex then
                cls(i)
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