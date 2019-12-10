if length(ARGS) != 1
    println("Need exactly one argument!")
    exit(1)
end

Base.zero(::Type{Char}) = '\0'

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

function perms(arr::AbstractArray)
    ret = Array{typeof(arr)}(8)
    ret[1:4] = [ arr, rotr90(arr), rot180(arr), rotl90(arr) ]
    for i in 1:4
        ret[4+i] = permutedims(ret[i], (2,1))
    end
    return unique(ret)
end

input = [ split.(x, '/') for x in split.(readlines(open(ARGS[1])), " => ") ]
input = map.(arrToMat, input)

rules = Dict{Array{Char,2},Array{Char,2}}()

for pattern in input
    ps = perms(pattern[1])
    for p in ps
        rules[p] = pattern[2]
    end
end

# base pattern
basePat = [ '.' '#' '.';
            '.' '.' '#';
            '#' '#' '#' ]

function paint(its)
    art = basePat
    for i in 1:its
        side = size(art)[1]
        div = side % 2 == 0 ? 2 : 3
        nDiv = div + 1
        nSide = Int((side/div)*nDiv)
        nArt = zeros(eltype(art), nSide, nSide)
        for (row, rowN) in zip(1:div:side, 1:nDiv:nSide)
            for (col, colN) in zip(1:div:side, 1:nDiv:nSide)
                nArt[rowN:rowN+nDiv-1, colN:colN+nDiv-1] = rules[art[row:row+div-1, col:col+div-1]]
            end
        end
        art = nArt
    end
    return art
end
