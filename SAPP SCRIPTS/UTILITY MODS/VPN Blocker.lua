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
    Copy your unique "Private Key" from that page and paste it into the API_KEY field (line 63) in this script (see config below).

    If VPN Blocker kicks or bans someone it will log the details of that action
    to a file called "VPN Blocker.log" in the servers root directory.

D I S C L A I M E R
-------------------
Some genuine players use a VPN to protect their privacy online and also game while using one.
VPN Blocker cannot differentiate between good and bad intentions
and will, therefore, kick or ban on sight if their IP is on the VPN Blocker database.
--

Copyright (c) 2023, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local VPNBlocker = {

    --------------------------------------------------------------------------
    -- I recommend reading the API Documentation before changing any settings:
    -- https://www.ipqualityscore.com/documentation/proxy-detection/overview
    --------------------------------------------------------------------------

    -------------------
    -- config starts --
    -------------------

    -- IP Quality Score API KEY:
    --
    api_key = 'nZLmnd32Z4aRybTpaIKWA7JuBnuU6d6v',


    -- If the player is using a VPN Connection, do this action:
    -- k = kick, b = ban
    --
    action = 'k',


    -- If action is "b" the player will be banned for this amount of time ((in minutes) set to 0 for permanent ban):
    --
    ban_time = 10,


    -- The reason for being kicked or banned:
    --
    reason = 'VPN Connection',


    -- Message output to the joining player:
    --
    feedback1 = "We've detected that you're using a VPN or Proxy - we do not allow these!'",


    -- Message output to Dedicated Server Console:
    --
    feedback2 = '$name was $action for using a VPN or Proxy (IP: $ip)',


    -- A message relay function temporarily removes the "msg_prefix"
    -- and will restore it to this when the relay is finished:
    --
    prefix = '**SAPP**',


    -- Log verbose details to the console?
    -- Includes: IP Address, Fraud Score, Bot Status, etc.
    --
    log_verbose = true,


    -- Request Parameters (ADVANCED USERS ONLY):
    -- https://www.ipqualityscore.com/documentation/proxy-detection/overview
    --
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
        bot_status = true
    },

    -- Request Parameters (ADVANCED USERS ONLY):
    -- https://www.ipqualityscore.com/documentation/proxy-detection/overview
    --
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
        mobile = false
    },

    -- Exclude IP Addresses from being checked:
    -- (useful for allowing VPNs for specific players)
    -- Set to 'true' to exclude the IP Address from being checked.
    exclusion_list = {
        ['127.0.0.1'] = true,
        ['192.168.1.1'] = true
    },

    -----------------
    -- config ends --
    -----------------

    -- do not touch --
    site = 'https://www.ipqualityscore.com/api/json/ip/api_key/'
}

local async_table = {}

local json = (loadfile 'json.lua')()
local ffi = require('ffi')

ffi.cdef [[
    typedef void http_response;
    http_response *http_get(const char *url, bool async);
    void http_destroy_response(http_response *);
    void http_wait_async(const http_response *);
    bool http_response_is_null(const http_response *);
    bool http_response_received(const http_response *);
    const char *http_read_response(const http_response *);
]]

local client = ffi.load('lua_http_client')

api_version = '1.12.0.0'

function OnScriptLoad()
    VPNBlocker.key = VPNBlocker.site:gsub('api_key', VPNBlocker.api_key)
    register_callback(cb['EVENT_PREJOIN'], 'PreJoin')
end

local function canConnect(data)
    for k, v in pairs(VPNBlocker.checks) do
        if (type(v) == 'boolean' and v and data[k]) then
            return false
        elseif (type(v) == 'number' and data[k] >= v) then
            return false
        end
    end
    return true
end

local function logVerbose(data)
    if (VPNBlocker.log_verbose) then
        for k,v in pairs(data) do
            print(k,v)
        end
    end
end

local help = [[HTTP RESPONSE IS NULL ->
-- * Possible loss of internet (check it).
-- * Possible End Point error (verify settings or contact IP Quality Score).

-- Sometimes small hiccups with the internet will cause this error.
-- Most of the time you can ignore it.]]

function VPNBlocker:checkAsync(id)

    local response = async_table[id]
    if response and response[1] and client.http_response_received(response[1]) then

        if not client.http_response_is_null(response[1]) then

            local results = ffi.string(client.http_read_response(response[1]))
            local data = json:decode(results)
            if (data) then

                logVerbose(data)

                local allowed = canConnect(data)
                if (not allowed) then

                    local player = response[2]
                    id = tonumber(id)

                    local state = (self.action == 'k' and 'kicked' or 'banned')
                    if (self.action == 'k') then
                        execute_command('k ' .. id .. ' ' .. ' "' .. self.reason .. '"')
                    else
                        execute_command('b ' .. id .. ' ' .. self.ban_time .. ' "' .. self.reason .. '"')
                    end

                    execute_command('msg_prefix ""')
                    local msg = self.feedback2:gsub('$name', player.name)
                    msg = msg:gsub('$action', state):gsub('$ip', player.ip)

                    say(id, self.feedback1)
                    say_all(msg);
                    cprint(msg, 12)
                    execute_command('msg_prefix "' .. self.prefix .. '"')
                end
            end
        else
            cprint(help, 12)
        end

        client.http_destroy_response(response[1])
        async_table[tostring(id)] = nil

        return false
    end

    return true
end

local function generateLink(player)
    local self = VPNBlocker
    local i = 0
    local link = tostring(self.key .. player.ip .. '?')
    for k, v in pairs(self.parameters) do
        link = (i < 1) and (link .. k .. '=' .. tostring(v)) or (link .. '&' .. k .. '=' .. tostring(v))
    end
    return link
end

local function ignorePlayer(ip)
    return VPNBlocker.exclusion_list[ip] and true or false
end

local function getPlayer(id)
    local ip = get_var(id, '$ip'):match('%d+.%d+.%d+.%d+')
    return (not ignorePlayer(ip)) and {
        ip = ip,
        name = get_var(id, '$name')
    } or nil
end

function PreJoin(id)

    local player = getPlayer(id)
    if (not player) then
        return
    end

    id = tostring(id)
    local link = generateLink(player)
    async_table[id] = { client.http_get(link, true), player }

    timer(1, 'checkAsync', id)
end

function checkAsync(id)
    return VPNBlocker:checkAsync(id)
end

function OnScriptUnload()
    -- N/A
end