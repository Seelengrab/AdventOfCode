const empty = 0
const wall = 1
const block = 2
const hpaddle = 3
const ball = 4

function updateMap!(out, tiles, score)
    x = take!(out) + 1
    y = take!(out) + 1
    id = take!(out)
    if x == 0 && y == 1
        score[] = id
    else
        if id == wall
            @show x,y,id
        end
        tiles[x,y] = id
    end
end

function drawMap(tiles, score)
    buf = IOBuffer()
    print(buf, b"^L")
    println(buf, score[])
    for y in axes(tiles, 2)
        for x in axes(tiles, 1)
            if tiles[x,y] == 0
                print(buf, '.')
            else
                print(buf, tiles[x,y])
            end
        end
        println(buf, "")
    end
    println(stdout, String(take!(buf)))
end

function runGame(inp)
    inComm = InfChannel{Int}(0)
    outComm = Channel{Int}(Inf)
    diagComm = Channel{Int}(Inf)
    m = Intmachine(0, deepcopy(inp), false, inComm=inComm, outComm=outComm, diagComm=diagComm)
    t = @async run!(m)

    tiles = zeros(Int, 42,20)
    score = Ref(0)
    x = -1
    y = -1

    # initial drawing
    for _ in 1:(42*20)
        updateMap!(outComm, tiles, score)
    end
    drawMap(tiles, score)

    while !istaskdone(t) || isready(outComm)
        updateMap!(outComm, tiles, score)
        drawMap(tiles, score)
    end

    println(score[])
    return tiles, score[]
end