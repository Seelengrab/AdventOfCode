if length(ARGS) != 1
    println("Need exactly one argument!")
    exit(1)
end

struct Point
    pos
    vel
end

function parseInput(file)
    inp = readlines(file)
    cleaned = map(x -> replace(x, "position=<" => ""), inp)
    cleaned2 = map(x -> replace(x, ">" => ""), cleaned)
    x = split.(cleaned2, " velocity=<")
    g = map(y -> map(z -> parse.(Int,z), split.(y, ", ")), x)
    pos = [ j[1]' for j in g ]
    vel = [ j[2]' for j in g ]
    return reshape(collect(Iterators.flatten(pos)), (length(pos), 2)), reshape(collect(Iterators.flatten(vel)), (length(vel), 2))
end

function doStuff(file)
    points = parseInput(file)

end