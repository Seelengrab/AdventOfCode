function doStuff(file)
    input = readlines(file)
    pos = '5'
    res = []
    pad = Dict([
        '1' => Dict([ 'D' => '3']),
        '2' => Dict([ 'D' => '6', 'R' => '3' ]),
        '3' => Dict([ 'D' => '7', 'R' => '4', 'U' => '1', 'L' => '2']),
        '4' => Dict([ 'D' => '8', 'L' => '3' ]),
        '5' => Dict([ 'R' => '6']),
        '6' => Dict([ 'D' => 'A', 'R' => '7', 'U' => '2', 'L' => '5']),
        '7' => Dict([ 'D' => 'B', 'R' => '8', 'U' => '3', 'L' => '6']),
        '8' => Dict([ 'D' => 'C', 'R' => '9', 'U' => '4', 'L' => '7']),
        '9' => Dict([ 'L' => '8']),
        'A' => Dict([ 'R' => 'B', 'U' => '6']),
        'B' => Dict([ 'D' => 'D', 'R' => 'C', 'U' => '7', 'L' => 'A']),
        'C' => Dict([ 'U' => '8', 'L' => 'B']),
        'D' => Dict([ 'U' => 'B'])
    ])
    for line in input
        for dir in line
            nPos = move(dir, pos, pad)
            if nPos == pos
                continue
            end

            pos = nPos
        end
        push!(res, pos)
    end
    return res
end

function move(dir, pos, pad)
    moves = pad[pos]
    if haskey(moves, dir)
        return moves[dir]
    end
    return pos
end
