function doStuff(file)
    input = readlines(file)
    pos = 5
    res = []
    for line in input
        for dir in line
            nPos = move(dir, pos)
            if nPos == pos
                continue
            end

            pos = nPos
        end
        push!(res, pos)
    end
    return res
end

function move(dir, pos)
    if pos == 1
        if dir == 'R'
            return 2
        elseif dir == 'D'
            return 4
        else
            return 1
        end
    elseif pos == 2
        if dir == 'L'
            return 1
        elseif dir == 'D'
            return 5
        elseif dir == 'R'
            return 3
        else
            return 2
        end
    elseif pos == 3
        if dir == 'L'
            return 2
        elseif dir == 'D'
            return 6
        else
            return 3
        end
    elseif pos == 4
        if dir == 'U'
            return 1
        elseif dir == 'R'
            return 5
        elseif dir == 'D'
            return 7
        else
            return 4
        end
    elseif pos == 5
        if dir == 'U'
            return 2
        elseif dir == 'R'
            return 6
        elseif dir == 'D'
            return 8
        else
            return 4
        end
    elseif pos == 6
        if dir == 'U'
            return 3
        elseif dir == 'D'
            return 9
        elseif dir == 'L'
            return 5
        else
            return 6
        end
    elseif pos == 7
        if dir == 'U'
            return 4
        elseif dir == 'R'
            return 8
        else
            return 7
        end
    elseif pos == 8
        if dir == 'L'
            return 7
        elseif dir == 'U'
            return 5
        elseif dir == 'R'
            return 9
        else
            return 8
        end
    elseif pos == 9
        if dir == 'L'
            return 8
        elseif dir == 'U'
            return 6
        else
            return 9
        end
    else
        error("Illegal position!")
    end
end
