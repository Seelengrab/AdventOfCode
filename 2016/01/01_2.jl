@enum North East South West

function parseInput(file)
    input = split(readline(file), ", ")
    map(x -> (x[1], parse(x[2:end])), input)
end

function doStuff(input)
    pos = [0,0]
    dir = North
    known = []
    for inst in parseInput(input)
        dir = switchDir(dir, inst[1])
        pos = move(pos, dir, inst[2], known)
    end
    return sum(pos)
end

function move(pos, dir, steps, known)
    for i in 1:steps
        if dir == North
            pos = pos + [1, 0]
        elseif dir == East
            pos = pos + [0, 1]
        elseif dir == South
            pos = pos - [1, 0]
        elseif dir == West
            pos = pos - [0, 1]
        end

        if pos in known
            println(sum(pos))
            exit(0)
        end

        push!(known, pos)
    end

    return pos
end

function switchDir(dir, turn)
    if turn == 'L'
        if dir == North
            return West
        elseif dir == East
            return North
        elseif dir == South
            return East
        elseif dir == West
            return South
        end
    elseif turn == 'R'
        if dir == North
            return East
        elseif dir == East
            return South
        elseif dir == South
            return West
        elseif dir == West
            return North
        end
    else
        error("Invalid turn!")
    end
end
