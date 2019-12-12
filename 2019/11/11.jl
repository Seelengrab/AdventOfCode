function runRobot(code)
    coords = Dict{Tuple{Int,Int}, Int}()
    inC = Channel{Int}(Inf)
    outC = Channel{Int}(Inf)
    diag = Channel{Int}(10)
    m = Intmachine(0, deepcopy(code), inComm=inC, outComm=outC, diagComm=diag)
    t = @async run!(m)

    pos = (0,0)
    dir = (1,0)
    coords[(0,0)] = 1 # part 2
    while !istaskdone(t)
        col = get(coords, pos, 0)
        while true
            op = take!(diag)
            op == 0 && break
            put!(inC, col)
        end
        nCol = take!(outC)
        coords[pos] = nCol

        take!(diag)
        nDir = take!(outC)

        if nDir == 0
            if dir == (1,0)
                dir = (0,-1)
            elseif dir == (0,-1)
                dir = (-1,0)
            elseif dir == (-1,0)
                dir = (0,1)
            elseif dir == (0,1)
                dir = (1,0)
            end
        elseif nDir == 1
            if dir == (1,0)
                dir = (0,1)
            elseif dir == (0,-1)
                dir = (1,0)
            elseif dir == (-1,0)
                dir = (0,-1)
            elseif dir == (0,1)
                dir = (-1,0)
            end
        end

        pos = pos .+ dir
    end

    coords
end

function drawId(coords)
    mnX = minimum(map(x -> x[1], collect(keys(coords))))
    mnY = minimum(map(x -> x[2], collect(keys(coords))))

    mxX = maximum(map(x -> x[1], collect(keys(coords))))
    mxY = maximum(map(x -> x[2], collect(keys(coords))))

    id = zeros(Int, mxX - mnX + 5, mxY - mnY + 5)
    for ((x,y),c) in coords
        id[x-mnX+1,y-mnY+1] = c
    end

    for i in axes(id, 1)
        for j in axes(id,2)
            if (id[i,j] == 0)
                print(' ')
            else
                print(id[i,j])
            end
        end
        println()
    end
end