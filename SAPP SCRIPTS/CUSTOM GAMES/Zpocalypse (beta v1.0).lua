--[[
--=====================================================================================================--
Script Name: Zpocalypse (beta v1.0), for SAPP (PC & CE)
Description: A custom Zombies Game designed for Team-Slayer game types.

### Game Play Mechanics:
- Blue Team play as the "zombies".
- Red Team play as the "humans".
- Zombies wield a "skull" with which they melee humans.
- When a human is killed by a zombie they become a zombie themselves.
- When all players have become a zombie the game will end.
- Zombies are lighting fast and slightly stronger than humans.
- Zombies have the ability to camouflage themselves when they crouch.
- The last human alive will have special abilities, such as regenerating health, camouflage and super speed among other things.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"

local zombies = {}
local parameters = nil

function zombies:init()
    local weapon = zombies:GetTag()
    
    zombies.settings = {
    
        -- #Numbers of players required to set the game in motion (cannot be less than 2)
        required_players = 3,

        -- Continuous message emitted when there aren't enough players.
        not_enough_players = "%current%/%required% players needed to start the game.",

        -- #Countdown delay (in seconds)
        -- This is a pre-game-start countdown initiated at the beginning of each game.
        delay = 10,

        -- #Pre Game message (%timeRemaining% will be replaced with the time remaining)
        pre_game_message = "Zpocalypse will begin in %time_remaining% second%s%",

        -- #End of Game message (%team% will be replaced with the winning team)
        end_of_game = "The %team% team won!",
        
        on_game_begin = "The game has begun: You are on the %team% team",
        
        human_team = "red",
        zombie_team = "blue",

        -- Zombies vs Human:
        on_zombify = "%victim% was zombified by %killer%",
        
        -- Normal Suicide
        on_suicide = "%victim% committed suicide",
        
        -- Human vs Zombie:
        on_kill = "%victim% was killed by %killer%",

        on_last_man = {
            -- Zombie vs second-to-last human:
            normal = "%victim% was killed by %killer%. %lastman% is the last human standing!",
            -- Second-to-last Human committed suicide:
            suicide = "%victim% committed suicide. %lastman% is the last last human standing!",
            other = "%lastman% is the last last human standing!",
        },

        -- If this is true, the teams will be evenly balanced at the beginning of the game
        balance_teams = false,

        -- #Respawn time (override)
        -- When enabled, players who are killed by the opposing team will respawn immediately.
        -- Does not affect suicides or other deaths (PvP only by design).
        respawn_override = true,
        respawn_time = 0, -- In seconds (0 = immediate)

        -- Message emitted when someone becomes a human again:
        on_cure = "%killer% killed %victim% and was cured!",
        -- Get this many consecutive kills per life and become human again!
        cure_threshold = 5,

        attributes = {
            ["Humans"] = {
                -- Set to 0 to disable (normal speed is 1)
                running_speed = 1,
                -- Zombie Health: (0 to 99999) (Normal = 1)
                health = 1,
                damage_multiplier = 1, -- (0 to 10) (Normal = 1)
            },
            ["Zombies"] = {
                -- Set to 0 to disable (normal speed is 1)
                running_speed = 1.2,
                -- Zombie Health: (0 to 99999) (Normal = 1)
                health = 1.3,
                damage_multiplier = 10, -- (0 to 10) (Normal = 1)
                -- Set to 'false' to disable:
                invisibility_on_crouch = true,
            },
            ["Last Man Standing"] = {
                -- Set to 0 to disable (normal speed is 1)
                running_speed = 1.2,
                -- Zombie Health: (0 to 99999) (Normal = 1)
                health = 1.5,
                -- Set to 'false' to disable temporary overshield:
                overshield = true,
                -- Set to 'false' to disable this feature:
                invisibility_on_crouch = true,
                -- If true, the last man standing will have regenerating health:
                regenerating_health = true,
                -- Health will regenerate in chunks of this percent every 30 ticks until they gain maximum health.
                increment = 0.0005,
                -- Last Man damage multiplier
                damage_multiplier = 2.00, -- (0 to 9999) (Normal = 1)

                -- A NAV marker will appear above the last man standing if your set the "kill in order" gametype flag to "yes". 
                -- This only works on FFA and Team Slayer gametypes.
                use_nav_marker = true
            },
            
            weapons = {
            
                -- If true, humans will be given up to 4 custom weapons:
                use = true, -- Set to "false" to disable weapon assignments for all maps
                
                -- Set the weapon index to the corresponding tag number (see function mod:GetTag() on line 1099)
                
                -- To disable a slot, set it to nil:
                -- Example: ["mymap"] = {weapon[1], nil, nil, nil},
                -- In the above example, you will only spawn with the pistol on the map "mymap"
                
                -- =========== [ STOCK MAPS ] =========== --
                -- PRIMARY | SECONDARY | TERTIARY | QUATERNARY
                
                -- weapon[1] = pistol
                -- weapon[2] = sniper
                -- etc...
                
                -- Set all slots to "nil" to disable weapon assignment for that map.
                -- For example: ["mymap"] = {nil, nil, nil, nil},
                
                ["beavercreek"] = { weapon[1], weapon[2], weapon[3], nil}, -- pistol, sniper, shotgun
                ["bloodgulch"] = { weapon[2], weapon[1], weapon[9], weapon[5]},
                ["boardingaction"] = { weapon[10], weapon[1], nil, nil},
                ["carousel"] = { weapon[2], weapon[1], weapon[10], nil},
                ["dangercanyon"] = { weapon[1], weapon[4], weapon[7], nil},
                ["deathisland"] = { weapon[2], weapon[1], weapon[7], nil},
                ["gephyrophobia"] = { weapon[2], weapon[1], weapon[4], nil},
                ["icefields"] = { weapon[1], weapon[7], nil, nil},
                ["infinity"] = { weapon[1], weapon[2], weapon[4], nil},
                ["sidewinder"] = { weapon[1], weapon[4], weapon[3], weapon[2]},
                ["timberland"] = { weapon[1], weapon[2], weapon[10], nil},
                ["hangemhigh"] = { weapon[1], weapon[10], nil, nil},
                ["ratrace"] = { weapon[7], weapon[1], nil, nil},
                ["damnation"] = { weapon[7], weapon[1], nil, nil},
                ["putput"] = { weapon[5], weapon[6], weapon[3], weapon[8]},
                ["prisoner"] = { weapon[1], weapon[4], nil, nil},
                ["wizard"] = { weapon[1], weapon[2], nil, nil},
                
                -- Repeat the structure to add more entries:
                ["mapname"] = {nil, nil, nil, nil},
            }
        },

        -- Some functions temporarily remove the server prefix while broadcasting a message.
        -- This prefix will be restored to 'server_prefix' when the message relay is done.
        -- Enter your servers default prefix here:
        server_prefix = "** SERVER **",
    }
    
    --# Do Not Touch #--
    zombies.players = {}
    zombies.map = get_var(0, "$map")
        
    parameters = zombies.settings
    
    local weapons = parameters.attributes.weapons
    local use_custom_weapons = (weapons.use == true)
    zombies.human_weapons = use_custom_weapons
    
    if (zombies.human_weapons) then
        local count = 0
        for Slot,Weapon in pairs(weapons[zombies.map]) do
            if (Weapon ~= nil) then
                count = count + 1
            end
        end
        if (count == 0) then
            zombies.human_weapons = false
        end
    end
end

-- Variables for String Library:
local format = string.format
local gsub = string.gsub

-- Variables for Math Library:
local floor = math.floor

-- Game Variables:
local gamestarted
local countdown, init_countdown, print_nep
local kill_message_addresss, originl_kill_message

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb['EVENT_DIE'], 'OnPlayerDeath')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_WEAPON_DROP'], "OnWeaponDrop")

    kill_message_addresss = sig_scan("8B42348A8C28D500000084C9") + 3
    originl_kill_message = read_dword(kill_message_addresss)

    if (get_var(0, '$gt') ~= "n/a") then
        zombies:init()
        for i = 1, 16 do
            if player_present(i) then
                zombies:gameStartCheck(i)
            end
        end
    end
end

function OnScriptUnload()
    zombies:enableKillMessages()
end

function zombies:enableKillMessages()
    safe_write(true)
    write_dword(kill_message_addresss, originl_kill_message)
    safe_write(false)
end

function zombies:disableKillMessages()
    safe_write(true)
    write_dword(kill_message_addresss, 0x03EB01B1)
    safe_write(false)
end

function OnTick()

    local count = zombies:GetPlayerCount()
    local countdown_begun = (init_countdown == true)

    for _, player in pairs(zombies.players) do
        if (player) and player_present(player.id) then

            local isHteam = (player.team == parameters.human_team)
            local isZteam = (player.team == parameters.zombie_team)
            local isLastMan = (player.last_man ~= nil)
    
            if (print_nep) and (not gamestarted) and (count < parameters.required_players) then
                zombies:cls(player.id, 25)
                local msg = gsub(gsub(parameters.not_enough_players, 
                "%%current%%", count), 
                "%%required%%", parameters.required_players)
                rprint(player.id, msg)

            elseif (countdown_begun) and (not gamestarted) and (zombies.pregame) then
                zombies:cls(player.id, 25)
                rprint(player.id, zombies.pregame)

                -- Weapon Assignment and Attribute Logic:
            elseif (gamestarted) and player_alive(player.id) then

                local player_object = get_dynamic_player(player.id)
                if (player_object ~= 0) then
                
                    if (isZteam) and (player.zombie_assign) then
                        local coords = zombies:getXYZ(player.id, player_object)
                        if (not coords.invehicle) then
                            player.zombie_assign = false
                            execute_command("wdel " .. player.id)
                            local oddball = spawn_object("weap", player.weapon, coords.x, coords.y, coords.z)
                            assign_weapon(oddball, player.id)
                            player.drone = oddball
                        end
                    end
                    
                    local attributes = parameters.attributes
                    local weapons = attributes.weapons
                    
                    for index, attribute in pairs(attributes) do
                        
                        -- Human Weapon Assignment:
                        if (player.human_assign) and (index == "Humans") and (isHteam or isLastMan) then
                            local coords = zombies:getXYZ(player.id, player_object)
                            if (not coords.invehicle) then
                                player.human_assign = false
                                execute_command("wdel " .. player.id)
                                for Slot, Weapon in pairs(weapons[zombies.map]) do
                                    if (Slot == 1 or Slot == 2) then
                                        assign_weapon(spawn_object("weap", Weapon, coords.x, coords.y, coords.z), player.id)
                                    elseif (Slot == 3 or Slot == 4) then
                                        timer(250, "DelaySecQuat", player.id, Weapon, coords.x, coords.y, coords.z)
                                    end
                                end
                            end
                        end
                        
                        if (index == "Humans") and (isHteam) then
                            
                            -- Player is HUMAN:
                            if (attribute.running_speed > 0) then
                                execute_command("s " .. player.id .. " " .. tonumber(attribute.running_speed))
                            end
                            
                            -- Player is ZOMBIE:
                        elseif (index == "Zombies") and (isZteam) then
                            if (attribute.running_speed > 0) then
                                execute_command("s " .. player.id .. " " .. tonumber(attribute.running_speed))
                            end
                            zombies:CamoOnCrouch(player.id)
                            
                            
                            -- Player is LAST MAN STANDING
                        elseif (index == "Last Man Standing") and (isHteam and isLastMan) then
                            if (attribute.use_nav_marker) then
                                zombies:SetNav(player.id)
                            end

                            if (attribute.running_speed > 0) then
                                execute_command("s " .. player.id .. " " .. tonumber(attribute.running_speed))
                            end
                            zombies:CamoOnCrouch(player.id)

                            if (attribute.regenerating_health) then
                                if (player_object ~= 0) then
                                    if read_float(player_object + 0xE0) < 1 then
                                        write_float(player_object + 0xE0, read_float(player_object + 0xE0) + attribute.increment)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if (countdown_begun) then
        countdown = countdown + 0.03333333333333333

        local timeRemaining = parameters.delay - floor(countdown % 60)
        local char = zombies:getChar(timeRemaining)

        zombies.pregame = zombies.pregame or ""
        zombies.pregame = gsub(gsub(parameters.pre_game_message, 
        "%%time_remaining%%", timeRemaining), 
        "%%s%%", char)

        if (timeRemaining <= 0) then
        
            zombies:disableKillMessages()            
            gamestarted = true
            zombies:StopTimer()

            if (parameters.balance_teams) then
                for i = 1, 16 do
                    if player_present(i) then
                        zombies:sortPlayers(i, true)
                        local team = zombies:GetTeamType(i)
                        local msg = gsub(parameters.on_game_begin, "%%team%%", team)
                        rprint(i, msg)
                    end
                end
            else
                zombies:sortPlayers(nil, false)
            end
            zombies:SetLastMan()
            execute_command("sv_map_reset")
        end
    end
end

function OnGameStart()
    if (get_var(0, '$gt') ~= "n/a") then
        zombies:init()

        if not zombies:isTeamPlay() then
            zombies:unregisterSAPPEvents('Only supports team play!')
        elseif (parameters.required_players < 2) then
            zombies:unregisterSAPPEvents('Setting "required_players" cannot be less than 2!')
        else
            zombies:StopTimer()
            local function oddOrEven(Min, Max)
                math.randomseed(os.time())
                math.random();
                local num = math.random(Min, Max)
                if (num) then
                    return num
                end
            end
            if (oddOrEven(1, 2) % 2 == 0) then
                -- Number is even
                parameters.useEvenNumbers = true
            else
                -- Number is odd
                parameters.useEvenNumbers = false
            end
        end
    end
end

function OnGameEnd()
    zombies:StopTimer()
    gamestarted = false
end

function zombies:gameStartCheck(p)

    zombies:initPlayer(p, get_var(p, "$team"), true)

    local player_count = zombies:GetPlayerCount()
    local required = parameters.required_players

    if (player_count >= required) and (not init_countdown) and (not gamestarted) then
        zombies:StartTimer()
    elseif (player_count >= required) and (print_nep) then
        print_nep = false
    elseif (player_count > 0 and player_count < required) then
        print_nep = true
    end

    -- Game has already begun. Set player to zombie team:
    if (gamestarted) and (p) then
        if (get_var(p, "$team") == parameters.human_team) then
            zombies:SwitchTeam(p, parameters.zombie_team, true)
        end
    end
end

function OnPlayerConnect(p)
    zombies:gameStartCheck(p)
end

function OnPlayerDisconnect(PlayerIndex)

    local p = tonumber(PlayerIndex)
    local player = zombies:PlayerTable(p)

    local player_count = zombies:GetPlayerCount()
    player_count = player_count - 1

    local team_count = zombies:getTeamCount() -- blues[1], reds[2]
    local Zombies, Humans = team_count[1], team_count[2]

    local params = {}
    params.disconnect = true
    
    if (player.team == parameters.zombie_team) then
        zombies:CleanUpDrones(player.id, false)
        params.zombie_count = Zombies - 1
        params.human_count = Humans
    else
        params.human_count = Humans - 1
        params.zombie_count = Zombies
    end

    zombies:initPlayer(p, nil, false)

    if (gamestarted) then
        if (player_count <= 0) then

            -- Ensure all timer parameters are set to their default values.
            zombies:StopTimer()

            -- One player remains | ends the game.
        elseif (player_count == 1) then
            for i = 1, 16 do
                if (tonumber(i) ~= tonumber(p)) then
                    if player_present(i) then
                        -- Send game over message to the last remaining player:
                        local team = zombies:GetTeamType(i)
                        zombies:broadcast(gsub(parameters.end_of_game, "%%team%%", team), true)
                        break
                    end
                end
            end

            -- Checks if the remaining players are on the same team | ends the game.
        elseif (params.zombie_count <= 0 and params.human_count >= 1) then
            zombies:broadcast(gsub(parameters.end_of_game, "%%team%%", "human"), true)
        elseif (params.human_count <= 0 and params.zombie_count >= 1) then
            zombies:broadcast(gsub(parameters.end_of_game, "%%team%%", "zombie"), true)
        elseif (params.human_count == 1 and params.zombie_count >= 1) then
            zombies:SetLastMan(params)
        end

        -- Pre-Game countdown was initiated but someone left before the game began.
        -- Stop the timer, reset the countdown and display the continuous
        -- message emitted when there aren't enough players to start the game.
    elseif (not gamestarted) and (init_countdown and player_count < parameters.required_players) then
        print_nep = true
        countdown, init_countdown = 0, false
    end
end

function OnPlayerSpawn(PlayerIndex)
    local PlayerObject = get_dynamic_player(PlayerIndex)
    if (PlayerObject ~= 0 and gamestarted) then
        if player_alive(PlayerIndex) then
            local player = zombies:PlayerTable(PlayerIndex)
            
            local isHteam = (player.team == parameters.human_team)
            local isZteam = (player.team == parameters.zombie_team)
            local isLastMan = (player.last_man ~= nil)
            
            local weapons = parameters.attributes.weapons
            local use = (weapons.use == true)
            
            if (isZteam) then

                -- Set grenades to 0 for zombies:
                write_word(PlayerObject + 0x31E, 0)
                write_word(PlayerObject + 0x31F, 0)

                -- Set weapon assignment flag to true:
                player.zombie_assign = true
                -- Set zombie kill count to zero:
                player.kills = 0
                
            elseif (isHteam or isLastMan) and (use) then
                player.human_assign = zombies.human_weapons
            end
        end
    end
end

function OnWeaponDrop(PlayerIndex)
    zombies:CleanUpDrones(PlayerIndex, true)
end

function OnPlayerDeath(PlayerIndex, KillerIndex)

    if (gamestarted) then

        local killer = tonumber(KillerIndex)
        local victim = tonumber(PlayerIndex)

        local kteam = get_var(killer, "$team")
        local vteam = get_var(victim, "$team")

        local kname = get_var(killer, "$name")
        local vname = get_var(victim, "$name")

        if (killer > 0) then

            -- Check for suicide:
            local params = {}
            params.kname = kname
            params.vname = vname
            
            if (killer == victim) then
                params.suicide = true
                zombies:SwitchTeam(victim, parameters.zombie_team)
            end

            -- PvP:
            if (killer ~= victim) then
                
                -- Zombie killed Human:
                if (kteam == parameters.zombie_team) and (vteam == parameters.human_team) then        
                    params.zombified = true
                    -- Switch victim to Zombie team:
                    zombies:SwitchTeam(victim, parameters.zombie_team)

                    -- If zombie has "cure_threshold" kills, set them to human team:
                    local player = zombies:PlayerTable(killer)
                    player.kills = player.kills + 1

                    if (player.kills == zombies.cure_threshold) then
                        params.cured = true
                        zombies:SwitchTeam(killer, parameters.human_team)
                    end

                -- Human killed Zombie:
                elseif (kteam == parameters.human_team) and (vteam == parameters.zombie_team) then
                    params.pvp = true
                    zombies:CleanUpDrones(victim, false)
                end
            end

            zombies:endGameCheck()
            zombies:SetLastMan(params)
            
        elseif (killer == nil) or (killer == 0) then
            execute_command("msg_prefix \"\"")
            zombies:broadcast(vname .. " died", false)
            execute_command("msg_prefix \" " .. parameters.server_prefix .. "\"")
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex and gamestarted) then

        local cTeam = get_var(CauserIndex, "$team")
        local vTeam = get_var(PlayerIndex, "$team")

        if (cTeam == vTeam) then
            return false
        else
            for index, attribute in pairs(parameters.attributes) do
                if (index == "Humans") and (cTeam == parameters.human_team) then
                    return true, Damage * attribute.damage_multiplier
                elseif (index == "Zombies") and (cTeam == parameters.zombie_team) then
                    return true, Damage * attribute.damage_multiplier
                elseif (index == "Last Man Standing") and (cTeam == parameters.human_team) then
                    local player = zombies:PlayerTable(PlayerIndex)
                    if (player.last_man ~= nil) then
                        return true, Damage * attribute.damage_multiplier
                    end
                end
            end
        end
    end
