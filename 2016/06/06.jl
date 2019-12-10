function parseInput(file)
    inp = readlines(file)
    elSize = length(inp[1])
    inp = collect(Iterators.flatten(inp))
    reshape(inp, (elSize, Int(length(inp)/elSize)))
end

function mostCommon(arr)
    uns = unique(arr)
    mcount = 0
    mostCommon = '-'
    for c in uns
        co = count(x -> x == c, arr)
        if co > mcount
            mcount = co
            mostCommon = c
        end
    end
    return mostCommon
end

function leastCommon(arr)
    uns = unique(arr)
    mcount = Inf
    leastCommon = '-'
    for c in uns
        co = count(x -> x == c, arr)
        if co < mcount
            mcount = co
            leastCommon = c
        end
    end
    return leastCommon
end

function recover(file)
    input = parseInput(file)
    numCols = size(input)[1]
    res = Array{Char}(numCols)
    for i in 1:numCols
        # res[i] = mostCommon(input[i,:])
        res[i] = leastCommon(input[i,:])
    end
    String(res)
end
