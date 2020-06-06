--[[
--=====================================================================================================--
Script Name: Word Buster (v1.4), for SAPP (PC & CE)

--- Description ---
Advanced profanity filter mod that automatically censors, replaces or blocks chat messages containing profanity.

--- Features ---
* Pattern matching algorithm to detect variations of words, like "asshole", for example, "a$$hole", "assH0l3" or "a55h01e.
* Censor, Block or Replace bad words (optionally mute players)
* Supports multiple languages
* Warning System + Grace Period
* Customizable messages

-------------- [ INSTALLING LANGUAGE FILES ] ------------
1). Create a new folder in your servers Root directory and call it "wordbuster_database".
2). Download language files here: https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/tree/master/SAPP%20SCRIPTS/UTILITY%20MODS/Word%20Buster/wordbuster_database
3). Place these files in the folder you created in step 1.

SUPPORTED LANGUAGES:
Chinese, Czech, Danish, Dutch, English, Esperanto
French, German, Hungry, Italian, Japanese
Korean, Norwegian, Polish, Portuguese, Russian
Spanish, Swedish, Thai, Turkish, Vietnamese

-------------------------------------------------------------------
MUTE SUPPORT INFORMATION:
If "wordBuster.punishment" is set to "mute", you will need to download and install my custom
Mute System and a file called "json.lua".

Place "json.lua" in the server's root directory - not inside the Lua Folder.
It's crucial that the file names are "json.lua" and "Mute System.lua".
Ensure "Mute System.lua" is activated.

Download Links:
MUTE SYSTEM: https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/SAPP%20SCRIPTS/UTILITY%20MODS/Mute%20System%20(rewrite).lua
JSON FILE: https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/Miscellaneous/json.lua
-------------------------------------------------------------------

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local wordBuster = { }
-- Word Buster Configuration --

-- Version: Current version of Word Buster
wordBuster.version = 1.4

-- Censor Words: Censor words with "wordBuster.censor" character?
wordBuster.censorWords = true

-- Semi Censor: Show the first and last character of bad words?
-- If false, the whole word will be censored
wordBuster.semiCensor = true

-- Censor: Which character should be used to replace bad words?
wordBuster.censor = "*"

-- Replace profanity with a random word from the substitute list? (wordBuster.censor & wordBuster.blockWords MUST BE FALSE)
wordBuster.substituteWords = false

-- Block Word: If this is true, the player's message will not be sent
wordBuster.blockWords = false

-- Warning Count: How many warnings before the player is kicked?
wordBuster.warnings = 5

-- Grace Period: Warnings reset after this many seconds of no profanity
wordBuster.grace = 30

-- Punish action: Should players be kicked, banned or neither?
wordBuster.punishment = "mute" -- Valid Actions: "k" = kick, "b" = ban", "mute"

-- Mute Time: Maximum mute time (in minutes)
wordBuster.muteTime = 5

wordBuster.muteSystemScriptName = "Mute System"

-- Ban Time: How long should a player be banned for? (in minutes)
wordBuster.banTime = 5

-- Ban Reason: State the reason a player was banned
wordBuster.punishReason = "profanity"

-- Notify: Notify player that one of his/her words were censored
wordBuster.notifyUser = true

-- Notify Text: Sent to player when they use profanity (if not last warning or kick event)
wordBuster.notifyText = "[Word Buster] Watch your language!"

-- Notify Warning Text: Sent to player when they have 1 warning left
wordBuster.onWarn = "[Word Buster] You will be punished if you continue to use that language!"

-- Notify Kick Text: Sent to player when they are kicked
-- Reason is replaced with wordBuster.punishReason
wordBuster.onKick = "[Word Buster] You were kicked for %reason%!"

-- Notify Ban Text: Sent to player when they are Banned
-- %time% is replaced with "wordBuster.banTime"
-- %reason% is replaced with "wordBuster.punishReason"
wordBuster.onBan = "[Word Buster] You were banned for %time% minutes for %reason%"

-- Notify Admins: Notify admins that player was punished?
wordBuster.notifyAdmins = true

-- Notify Admins Text: Message sent to admins when someone is kicked
wordBuster.kickMsg = "[Word Buster] %name% was kicked for %reason%!"

-- Notify Admins Text: Message sent to admins when someone is kicked
wordBuster.banMsg = "[Word Buster] %name% was banned for %reason%!"

