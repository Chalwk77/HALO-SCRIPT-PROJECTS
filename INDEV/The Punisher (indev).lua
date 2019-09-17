--[[
--=====================================================================================================--
Script Name: The Punisher (v1.0), for SAPP (PC & CE)

Description: This script will punish players for certain actions (i.e, betrayals, teamshooting)

* Slightly Over-Engineered mod but meh!

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local punish = {}
local betray_count
local betray_warnings, teamshoot_warnings = { }, { }
local gsub = string.gsub

local globals = nil
local messages = { }

function punish.Init()
    -- Configuration [starts] -----------------------------------------------------
    punish.message_alignment = "|l"
    punish.betrayals = {
        
        -- If enabled, the script will punish players for Betraying:
        enabled = true,
        
        -- Actions taken on players who Betray:
        actions = { -- WARNING: ONLY ONE ACTION CAN BE ENABLED AT A TIME!
        
            ["KILL"] = { -- Player will be warned before being killed automatically.
                use = true,
                -- Player has this many warnings before action is taken:
                warnings = 5,
                
                -- If true the players respawn time will be changed to "respawn_time":
                edit_respawn_time = true,
                respawn_time = 10,
                
                -- If true then players wont get a death penalty point:
                deduct_death = true,
                
                -- If true, the console will be notified when action is taken on a player:
                notify_console = true,
                
                -- message1 = warning message:
                message1 = "%offender_name%, do not betray your team mates or you will be punished! Warnings Left: (%warnings_left%/%total_warnings%)",
                -- message2 = Action Message:
                message2 = '%offender_name%, you were killed for betraying!',
            },
            ["KICK"] = { -- Player will be warned before being kicked automatically.
                use = false,
                warnings = 5,
                edit_respawn_time = true,
                respawn_time = 10,
                deduct_death = true,
                notify_console = true,
                message1 = "%offender_name%, do not betray your team mates or you will be punished! Warnings Left: (%warnings_left%/%total_warnings%)",
                message2 = '%offender_name% was kicked for betraying!',
            },
            ["CRASH"] = { -- Player will be warned before being crashed automatically.
                use = false,
                warnings = 5,
                notify_console = true,
                message1 = "%offender_name%, do not betray your team mates or you will be punished! Warnings Left: (%warnings_left%/%total_warnings%)",
                message2 = "%offender_name%'s game client was crashed (by server) for betraying!",
            },
        }
    }
    
    punish.teamshooting = {
        enabled = true,
        actions = { -- WARNING: ONLY ONE ACTION CAN BE ENABLED AT A TIME!
            ["KILL"] = {
                use = true,
                warnings = 5,
                edit_respawn_time = true,
                respawn_time = 10,
                deduct_death = true,
                notify_console = true,
                message1 = "%offender_name%, do not Team-Shoot or you will be punished! Warnings Left: (%warnings_left%/%total_warnings%)",
                message2 = '%offender_name%, you were killed for Team Shooting!',
            },
            ["KICK"] = {
                use = false,
                warnings = 5,
                edit_respawn_time = true,
                respawn_time = 10,
                deduct_death = true,
                notify_console = true,
                message1 = "%offender_name%, do not Team-Shoot or you will be punished! Warnings Left: (%warnings_left%/%total_warnings%)",
                message2 = '%offender_name% was kicked for Team Shooting!',
            },
            ["CRASH"] = {
                use = false,
                warnings = 5,
                notify_console = true,
                message1 = "%offender_name%, do not Team-Shoot or you will be punished! Warnings Left: (%warnings_left%/%total_warnings%)",
                message2 = "%offender_name%'s game client was crashed (by server) for Team Shooting!",
            },
        }
    }
    -- Configuration [ends] -----------------------------------------------------
end

function OnScriptLoad()
    
    punish.Init()
    
    -- Register needed Event Callbacks: 
    
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    register_callback(cb['EVENT_TICK'], "OnTick")
    
    if (punish.teamshooting.enabled) then
        register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    end
    
    if (punish.betrayals.enabled) or (punish.teamshooting.enabled) then
        register_callback(cb['EVENT_BETRAY'], "OnPlayerBetray")
        register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
        register_callback(cb['EVENT_LEAVE'], "OnPlayerDisconnect")
    end
    
    if (get_var(0, "$gt") ~= "n/a") then
        punish.Reset()
    end
    
    local gp = sig_scan("8B3C85????????3BF9741FE8????????8B8E2C0200008B4610") + 3
    if (gp == 3) then
        return
    end
    globals = read_dword(gp)
end

function OnScriptUnload()
    -- Not Used
end

function OnGameStart()
    red_flag, blue_flag = read_dword(globals + 0x8), read_dword(globals + 0xC)
end

function OnPlayerConnect(PlayerIndex)

    messages[PlayerIndex] = {
        delta_time = 0,
        msg = {},
    }
    
    if (punish.betrayals.enabled) then
        local betray = punish.betrayals.actions
        for k,_ in pairs(betray) do
            if (betray[k].use) then
                betray_warnings[PlayerIndex] = betray[k].warnings
            end
        end
    end

    if (punish.teamshooting.enabled) then
        local teamshooting = punish.teamshooting.actions
        for k,_ in pairs(teamshooting) do
            if (teamshooting[k].use) then
                teamshoot_warnings[PlayerIndex] = teamshooting[k].warnings
            end
        end
    end    
end

function OnPlayerDisconnect(PlayerIndex)
    -- Clear the array index for this player:
    betray_warnings[PlayerIndex] = nil
    teamshoot_warnings[PlayerIndex] = nil
    messages[PlayerIndex] = nil
end

function punish.warningsReached(params)
    local params = params or nil
    local player = params.player
    
    if (params ~= nil) then
        local current_warnings = params.warning_table
        if (current_warnings[player] < 1) then
            return true
        end
    end
    return false
end

local function SendMessage(player, tab)
    if (tab ~= nil) then
        tab.delta_time = tab.delta_time + 0.03333333333333333
        cls(player)
        
        for i = 1,#tab.msg do        
            rprint(player, punish.message_alignment .. " " .. tab.msg[i])
        end
        
        if (tab.delta_time >= 5) then
            tab.msg, tab.delta_time = {}, 0
        end
    end
end

function OnTick()
    for i = 1,16 do
        if player_present(i) then
            if messages[i] ~= nil then
                SendMessage(i, messages[i])
            end
        end
    end
end

function OnPlayerBetray(PlayerIndex, VictimIndex)
    
    local victim = tonumber(VictimIndex)
    local killer = tonumber(PlayerIndex)
    
    local vTeam, kTeam = get_var(victim, "$team"), get_var(killer, "$team")
    
    if (killer > 0) and (killer ~= victim) and (kTeam == vTeam) then
    
        local betray = punish.betrayals.actions
        local p = { }
        p.player = killer
        p.table = betray
        p.warning_table = betray_warnings
        p.reason = "Betraying"
    
        for k,_ in pairs(betray) do
            if (betray[k].use) then
                p.type = k
                p.msg_type = "betrayals"
                punish.Execute(p)
            end
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    
    local victim = tonumber(PlayerIndex)
    local causer = tonumber(CauserIndex)
    
    local vTeam, kTeam = get_var(victim, "$team"), get_var(causer, "$team")
    
    if (causer > 0) and (causer ~= victim) and (kTeam == vTeam) then
        
        local teamshooting = punish.teamshooting.actions
        local p = { }
        p.player = causer
        p.table = teamshooting
        p.warning_table = teamshoot_warnings
        p.reason = "Team Shooting"
    
        for k,_ in pairs(teamshooting) do
            if (teamshooting[k].use) then
                p.type = k
                p.msg_type = "teamshooting"
                punish.Execute(p)
            end
        end
    end
end

function punish.Execute(params)
    local params = params or nil
    if (params ~= nil) then    
    
        local type = params.type
        local table = params.table
        local player = params.player
        local warning_table = params.warning_table
        local name = get_var(player, "$name")
        local msg_type = params.msg_type
    
        warning_table[player] = warning_table[player] - 1

        if not punish.warningsReached(params) then
            local warnings_left = warning_table[player]
            local total_warnings = table[type].warnings
            
            local msg = gsub(gsub(gsub(table[type].message1, 
            "%%offender_name%%", name), 
            "%%warnings_left%%", warnings_left), 
            "%%total_warnings%%", total_warnings)
            
            local tab = messages[player]
            tab.msg[#tab.msg + 1] = msg
            tab.delta_time = 0
            
        else
            local tab = messages[player]
            tab.msg[#tab.msg + 1] = msg
            tab.delta_time = 0
            
            params.notify_console = table[type].notify_console or nil
            params.name = name
            
            warning_table[player] = table[type].warnings
            
            -- Execute the punishment:
            if (params.type == "KILL") then
                params.respawn_time = table[type].respawn_time or nil
                params.deduct_death = table[type].deduct_death or nil
                params.edit_respawn_time = table[type].edit_respawn_time or nil
                punish.KillSilently(params)
            elseif (params.type == "KICK") then
                punish.Kick(params)
            elseif (params.type == "CRASH") then
                punish.Crash(params)
            end
        end
    end
end

function punish.Reset()
    
    -- Clear the array:
    betray_warnings = { }
    teamshoot_warnings = { }
    
    for i = 1,16 do
        if player_present(i) then
            betray_warnings[i] = punish.betrayals.warnings
            teamshoot_warnings[i] = punish.teamshooting.warnings
        end
    end
end

function punish.Kick(params)
    local params = params or nil
    if (params ~= nil) then
    
        local name = params.name
        local player = params.player
        local reason = params.reason
        local notify_console = params.notify_console
        
        execute_command("k" .. " " .. player .. " " .. reason)
        if (notify_console) then
            cprint(name .. " was kicked for " .. reason)
        end
    end
end

function punish.KillSilently(params)
    local params = params or nil
    
    if (params ~= nil) then
        if ClearInventory(params) then
            local kma = sig_scan("8B42348A8C28D500000084C9") + 3
            local original = read_dword(kma)
            
            safe_write(true)
            write_dword(kma, 0x03EB01B1)
            safe_write(false)
            
            execute_command("kill " .. tonumber(params.player))
            safe_write(true)
            write_dword(kma, original)
            safe_write(false)
            
            if (params.edit_respawn_time) then
                write_dword(get_player(params.player) + 0x2C, tonumber(params.respawn_time) * 33)            
            end
            
            -- Deduct one death:
            if (params.deduct_death) then
                local deaths = tonumber(get_var(params.player, "$deaths"))
                if (deaths > 1) then
                    execute_command("deaths " .. tonumber(params.player) .. " " .. deaths - 1)
                else
                    execute_command_sequence("w8 " .. params.respawn_time .. "; deaths " .. tonumber(params.player) .. " " .. deaths - 1)
                end
            end

            if (params.notify_console) then
                cprint(params.name .. " was killed for " .. params.reason)
            end
        end
    end
end

function punish.Crash(params)
    local params = params or nil
    
    if (params ~= nil) then
        local player_object = get_dynamic_player(params.player)
        if (player_object ~= 0) then
            local x, y, z = read_vector3d(player_object + 0x5C)
            local tag_name = GetRandomVehicleTag()            
            if (tag_name) then
                local vehicleID = spawn_object("vehi", tag_name, x, y, z)
                local vehicleObject = get_object_memory(vehicleID)
                if (vehicleObject ~= 0) then
                    for j = 0, 20 do
                        enter_vehicle(vehicleID, params.player, j)
                        exit_vehicle(params.player)
                    end
                    destroy_object(vehicleID)
                end
                if (params.notify_console) then
                    cprint(params.name .. " was crashed for " .. params.reason)
                end
            end
        end
    end
end

function ClearInventory(params)
    local params = params or nil
    
    if (params ~= nil) then
        local player_object = get_dynamic_player(params.player)
        if (player_object ~= 0) then
        
            -- Set grenade count to zero:
            write_word(player_object + 0x31E, 0)
            write_word(player_object + 0x31F, 0)
            
            -- Loop through player inventory and delete each weapon object:
            local weaponID = read_dword(player_object + 0x118)
            if (weaponID ~= 0) then
                for j = 0, 3 do
                    local weapon = read_dword(player_object + 0x2F8 + 4 * j)
                    if (weapon ~= red_flag) and (weapon ~= blue_flag) then
                        destroy_object(weapon)
                    end
                end
                return true
            end
        end
    end
    return false
end

function GetRandomVehicleTag()
    local temp = { }
    local tag_address = read_dword(0x40440000)
    local tag_count = read_dword(0x4044000C)
    
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = string.reverse(string.sub(read_string(tag), 1, 4))
        if (tag_class == "vehi") then
            temp[#temp + 1] = tag_name
        end
    end
    
    if (#temp > 0) then
        math.randomseed(os.time())
        math.random(); math.random(); math.random()
        return temp[math.random(#temp)]
    end
end

function cls(player)
    if (player) then
        for _ = 1, 25 do
            rprint(player, " ")
        end
    end
end
