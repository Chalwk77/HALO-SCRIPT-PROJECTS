api_version = "1.12.0.0"

local NameReplacer = {

    -----
    -- When a player joins the server, their name is cross-checked against the blacklist.
    -- If a match is made, their name will be changed to a random name from the below names table.
    -----

    blacklist = {
        "Hacker",
        "{BK} DIEGO",
        "TᑌᗰᗷᗩᑕᑌᒪOᔕ",
        "TUMBACULOS",
    },

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

    }
}

local network_struct

function OnScriptLoad()

    register_callback(cb["EVENT_PREJOIN"], "OnPreJoin")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerQuit")

    register_callback(cb["EVENT_GAME_START"], "OnGameStart")

    network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    OnGameStart()
end

local function CheckNameExists(Ply)
    local name = get_var(Ply, "$name")
    for j = 1, #self.names do
        if (name == self.names[j][1]) then
            self.names[j][1].used = true
        end
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then

        NameReplacer.players = { }

        for i = 1, #NameReplacer.names do
            NameReplacer.names[i].used = false
        end

        for i = 1, 16 do
            if player_present(i) then

                NameReplacer:InitPlayer(i, true)

                CheckNameExists(i)
            end
        end
    end
end

function NameReplacer:InitPlayer(Ply, Reset)

    if (not Reset) then

        CheckNameExists(Ply)

        self.players[Ply] = { n_id = nil }
        return
    end

    self.players[Ply] = nil
end

function OnPlayerQuit(Ply)

    Ply = NameReplacer.players[Ply]
    if (Ply ~= nil) then
        NameReplacer.names[Ply.n_id].used = false
    end

    NameReplacer:InitPlayer(Ply, true)
end

function NameReplacer:GetRandomName(Ply)

    if (self.players[Ply]) then

        local t = { }
        for i = 1, #self.names do
            if (self.names[i][1]:len() < 12 and not self.names[i].used) then
                t[#t + 1] = { self.names[i][1], i }
            end
        end

        if (#t > 0) then

            local rand = rand(1, #t - 1)
            local name = t[rand][1]
            local n_id = t[rand][2]

            self.names[n_id].used = true
            self.players[Ply].n_id = n_id

            return name
        end
    end

    return "no name"
end

function NameReplacer:PreJoin(Ply)

    self:InitPlayer(Ply, false)

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

function OnPreJoin(Ply)
    return NameReplacer:PreJoin(Ply)
end

return NameReplacer