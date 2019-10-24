--[[
--=====================================================================================================--
Script Name: VPN Blocker (VERSION 2), for SAPP (PC & CE)

#1: This mod requires that the following plugins are installed to your server:
- https://opencarnage.net/index.php?/topic/5998-sapp-http-client/
- http://regex.info/blog/lua/json

#2: Place "json.lua" and the contents of "sapp-http-client" in your servers root directory.

#3: Sign up for an account at www.ipqualityscore.com.
- Navigate to Proxy Detection Overview page: https://www.ipqualityscore.com/documentation/proxy-detection/overview
- Copy your unique "Private Key" from that page and paste 
it into the API_KEY field (line 29) in this script (see config below).

If VPN Blocker kicks or bans someone it will log the details of that action 
to a file called "VPN Blocker.log" in the servers root directory.


Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

api_version = "1.12.0.0"

local vpn_blocker = { 
    -- Configuration [starts]
    api_key = "API_KEY", -- paste your api key here (from www.ipqualityscore.com)
    url = "https://www.ipqualityscore.com/api/json/ip/api_key/",
    action = "k", -- k = kick, b = ban
    feedback1 = "We\'ve detected that you\'re using a VPN or Proxy - we do not allow these!'",
    feedback2 = "%name% was %action% for using a VPN or Proxy (IP: %ip%)",
    
    checks = {

        is_crawler = true,
        --Check if IP is associated with being a confirmed crawler 
        --such as Googlebot, Bingbot, etc based on hostname or IP address verification.
        
        vpn = true,
        --Check if IP suspected of being a VPN connection?
        
        tor = true,
        --Check if IP suspected of being a Tor connection?
        
        proxy = true,
        --Check if IP address suspected to be a proxy? (SOCKS, Elite, Anonymous, VPN, Tor, etc.)
        
        fraud_score = 85,
        --Fraud Score Threshold: 
        --Fraud Scores >= 75 are suspicious, but not necessarily fraudulent. 
        --I recommend flagging or blocking traffic with Fraud Scores >= 85, 
        --but you may find it beneficial to use a higher or lower threshold.
        
        bot_status = true,
        --Premium Account Feature:
        --Indicates if bots or non-human traffic has recently used this IP address to engage 
        --in automated fraudulent behavior. Provides stronger confidence that the IP address is suspicious.
    },
    
    exclusion_list = {
        "127.0.0.1", -- localhost
        "000.000.000.000",
        -- Repeat the structure to add more entries
    }
    -- Configuration [ends]
}

local gsub, format = string.gsub, string.format
local json = (loadfile "json.lua")()

function OnScriptLoad()
    register_callback(cb["EVENT_PREJOIN"], "OnPreJoin")
end

function OnPreJoin(p)

    local player = vpn_blocker:GetCredentials(p)
    if (player) then
        local url = gsub(vpn_blocker.url, "api_key", vpn_blocker.api_key)
        local data = vpn_blocker:Query(tostring(url .. player.ip))
            
        if (data) then
            local ip_lookup = json:decode(data)
            local connected = function()
                cprint("VPN Blocker -> Running Ip Lookup ^ Please wait...", 4+8)
                for k,v in pairs(vpn_blocker.checks) do
                    if (type(v) == "boolean") then
                        if (v) and (ip_lookup[k]) then
                            return false
                        end
                    elseif (type(v) == "number") then
                        if (ip_lookup[k] >= v) then
                            return false
                        end
                    end
                end
                return true
            end

            if (not connected()) then
                            
                say(p, vpn_blocker.feedback1)
                execute_command(vpn_blocker.action .. " " .. p)
                
                if (vpn_blocker.action == "k") then
                    action = "kicked"
                elseif (vpn_blocker.action == "b") then
                    action = "banned"
                end
                
                local logtime = true
                for key,value in pairs(ip_lookup) do
                    vpn_blocker:WriteLog(key,value, logtime)
                    if logtime then logtime = false end
                end
                
                local msg = gsub(gsub(gsub(vpn_blocker.feedback2, "%%name%%", player.name),
                "%%action%%", action), 
                "%%ip%%", player.ip)
                cprint(msg, 4+8)
            else        
                cprint("VPN Blocker -> Player connected successfully.", 2+8)
            end
        end
    end
end

function vpn_blocker:WriteLog(k,v, logtime)
    local file = io.open("VPN Blocker.log", "a+")
    if file then
    
        if (logtime) then
            file:write(os.date("[%H:%M:%S - %d/%m/%Y]: ").."\n")
        end
    
        local line = format("%s\t%s\n", tostring(k), tostring(v))
        file:write(line)
        file:close()
    end
end

function isExcluded(IP)
    -- Check if IP is in the exclusion list.
    local t = vpn_blocker.exclusion_list
    for i = 1,#t do
        if (t[i]) then
            if (IP == t[i]) then
                return true
            end
        end
    end
    return false
end
    
function vpn_blocker:GetCredentials(p)
    local ip = get_var(p, "$ip"):match('(%d+.%d+.%d+.%d+)')
    if (not isExcluded(ip)) then
        local name = get_var(p, "$name")
        return {ip = ip, name = name}
    else
        print('excluded')
        return nil
    end
end

-- Credits to Kavawuvi (002) for HTTP client functionality:
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

function vpn_blocker:Query(URL)
    local response = http_client.http_get(URL, false)
    local returning = nil
    if http_client.http_response_is_null(response) ~= true then
        local response_text_ptr = http_client.http_read_response(response)
        returning = ffi.string(response_text_ptr)
    end
    http_client.http_destroy_response(response)
    return returning
end

function OnScriptUnload()
    --
end

return vpn_blocker
