--[[
--=====================================================================================================--
Script Name: Trophy Hunter (v2), for SAPP (PC & CE)
Description: This is an adaptation of Kill-Confirmed from Call of Duty.
             When you kill someone, a trophy will fall at your victim's death location.
             In order to actually score you have to collect the trophy.
             
             This mod is designed for stock maps only!
             Message me on github if you want this mod to be designed for a specific map(s).

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local mod = { }

function mod:init()
    mod.settings = { 
    
        -- Scoring -
        claim = 1,               -- Collect your trophy
        claim_other = 1,         -- Collect somebody else's trophy
        claim_self = 2,          -- Collect your killer's trophy
        death_penalty = 1,       -- Death Penalty   [number of points deducted]
        suicide_penalty = 2,     -- Suicide Penalty [number of points deducted]
        scorelimit = 15,         -- The game will end when this scorelimit is reached
        
        -- Some functions temporarily remove the server prefix while broadcasting a message.
        -- This prefix will be restored to 'server_prefix' when the message relay is done.
        -- Enter your servers default prefix here:
        server_prefix = "** SERVER **",
        
        -- If true, trophies belonging to players players who just quit will despawned after 'time_until_despawn' seconds.
        despawn = true,
        -- Amount of time (in seconds) until trophies are despawned:
        time_until_despawn = 15,
        
        -- Type this command to lean how to play:
        info_command = "info",
        
        -- These messages are relayed in chat when you pickup/deny someone's trophy.
        on_claim = {
            "%killer% collected %victim%'s trophy!",
            "%victim% deined %killer%'s trophy!",
            "%player% stole %killer% trophy!",
        },

        -- If enabled, a welcome message will be displayed (see below)
        show_welcome_message = true,
        welcome = {
            "Welcome to Trophy Hunter",
            "Your victim will drop a trophy when they die!",
            "Collect this trophy to get points!",
            "Type %info_command% for more information.",
        },
        
        -- If enabled, the 'info_command' will display the following information:
        enable_info_command = true,
        info = {
            "|l-- POINTS --",
            "|lCollect your victims trophy:           |r+%claim% points",
            "|lCollect somebody else's trophy:        |r+%claim_other% points",
            "|lCollect your killer's trophy:          |r+%claim_self% points",
            "|lDeath Penalty:                         |r-%death_penalty% points",
            "|lSuicide Penalty:                       |r-%suicide_penalty% points",
            "|lCollecting trophies is the only way to score!",
        },
        
        -- Global Message sent when the game ends:
        win = {
            "|c--<->--<->--<->--<->--<->--<->--<->--",
            "|c%name% WON THE GAME!",
            "|c--<->--<->--<->--<->--<->--<->--<->--",
        },

        on_despawn = {
        
            -- Message sent when a player quits (if has trophies on the playing field)
            "%victim%'s trophies will despawn in %seconds% seconds",
        
            -- Message sent if player doesn't return before 'time_until_despawn' seconds elapsed.
            "%victim%'s trophies have despawned!",
            
            -- Message sent if player returns before 'time_until_despawn' seconds has elapsed.
            "%victim%' has returned! Their trophies will no longer despawn!",
        },
    }
end

-- Variables for String Library:
local format = string.format
local sub, gsub = string.sub, string.gsub
local lower, upper = string.lower, string.upper
local match, gmatch = string.match, string.gmatch

-- Variables for Math Library:
local floor, sqrt = math.floor, math.sqrt

-- Game Variables:
local game_over

-- Game Tables: 
local trophies, console_messages = { }, { }
local ip_table = { }
-- ...

function OnScriptLoad()

    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerDisconnect")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_WEAPON_PICKUP'], "OnWeaponPickup")
    
    if (get_var(0, '$gt') ~= 'n/a') then
        if mod:getGametype() then
            
            trophies, console_messages = { }, { }
            mod:init()
            game_over = false
            
            for i = 1,16 do
                if player_present(i) then
                    ip_table[i] = get_var(i, '$ip')
                end
            end
        end
    end
end

function OnScriptUnload()
    for k,v in pairs(trophies) do
        if (k) then
            destroy_object(v.trophy)
        end
    end
end

function OnNewGame()
    if mod:getGametype() then
        mod:init()
        game_over = false
        execute_command("scorelimit " .. mod.settings.scorelimit)
    end
end

function OnGameEnd()
    game_over = true
end

function OnPlayerConnect(PlayerIndex)
    ip_table[PlayerIndex] = get_var(PlayerIndex, '$ip')
    
    local set = mod.settings
    local ip = mod:GetIP(PlayerIndex)
    
    if (set.despawn) then
        local name = get_var(PlayerIndex, "$name")
        for k,v in pairs(trophies) do
            if (k) then
                if (v.vip == ip and v.despawn_trigger == true) then
                    v.despawn_trigger, v.time = false, 0
                    
                    execute_command("msg_prefix \"\"")
                    for k,message in pairs(set.on_despawn) do
                        print(message)
                        if (k == 3) then
                            say_all(gsub(message, "%%victim%%", name))
                        end
                    end
                    execute_command("msg_prefix \"" .. set.server_prefix .. "\" ")
                end
            end
        end
    end
    if (set.show_welcome_message) then
        for i,message in pairs(set.welcome) do
            set.welcome[i] = gsub(message, "%%info_command%%", set.info_command)
        end
        mod:NewConsoleMessage(set.welcome, 10, PlayerIndex, "welcome")
        return false
    end
end

function OnPlayerDisconnect(PlayerIndex)
    local set = mod.settings
    local ip = mod:GetIP(PlayerIndex)
    
    if (set.despawn) then
        local name = get_var(PlayerIndex, "$name")
        for k,v in pairs(trophies) do
            if (k) then
                if (v.vip == ip) then
                    v.despawn_trigger = true
                    execute_command("msg_prefix \"\"")
                    for k,message in pairs(set.on_despawn) do
                        if (k == 1) then
                            say_all(gsub(gsub(message, "%%victim%%", name), "%%seconds%%", v.duration))
                        end
                    end
                    execute_command("msg_prefix \"" .. set.server_prefix .. "\" ")
                end
            end
        end
    end
end

function OnTick()
    if (#console_messages > 0) then
        for k,v in pairs(console_messages) do
            if v.player and player_present(v.player) then
                v.time = v.time + 0.03333333333333333
                
                mod:cls(v.player)                    
                if type(v.message) == "table" then
                    for i = 1,#v.message do                    
                        rprint(v.player, v.message[i])
                    end
                else                    
                    rprint(v.player, v.message)
                end
                
                if (v.time >= v.duration) then
                    if (v.type == "endgame") then trophies = { } end
                    console_messages[k] = nil
                end
            end
        end
    end
    
    if (mod.settings.despawn) then
        for k,v in pairs(trophies) do
            if (k) then
                if (v.despawn_trigger) then
                    v.time = v.time + 0.03333333333333333
                    
                    if (v.time >= v.duration) then
                        destroy_object(v.trophy)
                            
                        execute_command("msg_prefix \"\"")
                        for k,message in pairs(mod.settings.on_despawn) do
                            if (k == 2) then
                                say_all(gsub(message, "%%victim%%", v.vn))
                            end
                        end
                        execute_command("msg_prefix \"" .. mod.settings.server_prefix .. "\" ")
                        
                        trophies[k] = nil
                    end
                end
            end
        end
    end
end

function OnPlayerChat(PlayerIndex, Message, type)
    if (type ~= 6) then
    
        local msg = mod:stringSplit(Message)
        if (#msg == 0) then
            return nil
        end
        
        local set = mod.settings
        local is_command = (sub(msg[1], 1, 1) == "/") or (sub(msg[1], 1, 1) == "\\")
        
        if (is_command) then
            
            msg = gsub(gsub(msg[1], "/",""), "\\", "")
            if (set.enable_info_command and msg == set.info_command) then
                local words = {
                    ["%%claim%%"] = set.claim,
                    ["%%claim_other%%"] = set.claim_other,
                    ["%%claim_self%%"] = set.claim_self,
                    ["%%death_penalty%%"] = set.death_penalty,
                    ["%%suicide_penalty%%"] = set.suicide_penalty
                }
                for i,_ in pairs(set.info) do
                    for k,v in pairs(words) do
                        set.info[i] = gsub(set.info[i], k, v)
                    end
                end
                mod:NewConsoleMessage(set.info, 5, PlayerIndex, "info")
                return false
            end
        end
    end
end

function OnWeaponPickup(PlayerIndex, WeaponIndex, Type)
    if (tonumber(Type) == 1) then
        mod:OnTrophyPickup(PlayerIndex, WeaponIndex)            
    end
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    
    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)
    
    local params = { }
    params.kname, params.vname = get_var(killer, "$name"), get_var(victim, "$name")
    params.victim, params.killer = victim, killer
    params.vip, params.kip = mod:GetIP(victim), mod:GetIP(killer)
    
    if (killer > 0) then
        execute_command("score " .. killer .. " -1")
        mod:spawnTrophy(params)
    elseif (victim == killer) then
        params.type = 1
        mod:UpdateScore(params)
        return false
    end
end

function mod:OnTrophyPickup(PlayerIndex, WeaponIndex)

    local player_object = get_dynamic_player(PlayerIndex)
    local WeaponID = read_dword(player_object + 0x118)
    local set = mod.settings
    
    if (WeaponID ~= 0) then
    
        local weapon = read_dword(player_object + 0x2F8 + (tonumber(WeaponIndex) - 1) * 4)
    
        local WeaponObject = get_object_memory(weapon)
        if (mod:ObjectTagID(WeaponObject) == set.trophy) then
                
            for k,v in pairs(trophies) do
                if (k == weapon) then
                
                    local params = { }
                                    
                    params.killer, params.victim = v.kid, v.vid
                    params.kname, params.vname = v.kn, v.vn
                    params.vip, params.kip = v.vip, v.kip
                    params.name = get_var(PlayerIndex, "$name")
                    
                    local msg = function(table, index)
                        return gsub(gsub(gsub(table[index], "%%killer%%", params.kname), "%%victim%%", params.vname), "%%player%%", params.name)
                    end
                    
                    execute_command("msg_prefix \"\"")
                    
                    
                    if (PlayerIndex == params.killer) then
                        params.type = 2
                        say_all(msg(set.on_claim, 1))
                    elseif (PlayerIndex == params.victim) then
                        params.type = 4
                        say_all(msg(set.on_claim, 2))
                    elseif (PlayerIndex ~= params.killer and PlayerIndex ~= params.victim) then
                        params.type = 3
                        say_all(msg(set.on_claim, 3))
                    end
                    execute_command("msg_prefix \"" .. set.server_prefix .. "\" ")

                    destroy_object(weapon)
                    trophies[k] = nil
                    
                    mod:UpdateScore(params)
                end
            end
        end
    end
end

function mod:UpdateScore(params)
    local params = params or nil
    if (params ~= nil) then
    
        local set = mod.settings
    
        local killer = params.killer
        local victim = params.victim
        local kname = params.kname
       
        if (params.type == 1) then
            execute_command("score " .. killer .. " +" .. set.suicide_penalty)
        elseif (params.type == 2) then
            execute_command("score " .. killer .. " +" .. set.claim)
        elseif (params.type == 3) then
            execute_command("score " .. killer .. " +" .. set.claim_other)
        elseif (params.type == 4) then
            execute_command("score " .. killer .. " +" .. set.claim_self)
        end
        
        if tonumber(get_var(killer, "$score")) >= set.scorelimit then
            game_over = true

            for k,v in pairs(set.win) do
                set.win[k] = gsub(set.win[k], "%%name%%", kname)
            end
            
            for i = 1,16 do
                if player_present(i) then
                    mod:NewConsoleMessage(set.win, 5, i, "endgame")
                end
            end
        end
        
        -- Prevent victim's score from going into negatives:
        if tonumber(get_var(victim, "$score")) <= -1 then
            execute_command("score " .. victim .. " 0")
        end
    end
end

function mod:getGametype()
    local gametype = get_var(1, "$gt")        
        
    local function set(bool)
        if (bool) then
            if (get_var(0, "$ffa") == "0") then
                set.trophy = {"weap", "weapons\\ball\\ball"}
            else
                set.trophy = {"eqip", "powerups\\full-spectrum vision"}
            end
        else
            set.trophy = {"eqip", "powerups\\full-spectrum vision"}
        end
    end
        
    if (gametype == "oddball" or gametype == "race") then
        unregister_callback(cb['EVENT_DIE'])
        unregister_callback(cb['EVENT_TICK'])
        unregister_callback(cb['EVENT_JOIN'])
        unregister_callback(cb['EVENT_CHAT'])
        unregister_callback(cb['EVENT_LEAVE'])
        unregister_callback(cb['EVENT_GAME_END'])
        unregister_callback(cb['EVENT_WEAPON_PICKUP'])
        cprint("Trophy Hunter GAME TYPE ERROR!", 4 + 8)
        cprint("This script doesn't support " .. gt[i], 4 + 8)
        return false
    elseif (gametype == "slayer" or gametype == "koth") then
        set(true)
    elseif (gametype == "ctf") then
        set(false)
    end
    return true
end

function mod:spawnTrophy(params)
    local params = params or nil
    if (params ~= nil) then
    
        local set = mod.settings
    
        local coords = mod:getXYZ(params)
        local x,y,z,offset = coords.x,coords.y,coords.z,coords.offset
        local object = spawn_object("weap", set.trophy, x, y, z + offset)
        
        local trophy = get_object_memory(object)
        trophies[object] = {
        
            kid = params.killer,
            vid = params.victim,
            kn = params.kname, 
            vn = params.vname,
            vip = params.vip,
            kip = params.kip,
            
            trophy = object,
            time = 0,
            duration = set.time_until_despawn,
            despawn_trigger = false,
        }
    end
end

function mod:getXYZ(params)
    local params = params or nil    
    if (params ~= nil) then
        local player_object = get_dynamic_player(params.victim)
        if (player_object ~= 0) then
                
            local coords = { }
            local x,y,z = 0,0,0
            
            if mod:isInVehicle(params.victim) then
                local VehicleID = read_dword(player_object + 0x11C)
                local vehicle = get_object_memory(VehicleID)
                coords.invehicle, coords.offset = true, 0.5
                x, y, z = read_vector3d(vehicle + 0x5c)
            else
                coords.invehicle, coords.offset = false, 0.3
                x, y, z = read_vector3d(player_object + 0x5c)
            end
            coords.x, coords.y, coords.z = format("%0.3f", x), format("%0.3f", y), format("%0.3f", z)
            return coords
        end
    end
end

function mod:NewConsoleMessage(Message, Duration, Player, Type)

    local function Add(a, b, c, d)
        return {
            message = a,
            duration = b,
            player = c,
            type = d,
            time = 0,
        }
    end

    table.insert(console_messages, Add(Message, Duration, Player, Type))
end

function mod:GetIP(p)
    
    if (halo_type == 'PC') then
        ip_address = ip_table[p]
    else
        ip_address = get_var(p, '$ip')
    end
    if ip_address ~= nil then
        return ip_address:match('(%d+.%d+.%d+.%d+:%d+)')
    else
        error(debug.traceback())
    end
end

function mod:isInVehicle(PlayerIndex)
    if (get_dynamic_player(PlayerIndex) ~= 0) then
        local VehicleID = read_dword(get_dynamic_player(PlayerIndex) + 0x11C)
        if VehicleID == 0xFFFFFFFF then
            return false
        else
            return true
        end
    else
        return false
    end
end

function mod:cls(player)
    if (player) then
        for _ = 1, 25 do
            rprint(player, " ")
        end
    end
end

function mod:ObjectTagID(object)
    if (object ~= nil and object ~= 0) then
        return read_string(read_dword(read_word(object) * 32 + 0x40440038))
    else
        return ""
    end
end

function mod:stringSplit(inp, sep)
    if (sep == nil) then
        sep = "%s"
    end
    local t, i = {}, 1
    for str in gmatch(inp, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
