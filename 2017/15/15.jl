# genA = 65
# genB = 8921
genA = 883
genB = 879

genAFactor = 16807
genBFactor = 48271
g = 1 << 16 -1

count = 0
for i in 1:5e6
    while true
        genA = (genA*genAFactor) % 2147483647
        genA % 4 == 0 && break
    end
    while true
        genB = (genB*genBFactor) % 2147483647
        genB % 8 == 0 && break
    end
# for i in 1:4e7
    # genA = (genA*genAFactor) % 2147483647
    # genB = (genB*genBFactor) % 2147483647
    if (genA & g) == (genB & g)
        count += 1
    end
end

println(count)

