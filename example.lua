-- A number between 1 and 4
PickRandom = math.random(1,4)

function GrenadeTable()
    frags = {
        beavercreek = math.random(1,4),
    }
    plasmas = { 
        beavercreek = PickRandom,
        -- PickRandom is equal math.random(1,4), as defined at line #2
    }
end