end

function zombies:killPlayer(PlayerIndex)
    local player = get_player(PlayerIndex)
    if (player ~= 0) then
        local PlayerObject = read_dword(player + 0x34)
        if (PlayerObject ~= nil) then
            destroy_object(PlayerObject)
        end
    end
end

function zombies:SwitchTeam(PlayerIndex, team, bool)
    local player = zombies:PlayerTable(PlayerIndex)
    player.team = team
    
    if not (bool) then

        -- Set the player's team:
        local Team = get_var(PlayerIndex, "$team")
        if (Team ~= team) then
            execute_command("st " .. tonumber(PlayerIndex) .. " " .. tostring(team))
        end

        -- Override respawn time:
        if (zombies.respawn_override == true) then
            local player = get_player(PlayerIndex)
            if (player ~= 0) then
                write_dword(player + 0x2C, parameters.respawn_time * 33)
            end
        end

        -- Set their health:
        local health = zombies:setHealth(PlayerIndex, team)
        execute_command_sequence("w8 " .. (parameters.respawn_time + 1) .. ";hp " .. PlayerIndex .. " " .. health)
    else
        -- Set the player's team:
        execute_command("st " .. tonumber(PlayerIndex) .. " " .. tostring(team))
        local health = zombies:setHealth(PlayerIndex, team)
        execute_command_sequence("w8 2;hp " .. PlayerIndex .. " " .. health)
    end
