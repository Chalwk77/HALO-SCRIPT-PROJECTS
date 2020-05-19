--[[
--=====================================================================================================--
Script Name: GuessWho (v1.0), for SAPP (PC & CE)
Description: N/A


Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"

local GuessWho = {

    --===== [ CONFIG STARTS ] ======--

    -- # Number of players required to set the game in motion (cannot be less than 3)
    required_players = 1,

    -- # Continuous message emitted when there aren't enough players.
    not_enough_players = "%current%/%required% players needed to start the game.",

    -- # Countdown delay (in seconds)
    -- This is a pre-game-start countdown initiated at the beginning of each game.
    delay = 10,

    -- # This message is the pre-game broadcast:
    pre_game_message = "|cGuessWho (v1.0) will begin in %minutes%:%seconds%",

    -- # This message is broadcast when the game begins:
    on_game_begin = "The game has begun",

    -- Some functions temporarily remove the server prefix while broadcasting a message.
    -- This prefix will be restored to 'server_prefix' when the message relay is done.
    -- Enter your servers default prefix here:
    server_prefix = "** SERVER **",

    maps = {
        ["bloodgulch"] = {
            r = 2.5,
            x = 65.749893188477,
            y = -120.40949249268,
            z = 0.11860413849354
        },
        -- more maps added in future updates

    }

    --===== [ CONFIG ENDS ] ======--

}

local players = { }
local coordinates = { }

local countdown = 0
local time_scale = 1 / 30
local game_started = false

local gsub = string.gsub
local floor = math.floor
local format = string.format

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb['EVENT_TICK'], "OnTick")

    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")

    register_callback(cb["EVENT_PRESPAWN"], "OnPreSpawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    if (get_var(0, '$gt') ~= "n/a") then
        game_started = false
    end
end

function OnScriptUnload()
    --
end

function OnTick()
    for player, v in pairs(players) do
        if (player) then
            if player_present(player) then

                -- Not Enough players

                if (GameState(player) == 1) then

                    local player_count = tonumber(get_var(0, "$pn"))
                    local msg = gsub(gsub(GuessWho.not_enough_players,
                            "%%current%%", player_count),
                            "%%required%%", GuessWho.required_players)

                    Respond(player, msg, "rcon")

                    -- Show Pre Game Countdown
                elseif (GameState(player) == 2) then

                    countdown = countdown + time_scale
                    local minutes, seconds = secondsToTime(GuessWho.delay - countdown)
                    local msg = gsub(gsub(GuessWho.pre_game_message, "%%minutes%%", minutes), "%%seconds%%", seconds)
                    Respond(player, msg, "rcon")

                    if (tonumber(seconds) <= 0) then
                        game_started = true
                        SetCircle()
                        ResetMap()
                        v.setspawn = true
                    end

                    -- Game is in play
                elseif (GameState() == 3) then

                end
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, '$gt') ~= "n/a") then
        game_started = false
    end
end

function OnGameEnd()

end

function GameState(PlayerIndex)
    local player_count = tonumber(get_var(0, "$pn"))
    if (player_count > 0 and player_count < GuessWho.required_players) and (not game_started) then
        cls(PlayerIndex, 25)
        countdown = 0
        return 1
    elseif (player_count >= GuessWho.required_players) and (not game_started) then
        cls(PlayerIndex, 25)
        return 2
    else
        countdown = 0
        game_started = true
        return 3
    end
end

function OnPlayerConnect(PlayerIndex)
    initPlayer(PlayerIndex, false)
end

function OnPlayerDisconnect(PlayerIndex)
    initPlayer(PlayerIndex, true)
end

function OnPreSpawn(PlayerIndex)
    write_vector3d(get_dynamic_player(victim) + 0x5C, DEATH_LOCATION[victim][1], DEATH_LOCATION[victim][2], DEATH_LOCATION[victim][3])
end

function initPlayer(PlayerIndex, Reset)
    if (Reset) then
        players[PlayerIndex] = { }
    else
        players[PlayerIndex] = {
            it = false
        }
    end
end

function cls(PlayerIndex, count)
    local count = count or 25
    for _ = 1, count do
        rprint(PlayerIndex, " ")
    end
end

function secondsToTime(seconds, bool)
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

function Respond(PlayerIndex, Message, Type)
    if (Type == "rcon") then
        rprint(PlayerIndex, Message)
    else
        execute_command("msg_prefix \"\"")
        say(PlayerIndex, Message)
        execute_command("msg_prefix \" " .. GuessWho.server_prefix .. "\"")
    end
end

function SetCircle()

    local map = get_var(0, "$map")
    local x,y = GuessWho.maps[map].x, GuessWho.maps[map].y
    local r = GuessWho.maps[map].r

    local iterations = 0
    for i = 1,360 do
        if (i > iterations) then
            iterations = iterations + 22.5
            local angle = i * math.pi / 180
            local X, Y = x + r * math.cos( angle ), y + r * math.sin( angle )
            coordinates[#coordinates+1] = {X,Y}
        end
    end
end

function ResetMap()
    local kma = sig_scan("8B42348A8C28D500000084C9") + 3
    local original = read_dword(kma)
    safe_write(true)
    write_dword(kma, 0x03EB01B1)
    safe_write(false)

    execute_command("sv_map_reset")

    safe_write(true)
    write_dword(kma, original)
    safe_write(false)
end


