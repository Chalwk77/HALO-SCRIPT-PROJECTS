api_version = "1.12.0.0"

local preventNegatives = true
local bots = {
    "Butcher", "Caboose", "Crazy", "Cupid", "Darling", "Dasher", "Disco", "Donut", "Dopey", "Ghost",
    "Goat", "Grumpy", "Hambone", "Hollywood", "Howard", "Jack", "Killer", "King", "Mopey", "New001",
    "Noodle", "Nuevo001", "Penguin", "Pirate", "Prancer", "Saucy", "Shadow", "Sleepy", "Snake", "Sneak",
    "Stompy", "Stumpy", "The Bear", "The Big L", "Tooth", "Walla Walla", "Weasel", "Wheezy", "Whicker",
    "Whisp", "Wilshire"
}

function OnScriptLoad()
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
end

function OnScriptUnload()
    -- N/A
end

local function isBot(victim)
    local vpsIP = get_var(victim, "$ip"):match("%d+.%d+.%d+.%d+")
    for _, botName in pairs(bots) do
        if get_var(victim, "$name") == botName and vpsIP == "127.0.0.1" then
            return true
        end
    end
    return false
end

local function adjust(value)
    return preventNegatives and math.max(0, value) or value
end

local function preventScoring(killer, victim)

    local newScore = adjust(tonumber(get_var(killer, "$score")) - 1)
    local newKills = adjust(tonumber(get_var(killer, "$kills")) - 1)
    local newAssists = adjust(tonumber(get_var(killer, "$assists")) - 1)
    local newDeaths = adjust(tonumber(get_var(victim, "$deaths")) - 1)

    execute_command("score " .. killer .. " " .. newScore)
    execute_command("kills " .. killer .. " " .. newKills)
    execute_command("deaths " .. victim .. " " .. newDeaths)
    execute_command("assists " .. killer .. " " .. newAssists)
end

function OnPlayerDeath(victim, killer)
    local victimIndex = tonumber(victim)
    local killerIndex = tonumber(killer)

    if killerIndex > 0 and killerIndex ~= victimIndex and isBot(victimIndex) then
        preventScoring(killerIndex, victimIndex)
    end
end