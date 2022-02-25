--[[
--=====================================================================================================--
Script Name: IP Lookup Tool, for SAPP (PC & CE)

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]] --

local VPNBlocker = {
    ip = "35.136.253.186",
    api_key = function()
        local api_key = ""
        local file = io.open("api_key.data")
        if (file) then
            api_key = file:read()
            file:close()
        end
        return api_key
    end,
    checks = {
        is_crawler = true,
        vpn = true,
        tor = true,
        proxy = true,
        fraud_score = 85,
        bot_status = true,
    },
    parameters = {
        strictness = 1,
        allow_public_access_points = true,
        lighter_penalties = false,
        fast = false,
        mobile = false
    },

    script_version = 1.5,
    site = "https://www.ipqualityscore.com/api/json/ip/api_key/"
}

api_version = "1.12.0.0"

local json = (loadfile "json.lua")()
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
local async_table = {}

function OnScriptLoad()
    VPNBlocker.key = VPNBlocker.site:gsub("api_key", VPNBlocker.api_key)
    register_callback(cb["EVENT_GAME_START"], "OnStart")
end

local function GenerateLink(IP)
    local i = 0
    local link = tostring(VPNBlocker.key .. IP .. "?")
    for k, v in pairs(VPNBlocker.parameters) do
        link = (i < 1 and link .. k .. "=" .. tostring(v) or link .. "&" .. k .. "=" .. tostring(v))
    end
    return link
end

function OnStart()
    local link = GenerateLink(VPNBlocker.ip)
    async_table["VPN"] = http_client.http_get(link, true)
    timer(1, "CheckResult", "VPN")
end

function CheckResult(ID)
    local t = async_table[ID]
    local response = http_client.http_response_received(t)
    if (response) then
        if (not http_client.http_response_is_null(t)) then
            local results = ffi.string(http_client.http_read_response(t))
            local data = json:decode(results)
            if (data) then
                print(" ")
                for k, v in pairs(data) do
                    print(k, v)
                end
                print(" ")
            end
        end
        http_client.http_destroy_response(t)
        async_table[ID] = nil
        return false
    end
    return true
end

function OnScriptUnload()
    -- N/A
end