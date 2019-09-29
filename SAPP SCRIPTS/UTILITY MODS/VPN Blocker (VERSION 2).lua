--[[
--=====================================================================================================--
Script Name: VPN Blocker (VERSION 2), for SAPP (PC & CE)

This mod requires that the following plugins are installed to your server:
1). https://opencarnage.net/index.php?/topic/5998-sapp-http-client/
2). http://regex.info/blog/lua/json

Place "json.lua" and the contents of "sapp-http-client" in your servers root directory.

Sign up for an account at www.ipqualityscore.com and paste 
your "Proxy & VPN Detection API" key into the API_KEY field (see config below).

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
    action = "kick",
    feedback = "We\'ve detected that you\'re using a VPN or Proxy - we do not allow these!'"
    -- Configuration [ends]
}

local json = (loadfile "json.lua")()

function OnScriptLoad()
    register_callback(cb["EVENT_PREJOIN"], "OnPreJoin")
end

function OnPreJoin(p)
    local player = vpn_blocker:GetCredentials(p)
    
    cprint("Retrieving vpn-ipv4 addresses. Please wait...", 2+8)
    
    local url = string.gsub(vpn_blocker.url, "api_key", vpn_blocker.api_key)
    local data = vpn_blocker:GetPage(tostring(url .. player.ip))
        
    if (data) then
        local ip_lookup = json:decode(data)
        
        if (ip_lookup.vpn) or (ip_lookup.tor) then
            say(p, vpn_blocker.feedback)
            
            if (vpn_blocker.action == "kick") then
                execute_command("k " .. p)
                cprint(player.name .. " was kicked for using a VPN or Proxy", 4+8)
                
            elseif (vpn_blocker.action == "ban") then
                execute_command("ipban " .. p)
                cprint(player.name .. " was banned for using a VPN or Proxy", 4+8)
            end
        end
    else
        error('VPN Blocker was unable to retrieve the IP Data.')
    end
end

function vpn_blocker:GetCredentials(p)
    return {
        ip = get_var(p, "$ip"):match('(%d+.%d+.%d+.%d+)'), 
        name = get_var(p, "$name")
    }
end

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
