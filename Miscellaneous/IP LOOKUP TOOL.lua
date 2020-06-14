-- Script Name: IP LOOK UP, for SAPP (PC & CE)

api_version = "1.12.0.0"
local vpn_blocker = {
    ip = "127.0.0.1",
    api_key = "nZLmnd32Z4aRybTpaIKWA7JuBnuU6d6v",
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
        mobile = false,
    }
}

local gsub = string.gsub
local json = (loadfile "json.lua")()

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
end

function OnGameStart()
    local site = "https://www.ipqualityscore.com/api/json/ip/api_key/"
    local key = gsub(site, "api_key", vpn_blocker.api_key)
    local query_link = tostring(key .. vpn_blocker.ip .. "?")
    local i = 0
    for k, v in pairs(vpn_blocker.parameters) do
        if (i == 0) then
            query_link = query_link .. k .. "=" .. tostring(v)
        else
            query_link = query_link .. "&" .. k .. "=" .. tostring(v)
        end
        i = i + 1
    end
    local JsonData = vpn_blocker:Query(query_link)
    if (JsonData) then
        local ip_lookup = json:decode(JsonData)
        if (ip_lookup.success) then
            print(" ")
            for k,v in pairs(ip_lookup) do
                print(k,v)
            end
        end
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
