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
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration Starts ----------------------------------------------------
local TPM = {

    -- Name of the JSON database containing custom teleport locations:
    -- This file will be located in the same directory as mapcycle.txt
    file = "teleports.json",

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

local floor = math.floor
local format = string.format
local json = (loadfile "json.lua")()

function OnScriptLoad()

    local cg_dir = read_string(read_dword(sig_scan("68??????008D54245468") + 0x1))
    TPM.dir = cg_dir .. "\\sapp\\" .. TPM.file

    register_callback(cb["EVENT_LEAVE"], "OnQuit")
    register_callback(cb["EVENT_JOIN"], "OnConnect")
    register_callback(cb["EVENT_COMMAND"], "OnCommand")
    register_callback(cb["EVENT_GAME_START"], "OnStart")
    TPM:CheckFile(true)
end

function OnScriptUnload()
    -- N/A
end

function OnStart()
    TPM:CheckFile(true)
end

function OnConnect(Ply)
    TPM:InitPlayer(Ply, false)
end

function OnQuit(Ply)
    TPM:InitPlayer(Ply, false)
end

local function CMDSplit(CMD)
    local Args = { }
    for word in CMD:gsub('"', ""):gmatch("([^%s]+)") do
        Args[#Args + 1] = word:lower()
    end
    return Args
end

local function Respond(Ply, Msg, Color)
    Color = Color or 10
    return (Ply == 0 and cprint(Msg, Color) or rprint(Ply, Msg))
end

function TPM:OnCommand(Ply, Command)
    local Args = CMDSplit(Command)
    for cmd, v in pairs(self.commands) do
        if (Args[1] == cmd) then
            local lvl = tonumber(get_var(Ply, "$lvl"))
            if (lvl >= v.permission or Ply == 0) then
                if (v.cmd_index == 1) then
                    self:Warp(Ply, Args)
                elseif (v.cmd_index == 2) then
                    self:Back(Ply)
                elseif (v.cmd_index == 3) then
                    self:SetWarp(Ply, Args)
                elseif (v.cmd_index == 4) then
                    self:DeleteWarp(Ply, Args)
                elseif (v.cmd_index == 5) then
                    self:WarpList(Ply, Args)
                end
            else
                Respond(Ply, "Insufficient Permission")
            end
            return false
        end
    end
end

function TPM:Warp(Ply, Args)
    if player_alive(Ply) then
        if (Args[2] ~= nil) then
            local records, map = self:CheckFile(), get_var(0, "$map")
            local w = records[map][Args[2]]
            if (w ~= nil) then
                Respond(Ply, "Teleporting to [" .. Args[2] .. "] at X: " .. w.x .. ", Y: " .. w.y .. ", Z: " .. w.z)
                self:Teleport(Ply, w.x, w.y, w.z)
            else
                Respond(Ply, "Warp name not found!")
            end
        else
            Respond(Ply, "Please enter a warp name")
        end
    else
        Respond(Ply, "Please wait until you respawn.")
    end
end

function TPM:Back(Ply)
    if player_alive(Ply) then
        local t = self.players[Ply]
        if (t) then
            local back = self:Teleport(Ply, t[1], t[2], t[3])
            if (back) then
                Respond(Ply, "Returning to previous location")
            else
                Respond(Ply, "Previous location not saved.")
            end
        else
            Respond(Ply, "Unable to return to previous location.")
        end
    else
        Respond(Ply, "Please wait until you respawn.")
    end
end

local function GetXYZ(Ply)
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

function TPM:SetWarp(Ply, Args)
    if player_alive(Ply) then
        if (Args[2] ~= nil) then

            local records, map = self:CheckFile(), get_var(0, "$map")
            local overwrite = Args[3] ~= nil and Args[3]:match("--o") or nil
            if (records[map][Args[2]] == nil or overwrite) then

                local file = assert(io.open(self.dir, "w"))
                if (file) then

                    local pos = GetXYZ(Ply)
                    local x = format("%0.3f", pos.x)
                    local y = format("%0.3f", pos.y)
                    local z = format("%0.3f", pos.z)

                    if (records[map][Args[2]] == nil) then
                        Respond(Ply, 'Location Saved: X: ' .. x .. ", Y: " .. y .. ", Z: " .. z)
                    elseif (overwrite) then
                        Respond(Ply, 'Location Updated: X: ' .. x .. ", Y: " .. y .. ", Z: " .. z)
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
                Respond(Ply, 'A location with that name already exists. Use parameter "-o" to overwrite')
                Respond(Ply, 'Example: /' .. Args[1] .. " " .. Args[2] .. " -o")
            end
        else
            Respond(Ply, "Please enter a warp name")
        end
    else
        Respond(Ply, "Please wait until you respawn.")
    end
end

function TPM:DeleteWarp(Ply, Args)
    if (Args[2] ~= nil) then
        local map = get_var(0, "$map")
        local records = self:CheckFile()
        if (records[map][Args[2]] ~= nil) then
            records[map][Args[2]] = nil
            local file = assert(io.open(self.dir, "w"))
            if (file) then
                file:write(json:encode_pretty(records))
                io.close(file)
                Respond(Ply, 'Successfully deleted warp "' .. Args[2] .. '"')
            end
        else
            Respond(Ply, "Warp name not found!")
        end
    else
        Respond(Ply, "Please enter a warp name")
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

local concat = table.concat
function TPM:FormatTable(t)
    local longest = 0
    for _, v in pairs(t) do
        if (v:len() > longest) then
            longest = v:len()
        end
    end
    local rows, row, count = {}, 1, 1
    for k, v in pairs(t) do
        if (count % self.max_results == 0) or (k == #t) then
            rows[row] = (rows[row] or "") .. v
        else
            rows[row] = (rows[row] or "") .. v .. spacing(longest - v:len() + self.spaces)
        end
        if (count % self.max_results == 0) then
            row = row + 1
        end
        count = count + 1
    end
    return concat(rows)
end

function TPM:GetPage(page)
    local max = self.max_results
    local start = (max) * page
    local startpage = (start - max + 1)
    local endpage = start
    return startpage, endpage
end

function TPM:getPageCount(total_names)
    local pages = total_names / (self.max_results)
    if ((pages) ~= floor(pages)) then
        pages = floor(pages) + 1
    end
    return pages
end

function TPM:WarpList(Ply, Args)

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
                    Respond(Ply, row, 10)
                end

                startIndex = (endIndex + 1)
                endIndex = (endIndex + (self.max_columns))
            end

            while (endIndex < #tab + self.max_columns) do
                formatResults()
            end

            Respond(Ply, '[Page ' .. page .. '/' .. total_pages .. ']', 2 + 8)
        else
            Respond(Ply, 'Invalid Page ID. Please type a page between 1-' .. total_pages)
        end
    else
        Respond(Ply, 'No warps on record for [' .. map .. ']')
    end
end

function TPM:Teleport(Ply, x, y, z)
    if (x) then
        local pos = GetXYZ(Ply)
        self.players[Ply] = { pos.x, pos.y, pos.z }
        write_vector3d((pos.obj ~= 0 and pos.obj or pos.dyn) + 0x5C, x, y, (pos.obj ~= 0 and z + 0.5 or z))
        return true
    end
    return false
end

function TPM:InitPlayer(Ply, Reset)
    if (not Reset) then
        self.players[Ply] = { }
    else
        self.players[Ply] = nil
    end
end

function TPM:CheckFile(init)

    if (init) then

        self.players = { }

        for i = 1, 16 do
            if player_present(i) then
                self:InitPlayer(i, false)
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

function OnCommand(P, C)
    return TPM:OnCommand(P, C)
end