end

function zombies:broadcast(message, endgame, exclude, player)
    execute_command("msg_prefix \"\"")
    if (not exclude) then
        say_all(message)
    else
        for i = 1, 16 do
            if player_present(i) then
                if (i ~= player) then
                    say(i, message)
                end
            end
        end
    end
    execute_command("msg_prefix \" " .. parameters.server_prefix .. "\"")
    -- End the game if variable "GameOver" is true.
    if (endgame) then
        execute_command("sv_map_next")
    end
end

function zombies:StartTimer()
    countdown, init_countdown = 0, true
end

function zombies:StopTimer()
    countdown, init_countdown = 0, false
    print_nep = false

    for i = 1, 16 do
        if player_present(i) then
            zombies:cls(i, 25)
        end
    end

    --
    if (gamestarted) then

        -- Only disable object interaction when the game begins:
        -- This will allow players to engage in PvP normally until enough players are present to start the game.
        --=======================================================================================================--

        -- Disable vehicles for both teams:
        execute_command("disable_all_vehicles 0 1")

        -- Disable weapon pick ups for zombies:
        execute_command("disable_object 'weapons\\assault rifle\\assault rifle' 2")
        execute_command("disable_object 'weapons\\flamethrower\\flamethrower' 2")
        execute_command("disable_object 'weapons\\needler\\mp_needler' 2")
        execute_command("disable_object 'weapons\\pistol\\pistol' 2")
        execute_command("disable_object 'weapons\\plasma pistol\\plasma pistol' 2")
        execute_command("disable_object 'weapons\\plasma rifle\\plasma rifle' 2")
        execute_command("disable_object 'weapons\\plasma_cannon\\plasma_cannon' 2")
        execute_command("disable_object 'weapons\\rocket launcher\\rocket launcher' 2")
        execute_command("disable_object 'weapons\\shotgun\\shotgun' 2")
        execute_command("disable_object 'weapons\\sniper rifle\\sniper rifle' 2")

        -- Disable Grenades for Zombies:
        execute_command("disable_object 'weapons\\frag grenade\\frag grenade' 2")
        execute_command("disable_object 'weapons\\plasma grenade\\plasma grenade' 2")
    end
