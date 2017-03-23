function string.findchar(str, char)
    local chars = string.split(str, "")
    local indexes = { }
    for k, v in ipairs(chars) do
        if v == char then
            table.insert(indexes, k)
        end
    end
    return table.unpack(indexes)
end

function string.split(str, ...)
    local subs = { }
    local sub = ""
    local i = 1
    for _, v in ipairs(arg) do
        if v == "" then
            for x = 1, string.len(str) do
                table.insert(subs, string.sub(str, x, x))
            end

            return subs
        end
    end
    for _, v in ipairs(arg) do
        if string.sub(str, 1, 1) == v then
            table.insert(subs, "")
            break
        end
    end
    while i <= string.len(str) do
        local bool, bool2
        for x = 1, #arg do
            if arg[x] ~= "" then
                local length = string.len(arg[x])
                if string.sub(str, i, i +(length - 1)) == arg[x] then
                    if i == string.len(str) then
                        bool2 = true
                    else
                        bool = true
                    end
                    i = i +(length - 1)
                    break
                end
            else
                for q = 1, string.len(str) do
                    subs = { }
                    table.insert(subs, string.sub(str, q, q))
                    i = string.len(str)
                    break
                end
            end
        end
        if not bool then
            sub = sub .. string.sub(str, i, i)
        end
        if bool or i == string.len(str) then
            if sub ~= "" then
                table.insert(subs, sub)
                sub = ""
            end
        end
        if bool2 then
            table.insert(subs, "")
        end
        i = i + 1
    end
    for k, v in ipairs(subs) do
        for _, d in ipairs(arg) do
            subs[k] = string.gsub(v, d, "")
        end
    end
    return subs
end

function string.wild(match, wild, case_sensative)
    if not case_sensative then
        match, wild = string.lower(match), string.lower(wild)
    end
    if string.sub(wild, 1, 1) == "?" then wild = string.gsub(wild, "?", string.sub(match, 1, 1), 1) end
    if string.sub(wild, string.len(wild), string.len(wild)) == "?" then wild = string.gsub(wild, "?", string.sub(match, string.len(match), string.len(match)), 1) end
    if not string.find(wild, "*") and not string.find(wild, "?") and wild ~= match then return false end
    if string.sub(wild, 1, 1) ~= string.sub(match, 1, 1) and string.sub(wild, 1, 1) ~= "*" then return false end
    if string.sub(wild, string.len(wild), string.len(wild)) ~= string.sub(match, string.len(match), string.len(match)) and string.sub(wild, string.len(wild), string.len(wild)) ~= "*" then return false end
    local substrings = string.split(wild, "*")
    local begin = 1
    for k, v in ipairs(substrings) do
        local sublength = string.len(v)
        local temp_begin = begin
        local temp_end = begin + sublength - 1
        local matchsub = string.sub(match, begin, temp_end)
        local bool
        repeat
            local wild = v
            local indexes = pack(string.findchar(wild, "?"))
            if #indexes > 0 then
                for _, i in ipairs(indexes) do
                    wild = string.gsub(wild, "?", string.sub(matchsub, i, i), 1)
                end
            end
            if matchsub == wild then
                bool = true
                break
            end
            matchsub = string.sub(match, temp_begin, temp_end)
            temp_begin = temp_begin + 1
            temp_end = temp_end + 1
        until temp_end >= string.len(match)
        if not bool then
            return false
        end
        begin = sublength + 1
    end
    return true
end
