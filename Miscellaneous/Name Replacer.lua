api_version = "1.12.0.0"

local blacklist = {
    { "Hacker", "bobby" },
    { "TᑌᗰᗷᗩᑕᑌᒪOᔕ", "salmon" },
    { "TUMBACULOS", "tuna" },
    { "{BK} DIEGO", "sandwich" },
}

local network_struct

function OnScriptLoad()
    register_callback(cb["EVENT_PREJOIN"], "OnPreJoin")
    network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
end

function OnPreJoin(Ply)
    local name_on_join = get_var(Ply, "$name")
    for i = 1, #blacklist do

        local blacklisted_name = blacklist[i][1]
        local replacement_name = blacklist[i][2]

        if (name_on_join == blacklisted_name) then

            local count = 0
            local address = network_struct + 0x1AA + 0x40 + to_real_index(Ply) * 0x20

            for _ = 1, 12 do
                write_byte(address + count, 0)
                count = count + 2
            end

            count = 0

            local str = replacement_name:sub(1, 11)
            local length = str:len()

            for j = 1, length do
                local new_byte = string.byte(str:sub(j, j))
                write_byte(address + count, new_byte)
                count = count + 2
            end

            break
        end
    end
end