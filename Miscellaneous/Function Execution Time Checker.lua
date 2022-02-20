-- Table that holds the averages:
-- t[1]{} = msg:gsub(...)  method
-- t[2]{} = gsub(msg, ...) method
local times = { {}, {} }

-- How many times to execute the performance test:
local function_iterations = 100

-- How many times to execute the two different gsub methods:
local gsub_iterations = 1000

-- A string to execute gsub on:
local msg = "$var1"

-- Store gsub from string library as a variable (for the 2nd method):
local gsub = string.gsub

-- Performance test function:
local function PerformanceTest(TYPE)
    local time = os.clock
    local t1 = time()
    for _ = 1, gsub_iterations do
        if (TYPE == 1) then
            msg = msg:gsub('$var1', "1")
        else
            msg = gsub(msg, '$var1', "1")
        end
    end
    table.insert(times[TYPE], time() - t1)
end

-- Execute performance test:
for _ = 1, function_iterations do
    PerformanceTest(1)
    PerformanceTest(2)
end

-- Gets the average times of t{}:
function math.average(t)
    local time = 0
    for _, v in pairs(t) do
        time = time + v
    end
    return time / #t
end

-- Store averages:
local t1 = math.average(times[1])
local t2 = math.average(times[2])

-- Get longest/shortest times:
local longest = math.max(t1, t2)
local shortest = math.min(t1, t2)

-- Format @n to @p decimal places:
local function f(n, p)
    return ("%." .. p .. "f"):format(n)
end

-- Calculate fastest %:
local remainder = (longest - shortest)
local p = f(remainder / longest * 100, 3)

local function ms(n)
    return (n >= 1 and " seconds") or " ms"
end

-- Format averages:
local s1 = f(t1, 7) .. ms(t1)
local s2 = f(t2, 7) .. ms(t2)

-- Print results:
if (t1 < t2) then
    print("msg:gsub(...) / " .. p .. "% faster / Average time " .. s1)
    print("gsub(msg, ...) finished in " .. s2)
else
    print("gsub(msg, ...) / " .. p .. "% faster / Average time " .. s2)
    print("msg:gsub(...) finished in " .. s1)
end