end

function zombies:endGameCheck()
    local team_count = zombies:getTeamCount() -- blues[1], reds[2]
    local Zombies, Humans = team_count[1], team_count[2]

    -- No humans left -> zombies win
    if (Humans == 0 and Zombies >= 1) then
        zombies:broadcast(gsub(parameters.end_of_game, "%%team%%", "Zombies"), true)
    end
end

-- This function deletes stray oddballs:
function zombies:CleanUpDrones(PlayerIndex, Assign)
    local player = zombies:PlayerTable(PlayerIndex)
    if (player.team == parameters.zombie_team) then
        if (player.drone) then
            destroy_object(player.drone)
            player.drone = nil
        end
        if (Assign) then
            player.zombie_assign = true
        end
   end
end

function zombies:cls(PlayerIndex, count)
    local count = count or 25
    for _ = 1, count do
        rprint(PlayerIndex, " ")
    end
end

function zombies:isTeamPlay()
    if (get_var(0, "$ffa") == "0") then
        return true
    end
end

function zombies:sortPlayers(PlayerIndex, BalanceTeams)
    if (gamestarted) then

        if (BalanceTeams) then
            if (parameters.useEvenNumbers) then
                if (tonumber(PlayerIndex) % 2 == 0) then
                    zombies:setTeam(PlayerIndex, parameters.zombie_team)
                else
                    zombies:setTeam(PlayerIndex, parameters.human_team)
                end
            else
                if (tonumber(PlayerIndex) % 2 == 0) then
                    zombies:setTeam(PlayerIndex, parameters.human_team)
                else
                    zombies:setTeam(PlayerIndex, parameters.zombie_team)
                end
            end
        else

            local players = { }
            for i = 1, 16 do
                if player_present(i) then
                    players[#players + 1] = i
                end
            end

            if (#players > 0) then

                math.randomseed(os.time())
                math.random();
                math.random();
                math.random();

                -- Choose random player to become Zombie (blue team):
                local player = players[math.random(1, #players)]
                zombies:setTeam(player, parameters.zombie_team)
                local team = zombies:GetTeamType(player)
                local msg = gsub(parameters.on_game_begin, "%%team%%", team)
                rprint(player, msg)

                -- Set every other player as a human (red team):
                for i = 1, 16 do
                    if (player_present(i) and i ~= player) then
                        zombies:setTeam(i, parameters.human_team)
                        local team = zombies:GetTeamType(i)
                        local msg = gsub(parameters.on_game_begin, "%%team%%", team)
                        rprint(i, msg)
                    end
                end
            end
        end
    end
end

function zombies:setHealth(PlayerIndex, Team)
    for index, attribute in pairs(parameters.attributes) do
        if (index == "Humans") and (Team == parameters.human_team) then
            return tonumber(attribute.health)
        elseif (index == "Zombies") and (Team == parameters.zombie_team) then
            return tonumber(attribute.health)
        elseif (index == "Last Man Standing") and (Team == parameters.human_team) then
            local player = zombies:PlayerTable(PlayerIndex)
            if (player.last_man ~= nil) then
                return tonumber(attribute.health)
            end
        end
    end
end

function zombies:GetTeamType(p)
    local team = get_var(p, "$team")
    if (team == parameters.human_team) then
        return "human"
    else
        return "zombie"
    end
end

function zombies:setTeam(PlayerIndex, team)

    local PlayerObject = get_dynamic_player(PlayerIndex)
    zombies:deleteWeapons(PlayerIndex, PlayerObject)

    if (PlayerObject ~= 0) then
        write_word(PlayerObject + 0x31E, 0)
        write_word(PlayerObject + 0x31F, 0)
    end

    zombies:killPlayer(PlayerIndex)
    zombies:SwitchTeam(PlayerIndex, team)
    zombies:ResetScore(PlayerIndex)
end

function zombies:deleteWeapons(PlayerIndex, PlayerObject)
    if (PlayerObject ~= 0) then
        local WeaponID = read_dword(PlayerObject + 0x118)
        if WeaponID ~= 0 then
            for j = 0, 3 do
                local ObjectID = read_dword(PlayerObject + 0x2F8 + j * 4)
                destroy_object(ObjectID)
            end
        end
    end
end

function zombies:SetLastMan(params)

    local msg = nil
    local Zombies, Humans = 0,0
    local params = params or {}
    
    if (params.disconnect) then
        Zombies, Humans = params.zombie_count, params.human_count 
    else      
        local team_count = zombies:getTeamCount()
        Zombies, Humans = team_count[1], team_count[2]
    end

    if (Humans == 1 and Zombies >= 1) then
        for _, player in pairs(zombies.players) do
            if (player) then
                if (player.team == parameters.human_team) then
                    if (player.last_man == nil) then
                        player.last_man, params.last_man = true, player.name
                        for index, attribute in pairs(parameters.attributes) do
                            if (index == "Last Man Standing") then
                                local player_object = get_dynamic_player(player.id)
                                if (player_object ~= 0) then
                                    if (attribute.overshield) then
                                        zombies:ApplyOvershield(player.id)
                                    end
                                    write_float(player_object + 0xE0, floor(tonumber(attribute.health)))
                                end
                            end
                        end
                        break
                    end
                end
            end
        end
    end

    if (params.last_man) then
        if (params.suicide) then
            msg = gsub(gsub(parameters.on_last_man.suicide, "%%victim%%", params.vname), "%%lastman%%", params.last_man)  
        else
            if not (params.disconnect) then
                msg = gsub(gsub(gsub(parameters.on_last_man.normal, 
                "%%victim%%", params.vname), 
                "%%killer%%", params.kname),
                "%%lastman%%", params.last_man)
            else
                msg = gsub(parameters.on_last_man.other, "%%lastman%%", params.last_man)
            end
        end
    elseif (not params.last_man) then
    
        -- Suicide:
        if (params.suicide) then
            msg = gsub(parameters.on_suicide, "%%victim%%", params.vname)
        
        -- Zombie kills Human (not cured)
        elseif (params.zombified and not params.cured) then
            msg = gsub(gsub(parameters.on_zombify, "%%victim%%", params.vname), "%%killer%%", params.kname)
            
        -- Zombie kills Human (cured)
        elseif (params.zombified and params.cured) then
            msg = gsub(gsub(parameters.on_cure, "%%victim%%", params.vname), "%%killer%%", params.kname)
            
        -- Human kills Zombie:
        elseif (params.pvp) then
            msg = gsub(gsub(parameters.on_kill, "%%victim%%", params.vname), "%%killer%%", params.kname)
        end
    end
    
    if (msg ~= nil) then
        zombies:broadcast(msg, false)
    end
end

function zombies:ApplyOvershield(PlayerIndex)
    if (player_present(PlayerIndex) and player_alive(PlayerIndex)) then
        local ObjectID = spawn_object("eqip", "powerups\\over shield")
        powerup_interact(ObjectID, PlayerIndex)
    end
end

function zombies:CamoOnCrouch(PlayerIndex)
    local team = get_var(PlayerIndex, "$team")

    for index, attribute in pairs(parameters.attributes) do
        if (index == "Zombies" and team == parameters.zombie_team) or (index == "Last Man Standing" and team == parameters.human_team) then
            if (attribute.invisibility_on_crouch) then
                local player_object = get_dynamic_player(PlayerIndex)
                if (player_object ~= 0) then
                    local couching = read_float(player_object + 0x50C)
                    if (couching == 1) then
                        execute_command("camo " .. PlayerIndex .. " 2")
                    end
                end
            end
        end
    end
end

function zombies:unregisterSAPPEvents(error)
    unregister_callback(cb['EVENT_TICK'])
    unregister_callback(cb['EVENT_GAME_END'])
    unregister_callback(cb['EVENT_JOIN'])
    unregister_callback(cb['EVENT_LEAVE'])
    unregister_callback(cb['EVENT_DIE'])
    unregister_callback(cb['EVENT_DAMAGE_APPLICATION'])
    execute_command("log_note \"" .. format('[Zpocalypse] ' .. error) .. "\"")
    cprint(format('[Zpocalypse] ' .. error), 4 + 8)
end

function zombies:GetPlayerCount()
    return tonumber(get_var(0, "$pn"))
end

function zombies:getTeamCount()
    local blues = get_var(0, "$blues")
    local reds = get_var(0, "$reds")
    return { tonumber(blues), tonumber(reds) }
end

function zombies:SetNav(LastMan)
    for i = 1, 16 do
        if player_present(i) then
            local PlayerSM = get_player(i)
            local PTableIndex = to_real_index(i)
            if (PlayerSM ~= 0) then
                if (LastMan ~= nil) then
                    write_word(PlayerSM + 0x88, to_real_index(LastMan))
                else
                    write_word(PlayerSM + 0x88, PTableIndex)
                end
            end
        end
    end
end

function zombies:getChar(input)
    local char = ""
    if (tonumber(input) > 1) then
        char = "s"
    elseif (tonumber(input) <= 1) then
        char = ""
    end
    return char
end

function zombies:PickRandomTeam()
    math.randomseed(os.time())
    math.random();
    math.random();
    math.random();
    local team, num = 0, math.random(1, 2)
    if (num == 1) then
        team = parameters.human_team
    else
        team = parameters.zombie_team
    end
    return team
end

function zombies:ResetScore(PlayerIndex)
    execute_command("score " .. PlayerIndex .. " 0")
    execute_command_sequence("team_score 0 0")
end

function zombies:initPlayer(PlayerIndex, Team, Init)
    if (PlayerIndex) then
        local players = zombies.players
        if (Init) then
            players[#players + 1] = {
                kills = 0,
                team = Team,
                drone = nil,
                zombie_assign = false,
                human_assign = false,
                last_man = nil,
                id = PlayerIndex,
                -- Zombie Weapon:
                weapon = "weapons\\ball\\ball",
                -- Human Weapons:
                name = get_var(PlayerIndex, "$name"),
            }
        else
            for index, player in pairs(players) do
                if (player.id == PlayerIndex) then
                    players[index] = nil
                end
            end
        end
    end
end

function zombies:PlayerTable(PlayerIndex)
    local players = zombies.players
    for _, player in pairs(players) do
        if (player) then
            if (player.id == PlayerIndex) then
                return player
            end
        end
    end
    return nil
end

function zombies:getXYZ(PlayerIndex, PlayerObject)
    local coords, x, y, z = { }
    if player_alive(PlayerIndex) then
        local VehicleID = read_dword(PlayerObject + 0x11C)
        if (VehicleID == 0xFFFFFFFF) then
            coords.invehicle = false
            x, y, z = read_vector3d(PlayerObject + 0x5c)
        else
            coords.invehicle = true
            x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
        end
            
        if (coords.invehicle) then z = z + 1 end
        coords.x, coords.y, coords.z = x, y, z
    end
    return coords
end

function zombies:GetTag()
    return {
    
        -- ============= [ STOCK WEAPONS ] ============= --
        [1] = "weapons\\pistol\\pistol",
        [2] = "weapons\\sniper rifle\\sniper rifle",
        [3] = "weapons\\plasma_cannon\\plasma_cannon",
        [4] = "weapons\\rocket launcher\\rocket launcher",
        [5] = "weapons\\plasma pistol\\plasma pistol",
        [6] = "weapons\\plasma rifle\\plasma rifle",
        [7] = "weapons\\assault rifle\\assault rifle",
        [8] = "weapons\\flamethrower\\flamethrower",
        [9] = "weapons\\needler\\mp_needler",
        [10] = "weapons\\shotgun\\shotgun",
        [11] = "weapons\\ball\\ball",
        [12] = "weapons\\flag\\flag",
        
        -- ============= [ CUSTOM WEAPONS ] ============= --
        -- Weapon indexes 11-30 belong to bigassv2,104
        [13] = "altis\\weapons\\binoculars\\binoculars",
        [14] = "altis\\weapons\\binoculars\\gauss spawner\\create gauss",
        [15] = "altis\\weapons\\smoke\\smoke",
        [16] = "bourrin\\halo reach\\vehicles\\warthog\\gauss\\gauss gun",
        [17] = "bourrin\\halo reach\\vehicles\\warthog\\rocket\\rocket",
        [18] = "bourrin\\weapons\\dmr\\dmr",
        [19] = "bourrin\\weapons\\ma5k\\cmt's ma5k reloaded",
        [20] = "bourrin\\weapons\\masternoob's assault rifle\\assault rifle",
        [21] = "cmt\\weapons\\human\\shotgun\\shotgun",
        [22] = "cmt\\weapons\\human\\stealth_sniper\\sniper rifle",
        [23] = "halo reach\\objects\\weapons\\support_high\\spartan_laser\\spartan laser",
        [24] = "halo3\\weapons\\odst pistol\\odst pistol",
        [25] = "my_weapons\\trip-mine\\trip-mine",
        [26] = "reach\\objects\\weapons\\pistol\\magnum\\magnum",
        [27] = "vehicles\\le_falcon\\weapon",
        [28] = "vehicles\\scorpion\\scorpion cannon_heat",
        [29] = "weapons\\gauss sniper\\gauss sniper",
        [30] = "weapons\\rocket launcher\\rocket launcher test",
        
        -- repeat the structure to add more weapon tags:
        [31] = "tag_goes_here",
    }
end

function DelaySecQuat(PlayerIndex, Weapon, x, y, z)
    assign_weapon(spawn_object("weap", Weapon, x, y, z), PlayerIndex)
end
