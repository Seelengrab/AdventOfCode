function parseInput(inp)
    Dict{String,String}(map(x -> x[2] => x[1], split.(readlines(inp), ')')))
end

function numOrbits(map, sat)
    if sat == "COM"
        return 0
    end

    return 1 + numOrbits(map, map[sat])
end

function getPath(map, sat)
    if sat == "COM"
        return ""
    end

    return getPath(map, map[sat]) * sat * ","
end

function numTransfer(map, a, b)
    pa = getPath(map, map[a])
    pb = getPath(map, map[b])
    s = ""
    for i in 1:min(length(pa), length(pb))
        if pa[1:i] == pb[1:i]
            s = pa[1:i]
        end
    end
    na = numOrbits(map, map[a]) - count(==(','), s)
    nb = numOrbits(map, map[b]) - count(==(','), s)
    return na+nb
end