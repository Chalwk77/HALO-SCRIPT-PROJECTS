--[[
--=====================================================================================================--
Script Name: VPN Blocker (beta v1.0), for SAPP (PC & CE)


This mod requires that the following plugin is installed to your server:
https://opencarnage.net/index.php?/topic/5998-sapp-http-client/
Credits to Kavawuvi (002) for HTTP client functionality.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

api_version = "1.12.0.0"

local vpn_blocker = { 
    url = 'https://github.com/Chalwk77/VPNs/blob/master/vpn-ipv4.txt',
    ips = {},
    action = "kick",
    feedback = "We\'ve detected that you\'re using a VPN or Proxy - we do not allow these!'"
}

function OnScriptLoad()
    if vpn_blocker:GetData() then
        register_callback(cb["EVENT_PREJOIN"], "OnPreJoin")
    end
end

function OnPreJoin(p)
    local player = vpn_blocker:GetCredentials(p)
    for _,v in pairs(vpn_blocker.ips) do
        if (player.ip == v) then
            say(p, vpn_blocker.feedback)
            if (vpn_blocker.action == "kick") then
                execute_command("k " .. p)
                cprint(player.name .. " was kicked for using a VPN or Proxy", 4+8)
            elseif (vpn_blocker.action == "ban") then
                execute_command("ipban " .. p)
                cprint(player.name .. " was banned for using a VPN or Proxy", 4+8)
            end
        end
    end
end

function vpn_blocker:GetData()
    cprint("Retrieving vpn-ipv4 addresses. Please wait...", 2+8)
    local url = 'https://raw.githubusercontent.com/Chalwk77/VPNs/master/vpn-ipv4.txt'
    local data = vpn_blocker:GetPage(tostring(vpn_blocker.url))
    if (data) then
        local line = vpn_blocker:stringSplit(data, "\n")
        for i = 1, #line do
            local ip = line[i]:match('(%d+.%d+.%d+.%d+)')
            vpn_blocker.ips[#vpn_blocker.ips + 1] = ip
        end
        return true
    else
        error('VPN Blocker was unable to retrieve the IP Data.')
    end
end

function vpn_blocker:GetCredentials(p)
    local ip = get_var(p, "$ip")
    local name = get_var(p, "$name") -- for a future update
    local hash = get_var(p, "$hash") -- for a future update
    return {ip = ip:match('(%d+.%d+.%d+.%d+)'), name = name, hash = hash}
end

function vpn_blocker:stringSplit(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t = {}
    i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
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
http_client = ffi.load("lua_http_client")

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
