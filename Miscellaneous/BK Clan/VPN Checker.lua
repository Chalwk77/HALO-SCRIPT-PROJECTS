--[[
--=====================================================================================================--
Script Name: VPN Checker, for SAPP (PC & CE)
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
    Copy your unique "Private Key" from that page and paste it into the API_KEY field (line 54) in this script (see config below).

Copyright (c) 2020-2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local VPN = {

    -- Custom command used to check vpn status:
    --
    command = "vpn",

    -- Minimum permission lvl required to execute the custom command:"
    --
    permission = 1,

    -- I recommend reading the API Documentation before changing any settings:
    -- https://www.ipqualityscore.com/documentation/proxy-detection/overview

    -- Paste your API KEY here (from the above link)
    api_key = "API_KEY",

    -- Request Parameters:
    checks = {

        --Check if IP is associated with being a confirmed crawler
        --such as Googlebot, Bingbot, etc based on hostname or IP address verification.
        is_crawler = true,

        --Check if IP suspected of being a VPN connection?
        vpn = true,

        --Check if IP suspected of being a Tor connection?
        tor = true,

        --Check if IP address suspected to be a proxy? (SOCKS, Elite, Anonymous, VPN, Tor, etc.)
        proxy = true,

        --Fraud Score Threshold:
        --Fraud Scores >= 75 are suspicious, but not necessarily fraudulent.
        --I recommend flagging or blocking traffic with Fraud Scores >= 85,
        --but you may find it beneficial to use a higher or lower threshold.
        fraud_score = 85,

        --Premium Account Feature:
        --Indicates if bots or non-human traffic has recently used this IP address to engage
        --in automated fraudulent behavior. Provides stronger confidence that the IP address is suspicious.
        bot_status = true
    },

    parameters = {
        -- How in depth (strict) do you want this query to be?
        -- Higher values take longer to process and may provide a higher false-positive rate.
        -- It is recommended to start at "0", the lowest strictness setting, and increasing to "1" or "2" depending on your needs.
        strictness = 1,

        -- Bypasses certain checks for IP addresses from education and research institutions, schools, and some corporate connections
        -- to better accommodate audiences that frequently use public connections.
        allow_public_access_points = true,

        -- Enable this setting to lower detection rates and Fraud Scores for mixed quality IP addresses.
        -- If you experience any false-positives with your traffic then enabling this feature will provide better results.
        lighter_penalties = false,

        -- This setting is used for time-sensitive lookups that require a faster response time.
        -- Accuracy is slightly degraded with the "fast" approach, but not significantly noticeable.
        fast = false,

        -- You can optionally specify that this lookup should be treated as a mobile device.
        mobile = false,
    }
}

-- Preload JSON Interpreter Library:
--
local json = (loadfile "json.lua")()
local site = "https://www.ipqualityscore.com/api/json/ip/api_key/"

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

local function Query(URL)
    local returning
    local response = http_client.http_get(URL, false)
    if http_client.http_response_is_null(response) ~= true then
        local response_text_ptr = http_client.http_read_response(response)
        returning = ffi.string(response_text_ptr)
    end
    http_client.http_destroy_response(response)
    return returning
end

function OnScriptLoad()
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
end

local function Respond(Ply, Msg)
    if (Ply == 0) then
        cprint(Msg)
    else
        rprint(Ply, Msg)
    end
end

local function GetPlayers(Ply, Args)
    local pl = { }
    if (Args[2] == "me" or Args[2] == nil) then
        if (Ply ~= 0) then
            table.insert(pl, Ply)
        else
            Respond(Ply, "Please enter a valid player id (#1-16)")
        end
    elseif (Args[2] ~= nil and Args[2]:match("^%d+$")) then
        if player_present(Args[2]) then
            table.insert(pl, Args[2])
        else
            Respond(Ply, "Player #" .. Args[2] .. " is not online")
        end
    elseif (Args[2] == "all" or Args[2] == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(pl, i)
            end
        end
        if (#pl == 0) then
            Respond(Ply, "There are no players online!")
        end
    else
        Respond(Ply, "Invalid Command Syntax. Please try again!")
    end
    return pl
end

function VPN:OnCommand(Ply, CMD)

    local Args = { }
    for Params in CMD:gmatch("([^%s]+)") do
        Args[#Args + 1] = Params:lower()
    end

    if (#Args > 0) then
        local lvl = tonumber(get_var(Ply, "$lvl"))
        if (Args[1] == self.command) then
            if (lvl >= self.permission or Ply == 0) then

                local pl = GetPlayers(Ply, Args)
                if (pl) then

                    Respond(Ply, "Running Analysis. Please wait..")

                    for player = 1, #pl do

                        local TID = tonumber(pl[player])
                        local ip = get_var(TID, "$ip"):match("%d+.%d+.%d+.%d+")
                        local key = site:gsub("api_key", self.api_key)
                        local query_link = tostring(key .. ip .. "?")

                        local i = 0
                        for k, v in pairs(self.parameters) do
                            if (i == 0) then
                                query_link = query_link .. k .. "=" .. tostring(v)
                            else
                                query_link = query_link .. "&" .. k .. "=" .. tostring(v)
                            end
                            i = i + 1
                        end

                        local JsonData = Query(query_link)
                        if (JsonData) then
                            local ip_lookup = json:decode(JsonData)
                            if (ip_lookup.success) then
                                Respond(Ply, "VPN STATUS FOR " .. get_var(TID, "$name") .. " [" .. ip .. "]")
                                Respond(Ply, " ") -- line break
                                for k, v in pairs(self.checks) do
                                    local case1 = (type(v) == "boolean" and v)
                                    local case2 = (type(v) == "number" and ip_lookup[k] >= v) -- only display fraud score if it's >= v
                                    if (case1 or case2) then
                                        Respond(Ply, k .. " = " .. tostring(ip_lookup[k]))
                                    end
                                end
                                Respond(Ply, " ") -- line break
                            end
                            return false
                        end
                        Respond(Ply, "Something went wrong. Please check script settings.")
                    end
                end
            else
                Respond(Ply, "You do not have permission to execute this command!")
            end
            return false
        end
    end
end

function OnServerCommand(P, C)
    return VPN:OnCommand(P, C)
end

function OnScriptUnload()
    -- N/A
end