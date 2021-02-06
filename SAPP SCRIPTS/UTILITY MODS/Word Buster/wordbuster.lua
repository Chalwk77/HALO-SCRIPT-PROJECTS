--[[
--=====================================================================================================--
Script Name: Word Buster, for SAPP (PC & CE)

--- Description ---
Advanced profanity filter mod that automatically censors, replaces or blocks chat messages containing profanity.

--- Features ---
* Pattern matching algorithm to detect variations of words, like "asshole", for example, "a$$hole", "assH0l3" or "a55h01e.
* Censor, Block or Replace bad words (optionally mute players)
* Supports multiple languages
* Warning System + Grace Period
* Customizable messages

-------------- [ INSTALLING LANGUAGE FILES ] ------------
1). Create a new folder in your servers Root directory and call it "WordBuster_database".
2). Download language files here: https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/tree/master/SAPP%20SCRIPTS/UTILITY%20MODS/Word%20Buster/WordBuster_database
3). Place these files in the folder you created in step 1.

SUPPORTED LANGUAGES:
Chinese, Czech, Danish, Dutch, English, Esperanto
French, German, Hungry, Italian, Japanese
Korean, Norwegian, Polish, Portuguese, Russian
Spanish, Swedish, Thai, Turkish, Vietnamese

-------------------------------------------------------------------
MUTE SUPPORT INFORMATION:
If "WordBuster.punishment" is set to "mute", you will need to download and install my custom
Mute System and a file called "json.lua".

Place "json.lua" in the server's root directory - not inside the Lua Folder.
It's crucial that the file names are "json.lua" and "Mute System.lua".
Ensure "Mute System.lua" is initialized.

Download Links:
MUTE SYSTEM: https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/SAPP%20SCRIPTS/UTILITY%20MODS/Mute%20System%20(rewrite).lua
JSON FILE: https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/Miscellaneous/json.lua
-------------------------------------------------------------------

