api_version = "1.12.0.0"

-- Configuration [STARTS] ------------------------------------------------------
local Troll = {

    -- Randomly prevent bullets from dealing damage:
    ["No Weapon Damage"] = {
        enabled = true,

    },

    -- Jumble 1-2 characters in some sentences:
    ["Chat Text Randomizer"] = {
        enabled = true,
        min_chances = 1, -- 1 in 6 chance of your messages being randomized every time you chat.
        max_chances = 1,
        format = {

            --[[ Custom Variables:

                %name% - will output the players name
                %msg% - will output message
                "%id% - will output the Player Index ID

            --]]

            global = "%name%: %msg%",
            team = "[%name%]: %msg%",
            vehicle = "[%name%]: %msg%"
        }
    },

    -- Inexplicable Deaths (no death message):
    ["Silent Kill"] = {
        enabled = true,

        -- When a player spawns, the interval until they are killed is randomized.
        -- The interval itself is an amount of seconds between "min" and "max".
        min = 1, -- in seconds
        max = 300, -- in seconds
    },

    -- Randomly set Z axis to -0.5/WU:
    ["Teleport Under Map"] = {
        enabled = true,

        -- Players will be teleported a random number of world units under the map.
        -- The value of W/Units is a random number between minZ, maxZ
        minZ = 0.3, -- in world units
        maxZ = 0.7, -- in world units

        -- Players will be teleported under the map at a random time between min/max seconds.
        min = 60, -- in seconds
        max = 300, -- in seconds
    },

    -- Randomly force player to drop flag:
    ["Flag Dropper"] = {
        enabled = true,

        -- When a player pick up the flag, the interval until they drop it is randomized.
        -- The interval itself is an amount of seconds between "min" and "max".
        min = 1, -- in seconds
        max = 60, -- in seconds
    },

    -- Randomly eject player from vehicle:
    ["Vehicle Exit"] = {
        enabled = true,

        -- When a player enters a vehicle, the interval until they are forced to exit is randomized.
        -- The interval itself is an amount of seconds between "min" and "max".
        min = 1, -- in seconds
        max = 60, -- in seconds
    },

    -- Change name on join to something random
    ["Name Changer"] = {
        enabled = true,

        names = { -- Max 11 Characters only!
            "iLoveAG",
            "iLoveV3",
            "loser4Eva",
            "iLoveChalwk",
            "iLoveSe7en",
            "iLoveAussie",
        }
    },

    -- Randomly change weapon ammo/battery:
    ["Ammo Changer"] = {
        enabled = true,

    },

    -- Forced Disconnect:
    ["Silent Kick"] = {
        enabled = true,

        announcements = {
            enabled = false,
            msg = "%name% was silently disconnected from the server!"
        },

        -- When a player joins, the interval until they are kicked is randomized.
        -- The interval itself is an amount of minutes between "min" and "max".
        min = 60, -- in seconds
        max = 300, -- in seconds
    },

    -- Random Color Change:
    ["Random Color Change"] = {
        enabled = true,

        colors = {
            { 0, true }, --white
            { 1, true }, --black
            { 2, true }, --red
            { 3, true }, --blue
            { 4, true }, --gray
            { 5, true }, --yellow
            { 6, true }, --green
            { 7, true }, --pink
            { 8, true }, --purple
            { 9, true }, --cyan
            { 10, true }, --cobalt
            { 11, true }, --orange
            { 12, true }, --teal
            { 13, true }, --sage
            { 14, true }, --brown
            { 15, true }, --tan
            { 16, true }, --maroon
            { 17, true } --salmon
        }
    },
}

local server_prefix = "**SAPP**"

local affected_users_only = true
local affected_users = {
    "127.0.0.1", -- Local Host
    "108.5.107.145" -- DeathBringR
}

-- Configuration [ENDS] ------------------------------------------------------

