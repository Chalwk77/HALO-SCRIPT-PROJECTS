--[[
--=====================================================================================================--
Script Name: Stun Grenades, for SAPP (PC & CE)
Description: Make frags behave like Stun Grenades

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local players = {}

-- Configuration Starts --
local tags = {
    -- Tag | Stun Time | Stun Percent | Enabled/Disabled
    { "weapons\\frag grenade\\explosion",       5,      0.5,      true},
    { "weapons\\plasma grenade\\explosion",     5,      0.5,      true},
    { "weapons\\plasma grenade\\attached",      10,     0.5,      true},
}
-- Configuration Ends --

local delta_time = 0.03333333333333333
local floor = math.floor

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    if (get_var(0, "$gt") ~= "n/a") then
        players = {}
        for i = 1, 16 do
            if player_present(i) then
                initPlayer(i, true)
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        players = {}
    end
end

function OnPlayerSpawn(PlayerIndex)
    for i,player in pairs(players) do
        if (i == PlayerIndex) then
            player.stunned, player.timer = false, 0
        end
    end
end

function OnTick()
    for i,player in pairs(players) do
        if player_alive(i) then
            if (player.stunned) then
                player.timer = player.timer + delta_time
                local timeRemaining = player.stun_duration - floor(player.timer % 60)                
                execute_command("s " .. i .. " " .. player.stun_percent)
                if (timeRemaining <= 0) then
                    initPlayer(i, true)
                    execute_command("s " .. i .. " 1")
                end
            end
        end
    end
end

function OnPlayerConnect(PlayerIndex)
    initPlayer(PlayerIndex, true)
end

function OnPlayerDisconnect(PlayerIndex)
    initPlayer(PlayerIndex, false)
end

function OnScriptUnload()
    --
end

function initPlayer(PlayerIndex, Init)
    if (Init) then
        players[PlayerIndex] = {
            stunned = false,
            timer = 0,
            stun_percent = 0,
            stun_duration = 0,
        }
    else
        players[PlayerIndex] = nil
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
        for Table, _ in pairs(tags) do
            for _, Table in pairs(tags) do
                if (Table[4]) then
                    if (MetaID == GetTag("jpt!", Table[1])) then
                        for i,player in pairs(players) do
                            if (i == PlayerIndex) and player_alive(PlayerIndex) then
                                player.stunned, player.timer = true, 0
                                player.stun_duration, player.stun_percent = Table[2], Table[3]
                                return true
                            end
                        end
                    end
                end
            end
        end
    end
end

function GetTag(obj_type, obj_name)
    local tag = lookup_tag(obj_type, obj_name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end
