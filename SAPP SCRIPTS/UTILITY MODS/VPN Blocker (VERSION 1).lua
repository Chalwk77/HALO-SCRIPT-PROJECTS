--[[
--=====================================================================================================--
Script Name: VPN Blocker (VERSION 1), for SAPP (PC & CE)

This mod requires that the following plugin is installed to your server:
https://opencarnage.net/index.php?/topic/5998-sapp-http-client/

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

api_version = "1.12.0.0"

local vpn_blocker = { 
    url = 'https://github.com/Chalwk77/VPNs/blob/master/vpn-ipv4.txt',
    action = "kick", -- Valid Actions: kick,ban
    feedback1 = "We\'ve detected that you\'re using a VPN or Proxy - we do not allow these!'",
    feedback2 = "%name% was %action% for using a VPN or Proxy (IP: %ip%)",
}

function OnScriptLoad()
    if vpn_blocker:GetData() then
        register_callback(cb["EVENT_PREJOIN"], "OnPreJoin")
    end
end

function OnScriptUnload()
    --
end

function OnPreJoin(p)
    local player = vpn_blocker:GetCredentials(p)
    for _,v in pairs(vpn_blocker.ips) do
        if (player.ip == v) then
            
            say(p, vpn_blocker.feedback1)
            
            if (vpn_blocker.action == "k") then
                action = "kicked"
            elseif (vpn_blocker.action == "b") then
                action = "banned"
            end
            
            local msg = gsub(gsub(gsub(vpn_blocker.feedback2, "%%name%%", player.name),"%%action%%", action), "%%ip%%", player.ip)
            cprint(msg, 4+8)
            log_note(msg)
            execute_command(vpn_blocker.action .. " " .. p)
        end
    end
end

function vpn_blocker:GetData()
    cprint("Retrieving vpn-ipv4 addresses. Please wait...", 2+8)
    local data = vpn_blocker:GetPage(tostring(vpn_blocker.url))
    
    vpn_blocker.ips = vpn_blocker.ips or { }
    vpn_blocker.ips = { }
    
    if (data) then
        local line = vpn_blocker:stringSplit(data, "\n")
        for i = 1, #line do
            local ip = line[i]:match('(%d+.%d+.%d+.%d+)')
            vpn_blocker.ips[#vpn_blocker.ips + 1] = ip
        end
        cprint("VPN Blocker -> Successfully stored (" .. #vpn_blocker.ips .. ") vpn-ipv4 IPs.", 2+8)
        return true
    else
        error('VPN Blocker was unable to retrieve the IP Data.')
    end
end

function vpn_blocker:GetCredentials(p)
    local ip = get_var(p, "$ip")
    local name = get_var(p, "$name")
    return {ip = ip:match('(%d+.%d+.%d+.%d+)'), name = name}
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
