-- Set this to false to allow a players score to go into negatives:
--

local vps_ip = "127.0.0.1"

local prevent_negatives = true

local bots = {
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
}

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
end

local function PreventScoring(Killer, Victim)

    local score = tonumber(get_var(Killer, "$score") - 1)
    local kills = tonumber(get_var(Killer, "$kills") - 1)
    local assists = tonumber(get_var(Killer, "$assists") - 1)
    local deaths = tonumber(get_var(Victim, "$deaths") - 1)

    if (prevent_negatives) then
        score = (score < 0 and 0) or score
        kills = (kills < 0 and 0) or kills
        deaths = (deaths < 0 and 0) or deaths
        assists = (assists < 0 and 0) or assists
    end

    execute_command("score " .. Killer .. " " .. score)
    execute_command("kills " .. Killer .. " " .. kills)
    execute_command("deaths " .. Victim .. " " .. deaths)
    execute_command("assists " .. Killer .. " " .. assists)
end

function OnPlayerDeath(Victim, Killer)
    local k, v = tonumber(Killer), tonumber(Victim)
    if (k > 0 and k ~= v) then
        local bot_ip = get_var(Victim, "$ip"):match("%d+.%d+.%d+.%d+")
        if (bot_ip == vps_ip) then
            for _, bot_name in pairs(bots) do
                if (get_var(v, "$name") == bot_name) then
                    PreventScoring(k, v)
                end
            end
        end
    end
end

function OnScriptUnload()
    -- N/A
end