-- Server Prefix: A message relay function temporarily removes the server prefix
-- and will restore it to this when the relay is finished
wordBuster.serverPrefix = "**SAPP**"

-- Chat Format: Messages are modified to accommodate censoring
-- %name% - will output the players name
-- %msg% - will output message
-- "%id% - will output the Player Index ID

wordBuster.chatFormat = {
    global = "%name%: %msg%",
    team = "[%name%]: %msg%",
    vehicle = "[%name%]: %msg%"
}

-- Word Substitutions: If (wordBuster.substituteWords) is enabled,
-- bad words will be randomly replaced with one of these words:
wordBuster.substitutions = {
    "buccaneer", "bulgur", "bumfuzzle", "canoodle", "cantankerous",
    "bamboozled", "bazinga", "bevy", "bifurcate", "bilirubin", "bobolink",
    "prestidigitation", "proctor", "rapscallion", "rookery", "rumpus", "scootch",
    "dingy", "doodle", "doohickey", "eschew", "fiddledeedee", "finagle", "flanker",
    "sprocket", "squeegee", "succubus", "tater", "tuber", "tuchis", "viper", "waddle",
    "kerplunk", "kinkajou", "knickers", "lackadaisical", "loopy", "manscape", "monkey",
    "walkabout", "wasabi", "weasel", "wenis", "whatnot", "wombat", "wonky", "zeitgeist",
    "floozy", "fungible", "girdle", "gobsmacked", "grog", "gumption", "gunky", "hitherto",
    "carbuncle", "caterwaul", "cattywampus", "cheeky", "conniption", "coot", "didgeridoo",
    "mugwump", "namby-pamby", "noggin", "pantaloons", "passel", "persnickety", "popinjay",
    "hoi polloi", "hornswoggle", "hullabaloo", "indubitably", "janky", "kahuna", "katydid",
    "scuttlebutt", "shebang", "Shih Tzu", "smegma", "snarky", "snuffle", "spelunker", "spork",
}

-- Language Directory: Folder path to Language Files database (default: server root)
wordBuster.lang_directory = "wordbuster_database/"

-- Languages: Which languages should be loaded?
wordBuster.languages = {
    ["cs"] = false, -- Czech
    ["da"] = false, -- Danish
    ["de"] = false, -- German
    ["en"] = true, -- English
    ["eo"] = false, -- Esperanto
    ["es"] = true, -- Spanish
    ["fr"] = false, -- French
    ["hu"] = false, -- Hungry
    ["it"] = false, -- Italy
    ["ja"] = false, -- Japan
    ["ko"] = false, -- Korea
    ["nl"] = false, -- Dutch
    ["no"] = false, -- Norway
    ["pl"] = false, -- Poland
    ["pt"] = false, -- Portuguese
    ["ru"] = false, -- Russia
    ["sv"] = false, -- Swedish
    ["th"] = false, -- Thai
    ["tr"] = false, -- Turkish
    ["zh"] = false, -- Chinese
    ["tlh"] = false, -- Vietnamese
}

-- Whitelist: Groups allowed to use bad words
wordBuster.whitelist = {
    [-1] = false, -- PUBLIC
    [1] = true, -- ADMIN LEVEL 1
    [2] = true, -- ADMIN LEVEL 2
    [3] = true, -- ADMIN LEVEL 3
    [4] = false, -- ADMIN LEVEL 4
}

-- Patterns: Advanced users only, patterns used to block variations of bad words
wordBuster.patterns = {
    ["a"] = { "[aA@]" },
    ["b"] = { "[bB]" },
    ["c"] = { "[cCkK]" },
    ["d"] = { "[dD]" },
    ["e"] = { "[eE3]" },
    ["f"] = { "[fF]" },
    ["g"] = { "[gG6]" },
    ["h"] = { "[hH]" },
    ["i"] = { "[iIl!1]" },
    ["j"] = { "[jJ]" },
    ["k"] = { "[cCkK]" },
    ["l"] = { "[lL1!i]" },
    ["m"] = { "[mM]" },
    ["n"] = { "[nN]" },
    ["o"] = { "[oO0]" },
    ["p"] = { "[pP]" },
    ["q"] = { "[qQ9]" },
    ["r"] = { "[rR]" },
    ["s"] = { "[sS$5]" },
    ["t"] = { "[tT7]" },
    ["u"] = { "[uUvV]" },
    ["v"] = { "[vVuU]" },
    ["w"] = { "[wW]" },
    ["x"] = { "[xX]" },
    ["y"] = { "[yY]" },
    ["z"] = { "[zZ2]" },
}

