if length(ARGS) != 1
    println("Need exactly one argument!")
    exit(1)
end

function parseInput(inp)
    return readlines(open(inp))
end

function countOf(item, num)
    for c in item
        if count(x -> c == x, item) == num
            return 1
        end
    end
    return 0
end

data = parseInput(ARGS[1])
# part 1
println(sum(countOf.(data, 2)) * sum(countOf.(data, 3)))

function dist(a, b)
    if length(a) != length(b)
        return abs(length(a) - lenth(b))
    end
    count = 0
    for c in eachindex(a)
        if a[c] != b[c]
            count += 1
        end
    end
    return count
end

# part 2
for s in data
    for x in data
        if dist(s, x) == 1
            println(s)
            println(x)
            exit(0)
        end
    end
end
