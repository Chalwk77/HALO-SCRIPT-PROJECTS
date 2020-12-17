--[[
--=====================================================================================================--
Script Name: Teleport Manager (rewrite), for SAPP (PC & CE)
Description: Create custom teleports and warp to them on demand.

Command Syntax:
/setwarp [warp name] [opt -o]
> Create a new warp.
> If you specify the '-o' parameter, you can overwrite the existing warp.

/back
> Teleport to your previous location

/warp [warp name]
> Teleport to the defined warp

/delwarp [warp name]
> Delete the specified warp

/warplist [opt page #]
> View a list of all warps linked to the current map.

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration Starts ----------------------------------------------------
local TeleportManager = {
    dir = "teleports.json",
    --
    -- When viewing the warp list, results are split up into pages:
    -- Max results to load per page:
    max_results = 50,

    -- Aliases are printed in columns of 5:
    max_columns = 5,

    -- Spacing between names per column:
    spaces = 2,
    --
    --
    commands = {
        ["warp"] = {
            permission = 1,
            cmd_index = 1,
        },
        ["back"] = {
            permission = 1,
            cmd_index = 2,
        },
        ["setwarp"] = {
            permission = 1,
            cmd_index = 3,
        },
        ["delwarp"] = {
            permission = 1,
            cmd_index = 4,
        },
        ["warplist"] = {
            permission = 1,
            cmd_index = 5,
        }
    },
}
-- Configuration Ends -

local json = (loadfile "json.lua")()
local len, floor, concat = string.len, math.floor, table.concat
local gmatch, lower, format = string.gmatch, string.lower, string.format

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    TeleportManager:CheckFile(true)
end

function OnScriptUnload()

end

function OnGameStart()
    TeleportManager:CheckFile(true)
end

function InitPlayer(Ply, Reset)
    if (Reset) then
        TeleportManager.players[Ply] = nil
    else
        TeleportManager.players[Ply] = { }
    end
end

function OnPlayerConnect(Ply)
    InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    InitPlayer(Ply, false)
end

local function CMDSplit(CMD)
    local Args, index = { }, 1
    for Params in gmatch(CMD, "([^%s]+)") do
        Args[index] = lower(Params)
        index = index + 1
    end
    return Args
end

function TeleportManager:OnServerCommand(Executor, Command)
    local Args = CMDSplit(Command)
    for cmd, v in pairs(self.commands) do
        if (Args[1] == cmd) then
            local lvl = tonumber(get_var(Executor, "$lvl"))
            if (lvl >= v.permission or Executor == 0) then
                if (v.cmd_index == 1) then
                    self:Warp(Executor, Args)
                elseif (v.cmd_index == 2) then
                    self:Back(Executor)
                elseif (v.cmd_index == 3) then
                    self:SetWarp(Executor, Args)
                elseif (v.cmd_index == 4) then
                    self:DeleteWarp(Executor, Args)
                elseif (v.cmd_index == 5) then
                    self:WarpList(Executor, Args)
                end
            else
                self:Respond(Executor, "Insufficient Permission")
            end
            return false
        end
    end
end

function TeleportManager:Warp(Ply, Args)
    if player_alive(Ply) then
        if (Args[2] ~= nil) then
            local records, map = self:CheckFile(), get_var(0, "$map")
            local w = records[map][Args[2]]
            if (w ~= nil) then
                self:Respond(Ply, "Teleporting to [" .. Args[2] .. "] at X: " .. w.x .. ", Y: " .. w.y .. ", Z: " .. w.z)
                self:Teleport(Ply, w.x, w.y, w.z)
            else
                self:Respond(Ply, "Warp name not found!")
            end
        else
            self:Respond(Ply, "Please enter a warp name")
        end
    else
        self:Respond(Ply, "Please wait until you respawn.")
    end
end

function TeleportManager:Back(Ply)
    if player_alive(Ply) then
        local t = self.players[Ply]
        if (t) then
            local back = self:Teleport(Ply, t[1], t[2], t[3])
            if (back) then
                self:Respond(Ply, "Returning to previous location")
            else
                self:Respond(Ply, "Previous location not saved.")
            end
        else
            self:Respond(Ply, "Unable to return to previous location.")
        end
    else
        self:Respond(Ply, "Please wait until you respawn.")
    end
end

function TeleportManager:SetWarp(Ply, Args)
    if player_alive(Ply) then
        if (Args[2] ~= nil) then

            local records, map = self:CheckFile(), get_var(0, "$map")
            local overwrite = Args[3] ~= nil and Args[3]:match("--o") or nil
            if (records[map][Args[2]] == nil or overwrite) then

                local file = assert(io.open(self.dir, "w"))
                if (file) then

                    local pos = self:GetXYZ(Ply)
                    local x = format("%0.3f", pos.x)
                    local y = format("%0.3f", pos.y)
                    local z = format("%0.3f", pos.z)

                    if (records[map][Args[2]] == nil) then
                        self:Respond(Ply, 'Location Saved: X: ' .. x .. ", Y: " .. y .. ", Z: " .. z)
                    elseif (overwrite) then
                        self:Respond(Ply, 'Location Updated: X: ' .. x .. ", Y: " .. y .. ", Z: " .. z)
                    end

                    records[map][Args[2]] = {
                        x = x,
                        y = y,
                        z = z,
                    }

                    file:write(json:encode_pretty(records))
                    io.close(file)
                end
            else
                self:Respond(Ply, 'A location with that name already exists. Use parameter "-o" to overwrite')
                self:Respond(Ply, 'Example: /' .. Args[1] .. " " .. Args[2] .. " -o")
            end
        else
            self:Respond(Ply, "Please enter a warp name")
        end
    else
        self:Respond(Ply, "Please wait until you respawn.")
    end
end

function TeleportManager:DeleteWarp(Ply, Args)
    if (Args[2] ~= nil) then
        local map = get_var(0, "$map")
        local records = self:CheckFile()
        if (records[map][Args[2]] ~= nil) then
            records[map][Args[2]] = nil
            local file = assert(io.open(self.dir, "w"))
            if (file) then
                file:write(json:encode_pretty(records))
                io.close(file)
                self:Respond(Ply, 'Successfully deleted warp "' .. Args[2] .. '"')
            end
        else
            self:Respond(Ply, "Warp name not found!")
        end
    else
        self:Respond(Ply, "Please enter a warp name")
    end
end

local function spacing(n)
    local Str, Sep = "", ","
    for i = 1, n do
        if i == math.floor(n / 2) then
            Str = Str .. ""
        end
        Str = Str .. " "
    end
    return Sep .. Str
end

function TeleportManager:FormatTable(t)
    local longest = 0
    for _, v in pairs(t) do
        if (len(v) > longest) then
            longest = len(v)
        end
    end
    local rows, row, count = {}, 1, 1
    for k, v in pairs(t) do
        if (count % self.max_results == 0) or (k == #t) then
            rows[row] = (rows[row] or "") .. v
        else
            rows[row] = (rows[row] or "") .. v .. spacing(longest - len(v) + self.spaces)
        end
        if (count % self.max_results == 0) then
            row = row + 1
        end
        count = count + 1
    end
    return concat(rows)
end

function TeleportManager:GetPage(page)
    local max = self.max_results
    local start = (max) * page
    local startpage = (start - max + 1)
    local endpage = start
    return startpage, endpage
end

function TeleportManager:getPageCount(total_names)
    local pages = total_names / (self.max_results)
    if ((pages) ~= floor(pages)) then
        pages = floor(pages) + 1
    end
    return pages
end

function TeleportManager:WarpList(Ply, Args)

    local tab = { }
    local map = get_var(0, "$map")
    local records = self:CheckFile()

    for k, _ in pairs(records[map]) do
        tab[#tab + 1] = k
    end

    if (#tab > 0) then

        local page = Args[2] ~= nil and Args[2]:match("^%d+$") or 1
        local total_pages = self:getPageCount(#tab)

        if (page > 0 and page <= total_pages) then

            local startIndex, endIndex = 1, self.max_columns
            local startpage, endpage = self:GetPage(page)

            local results = { }
            for page_num = startpage, endpage do
                if tab[page_num] then
                    results[#results + 1] = tab[page_num]
                end
            end

            local function formatResults()
                local tmp, row = { }

                for i = startIndex, endIndex do
                    tmp[i] = results[i]
                    row = self:FormatTable(tmp)
                end

                if (row ~= nil and row ~= "" and row ~= " ") then
                    self:Respond(Ply, row, 10)
                end

                startIndex = (endIndex + 1)
                endIndex = (endIndex + (self.max_columns))
            end

            while (endIndex < #tab + self.max_columns) do
                formatResults()
            end

            self:Respond(Ply, '[Page ' .. page .. '/' .. total_pages .. ']', 2 + 8)
        else
            self:Respond(Ply, 'Invalid Page ID. Please type a page between 1-' .. total_pages)
        end
    else
        self:Respond(Ply, 'No warps on record for [' .. map .. ']')
    end
end

function TeleportManager:Teleport(Ply, x, y, z)
    if (x) then
        local pos = self:GetXYZ(Ply)
        self.players[Ply] = { pos.x, pos.y, pos.z }
        write_vector3d((pos.obj ~= 0 and pos.obj or pos.dyn) + 0x5C, x, y, (pos.obj ~= 0 and z + 0.5 or z))
        return true
    end
    return false
end

function TeleportManager:GetXYZ(Ply)
    local pos, x, y, z = { }
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        local VehicleID = read_dword(DyN + 0x11C)
        local VehicleObj = get_object_memory(VehicleID)
        if (VehicleID == 0xFFFFFFFF) then
            x, y, z = read_vector3d(DyN + 0x5c)
        elseif (VehicleObj ~= 0) then
            x, y, z = read_vector3d(VehicleObj + 0x5c)
        end
        pos.x, pos.y, pos.z, pos.dyn, pos.obj = x, y, z, DyN, VehicleObj
    end
    return pos
end

function TeleportManager:CheckFile(init)

    if (init) then
        self.players = { }
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, false)
            end
        end
    end

    if (get_var(0, "$gt") ~= "n/a") then

        local content = ""
        local file = io.open(self.dir, "r")
        if (file) then
            content = file:read("*all")
            io.close(file)
        end

        local map = get_var(0, "$map")
        local records = json:decode(content) or { }
        if (not records or records[map] == nil) then
            file = assert(io.open(self.dir, "w"))
            if (file) then
                records[map] = { }
                file:write(json:encode_pretty(records))
                io.close(file)
            end
        end
        return records
    end
end

function TeleportManager:Respond(Ply, Message, Color)
    Color = Color or 10
    if (Ply == 0) then
        cprint(Message, Color)
    else
        rprint(Ply, Message)
    end
end

function OnServerCommand(P, C)
    return TeleportManager:OnServerCommand(P, C)
end