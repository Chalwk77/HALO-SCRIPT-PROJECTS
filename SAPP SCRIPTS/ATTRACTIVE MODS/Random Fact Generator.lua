--[[
--=====================================================================================================--
Script Name: Random Facts Generator, for SAPP (PC & CE)
Description: This script will announce a random fact from the end_point (see config)
             every "interval" seconds.

             NOTE: This script is not the most efficient and may cause temporary lag
                   when it queries the endpoint for a random fact.

I M P O R T A N T
-----------------
1): This mod requires that the following plugins are installed to your server:
    https://opencarnage.net/index.php?/topic/5998-sapp-http-client/
    http://regex.info/blog/lua/json
2): Place "json.lua" and the contents of "sapp-http-client" in your servers root directory.

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
-- config starts --

-- How often (in seconds) should we announce a random message?
local interval = 180
local end_point = "https://api.chucknorris.io/jokes/random"

-- A message relay function will temporarily remove the serve prefix
-- and restore it to this when done.
local server_prefix = "**SAPP**"
-- config ends --

-- do not touch --
local delta_time
local game_stated
local time_scale = 1 / 30
local json = assert(loadfile("json.lua"))()

function OnScriptLoad()

    -- Register needed SAPP event callbacks:
    register_callback(cb["EVENT_TICK"], "GameUpdate")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    OnGameStart()
end

-- This function is called every 1/30th second:
function GameUpdate()

    if (game_stated) then
        delta_time = delta_time + time_scale
        if (delta_time >= interval) then
            delta_time = 0
            local data = Query(end_point)
            local jokes = (data and json:decode(data))
            return data and (jokes.value ~= nil and SayAll(jokes.value))
        end
    end
end

function OnGameStart()
    game_stated = false
    if (get_var(0, "$gt") ~= "n/a") then
        delta_time = 0
        game_stated = true
    end
end

function OnGameEnd()
    game_stated = false
end

function SayAll(STR)
    execute_command('msg_prefix \"\"')
    say_all(STR)
    cprint(STR)
    execute_command('msg_prefix ' .. server_prefix)
end

function OnScriptUnload()
    -- N/A
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
local client = ffi.load("lua_http_client")

function Query(URL)
    local response = client.http_get(URL, false)
    local returning
    if (not client.http_response_is_null(response)) then
        local res = client.http_read_response(response)
        returning = ffi.string(res)
    end
    client.http_destroy_response(response)
    return returning
end