if length(ARGS) != 1
    println("Need exactly one argument!")
    exit(1)
end

global fabric = zeros(Int, 1000, 1000)
global overlaps = zeros(Int, 1000, 1000)

mutable struct piece
    id
    x
    y
    xsize
    ysize
    overlaps
end

function parseInput(input)
    data = readlines(input)
    return parseLine.(data)
end

function parseLine(line)
    rep = replace(line, r"@ |#" => "")
    rep = parse.(Int, split(replace(rep, r",|x|: " => " ")))
    # println(rep)
    return piece(rep[1], rep[2], rep[3], rep[4], rep[5], false)
end

pieces = parseInput(ARGS[1])
totalcounter = 0
counter = 0
for p in pieces
    global fabric
    global totalcounter
    if any(fabric[(p.y+1):(p.y+p.ysize), (p.x+1):(p.x+p.xsize)] .!= 0)
        totalcounter += 1
    end
    for y in (p.y+1):(p.y+p.ysize)
        for x in (p.x+1):(p.x+p.xsize)
            if fabric[y,x] != 0
                p.overlaps = true
                pieces[fabric[y,x]].overlaps = true
                overlaps[y,x] = -1
            end
            fabric[y,x] = p.id
        end
    end
end

println(count(x -> x == -1, fabric))

for p in pieces
    if !p.overlaps
        println(p.id)
        exit(1)
    end
end

