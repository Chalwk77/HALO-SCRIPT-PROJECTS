--[[
--=====================================================================================================--
Script Name: Name Replacer, for SAPP (PC & CE)
Description: Change blacklisted names into something funny!

             During pre-join, a player's name is cross-checked against a blacklist table.
             If a match is made, their name will be changed to a random one from a table called "random_names".

             As random names get assigned, they become marked as "used" until the player quits the server.
             This is to prevent someone else from being assigned the same random name.

todo: [~] FIX: Names are not changing?

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- config starts --

local NameReplacer = {

    --
    -- BLACKLIST TABLE:
    --
    blacklist = {
        "Chalwk",
        "Butcher",
        "Caboose",
        "Crazy",
        "Cupid",
        "Darling",
        "Dasher",
        "Disco",
        "Donut",
        "Dopey",
        "Ghost",
        "Goat",
        "Grumpy",
        "Hambone",
        "Hollywood",
        "Howard",
        "Jack",
        "Killer",
        "King",
        "Mopey",
        "New001",
        "Noodle",
        "Nuevo001",
        "Penguin",
        "Pirate",
        "Prancer",
        "Saucy",
        "Shadow",
        "Sleepy",
        "Snake",
        "Sneak",
        "Stompy",
        "Stumpy",
        "The Bear",
        "The Big L",
        "Tooth",
        "Walla Walla",
        "Weasel",
        "Wheezy",
        "Whicker",
        "Whisp",
        "Wilshire",
    },

    --
    -- NAMES TABLE:
    --
    random_names = {
        { "Liam" },
        { "Noah" },
        { "Oliver" },
        { "Elijah" },
        { "William" },
        { "James" },
        { "Benjamin" },
        { "Lucas" },
        { "Henry" },
        { "Alexander" },
        { "Mason" },
        { "Michael" },
        { "Ethan" },
        { "Daniel" },
        { "Jacob" },
        { "Logan" },
        { "Jackson" },
        { "Levi" },
        { "Sebastian" },
        { "Mateo" },
        { "Jack" },
        { "Owen" },
        { "Theodore" },
        { "Aiden" },
        { "Samuel" },
        { "Joseph" },
        { "John" },
        { "David" },
        { "Wyatt" },
        { "Matthew" },
        { "Luke" },
        { "Asher" },
        { "Carter" },
        { "Julian" },
        { "Grayson" },
        { "Leo" },
        { "Jayden" },
        { "Gabriel" },
        { "Isaac" },
        { "Lincoln" },
        { "Anthony" },
        -- repeat the structure to add more entries
        --
    }
}

-- config ends --

local network_struct

local byte = string.byte
local char = string.char
local random = math.random

function OnScriptLoad()

    register_callback(cb["EVENT_LEAVE"], "OnQuit")
    register_callback(cb["EVENT_PREJOIN"], "OnPreJoin")
    register_callback(cb["EVENT_GAME_START"], "OnStart")

    network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)

    OnStart()
end

function NameReplacer:Init()
    if (get_var(0, "$gt") ~= "n/a") then

        self.players = { }

        -- Set all names to "unused" by default:
        --
        for _, v in pairs(self.random_names) do
            v.used = false
        end

        for i = 1, 16 do
            if player_present(i) then
                self:CheckNameExists(i)
            end
        end
    end
end

function NameReplacer:OnQuit(Ply)

    -- Mark name as "unused":
    --
    local id = self.players[Ply]

    if (id ~= nil) then
        self.random_names[id].used = false
    end

    self.players[Ply] = nil
end

function NameReplacer:GetRandomName(Ply)

    -- Determine and store all name candidates:
    --
    local t = {}
    for i, v in pairs(self.random_names) do
        if (v[1]:len() < 12 and not v.used) then
            t[#t + 1] = { v[1], i } -- {name, table index}
        end
    end

    --
    -- Pick random name candidate:
    if (#t > 0) then

        local n = rand(1, #t + 1)
        local name = t[n][1]
        local n_id = t[n][2] -- table index from names

        self.players[Ply] = n_id
        self.random_names[n_id].used = true

        return name
    end

    -- If the script was unable to pick a random name,
    -- generate a random 11 character
    local name = ""
    for _ = 1, random(1, 11) do
        name = name .. char(random(97, 122))
    end

    return name
end

function NameReplacer:PreJoin(Ply)

    self:CheckNameExists(Ply)

    local name_on_join = get_var(Ply, "$name")
    for _, black_listed_name in pairs(self.blacklist) do

        if (name_on_join == black_listed_name) then

            local new_name = self:GetRandomName(Ply)

            local count = 0
            local address = network_struct + 0x1AA + 0x40 + to_real_index(Ply) * 0x20

            for _ = 1, 12 do
                write_byte(address + count, 0)
                count = count + 2
            end

            count = 0

            local str = new_name:sub(1, 11)
            local length = str:len()

            for j = 1, length do
                local new_byte = byte(str:sub(j, j))
                write_byte(address + count, new_byte)
                count = count + 2
            end

            break
        end
    end
end

--
-- Checks if a newly-joined player's name is already in the random names table.
-- If true, that name gets marked as "used".
function NameReplacer:CheckNameExists(Ply)
    local name = get_var(Ply, "$name")
    for _, v in pairs(self.random_names) do
        if (name == v[1]) then
            v.used = true
        end
    end
end

function OnPreJoin(Ply)
    NameReplacer:PreJoin(Ply)
end

function OnStart()
    NameReplacer:Init()
end

function OnQuit(Ply)
    NameReplacer:OnQuit(Ply)
end

return NameReplacer