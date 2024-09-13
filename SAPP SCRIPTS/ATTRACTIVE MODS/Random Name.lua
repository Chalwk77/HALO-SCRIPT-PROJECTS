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

Copyright (c) 2021-2024, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--======================================================================================================--
]]--

-- Configuration
local names = {
    ["ADuck"] = {
        { "Halo" }, { "Cortana" }, { "MasterChief" }, { "Covenant" }, { "Flood" },
        { "Grunt" }, { "Elite" }, { "Brute" }, { "Jackal" }, { "Hunter" },
        { "Prophet" }, { "Monitor" }, { "Sentinel" }, { "Spartan" }, { "ODST" },
        { "Marine" }, { "Pilot" }, { "Engineer" }
    },
    ["AGuy"] = {
        { "NewName1" }, { "NewName2" }
    }
}

-- API version required by SAPP
api_version = "1.12.0.0"

-- State variables
local players = {}
local network_struct

-- Function to initialize the script
function OnScriptLoad()
    network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerQuit")
    register_callback(cb["EVENT_PREJOIN"], "OnPlayerPreJoin")
    OnGameStart()
end

-- Function to handle script unload event
function OnScriptUnload()
    -- No cleanup required
end

-- Function to handle game start event
function OnGameStart()
    if get_var(0, "gt") ~= "n/a" then
        for name, _ in pairs(names) do
            for index, _ in pairs(names[name]) do
                names[name][index].taken = false
            end
        end
    end
end

-- Function to get a random name for a player
local function GetRandomName(player_id)
    local available_names = {}
    local player_name = get_var(player_id, "$name")

    if names[player_name] then
        for index, name_entry in pairs(names[player_name]) do
            if not name_entry.taken then
                table.insert(available_names, { name_entry[1], index })
            end
        end

        if #available_names > 0 then
            math.randomseed(os.clock())
            local random_entry = available_names[math.random(1, #available_names)]
            local new_name = random_entry[1]
            local name_index = random_entry[2]

            names[player_name][name_index].taken = true
            players[player_id] = { player_name, name_index }

            return new_name
        end
    end

    return false
end

-- Function to handle player pre-join event
function OnPlayerPreJoin(player_id)
    local new_name = GetRandomName(player_id)
    if new_name then
        local cstruct = network_struct + 0x1AA + 0x40 + to_real_index(player_id) * 0x20
        WriteWideString(cstruct, string.sub(new_name, 1, 11), 12)
    end
end

-- Function to handle player quit event
function OnPlayerQuit(player_id)
    if players[player_id] then
        local original_name = players[player_id][1]
        local name_index = players[player_id][2]

        names[original_name][name_index].taken = false
        players[player_id] = nil
    end
end

-- Function to write a wide string to memory
function WriteWideString(address, str, length)
    for i = 0, length - 1 do
        write_byte(address + i * 2, 0)
    end
    for i = 1, #str do
        write_byte(address + (i - 1) * 2, string.byte(str, i))
    end
end