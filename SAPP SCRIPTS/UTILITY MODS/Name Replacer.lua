--[[
--=====================================================================================================--
Script Name: Name Replacer, for SAPP (PC & CE)
Description: Change blacklisted names into something funny!

During pre-join, a player's name is cross-checked against a blacklist table.
If a match is made, their name will be changed to a random one from a table called 'random_names'.

As random names get assigned, they become marked as 'used' until the player quits the server.
This is to prevent someone else from being assigned the same random name.

Copyright (c) 2023, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

-- Configuration for blacklisted names and random names
local blacklist = {
    'Butcher', 'Caboose', 'Crazy', 'Cupid', 'Darling', 'Dasher',
    'Disco', 'Donut', 'Dopey', 'Ghost', 'Goat', 'Grumpy',
    'Hambone', 'Hollywood', 'Howard', 'Jack', 'Killer', 'King',
    'Mopey', 'New001', 'Noodle', 'Nuevo001', 'Penguin', 'Pirate',
    'Prancer', 'Saucy', 'Shadow', 'Sleepy', 'Snake', 'Sneak',
    'Stompy', 'Stumpy', 'The Bear', 'The Big L', 'Tooth',
    'Walla Walla', 'Weasel', 'Wheezy', 'Whicker', 'Whisp',
    'Wilshire'
}

local random_names = {
    'Liam', 'Noah', 'Oliver', 'Elijah', 'William', 'James',
    'Benjamin', 'Lucas', 'Henry', 'Alexander', 'Mason',
    'Michael', 'Ethan', 'Daniel', 'Jacob', 'Logan',
    'Jackson', 'Levi', 'Sebastian', 'Mateo', 'Jack',
    'Owen', 'Theodore', 'Aiden', 'Samuel', 'Joseph',
    'John', 'David', 'Wyatt', 'Matthew', 'Luke',
    'Asher', 'Carter', 'Julian', 'Grayson', 'Leo',
    'Jayden', 'Gabriel', 'Isaac', 'Lincoln', 'Anthony'
}

local players = {}
local network_struct
local ce
local byte = string.byte
local char = string.char

function OnScriptLoad()
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_PREJOIN'], 'OnPreJoin')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')

    network_struct = read_dword(sig_scan('F3ABA1????????BA????????C740??????????E8????????668B0D') + 3)
    ce = (halo_type == 'PC' and 0x0 or 0x40)

    OnStart()
end

-- Get a random name for the player
local function getRandomName(player)
    local availableNames = {}

    for i, name in ipairs(random_names) do
        if not players[name] then
            table.insert(availableNames, {name = name, index = i})
        end
    end

    if #availableNames > 0 then
        local randomIndex = rand(1, #availableNames)
        local chosenName = availableNames[randomIndex].name
        local nameIndex = availableNames[randomIndex].index

        players[player] = nameIndex
        random_names[nameIndex].used = true

        return chosenName
    end

    return generateRandomString(11)
end

-- Generate a random string of a specified length
local function generateRandomString(length)
    local name = ''
    for _ = 1, length do
        name = name .. char(rand(97, 123)) -- lowercase letters a-z
    end
    return name
end

-- Mark a name as 'used' if it exists in the random names table
local function checkName(name)
    for _, v in ipairs(random_names) do
        if name == v then
            players[name] = true
        end
    end
end

-- Set a player's name to a new random name
local function setNewName(id, newName)
    local count = 0
    local address = network_struct + 0x1AA + ce + to_real_index(id) * 0x20

    for _ = 1, 12 do
        write_byte(address + count, 0) -- Clear existing name
        count = count + 2
    end

    local str = newName:sub(1, 11) -- Limit to 11 characters
    local length = str:len()

    for j = 1, length do
        local new_byte = byte(str:sub(j, j))
        write_byte(address + count, new_byte)
        count = count + 2
    end
end

-- Handle player pre-join events
function OnPreJoin(player)
    local name = get_var(player, '$name')
    checkName(name)

    for _, blacklisted_name in ipairs(blacklist) do
        if name == blacklisted_name then
            local new_name = getRandomName(player)
            setNewName(player, new_name)
            cprint(string.format("[Name Replacer] Player %s's name changed to %s.", name, new_name))
            break
        end
    end
end

-- Handle player quit events
function OnQuit(player)
    local id = players[player]

    if id then
        random_names[id].used = false
        players[player] = nil
    end
end

-- Initialize the script and reset names for all players
function OnStart()
    if get_var(0, '$gt') ~= 'n/a' then
        players = {}

        for _, v in ipairs(random_names) do
            v.used = false
        end

        for i = 1, 16 do
            if player_present(i) then
                checkName(get_var(i, '$name'))
            end
        end
    end
end
