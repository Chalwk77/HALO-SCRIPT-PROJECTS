--[[
--=====================================================================================================--
Script Name: Name Replacer, for SAPP (PC & CE)
Description: Change blacklisted names into something funny!

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- config starts --

local NameReplacer = {

    -- When a player joins the server, their name is cross-checked against the BLACKLIST TABLE.
    -- If a match is made, their name will be changed to a random name from the below NAMES TABLE.

    --
    -- BLACKLIST TABLE:
    -- Note: Names can only be max 11 characters!
    blacklist = {
        "Hacker",
        "TᑌᗰᗷᗩᑕᑌᒪOᔕ",
        "TUMBACULOS",
    },


    --
    -- NAMES TABLE:
    -- Note: Names can only be max 11 characters!
    names = {
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

        -- repeat the structure to add more entries
        --
        --
    }
}

-- config ends --

local network_struct

function OnScriptLoad()

    register_callback(cb["EVENT_PREJOIN"], "OnPreJoin")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerQuit")

    register_callback(cb["EVENT_GAME_START"], "OnGameStart")

    network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    OnGameStart()
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then

        NameReplacer.players = { }

        -- Set all names to "unused" by default:
        --
        for _,v in pairs(NameReplacer.names) do
            v.used = false
        end

        for i = 1, 16 do
            if player_present(i) then
                NameReplacer:CheckNameExists(i)
            end
        end
    end
end

function OnPlayerQuit(Ply)

    -- Mark name as "unused":
    --
    local id = NameReplacer.players[Ply]
    if (id ~= nil) then
        NameReplacer.names[id].used = false
    end

    NameReplacer.players[Ply] = nil
end

function NameReplacer:GetRandomName(Ply)

    -- Determine and store all name candidates:
    --
    local t = { }
    for i,v in pairs(self.names) do
        if (v[1]:len() < 12 and not v.used) then
            t[#t + 1] = { v[1], i }
        end
    end

    -- Pick random name candidate:
    if (#t > 0) then

        local rand = rand(1, #t - 1)
        local name = t[rand][1]
        local n_id = t[rand][2]

        self.players[Ply] = n_id
        self.names[n_id].used = true

        return name
    end

    return "no name"
end

function NameReplacer:PreJoin(Ply)

    self:CheckNameExists(Ply)
    local name_on_join = get_var(Ply, "$name")
    for _, name in pairs(self.blacklist) do

        if (name_on_join == name) then

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
                local new_byte = string.byte(str:sub(j, j))
                write_byte(address + count, new_byte)
                count = count + 2
            end

            break
        end
    end
end

--
-- Checks if a newly joined players name is already in the random names table.
-- If true, that name gets marked as "used".
function NameReplacer:CheckNameExists(Ply)
    local name = get_var(Ply, "$name")
    for _,v in pairs(self.names) do
        if (name == v[1]) then
            v[1].used = true
        end
    end
end

function OnPreJoin(Ply)
    return NameReplacer:PreJoin(Ply)
end

-- For a future update:
return NameReplacer