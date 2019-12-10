function parseInput(file)
    map.(parse, split.(readlines(file)))
end

function doStuff(file)
    return count(isValid, parseInput(file))
end

function isValid(triag)
    return (triag[1]+triag[2] > triag[3]
        && triag[1]+triag[3] > triag[2]
        && triag[2]+triag[3] > triag[1])
end
