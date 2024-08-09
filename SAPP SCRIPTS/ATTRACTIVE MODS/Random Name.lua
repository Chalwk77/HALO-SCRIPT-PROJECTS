--[[
--======================================================================================================--
Script Name: Random Name, for SAPP (PC & CE)
Description: This script will force someone to use a random name.
             Only players whose name is listed in the "names" table (see config section)
             will be affected by this script.

             [!] NOTE [!]
             Unloading/Loading the script while the server is running or using reload command
             may cause issues. Avoid if possible.
             This script should be persistent and initialised via init.txt
             ---------------------------------------------------------------

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--======================================================================================================--
]]--

local names = {

    -- If someone joins with the name "Tumbaculos",
    -- the script force them to use 1 of 20 random names:

    ["Tumbaculos"] = {

        -- Max 11 Characters only!

        { "Tumba Ass" },
        { "iLoveAG" },
        { "iLoveV3" },
        { "loser4Eva" },
        { "iLoveChalwk" },
        { "iLoveSe7en" },
        { "iLoveAussie" },
        { "benDover" },
        { "clitEruss" },
        { "tinyDick" },
        { "cumShot" },
        { "PonyGirl" },
        { "iAmGroot" },
        { "twi$t3d" },
        { "maiBahd" },
        { "frown" },
        { "Laugh@me" },
        { "imaDick" },
        { "facePuncher" },
        { "TEN" },
        { "whatElse" },
    },

    -- Example:
    ["AssHole"] = {
        { "NewName1" },
        { "NewName2" },
        -- ect ...
    }

    -- Repeat the structure to add more names.
    --
}

api_version = "1.12.0.0"

local players = { }
local network_struct

function OnScriptLoad()
    network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)

    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerQuit")
    register_callback(cb["EVENT_PREJOIN"], "OnPlayerPreJoin")
    OnGameStart()
end

function OnScriptUnload()
    -- N/A
end

function OnGameStart()
    if (get_var(0, "gt") ~= "n/a") then
        for n, _ in pairs(names) do
            for k, _ in pairs(names[n]) do
                if (not names[n][k].taken) then
                    names[n][k].taken = false
                end
            end
        end
    end
end

local function GetRandomName(Ply)

    local tmp = { }
    local name = get_var(Ply, "$name")
    if (names[name]) then
        for k, _ in pairs(names[name]) do
            if (not names[name][k].taken) then
                table.insert(tmp, { names[name][k][1], k })
            end
        end

        if (#tmp > 0) then

            math.randomseed(os.clock())
            math.random();
            math.random();
            math.random();

            -- Pick random name table from names[name]:
            local t = tmp[math.random(1, #tmp)]

            local n = t[1] -- new name
            local i = t[2] -- names[name] table index

            names[name][i].taken = true

            players[Ply] = { name, i }

            return n, i
        end
    end

    return false
end

function OnPlayerPreJoin(Ply)
    local new_name = GetRandomName(Ply)
    if (new_name) then
        local cstruct = network_struct + 0x1AA + 0x40 + to_real_index(Ply) * 0x20
        WriteWideString(cstruct, string.sub(new_name, 1, 11), 12)
    end
end

function OnPlayerQuit(Ply)
    if (players[Ply]) then

        local n = players[Ply][1]
        local i = players[Ply][2]

        names[n][i].taken = false

        players[Ply] = nil
    end
end

function WriteWideString(A, S, L)
    local Count = 0
    for _ = 1, L do
        write_byte(A + Count, 0)
        Count = Count + 2
    end
    local count = 0
    local length = string.len(S)
    for i = 1, length do
        local newbyte = string.byte(string.sub(S, i, i))
        write_byte(A + count, newbyte)
        count = count + 2
    end
end