local players = { }
local gsub = string.gsub
local floor = math.floor
local time_scale = 1 / 30

-- Color Change Variable:
local ls

-- Flag Dropper Variables:
local flag, globals = { }, nil

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb["EVENT_TICK"], "OnTick")

    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    register_callback(cb["EVENT_CHAT"], "OnPlayerChat")

    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_VEHICLE_ENTER"], "OnVehicleEntry")

    register_callback(cb["EVENT_PRESPAWN"], "OnPreSpawn")

    local gp = sig_scan("8B3C85????????3BF9741FE8????????8B8E2C0200008B4610") + 3
    if (gp == 3) then
        return
    end
    globals = read_dword(gp)

    LSS(true)

    if (get_var(0, "$gt") ~= "n/a") then
        players = { }
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, false)
            end
        end
    end
end

function OnScriptUnload()
    LSS(false)
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        players = { }
        flag = { read_word(globals + 0x8), read_word(globals + 0xc) }
    end
end

function OnGameEnd()

end

function OnTick()
    for player, v in pairs(players) do
        if (player) then

            local DynamicPlayer = get_dynamic_player(player)
            math.randomseed(os.time())

            local silentkill = Troll["Silent Kill"]
            if (silentkill.enabled) then
                if player_alive(player) then
                    v[3].timer = v[3].timer + time_scale
                    if (v[3].timer >= v[3].time_until_kill) then
                        KillSilently(player)
                    end
                end
            end

            local tpundermap = Troll["Teleport Under Map"]
            if (tpundermap.enabled) then
                if player_alive(player) then
                    if (not InVehicle(DynamicPlayer)) then
                        v[4].timer = v[4].timer + time_scale
                        if (math.floor(v[4].timer) >= v[4].time_until_tp) then
                            v[4].timer = 0
                            v[4].time_until_tp = math.random(tpundermap.min, tpundermap.max)
                            local x, y, z = read_vector3d(DynamicPlayer + 0x5c)
                            write_vector3d(DynamicPlayer + 0x5c, x, y, z - v[4].zaxis)
                        end
                    end
                end
            end

            local flagdropper = Troll["Flag Dropper"]
            if (flagdropper.enabled) then
                if (DynamicPlayer ~= 0) and player_alive(player) then
                    if (not InVehicle(DynamicPlayer)) then
                        if holdingFlag(DynamicPlayer) then
                            v[5].hasflag = true
                            v[5].timer = v[5].timer + time_scale
                            if (math.floor(v[5].timer) >= v[5].time_until_drop) then
                                drop_weapon(player)
                            end
                        elseif (v[5].hasflag) then
                            v[5].hasflag = false
                            v[5].time_until_drop = math.random(flagdropper.min, flagdropper.max)
                            v[5].timer = 0
                        else
                            v[5].timer = 0
                        end
                    end
                end
            end

            local vehicleexit = Troll["Vehicle Exit"]
            if (vehicleexit.enabled) then
                if (DynamicPlayer ~= 0) then
                    if InVehicle(DynamicPlayer) and player_alive(player) then
                        v[6].timer = v[6].timer + time_scale
                        if (v[6].timer >= v[6].time_until_exit) then
                            exit_vehicle(player)
                        end
                    end
                end
            end

            local silentkick = Troll["Silent Kick"]
            if (silentkick.enabled) then
                v[9].timer = v[9].timer + time_scale
                if (v[9].timer >= v[9].time_until_kick) then
                    SilentKick(player)
                end
            end
        end
    end
end

function OnPlayerConnect(P)
    InitPlayer(P, false)
end

function OnPlayerDisconnect(P)
    InitPlayer(P, true)
end