-- [CONFIG ENDS] ============================================================================================

local len = string.len
local sub, gsub = string.sub, string.gsub
local insert, remove = table.insert, table.remove

function OnScriptLoad()
    wordBuster:Load()
end

function OnScriptUnload()
    -- N/A
end

function wordBuster:Load()

    cprint("[Word Buster] Loading languages...", 2 + 8)

    local load_count = 0

    wordBuster.players = { }
    wordBuster.players = { }
    wordBuster.badWords = { }

    local dir = wordBuster.lang_directory
    for lang, load in pairs(wordBuster.languages) do
        if load then

            local file = io.open(dir .. lang .. ".txt", "r")
            if (file ~= nil) then
                io.close(file)
            end

            if (file) then

                load_count = load_count + 1

                local words = {}
                for line in io.lines(dir .. lang .. ".txt") do
                    insert(words, line)
                end

                for _, word in pairs(words) do
                    local Pattern = ""
                    for _, char in pairs(string.ToTable(word)) do
                        if (wordBuster.patterns[char]) then
                            for i = 1, #wordBuster.patterns[char] do
                                if (wordBuster.patterns[char][i]) then
                                    Pattern = Pattern .. wordBuster.patterns[char][i]
                                end
                            end
                        else
                            Pattern = Pattern .. "."
                        end
                    end

                    insert(wordBuster.badWords, { Pattern, word, lang })
                end
            else
                cprint("[Word Buster] Couldn't load language '" .. lang .. ".txt', language not found!", 4 + 8)
            end
        end
    end

    if (#wordBuster.badWords > 0) then

        if (get_var(0, "$gt") ~= "n/a") then
            for i = 1, 16 do
                if player_present(i) then
                    wordBuster:InitPlayer(i, false)
                end
            end
        end

        for k, v in pairs(wordBuster.badWords) do
            if (v[1] == "" or v[1] == " ") then
                cprint("[Word Buster] Removing empty filters " .. v, 4 + 8)
                remove(wordBuster.badWords, k) -- Removes empty filters
            end
        end

        local time_took = os.clock()

        cprint("[Word Buster] Successfully loaded " .. load_count .. " languages:", 2 + 8)
        cprint("[Word Buster] " .. #wordBuster.badWords .. " words loaded in " .. time_took .. " seconds", 2 + 8)

        register_callback(cb["EVENT_TICK"], "OnTick")
        register_callback(cb["EVENT_CHAT"], "OnPlayerChat")
        register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
        register_callback(cb["EVENT_GAME_START"], "OnGameStart")
        register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
        register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    else
        unregister_callback(cb["EVENT_TICK"])
        unregister_callback(cb["EVENT_CHAT"])
        unregister_callback(cb["EVENT_JOIN"])
        unregister_callback(cb["EVENT_LEAVE"])
        unregister_callback(cb["EVENT_GAME_START"])
        cprint("[Word Buster] Unable to load Bad Words! ", 4 + 8)
    end
end

function OnGameStart()
    -- DEBUG CODE:

    --local _, Params = wordBuster:isCensored("sex")
    --if (#Params > 0) then
    --    for i = 1, #Params do
    --        cprint("------------- WORD FOUND ------------- ", 5 + 8)
    --        cprint("Pattern: " .. Params[i][1], 5 + 8)
    --        cprint("Word: " .. Params[i][2], 5 + 8)
    --        cprint("Language: " .. Params[i][3], 5 + 8)
    --    end
    --else
    --    cprint("WORD NOT FOUND", 4 + 8)
    --end

    if (get_var(0, "$gt") ~= "n/a") then
        wordBuster.players = { }
    end
end

function OnTick()

    -- Profanity grace timer:
    for player, v in pairs(wordBuster.players) do
        if (player) then
            if (v.begin_cooldown) then
                v.timer = v.timer + 1 / 30
                if (v.timer >= wordBuster.grace) then
                    v.timer = 0
                    v.begin_cooldown = false
                    v.warnings = wordBuster.warnings
                end
            end
        end
    end
end

function OnPlayerConnect(PlayerIndex)
    wordBuster:InitPlayer(PlayerIndex, false)
end

function OnPlayerDisconnect(PlayerIndex)
    wordBuster:InitPlayer(PlayerIndex, true)
end

function wordBuster:InitPlayer(Player, Reset)
    if (Reset) then
        wordBuster.players[Player] = { }
    else
        wordBuster.players[Player] = {
            timer = 0,
            begin_cooldown = false,
            warnings = wordBuster.warnings,
        }
    end
end

function OnPlayerChat(PlayerIndex, Message, Type)

    if (PlayerIndex > 0 and Type ~= 6) then

        -- Check if player is whitelisted:
        local lvl = tonumber(get_var(PlayerIndex, "$lvl"))
        if (wordBuster.whitelist[lvl]) then
            return
        end

        -- Ignore command text:
        local CMD = ((sub(Message, 1, 1) == "/") or (sub(Message, 1, 1) == "\\"))
        if (not CMD) then

            local p = wordBuster.players[PlayerIndex]
            local Str, Params = wordBuster:isCensored(Message)
            if (#Params > 0) then

                Message = Str

                local name = get_var(PlayerIndex, "$name")
                p.timer = 0
                p.begin_cooldown = true
                p.warnings = p.warnings - 1

                cprint("--------- [ WORD BUSTER ] ---------", 5 + 8)
                cprint(name .. " used profanity:")
                for i = 1, #Params do
                    cprint(Params[i][1] .. ", " .. Params[i][2] .. ", " .. Params[i][3])
                end
                cprint("--------------------------------------------------------------------", 5 + 8)

                if (wordBuster.notifyUser) then
                    if (p.warnings > 1) then
                        -- Send Warning:
                        wordBuster:Broadcast(PlayerIndex, wordBuster.notifyText, "rprint")
                    elseif (p.warnings == 1) then
                        -- Send last warning:
                        wordBuster:Broadcast(PlayerIndex, wordBuster.onWarn, "rprint")
                    end
                end

                -- Take "action" on this player:
                if (p.warnings <= 0) then
                    wordBuster:TakeAction(PlayerIndex, name)
                    return false
                end

                -- NOTE: Players will still be punished even if words are being blocked (by design).
                if (wordBuster.blockWords) then
                    return false
                end

                local f = wordBuster.chatFormat
                local FORMAT = wordBuster.formatMessage

                if (Type == 0) then
                    wordBuster:Broadcast(PlayerIndex, FORMAT(PlayerIndex, Message, f.global, name), "say_all")
                    return false
                elseif (Type == 1) then
                    wordBuster:SayTeam(PlayerIndex, FORMAT(PlayerIndex, Message, f.team, name))
                    return false
                elseif (Type == 2) then
                    wordBuster:SayTeam(PlayerIndex, FORMAT(PlayerIndex, Message, f.vehicle, name))
                    return false
                end
            end
        else
            return false
        end
    end
end

function wordBuster:SayTeam(PlayerIndex, Message)
    local team = get_var(PlayerIndex, "$team")
    for i = 1, 16 do
        if player_present(i) then
            if (get_var(i, "$team") == team) then
                wordBuster:Broadcast(i, Message, "say")
            end
        end
    end
end

function wordBuster:Broadcast(PlayerIndex, Message, Type)
    execute_command("msg_prefix \"\"")
    if (Type == "rprint") then
        rprint(PlayerIndex, Message)
    elseif (Type == "say") then
        say(PlayerIndex, Message)
    elseif (Type == "say_all") then
        say_all(Message)
    end
    execute_command("msg_prefix \" " .. wordBuster.serverPrefix .. "\"")
end

function wordBuster:CensorWord(WORD)
    if (wordBuster.semiCensor) then
        for i = 1, len(WORD) do
            if (i > 1 and i < len(WORD)) then
                local letters = sub(WORD, i, i)
                WORD = gsub(WORD, letters, wordBuster.censor)
            end
        end
        return WORD
    else
        local censor, l = "", 0
        while l < len(WORD) do
            censor = censor .. wordBuster.censor
            l = l + 1
        end
        return gsub(WORD, WORD, censor)
    end
end

function wordBuster:isCensored(Msg)
    local Params = { }
    for _, Pattern in pairs(wordBuster.badWords) do

        local censored_word = Msg:lower():match(Pattern[1])
        if (censored_word ~= nil) then

            if (wordBuster.censorWords) then
                Msg = wordBuster:CensorWord(censored_word)
            elseif (wordBuster.substituteWords) then
                Msg = wordBuster:SubstituteWord()
            end

            Params[#Params + 1] = Pattern
        end
    end
    return Msg, Params
end

function wordBuster:SubstituteWord()
    math.randomseed(os.time())
    local s = wordBuster.substitutions
    return s[math.random(#s)]
end

function wordBuster.formatMessage(PlayerIndex, Msg, Str, Name)

    local patterns = {
        { "%%name%%", Name },
        { "%%msg%%", Msg },
        { "%%id%%", PlayerIndex }
    }

    for i = 1, #patterns do
        Str = (gsub(Str, patterns[i][1], patterns[i][2]))
    end

    return Str
end

function wordBuster:TakeAction(PlayerIndex, Name)
    if (wordBuster.punishment == "k") then
        wordBuster:SilentKick(PlayerIndex, Name)
    elseif (wordBuster.punishment == "b") then
        wordBuster:BanPlayer(PlayerIndex, Name)
    elseif (wordBuster.punishment == "mute") then
        wordBuster:MutePlayer(PlayerIndex, Name)
    end
end

-- Overwhelm the player console (causes player to disconnect)
function wordBuster:SilentKick(PlayerIndex, Name)

    if (wordBuster.notifyAdmins) then
        local Msg = gsub(gsub(wordBuster.kickMsg,
                "%%name%%", Name),
                "%%reason%%", wordBuster.punishReason)
        for i = 1, 16 do
            if player_present(i) then
                if (i ~= PlayerIndex) then
                    if (tonumber(get_var(i, "$lvl")) >= 1) then
                        Broadcast(i, Msg, "say")
                    end
                end
            end
        end
        cprint(Msg, 5 + 8)
    end

    if (wordBuster.notifyUser) then
        wordBuster:Broadcast(PlayerIndex, gsub(wordBuster.onKick, "%%reason%%", wordBuster.punishReason), "say")
    end

    for _ = 1, 9999 do
        rprint(PlayerIndex, " ")
    end
end

-- Overwhelm the player console (causes player to disconnect)
function wordBuster:BanPlayer(PlayerIndex, Name)

    if (wordBuster.notifyAdmins) then
        local Msg = gsub(gsub(wordBuster.banMsg,
                "%%name%%", Name),
                "%%reason%%", wordBuster.punishReason)
        for i = 1, 16 do
            if player_present(i) then
                if (i ~= PlayerIndex) then
                    if (tonumber(get_var(i, "$lvl")) >= 1) then
                        Broadcast(i, Msg, "say")
                    end
                end
            end
        end
        cprint(Msg, 5 + 8)
    end

    if (wordBuster.notifyUser) then

        local msg = gsub(gsub(wordBuster.onBan,
                "%%time%%", wordBuster.banTime),
                "%%reason%%", wordBuster.punishReason)

        wordBuster:Broadcast(PlayerIndex, msg, "say")
    end

    execute_command("ipban " .. PlayerIndex .. " " .. wordBuster.banTime .. " \"" .. wordBuster.punishReason .. "\"")
end

function wordBuster:MutePlayer(PlayerIndex)
    local ID = tonumber(PlayerIndex)
    local TIME = tonumber(wordBuster.muteTime)
    execute_command('lua_call "' .. wordBuster.muteSystemScriptName .. '" ExternalMute ' .. ID .. ' ' .. TIME)
end

string.ToTable = function(String)
    local Array = {}
    for i = 1, String:len() do
        insert(Array, String:sub(i, i))
    end
    return Array
end

function report()
    local script_version = string.format("%0.2f", wordBuster.version)
    cprint("--------------------------------------------------------", 5 + 8)
    cprint("Please report this error on github:", 7 + 8)
    cprint("https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", 7 + 8)
    cprint("Script Version: " .. script_version, 7 + 8)
    cprint("--------------------------------------------------------", 5 + 8)
end

function OnError()
    cprint(debug.traceback(), 4 + 8)
    timer(50, "report")
end
