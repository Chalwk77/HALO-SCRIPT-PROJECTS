-- Set to false to allow players' scores to go negative
local preventNegatives = true

-- List of bot names
local bots = {
    "Butcher", "Caboose", "Crazy", "Cupid", "Darling", "Dasher", "Disco", "Donut", "Dopey", "Ghost",
    "Goat", "Grumpy", "Hambone", "Hollywood", "Howard", "Jack", "Killer", "King", "Mopey", "New001",
    "Noodle", "Nuevo001", "Penguin", "Pirate", "Prancer", "Saucy", "Shadow", "Sleepy", "Snake", "Sneak",
    "Stompy", "Stumpy", "The Bear", "The Big L", "Tooth", "Walla Walla", "Weasel", "Wheezy", "Whicker",
    "Whisp", "Wilshire"
}

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
end

function OnScriptUnload()
    -- N/A
end

-- Helper functions
local function isBot(victim)
    -- Check if the victim is a bot by comparing its IP to the VPS IP and name to the bot list
    local vpsIP = get_var(victim, "$ip"):match("%d+.%d+.%d+.%d+")
    for _, botName in pairs(bots) do
        if get_var(victim, "$name") == botName and vpsIP == "127.0.0.1" then
            return true
        end
    end
    return false
end

local function preventScoring(killer, victim)

    local newScore = tonumber(get_var(killer, "$score")) - 1
    local newKills = tonumber(get_var(killer, "$kills")) - 1
    local newAssists = tonumber(get_var(killer, "$assists")) - 1
    local newDeaths = tonumber(get_var(victim, "$deaths")) - 1

    -- Prevent score values from going negative if preventNegatives is set to true
    if preventNegatives then
        newScore = (newScore < 0 and 0) or newScore
        newKills = (newKills < 0 and 0) or newKills
        newAssists = (newAssists < 0 and 0) or newAssists
        newDeaths = (newDeaths < 0 and 0) or newDeaths
    end

    -- Update player scores
    execute_command("score " .. killer .. " " .. newScore)
    execute_command("kills " .. killer .. " " .. newKills)
    execute_command("deaths " .. victim .. " " .. newDeaths)
    execute_command("assists " .. killer .. " " .. newAssists)
end

function OnPlayerDeath(victim, killer)
    local victimIndex = tonumber(victim)
    local killerIndex = tonumber(killer)

    -- Check if the victim is a bot and the killer is a player
    if killerIndex > 0 and killerIndex ~= victimIndex and isBot(victimIndex) then
        preventScoring(killerIndex, victimIndex)
    end
end
