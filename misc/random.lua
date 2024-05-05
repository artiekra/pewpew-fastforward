local module = {}

function module.generate(seed, min, max)
    seed = (seed * 1664525 + 1013904223) % 4294967296

    -- scale the random number to fit within the range [min, max]
    local number = (seed % (max - min + 1)) + min

    return number
end 

return module
