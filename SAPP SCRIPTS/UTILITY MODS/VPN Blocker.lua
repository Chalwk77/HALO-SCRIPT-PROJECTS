--[[
--=====================================================================================================--
Script Name: VPN Blocker, for SAPP (PC & CE)

Description: VPN Blocker will detect whether an IP Address is a Proxy, Tor, or VPN Connection
             and retrieve an overall Fraud Score that provides accurate risk analysis.

             The Fraud Score is a probability of malicious intent based on Machine Learning
             and Data Analysis systems that are run by IP Quality Score.

             For each IP lookup, an IP address and other forensic factors of the connection are analysed to
             determine if the user is hiding behind a spoofed or anonymized IP, tunnelled connection, a botnet,
             or attempting to frequently change their device.

             Private VPNs can be detected, but it might pay to upgrade your IP Quality Score account.
             This is at your own expense, obviously.
             I provide the tool to connect to the API but it's up to the end-user to decide what account type they register with.
             The Free account is pretty good in general.


I M P O R T A N T
-----------------

1): This mod requires that the following plugins are installed to your server:
    https://opencarnage.net/index.php?/topic/5998-sapp-http-client/
    http://regex.info/blog/lua/json

2): Place "json.lua" and the contents of "sapp-http-client" in your servers root directory.

3): Sign up for an account at www.ipqualityscore.com.
    Navigate to Proxy Detection Overview page: https://www.ipqualityscore.com/documentation/proxy-detection/overview
    Copy your unique "Private Key" from that page and paste it into the API_KEY field (line 62) in this script (see config below).

    If VPN Blocker kicks or bans someone it will log the details of that action
    to a file called "VPN Blocker.log" in the servers root directory.

D I S C L A I M E R
-------------------
Some genuine players use a VPN to protect their privacy online and also game while using one.
VPN Blocker cannot differentiate between good and bad intentions
and will, therefore, kick or ban on sight if their IP is on the VPN Blocker database.
--

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]] --

local VPNBlocker = {

    -- config starts --

    -- I recommend reading the API Documentation before changing any settings:
    -- https://www.ipqualityscore.com/documentation/proxy-detection/overview

    -- IP Quality Score API KEY:
    --
    api_key = "PASTE_YOUR_API_KEY_HERE",

    -- If the player is using a VPN Connection, do this action:
    -- k = kick, b = ban
    --
    action = "k",

    -- If action is "b" the player will be banned for this amount of time ((in minutes) set to 0 for permanent ban):
    --
    bantime = 10,

    -- The reason for being kicked or banned:
    --
    reason = "VPN Connection",

    -- Message output to the joining player:
    --
    feedback1 = "We've detected that you're using a VPN or Proxy - we do not allow these!'",

    -- Message output to Dedicated Server Console:
    --
    feedback2 = "$name was $action for using a VPN or Proxy (IP: $ip)",

    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished:
    --
    serverPrefix = "**SAPP**",

    -- Request Parameters:
    checks = {

        -- Check if IP is associated with being a confirmed crawler
        -- such as Googlebot, Bingbot, etc based on hostname or IP address verification.
        --
        is_crawler = true,

        -- Check if IP suspected of being a VPN connection?
        --
        vpn = true,

        -- Check if IP suspected of being a Tor connection?
        --
        tor = true,

        -- Check if IP address suspected to be a proxy? (SOCKS, Elite, Anonymous, VPN, Tor, etc.)
        --
        --
        proxy = true,

        -- Fraud Score Threshold:
        -- Fraud Scores >= 75 are suspicious, but not necessarily fraudulent.
        -- I recommend flagging or blocking traffic with Fraud Scores >= 85,
        -- but you may find it beneficial to use a higher or lower threshold:
        --
        fraud_score = 85,

        -- Premium Account Feature:
        -- Indicates if bots or non-human traffic has recently used this IP address to engage
        -- in automated fraudulent behavior. Provides stronger confidence that the IP address is suspicious:
        --
        bot_status = true,
    },

    parameters = {
        -- How in depth (strict) do you want this query to be?
        -- Higher values take longer to process and may provide a higher false-positive rate.
        -- It is recommended to start at "0", the lowest strictness setting, and increasing to "1" or "2" depending on your needs:
        --
        strictness = 1,

        -- Bypasses certain checks for IP addresses from education and research institutions, schools, and some corporate connections
        -- to better accommodate audiences that frequently use public connections:
        --
        allow_public_access_points = true,

        -- Enable this setting to lower detection rates and Fraud Scores for mixed quality IP addresses.
        -- If you experience any false-positives with your traffic then enabling this feature will provide better results:
        --
        lighter_penalties = false,

        -- This setting is used for time-sensitive lookups that require a faster response time.
        -- Accuracy is slightly degraded with the "fast" approach, but not significantly noticeable:
        --
        fast = false,

        -- You can optionally specify that this lookup should be treated as a mobile device:
        --
        mobile = false,
    },

    exclusion_list = {

        "127.0.0.1",
        "192.168.1.1",
        --
        -- Repeat the structure to add more entries ip entries
        --
    },

    -- Script errors (if any) will be logged to this file:
    --
    error_file = "VPN Blocker (errors).log",

    -- config ends --

    -- DO NOT TOUCH BELOW THIS POINT --
    script_version = 1.3,
    site = "https://www.ipqualityscore.com/api/json/ip/api_key/"
}

