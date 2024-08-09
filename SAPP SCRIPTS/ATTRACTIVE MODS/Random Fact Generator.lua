--[[
--=====================================================================================================--
Script Name: Random Facts Generator, for SAPP (PC & CE)
Description: This script will periodically say a random fact from the Chuck Norris Joke API.

1): This mod requires that the following plugins are installed to your server:
    https://opencarnage.net/index.php?/topic/5998-sapp-http-client/
    http://regex.info/blog/lua/json

2): Place "json.lua" and the contents of "sapp-http-client" in your servers root directory.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
-- config starts --

-- How often (in seconds) should we announce a random message:
-- Do not set lower than 3 seconds.
local interval = 120

-- URL to Chuck Norris Joke API:
local end_point = "https://api.chucknorris.io/jokes/random"

-- If true, Chuck Norris's name will be replaced
-- with the name of a random player on the server:
local replace_name = true
--

-- A message relay function will temporarily remove the server prefix
-- and restore it to this when done:
local server_prefix = "**SAPP**"
-- config ends --

local async_data
local game_stated
local players = { }
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
local client = ffi.load("lua_http_client")

function OnScriptLoad()

    register_callback(cb["EVENT_JOIN"], "Join")
    register_callback(cb["EVENT_LEAVE"], "Quit")
    register_callback(cb["EVENT_GAME_END"], "OnEnd")
    register_callback(cb["EVENT_GAME_START"], "OnStart")

    OnStart()
end

function ShowJoke()
    local response = client.http_response_received(async_data)
    if (response) then
        if (not client.http_response_is_null(async_data)) then
            local results = ffi.string(client.http_read_response(async_data))
            local jokes = json:decode(results)
            local joke = jokes.value
            if (replace_name and #players > 0) then
                local name = players[rand(1, #players + 1)]
                jokes.value = joke:gsub("Chuck Norris", name)
            end
            execute_command('msg_prefix \"\"')
            say_all(joke)
            execute_command('msg_prefix ' .. server_prefix)
            cprint(joke)
        end
        client.http_destroy_response(async_data)
        async_data = nil
        return false
    end
    return true
end

function LoopJokes()
    async_data = client.http_get(end_point, true)
    timer(1, "ShowJoke")
    return game_stated
end

function OnStart()
    game_stated = false
    if (get_var(0, "$gt") ~= "n/a") then
        game_stated = true
        interval = (interval < 3 and 3) or interval
        timer(1000 * interval, "LoopJokes")
    end
end

function OnEnd()
    game_stated = false
end

function Join(Ply)
    players[Ply] = get_var(Ply, "$name")
end

function Quit(Ply)
    players[Ply] = nil
end

function OnScriptUnload()
    -- N/A
end