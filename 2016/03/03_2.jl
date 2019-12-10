function doStuff(file)
    s = 0
    inp = processInput(file)
    for i in 1:3
        slice = reshape(inp[i:3:end], (3, Int(length(inp)/9)))
        for ind in 1:size(slice)[2]
            if isValid(slice[:,ind])
                s += 1
            end
        end
    end
    return s
end

function isValid(triag)
    return (triag[1]+triag[2] > triag[3]
        && triag[1]+triag[3] > triag[2]
        && triag[2]+triag[3] > triag[1])
end

function processInput(file)
    input = map.(parse, split.(readlines(file)))
    s = length(input)
    input = collect(Iterators.flatten(input))
end