api_version = "1.12.0.0"
local json = (loadfile "json.lua")()

function OnScriptLoad()
    VPNBlocker:RegisterKey()
    register_callback(cb["EVENT_PREJOIN"], "PreJoin")
end

local function IsConnected(t)
    for k, v in pairs(VPNBlocker.checks) do
        if (type(v) == "boolean") then
            if (v) and (t[k]) then
                return false
            end
        elseif (type(v) == "number") then
            if (t[k] >= v) then
                return false
            end
        end
    end
    return true
end

local function SilentKick(p)
    for _ = 1, 99999 do
        rprint(p, " ")
    end
end

function VPNBlocker:GenerateLink(Ply)
    local i = 0
    local link = tostring(self.key .. Ply.ip .. "?")
    for k, v in pairs(self.parameters) do
        link = (i < 1 and link .. k .. "=" .. tostring(v) or link .. "&" .. k .. "=" .. tostring(v))
    end
    return link
end

function VPNBlocker:Say(Ply, Msg)
    execute_command("msg_prefix \"\"")
    if (not Ply) then
        say_all(Msg)
    else
        say(Ply, Msg)
    end
    execute_command("msg_prefix \" " .. self.serverPrefix .. "\"")
end

local function Excluded(IP)
    for _, v in pairs(VPNBlocker.exclusion_list) do
        if (IP == v) then
            return true
        end
    end
    return false
end

local function GetPlayer(Ply)
    local ip = get_var(Ply, "$ip"):match('(%d+.%d+.%d+.%d+)')
    if (not Excluded(ip)) then
        return {
            ip = ip,
            name = get_var(Ply, "$name")
        }
    end
    return nil
end

function VPNBlocker:PreJoin(Ply)

    local player = GetPlayer(Ply)
    if (player) then

        local link = self:GenerateLink(player)
        local JsonData = self:Query(link)

        if (JsonData) then

            local ip_lookup = json:decode(JsonData)
            if (ip_lookup.success) then

                local allowed = IsConnected(ip_lookup)
                if (not allowed) then

                    self:Say(Ply, self.feedback1)
                    local state = "none"

                    if (self.action == "k") then
                        state = "kicked"
                        SilentKick(Ply)
                    elseif (self.action == "b") then
                        state = "banned"
                        execute_command("b" .. " " .. Ply .. " " .. self.bantime .. " \"" .. self.reason .. "\"")
                    end

                    local msg = self.feedback2:gsub("$name", player.name)
                    msg = msg:gsub("$action", state):gsub("$ip", player.ip)
                    self:Say(_, msg)
                    cprint(msg, 4 + 8)
                end
                return
            end

            -- Error Handling:
            cprint("[VPN BLOCKER ERROR]", 4 + 8)
            for k, v in pairs(ip_lookup) do
                print(k, v)
            end
            cprint("=========================================================", 12)
        end
    end
end

function PreJoin(Ply)
    VPNBlocker:PreJoin(Ply)
end

function VPNBlocker:RegisterKey()
    self.key = self.site:gsub("api_key", self.api_key)
end

-- Credits to Kavawuvi or HTTP client functionality:
local ffi = require("ffi")
ffi.cdef [[
    typedef void http_response;
    http_response *http_get(const char *url, bool async);
    void http_destroy_response(http_response *);
    void http_wait_async(const http_response *);
    bool http_response_is_null(const http_response *);
    bool http_response_received(const http_response *);
    const char *http_read_response(const http_response *);
    uint32_t http_response_length(const http_response *);
]]
local http_client = ffi.load("lua_http_client")

function VPNBlocker:Query(URL)
    local returning
    local response = http_client.http_get(URL, false)
    if (http_client.http_response_is_null(response) ~= true) then
        local response_text_ptr = http_client.http_read_response(response)
        returning = ffi.string(response_text_ptr)
    end
    http_client.http_destroy_response(response)
    return returning
end

local function WriteError(err)
    local file = io.open(VPNBlocker.error_file, "a+")
    if (file) then
        file:write(err .. "\n")
        file:close()
    end
end

function OnError(Error)
    local log = {
        { os.date("[%H:%M:%S - %d/%m/%Y]"), true, 12 },
        { Error, false, 12 },
        { debug.traceback(), true, 12 },
        { "--------------------------------------------------------", true, 5 },
        { "Please report this error on github:", true, 7 },
        { "https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", true, 7 },
        { "Script Version: " .. VPNBlocker.script_version, true, 7 },
        { "--------------------------------------------------------", true, 5 }
    }
    for _, v in pairs(log) do
        WriteError(v[1])
        if (v[2]) then
            cprint(v[1], v[3])
        end
    end
    WriteError("\n")
end

function OnScriptUnload()
    --
end

-- For a future update:
return VPNBlocker