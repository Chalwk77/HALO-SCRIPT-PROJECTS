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
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

-- config starts --

--
-- BLACKLIST TABLE:
--
local blacklist = {
    'Butcher',
    'Caboose',
    'Crazy',
    'Cupid',
    'Darling',
    'Dasher',
    'Disco',
    'Donut',
    'Dopey',
    'Ghost',
    'Goat',
    'Grumpy',
    'Hambone',
    'Hollywood',
    'Howard',
    'Jack',
    'Killer',
    'King',
    'Mopey',
    'New001',
    'Noodle',
    'Nuevo001',
    'Penguin',
    'Pirate',
    'Prancer',
    'Saucy',
    'Shadow',
    'Sleepy',
    'Snake',
    'Sneak',
    'Stompy',
    'Stumpy',
    'The Bear',
    'The Big L',
    'Tooth',
    'Walla Walla',
    'Weasel',
    'Wheezy',
    'Whicker',
    'Whisp',
    'Wilshire'
}

--
-- NAMES TABLE:
--
local random_names = {
    { 'Liam' },
    { 'Noah' },
    { 'Oliver' },
    { 'Elijah' },
    { 'William' },
    { 'James' },
    { 'Benjamin' },
    { 'Lucas' },
    { 'Henry' },
    { 'Alexander' },
    { 'Mason' },
    { 'Michael' },
    { 'Ethan' },
    { 'Daniel' },
    { 'Jacob' },
    { 'Logan' },
    { 'Jackson' },
    { 'Levi' },
    { 'Sebastian' },
    { 'Mateo' },
    { 'Jack' },
    { 'Owen' },
    { 'Theodore' },
    { 'Aiden' },
    { 'Samuel' },
    { 'Joseph' },
    { 'John' },
    { 'David' },
    { 'Wyatt' },
    { 'Matthew' },
    { 'Luke' },
    { 'Asher' },
    { 'Carter' },
    { 'Julian' },
    { 'Grayson' },
    { 'Leo' },
    { 'Jayden' },
    { 'Gabriel' },
    { 'Isaac' },
    { 'Lincoln' },
    { 'Anthony' },
    -- repeat the structure to add more entries
    --
}

-- config ends --

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

local function getRandomName(ply)

    -- Store all name candidates:
    --
    local t = {}
    for i, v in ipairs(random_names) do
        -- Only store names less than 12 characters:
        if (v[1]:len() < 12 and not v.used) then
            t[#t + 1] = { v[1], i } -- {name, table index}
        end
    end

    --
    -- Pick random name candidate:
    if (#t > 0) then

        local n = rand(1, #t + 1)
        local name = t[n][1]
        local id = t[n][2] -- table index from names

        players[ply] = id
        random_names[id].used = true

        return name
    end

    -- If the script was unable to pick a random name,
    -- generate a random 11 character name:
    -- Technical note (FYI): SAPP's rand() function is exclusive of the max value.
    local name = ''
    for _ = 1, rand(1, 12) do
        name = name .. char(rand(97, 123))
    end

    return name
end

--
-- Checks if a newly-joined player's name is already in the random names table.
-- If true, that name gets marked as 'used'.
local function checkName(name)
    for _, v in ipairs(random_names) do
        if (name == v[1]) then
            v.used = true
        end
    end
end

-- Sets the player's name to a random name from the random_names table:
-- @arg: id = player id
-- @arg newName = new name
local function setNewName(id, newName)
    local count = 0
    local address = network_struct + 0x1AA + ce + to_real_index(id) * 0x20

    for _ = 1, 12 do
        write_byte(address + count, 0)
        count = count + 2
    end

    count = 0

    local str = newName:sub(1, 11)
    local length = str:len()

    for j = 1, length do
        local new_byte = byte(str:sub(j, j))
        write_byte(address + count, new_byte)
        count = count + 2
    end
end

-- @arg Ply = player id
function OnPreJoin(Ply)

    local name = get_var(Ply, '$name')
    checkName(name)


    -- Check if their name is blacklisted:
    for _, black_listed_name in ipairs(blacklist) do
        if (name == black_listed_name) then

            -- If so, generate a new name and set it:
            local new_name = getRandomName(Ply)
            setNewName(Ply, new_name)

            break
        end
    end
end

function OnQuit(Ply)

    -- Mark name as 'unused':
    --
    local id = players[Ply]

    if (id ~= nil) then
        random_names[id].used = false
    end

    -- Remove player from table (garbage collection):
    players[Ply] = nil
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        players = { }

        -- Set all names to 'unused' by default:
        --
        for _, v in ipairs(random_names) do
            v.used = false
        end

        -- Check all players in the server:
        for i = 1, 16 do
            if player_present(i) then
                checkName(get_var(i, '$name'))
            end
        end
    end
end