function OnPreSpawn(PlayerIndex)

    local t = players[PlayerIndex]
    math.randomseed(os.time())

    if (t ~= nil) then

        local colorchange = Troll["Random Color Change"]
        if (colorchange.enabled) then
            local player = get_player(PlayerIndex)
            if (player ~= 0) then
                local id = tonumber(t[10].color())
                write_byte(player + 0x60, id)
            end
        end

        local silentkill = Troll["Silent Kill"]
        if (silentkill.enabled) then
            t[3].timer = 0
            t[3].time_until_kill = math.random(Troll["Silent Kill"].min, Troll["Silent Kill"].max)
        end

        local tpundermap = Troll["Teleport Under Map"]
        if (tpundermap.enabled) then
            t[4].zaxis = math.random(Troll["Teleport Under Map"].minZ, Troll["Teleport Under Map"].maxZ)
            t[4].time_until_tp = math.random(Troll["Teleport Under Map"].min, Troll["Teleport Under Map"].max)
        end
    end
end

function OnPlayerChat(P, Message, Type)
    if (Type ~= 6) then
        local p = players[P]
        if (p ~= nil) then
            local t = Troll["Chat Text Randomizer"]
            if (t.enabled) then
                if (p[2].chance() == 1) then

                    local new_message = ShuffleWords(Message)
                    local formatMsg = function(Msg)
                        local patterns = {
                            { "%%name%%", p.name },
                            { "%%msg%%", new_message },
                            { "%%id%%", P }
                        }
                        for i = 1, #patterns do
                            Msg = (gsub(Msg, patterns[i][1], patterns[i][2]))
                        end
                        return Msg
                    end

                    execute_command("msg_prefix \"\"")
                    if (Type == 0) then
                        say_all(formatMsg(t.format.global))
                    elseif (Type == 1) then
                        SayTeam(P, formatMsg(t.format.team))
                    elseif (Type == 2) then
                        SayTeam(P, formatMsg(t.format.vehicle))
                    end
                    execute_command("msg_prefix \" " .. server_prefix .. "\"")
                    return false
                end
            end
        end
    end
end

function SayTeam(P, Message)
    for i = 1, 16 do
        if player_present(i) then
            if get_var(i, "$team") == get_var(P, "$team") then
                say(i, Message)
            end
        end
    end
end

