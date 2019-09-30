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
    -- Configuration [ends]
}

local gsub = string.gsub
local json = (loadfile "json.lua")()

function OnScriptLoad()
    register_callback(cb["EVENT_PREJOIN"], "OnPreJoin")
end

function OnPreJoin(p)
    local player = vpn_blocker:GetCredentials(p)
    cprint("VPN Blocker -> Running Ip Lookup ^ Please wait...", 2+8)
    local url = gsub(vpn_blocker.url, "api_key", vpn_blocker.api_key)
    local data = vpn_blocker:GetPage(tostring(url .. player.ip))
        
    if (data) then
        local ip_lookup = json:decode(data)
        
        
        if (ip_lookup.host ~= "localhost") and (ip_lookup.vpn) or (ip_lookup.tor) then
            say(p, vpn_blocker.feedback1)
            execute_command(vpn_blocker.action .. " " .. p)
            
            if (vpn_blocker.action == "k") then
                action = "kicked"
            elseif (vpn_blocker.action == "b") then
                action = "banned"
            end
            
            for k,v in pairs(ip_lookup) do
                print(k,v)
            end
            
            local msg = gsub(gsub(gsub(vpn_blocker.feedback2, "%%name%%", player.name),"%%action%%", action), "%%ip%%", player.ip)
            cprint(msg, 4+8)
            execute_command("log_note" .. msg)
            vpn_blocker:WriteLog(msg)
        end
    else
        error('VPN Blocker was unable to retrieve the IP Data.')
    end
end

function vpn_blocker:WriteLog(msg)
    local file = io.open("VPN Blocker.log", "a+")
    if file then
        local timestamp = os.date("[%H:%M:%S - %d/%m/%Y]: ")
        local line = string.format("%s\t%s\n", timestamp, tostring(msg))
        file:write(line)
        file:close()
    end
end

function vpn_blocker:GetCredentials(p)
    local ip = get_var(p, "$ip")
    local name = get_var(p, "$name")
    return {ip = ip:match('(%d+.%d+.%d+.%d+)'), name = name}
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

function vpn_blocker:GetPage(URL)
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
