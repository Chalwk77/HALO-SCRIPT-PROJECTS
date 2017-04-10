local crNotice = {
    DOCUMENT = "HPC AnnounceOnJoin (basic), Phasor V2+.lua",
    VERSION = "1.2",
    DESCRIPTION = "This script will announce (AnnounceMessage) to joining player",
    ENGINE = "Phasor V2+ (modified)",
    INTENDED = "Halo PC (Combat Evolved)",
    URL = "https://github.com/Chalwk77",
    AUTHOR = "Jericho Crosby (Chalwk)",
    LICENSE = [[
        MIT LICENSE

        Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>

        Permission is hereby granted, free of charge, to any person obtaining a
        copy of this software and associated documentation files (the
        "Software"), to deal in the Software without restriction, including
        without limitation the rights to use, copy, modify, merge, publish,
        distribute, sublicense, and/or sell copies of the Software, and to
        permit persons to whom the Software is furnished to do so, subject to
        the following conditions:

        The above copyright notice and this permission notice shall be included
        in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
        OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
        MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
        IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
        CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
        TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
        SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
      ]]
}

Timer = 700
AnnounceMessage = "Welcome to <input here>"

function GetRequiredVersion()
    return
    200
end

function OnScriptLoad(processid, game, persistent)

end

function OnScriptUnload()

end

function OnPlayerJoin(player)

    privatesay(player, AnnounceMessage, false)

end

function OnGameEnd(stage)

    removetimer(Timer)

end

--[[ ======================================================= ]]--
-------------------------DO NOT REMOVE-------------------------
function printCRnotice()
    for k, v in pairs(crNotice) do
        print(k, v)
    end
end
-------------------------DO NOT REMOVE-------------------------
--[[ ======================================================= ]]--