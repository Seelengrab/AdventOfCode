input = replace.(readlines(open(ARGS[1])), " ", ".")
ysize = length(input[1])
xsize = length(input)
maxsize = sum(count.(x -> isalpha(x), input))
#   x
# y +----> 
#   |
#   Y

@enum Direction up right down left none

function getStart(field)
    x = 1
    y = 1
    for i in 1:xsize
       if field[x][i] == '|'
            y = i
            break
       end 
    end
    
    (x,y)
end

function inBounds(px, py)
    return px < xsize + 1 && px > 0 && py < ysize + 1 && py > 0
end

function newDir(field, pos::Tuple, oldDir)
    px = pos[1]
    py = pos[2]
    posPos = Dict(left => (px, py-1), right => (px, py+1), down => (px+1, py), up => (px-1, py))
    if oldDir == up
        delete!(posPos, down)
    elseif oldDir == right
        delete!(posPos, left)
    elseif oldDir == down
        delete!(posPos, up)
    elseif oldDir == left
        delete!(posPos, right)
    end

    for (dir, (nx, ny)) in posPos
        if !inBounds(nx, ny) 
            continue
        end
        if field[nx][ny] in union(['|', '-'], collect('A':'Z')) 
            return dir
        end
    end
    return none
end

function collectLetter(message::AbstractString, field, pos::Tuple)
    x = pos[1]
    y = pos[2]
    if !(field[x][y] in ['|','-','.'])
        message = "$message$(field[x][y])"
        println(message)
    end
    message
end

function walkDir(steps, pos, dir)
    x = pos[1]
    y = pos[2]
    if dir == up
        return (steps+1, x-1, y)
    elseif dir == down
        return (steps+1, x+1, y)
    elseif dir == right
        return (steps+1, x, y+1)
    elseif dir == left
        return (steps+1, x, y-1)
    end
    return (steps+1, x, y)
end

x, y = getStart(input)
dir = down
msg = ""
steps = -1

while inBounds(x, y) && dir != none && length(msg) < maxsize
    while inBounds(x, y) && !(input[x][y] in ['+','.'])
        msg = collectLetter(msg, input, (x,y))
        steps, x, y = walkDir(steps, (x,y), dir)
    end
    
    dir = newDir(input, (x,y), dir)
    steps, x, y = walkDir(steps, (x,y), dir)
end

println("Message is: '$msg', took $steps steps")

