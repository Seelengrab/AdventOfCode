mutable struct Class
    origin
    # points::Array{Array{Int,1},1}
    points
    edge
end

Base.show(io::IO, c::Class) = write(io, "$(c.origin) - $(c.edge) - $(c.points)" )

function manhattan(a, b)
    return abs(a[1] - b[1]) + abs(a[2] - b[2])
end

function manhattan(a, b::Class)
    return abs(a[1] - b.origin[1]) + abs(a[2] - b.origin[2])
end

function manhattan(a::Class, b)
    return abs(a.origin[1] - b[1]) + abs(a.origin[2] - b[2])
end

function manhattan(a::Class, b::Class)
    return abs(a.origin[1] - b.origin[1]) + abs(a.origin[2] - b.origin[2])
end

function parseInput(file)
    x = split.(readlines(file), ", ")
    data = map(y -> parse.(Int, y), x)
    return [ Class(d, 0, false) for d in data ]
end

function maximum(a::Array{T}, n) where {T <: Class}
    m = typemin(Int)
    for d in a
        if d.origin[n] > m
            m = d.origin[n]
        end
    end
    return m
end

function partOne(file)
    classes = parseInput(file)
    bigX = maximum(classes, 1)
    bigY = maximum(classes, 2)

    for x in 0:bigX+1
        for y in 0:bigY+1
            p = [x, y]
            distances = manhattan.(classes, Ref(p))
            closest = findall(x -> x == minimum(distances), distances)
            if (length(closest) == 1)
                classes[closest[1]].points += 1
                if !classes[closest[1]].edge && (x == 0 || y == 0 || x == bigX+1 || y == bigY+1)
                    classes[closest[1]].edge = true
                end
            end
        end
    end

    return findmax(map(x -> x.points, filter(c -> !c.edge, classes)))
end

function partTwo(file, maxDist)
    classes = parseInput(file)
    bigX = maximum(classes, 1)
    bigY = maximum(classes, 2)
    numTiles = 0

    for x in 0:bigX+1
        for y in 0:bigY+1
            p = [x, y]
            distances = manhattan.(classes, Ref(p))
            if sum(distances) < maxDist
                numTiles += 1
            end
        end
    end

    return numTiles
end

ret = partOne(ARGS[1])
println(ret)
ret = partTwo(ARGS[1], parse(Int,ARGS[2]))
println(ret)