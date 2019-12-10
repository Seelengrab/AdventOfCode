if length(ARGS) != 1
    println("Need exactly one argument!")
    exit(1)
end

LDict = Dict([
    [ 1, 0 ] => [ 0, 1 ], # down -> right
    [ 0, 1 ] => [ -1, 0 ], # right -> up
    [ -1, 0 ] => [ 0, -1 ], # up -> left
    [ 0, -1 ] => [ 1, 0 ], # left -> down
    ])
RDict = Dict([
    [ 1, 0 ] => [ 0, -1 ], # down -> left
    [ 0, -1 ] => [ -1, 0 ], # left -> up
    [ -1, 0 ] => [ 0, 1 ], # up -> right
    [ 0, 1 ] => [ 1, 0 ], # right -> down
])

function arrToMat(arr::AbstractArray)
    s = length(arr)
    M = Matrix{Char}(s, s)
    for line in 1:s
        for c in 1:s
            M[line, c] = arr[line][c]
        end
    end
    return M
end

function getInput()
    return arrToMat(readlines(open(ARGS[1])))
end

function infect(spots, bursts)
    pos = [ x for x in Int.(round.(size(spots)./2, RoundUp)) ]
    dir = [ -1; 0 ]
    count = 0
    for i in 1:bursts
        if (any(pos .> size(spots)) || any(p -> p == 0, pos))
            t = similar(spots, size(spots).+2)
            t[1:end] = '.'
            t[2:end-1, 2:end-1] = spots
            spots = t
            pos += [ 1; 1]
        end

        x = pos[1]
        y = pos[2]
        if (spots[x, y] == '#')
            dir = turn(dir, 'r')
            spots[x,y] = '.'
        else
            dir = turn(dir, 'l')
            spots[x,y] = '#'
            count += 1
        end
        pos += dir
    end
    display(spots)
    display(dir)
    display(pos)
    return count
end

function turn(pos, dir)
    if (dir == 'l')
        return LDict[pos]
    elseif (dir == 'r')
        return RDict[pos]
    else
        error("Invalid direction")
    end
end
