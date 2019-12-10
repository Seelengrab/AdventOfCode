@enum North East South West

function parseInput(file)
    input = split(readline(file), ", ")
    map(x -> (x[1], parse(x[2:end])), input)
end

function doStuff(input)
    pos = [0,0]
    dir = North
    for inst in parseInput(input)
        dir = switchDir(dir, inst[1])
        pos = move(pos, dir, inst[2])
    end
    return sum(pos)
end

function move(pos, dir, steps)
    if dir == North
        return pos + [steps, 0]
    elseif dir == East
        return pos + [0, steps]
    elseif dir == South
        return pos - [steps, 0]
    elseif dir == West
        return pos - [0, steps]
    end
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