Copyright (c) 2020-2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local WordBuster = {

    -- Word Buster Configuration --

    -- Version: Current version of Word Buster
    version = 1.5,

    -- Censor Words: Censor words with "censor" character?
    censorWords = true,

    -- Semi Censor: Show the first and last character of bad words?
    -- If false, the whole word will be censored
    semiCensor = true,

    -- Censor: Which character should be used to replace bad words?
    censor = "*",

    -- Block whole words: By default this is set to true, so profanity only matches on whole words.
    -- Setting this to false, results in partial word matches.
    matchWholeWord = true,

    -- Replace profanity with a random word from the substitute list? (WordBuster.censor & WordBuster.blockWords MUST BE FALSE)
    substituteWords = false,

    -- Block Word: If this is true, the player's message will not be sent
    blockWords = false,

    -- Warning Count: How many warnings before the player is kicked?
    warnings = 5,

    -- Grace Period: Warnings reset after this many seconds of no profanity
    grace = 30,

    -- Punish action: Should players be kicked, banned or neither?
    punishment = "k", -- Valid Actions: "k" = kick, "b" = ban", "mute"

    -- No Punish: If true, no punishments will be dealt (warning system will also be disabled)
    -- Note that word substitution and censoring will still work.
    noPunish = false,

    -- Mute Time: Maximum mute time (in minutes)
    muteTime = 5,

    -- Mute System Script Name: Exact name (without .lua)
    muteSystemScriptName = "Mute System",

    -- Ban Time: How long should a player be banned for? (in minutes)
    banTime = 5,

    -- Ban Reason: State the reason a player was banned
    punishReason = "profanity",

    -- Notify: Notify player that one of his/her words were censored
    notifyUser = true,

    -- Notify Text: Sent to player when they use profanity (if not last warning or kick event)
    notifyText = "[Word Buster] Watch your language!",

    -- Notify Warning Text: Sent to player when they have 1 warning left
    onWarn = "[Word Buster] You will be punished if you continue to use that language!",

    -- Notify Kick Text: Sent to player when they are kicked
    -- Reason is replaced with WordBuster.punishReason
    onKick = "[Word Buster] You were kicked for %reason%!",

    -- Notify Ban Text: Sent to player when they are Banned
    -- %time% is replaced with "WordBuster.banTime"
    -- %reason% is replaced with "WordBuster.punishReason"
    onBan = "[Word Buster] You were banned for %time% minutes for %reason%",

    -- Notify Admins: Notify admins that player was punished?
    notifyAdmins = true,

    -- Notify Admins Text: Message sent to admins when someone is kicked
    kickMsg = "[Word Buster] %name% was kicked for %reason%!",

    -- Notify Admins Text: Message sent to admins when someone is kicked
    banMsg = "[Word Buster] %name% was banned for %reason%!",

    -- Server Prefix: A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished
    serverPrefix = "**SAPP**",

    -- Chat Format: Messages are modified to accommodate censoring
    -- %name% - will output the players name
    -- %msg% - will output message
    -- "%id% - will output the Player Index ID

    chatFormat = {
        global = "%name%: %msg%",
        team = "[%name%]: %msg%",
        vehicle = "[%name%]: %msg%"
    },

    -- Word Substitutions: If (WordBuster.substituteWords) is enabled,
    -- bad words will be randomly replaced with one of these words:
    substitutions = {
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
    },

    -- Language Directory: Folder path to Language Files database (default: server root)
    lang_directory = "WordBuster/",

    -- Languages: Which languages should be loaded?
    languages = {
        ["cs"] = false, -- Czech
        ["da"] = false, -- Danish
        ["de"] = false, -- German
        ["en"] = true, -- English
        ["eo"] = false, -- Esperanto
        ["es"] = false, -- Spanish
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
    },

    -- Whitelist: Groups allowed to use bad words
    whitelist = {
        [-1] = false, -- PUBLIC
        [1] = true, -- ADMIN LEVEL 1
        [2] = true, -- ADMIN LEVEL 2
        [3] = true, -- ADMIN LEVEL 3
        [4] = true, -- ADMIN LEVEL 4

        -- Allow specific users:
        specific_users = {
            -- Set this to true to enable "specific_users" feature.
            enabled = true,

            -- Local Host IP:
            ["127.0.0.1"] = true,
            -- repeat the structure to add more IP entries.
        }
    },

    -- Patterns: Advanced users only, patterns used to block variations of bad words
    patterns = {
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
}

-- Word Buster Configuration Ends --

local insert, remove = table.insert, table.remove
local sub, gsub, find, len = string.sub, string.gsub, string.find, string.len

function OnScriptLoad()
    WordBuster:Load()
end

function OnScriptUnload()
    -- N/A
end

function WordBuster:Load()

    self.players = { }
    self.badWords = { }

    local dir = self.lang_directory
    local load_count, time_took = 0, 0

    cprint("[Word Buster] Loading languages...", 10)

    for lang, load in pairs(self.languages) do
        if load then

            local file = io.open(dir .. lang .. ".txt", "r")
            if (file ~= nil) then
                io.close(file)
            end

            if (file) then

                load_count = load_count + 1

                local words = { }
                for line in io.lines(dir .. lang .. ".txt") do
                    insert(words, line)
                end

                time_took = os.clock()
                for _, word in pairs(words) do
                    local Pattern = ""
                    for _, char in pairs(self:StringToTable(word)) do
                        if (self.patterns[char]) then
                            for i = 1, #self.patterns[char] do
                                if (self.patterns[char][i]) then
                                    Pattern = Pattern .. self.patterns[char][i]
                                end
                            end
                        else
                            Pattern = Pattern .. "."
                        end
                    end
                    insert(self.badWords, { Pattern, word, lang })
                end
            else
                cprint("[Word Buster] Couldn't load language '" .. lang .. ".txt', language not found!", 4 + 8)
            end
        end
    end

    if (#self.badWords > 0) then

        if (get_var(0, "$gt") ~= "n/a") then
            for i = 1, 16 do
                if player_present(i) then
                    self:InitPlayer(i, false)
                end
            end
        end

        local filters_found
        for k, v in pairs(WordBuster.badWords) do
            if (v[1] == "" or v[1] == " ") then
                filters_found = true
                remove(self.badWords, k) -- Removes empty filters
            end
        end
        if (filters_found) then
            cprint("[Word Buster] Removing empty filters.", 4 + 8)
        end

        cprint("[Word Buster] Successfully loaded " .. load_count .. " languages:", 2 + 8)
        cprint("[Word Buster] " .. #self.badWords .. " words loaded in " .. time_took .. " seconds", 2 + 8)

        if (not self.noPunish) then
            register_callback(cb["EVENT_TICK"], "OnTick")
        end
        register_callback(cb["EVENT_CHAT"], "OnPlayerChat")
        register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
        register_callback(cb["EVENT_GAME_START"], "OnGameStart")
        register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
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

    -- DEBUG:
    --local _, Params = WordBuster:isCensored("bimbo")
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
        WordBuster.players = { }
    end
end

-- Profanity grace timer:
function WordBuster:GraceTimer()
    for player, v in pairs(self.players) do
        if (player) then
            if (v.begin_cooldown) then
                v.timer = v.timer + 1 / 30
                if (v.timer >= self.grace) then
                    v.timer = 0
                    v.begin_cooldown = false
                    v.warnings = self.warnings
                end
            end
        end
    end
end

function OnPlayerConnect(Ply)
    WordBuster:InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    WordBuster:InitPlayer(Ply, true)
end

function WordBuster:InitPlayer(Ply, Reset)
    if (not Reset) then
        self.players[Ply] = {
            timer = 0,
            begin_cooldown = false,
            warnings = self.warnings
        }
    else
        self.players[Ply] = nil
    end
end

function WordBuster:OnMessageSend(Ply, Msg, Type)

    if (Ply > 0 and Type ~= 6) then

        if self:Whitelisted(Ply) then
            return
        end

        local CMD = ((sub(Msg, 1, 1) == "/") or (sub(Msg, 1, 1) == "\\"))
        if (not CMD) then

            local p = self.players[Ply]
            local Str, Params = self:isCensored(Msg)
            if (#Params > 0) then

                Msg = Str

                local name = get_var(Ply, "$name")
                p.timer = 0
                p.begin_cooldown = true
                p.warnings = p.warnings - 1

                cprint("--------- [ WORD BUSTER ] ---------", 13)
                cprint(name .. " used profanity:")
                for i = 1, #Params do
                    cprint(Params[i][1] .. ", " .. Params[i][2] .. ", " .. Params[i][3])
                end
                cprint("--------------------------------------------------------------------", 13)

                if (self.notifyUser) then
                    if (p.warnings > 1) then
                        -- Send Warning:
                        self:Broadcast(Ply, self.notifyText, "rprint")
                    elseif (p.warnings == 1) and (not self.noPunish) then
                        -- Send last warning:
                        self:Broadcast(Ply, self.onWarn, "rprint")
                    end
                end

                -- Take "action" on this player:
                if (p.warnings <= 0) and (not self.noPunish) then
                    self:TakeAction(Ply, name)
                    return false
                end

                -- NOTE: Players will still be punished even if words are being blocked (by design).
                if (self.blockWords) then
                    return false
                end

                local f = self.chatFormat
                local FORMAT = self.formatMessage

                if (Type == 0) then
                    self:Broadcast(Ply, FORMAT(Ply, Msg, f.global, name), "say_all")
                    return false
                elseif (Type == 1) then
                    self:SayTeam(Ply, FORMAT(Ply, Msg, f.team, name))
                    return false
                elseif (Type == 2) then
                    self:SayTeam(Ply, FORMAT(Ply, Msg, f.vehicle, name))
                    return false
                end
            end
        end
    end
end

function WordBuster:SayTeam(Ply, Msg)
    local team = get_var(Ply, "$team")
    for i = 1, 16 do
        if player_present(i) then
            if (get_var(i, "$team") == team) then
                self:Broadcast(i, Msg, "say")
            end
        end
    end
end

function WordBuster:Broadcast(Ply, Msg, Type)
    execute_command("msg_prefix \"\"")
    if (Type == "rprint") then
        rprint(Ply, Msg)
    elseif (Type == "say") then
        say(Ply, Msg)
    elseif (Type == "say_all") then
        say_all(Msg)
    end
    execute_command("msg_prefix \" " .. self.serverPrefix .. "\"")
end

function WordBuster:CensorWord(WORD)
    if (self.semiCensor) then
        for i = 1, len(WORD) do
            if (i > 1 and i < len(WORD)) then
                local letters = sub(WORD, i, i)
                WORD = gsub(WORD, letters, self.censor)
            end
        end
        return WORD
    else
        local censor, l = "", 0
        while l < len(WORD) do
            censor = censor .. self.censor
            l = l + 1
        end
        return gsub(WORD, WORD, censor)
    end
end

function WordBuster:isCensored(Msg)

    local Params = { }
    Msg = Msg:lower()

    for _, Pattern in pairs(self.badWords) do

        local censored_word

        if (not self.matchWholeWord) then
            censored_word = Msg:match(Pattern[1])
        else

            local S, F = find(gsub(Msg, "(.*)", " %1 "), "[^%a]" .. Pattern[1] .. "[^%a]")
            if (F) then
                F = F - 2
                censored_word = sub(Msg, S, F)
            end
        end

        if (censored_word ~= nil) then
            if (self.censorWords) then
                Msg = self:CensorWord(censored_word)
            elseif (self.substituteWords) then
                Msg = self:SubstituteWord()
            end
            Params[#Params + 1] = Pattern
        end
    end
    return Msg, Params
end

function WordBuster:SubstituteWord()
    math.randomseed(os.time())
    local s = self.substitutions
    return s[math.random(#s)]
end

function WordBuster.formatMessage(Ply, Msg, Str, Name)

    local patterns = {
        { "%%name%%", Name },
        { "%%msg%%", Msg },
        { "%%id%%", Ply }
    }

    for i = 1, #patterns do
        Str = (gsub(Str, patterns[i][1], patterns[i][2]))
    end

    return Str
end

function WordBuster:Whitelisted(PlayerIndex)
    if (self.whitelist.specific_users.enabled) then
        local IP = get_var(PlayerIndex, "$ip"):match("%d+.%d+.%d+.%d+")
        for k, v in pairs(self.whitelist.specific_users) do
            if (k == IP) and (v) then
                return true
            end
        end
    end
    local lvl = tonumber(get_var(PlayerIndex, "$lvl"))
    if (self.whitelist[lvl]) then
        return true
    end
end

function WordBuster:TakeAction(Ply, Name)
    if (self.punishment == "k") then
        self:SilentKick(Ply, Name)
    elseif (self.punishment == "b") then
        self:BanPlayer(Ply, Name)
    elseif (self.punishment == "mute") then
        self:MutePlayer(Ply, Name)
    end
end

function WordBuster:SilentKick(Ply, Name)

    if (self.notifyAdmins) then
        local Msg = gsub(gsub(self.kickMsg, "%%name%%", Name), "%%reason%%", self.punishReason)
        for i = 1, 16 do
            if player_present(i) then
                if (i ~= Ply) then
                    if (tonumber(get_var(i, "$lvl")) >= 1) then
                        self:Broadcast(i, Msg, "say")
                    end
                end
            end
        end
        cprint(Msg, 5 + 8)
    end

    if (self.notifyUser) then
        self:Broadcast(Ply, gsub(self.onKick, "%%reason%%", self.punishReason), "say")
    end

    for _ = 1, 9999 do
        rprint(Ply, " ")
    end
end

function WordBuster:BanPlayer(Ply, Name)

    if (self.notifyAdmins) then
        local Msg = gsub(gsub(self.banMsg,
                "%%name%%", Name),
                "%%reason%%", self.punishReason)
        for i = 1, 16 do
            if player_present(i) then
                if (i ~= Ply) then
                    if (tonumber(get_var(i, "$lvl")) >= 1) then
                        self:Broadcast(i, Msg, "say")
                    end
                end
            end
        end
        cprint(Msg, 5 + 8)
    end

    if (self.notifyUser) then

        local msg = gsub(gsub(self.onBan,
                "%%time%%", self.banTime),
                "%%reason%%", self.punishReason)

        self:Broadcast(Ply, msg, "say")
    end

    execute_command("ipban " .. Ply .. " " .. self.banTime .. " \"" .. self.punishReason .. "\"")
end

function WordBuster:MutePlayer(Ply)
    local ID = tonumber(Ply)
    local TIME = tonumber(self.muteTime)
    execute_command('lua_call "' .. self.muteSystemScriptName .. '" ExternalMute ' .. ID .. ' ' .. TIME)
end

function WordBuster:StringToTable(Str)
    local Array = {}
    for i = 1, Str:len() do
        insert(Array, Str:sub(i, i))
    end
    return Array
end

local function WriteLog(str)
    local file = io.open("Word Buster Error Log.log", "a+")
    if (file) then
        file:write(str .. "\n")
        file:close()
    end
end

-- In the event of an error, the script will trigger these two functions: OnError(), report()
function report(StackTrace, Error)

    local script_version = string.format("%0.2f", WordBuster.version)

    cprint(StackTrace, 4 + 8)

    cprint("--------------------------------------------------------", 5 + 8)
    cprint("Please report this error on github:", 7 + 8)
    cprint("https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", 7 + 8)
    cprint("Script Version: " .. script_version, 7 + 8)
    cprint("--------------------------------------------------------", 5 + 8)

    local timestamp = os.date("[%H:%M:%S - %d/%m/%Y]")
    WriteLog(timestamp)
    WriteLog("Please report this error on github:")
    WriteLog("https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues")
    WriteLog("Script Version: " .. tostring(script_version))
    WriteLog(Error)
    WriteLog(StackTrace)
    WriteLog("\n")
end

-- This function will return a string with a traceback of the stack call...
-- ...and call function 'report' after 50 milliseconds.
function OnError(Error)
    timer(50, "report", debug.traceback(), Error)
end

function OnPlayerChat(P, M, T)
    return WordBuster:OnMessageSend(P, M, T)
end

function OnTick()
    return WordBuster:GraceTimer()
end

-- For a future update ...
return WordBuster