function InitPlayer(P, Reset)
    if (Reset) then
        players[P] = nil
    else

        local Case = function()
            local ip = get_var(P, "$ip"):match("%d+.%d+.%d+.%d+")
            for i = 1, #affected_users do
                if (ip == affected_users[i] or not affected_users_only) then
                    return true
                end
            end
            return false
        end

        if (Case) then

            math.randomseed(os.time())
            players[P] = {
                name = get_var(P, "$name"),
                [1] = { -- No Weapon Damage

                },
                [2] = { -- Chat Text Randomizer
                    chance = function()
                        return math.random(Troll["Chat Text Randomizer"].min_chances, Troll["Chat Text Randomizer"].max_chances)
                    end
                },
                [3] = { -- Silent Kill
                    timer = 0,
                    time_until_kill = math.random(Troll["Silent Kill"].min, Troll["Silent Kill"].max)
                },
                [4] = { -- Teleport Under Map
                    timer = 0,
                    zaxis = math.random(Troll["Teleport Under Map"].minZ, Troll["Teleport Under Map"].maxZ),
                    time_until_tp = math.random(Troll["Teleport Under Map"].min, Troll["Teleport Under Map"].max)
                },
                [5] = { -- Flag Dropper
                    timer = 0,
                    hasflag = false,
                    time_until_drop = math.random(Troll["Flag Dropper"].min, Troll["Flag Dropper"].max)
                },
                [6] = { -- Vehicle Exit
                    timer = 0,
                    time_until_exit = math.random(Troll["Vehicle Exit"].min, Troll["Vehicle Exit"].max)
                },
                [7] = { -- Name Changer

                },
                [8] = { -- Ammo Changer

                },
                [9] = { -- Silent Kick
                    timer = 0,
                    broadcast = true,
                    time_until_kick = math.random(Troll["Silent Kick"].min, Troll["Silent Kick"].max)
                },
                [10] = { -- Random Color Change
                    color = function()

                        local temp = { }
                        local colors = Troll["Random Color Change"].colors
                        for i = 1, #colors do
                            if (colors[i][2]) then
                                temp[#temp + 1] = colors[i][1]
                            end
                        end

                        if (#temp > 0) then
                            return math.random(#temp)
                        end

                        return 0
                    end
                }
            }
        end
    end
end

function SilentKick(P)

    for _ = 1, 9999 do
        rprint(P, " ")
    end

    local sk = Troll["Silent Kick"]
    if (sk.announcements.enabled) then
        if (players[P][9].broadcast) then
            players[P][9].broadcast = false
            for i = 1, 6 do
                if player_present(i) and (i ~= P) then
                    say(i, gsub(sk.announcements.msg, "%%name%%", players[P].name))
                end
            end
        end
    end
end

function HasFlag(DP)
    for j = 0, 3 do
        local weapon = read_dword(DP + 0x2F8 + 4 * j)
        for i = 1, #flag do
            if (weapon == flag[i]) then
                return true
            end
        end
    end
end

function holdingFlag(DynamicPlayer)
    for i = 0, 3 do
        local WeaponID = read_dword(DynamicPlayer + 0x2F8 + 0x4 * i)
        if (WeaponID ~= 0xFFFFFFFF) then
            local Weapon = get_object_memory(WeaponID)
            if (Weapon ~= 0) then
                local tag_address = read_word(Weapon)
                local tag_data = read_dword(read_dword(0x40440000) + tag_address * 0x20 + 0x14)
                if (read_bit(tag_data + 0x308, 3) == 1) then
                    return true
                end
            end
        end
    end
    return false
end

function InVehicle(DynamicPlayer)
    local VehicleID = read_dword(DynamicPlayer + 0x11C)
    if (VehicleID ~= 0xFFFFFFFF) then
        return true
    end
    return false
end

function OnVehicleEntry(PlayerIndex, Seat)
    if (players[PlayerIndex] ~= nil) then
        if (Troll["Vehicle Exit"].enabled) then
            players[PlayerIndex][6].timer = 0
            players[PlayerIndex][6].time_until_exit = math.random(Troll["Vehicle Exit"].min, Troll["Vehicle Exit"].max)
        end
    end
end

function KillSilently(P)
    local kill_message_addresss = sig_scan("8B42348A8C28D500000084C9") + 3
    local original = read_dword(kill_message_addresss)
    safe_write(true)
    write_dword(kill_message_addresss, 0x03EB01B1)
    safe_write(false)
    execute_command("kill " .. tonumber(P))
    safe_write(true)
    write_dword(kill_message_addresss, original)
    safe_write(false)
    write_dword(get_player(P) + 0x2C, 0 * 33)
    local deaths = tonumber(get_var(P, "$deaths"))
    execute_command("deaths " .. tonumber(P) .. " " .. deaths - 1)
end

function ShuffleWords(String)
    math.randomseed(os.time())
    local letters = { }

    for letter in String:gmatch '.[\128-\191]*' do
        letters[#letters + 1] = { letter = letter, rnd = math.random() }
    end

    table.sort(letters, function(a, b)
        return a.rnd < b.rnd
    end)

    for i, v in ipairs(letters) do
        letters[i] = v.letter
    end
    return table.concat(letters)
end

--Credits to Kavawuvi for this chunk of code:
function LSS(state)
    if (state) then
        ls = sig_scan("741F8B482085C9750C")
        if (ls == 0) then
            ls = sig_scan("EB1F8B482085C9750C")
        end
        safe_write(true)
        write_char(ls, 235)
        safe_write(false)
    else
        if (ls == 0) then
            return
        end
        safe_write(true)
        write_char(ls, 116)
        safe_write(false)
    end
end
--------------------------------------------
