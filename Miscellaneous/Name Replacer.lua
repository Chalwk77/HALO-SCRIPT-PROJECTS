api_version = "1.12.0.0"

local blacklist = {
    { "Hacker", "bobby" },
    { "{BK} DIEGO", "sandwich" },
    { "TᑌᗰᗷᗩᑕᑌᒪOᔕ", "salmon" },
    { "TUMBACULOS", "tuna" },
}

local network_struct

function OnScriptLoad()
    register_callback(cb["EVENT_PREJOIN"], "OnPreJoin")
    network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
end

local function WriteWideString(address, str, len)
    local Count = 0
    for _ = 1, len do
        write_byte(address + Count, 0)
        Count = Count + 2
    end
    Count = 0
    local length = str:len()
    for i = 1, length do
        local newbyte = string.byte(str:sub(i, i))
        write_byte(address + Count, newbyte)
        Count = Count + 2
    end
end

function OnPreJoin(Ply)
    local name_on_join = get_var(Ply, "$name")
    for i = 1, #blacklist do
        local blacklisted_name = blacklist[i][1]
        local replacement_name = blacklist[i][2]
        if (name_on_join == blacklisted_name) then
            local ns = network_struct + 0x1AA + 0x40 + to_real_index(Ply) * 0x20
            WriteWideString(ns, replacement_name:sub(1, 11), 12)
            break
        end
    end
end