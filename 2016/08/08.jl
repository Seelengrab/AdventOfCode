function parseInput(inp)
    i = split.(replace.(readlines(inp), r"rotate |(x|y)=| by ", " "))
    map(x -> length(x) == 2 ? (x[1], parse.(split(x[2], 'x'))...) : (x[1], parse(x[2])+1, parse(x[3])), i)
end

function drawRect!(buffer, width, height)
    setindex!(buffer, true, 1:height, 1:width)
end

function rotRow!(buffer, row, amount)
    buffer[row,:] = circshift(buffer[row,:], amount)
end

function rotCol!(buffer, col, amount)
    buffer[:,col] = circshift(buffer[:,col], amount)
end

followInstructions(instructions) = followInstructions(instructions, 50, 6)

function followInstructions(instructions, w, h)
    b = falses(h,w)
    for instr in instructions
        if instr[1] == "rect"
            drawRect!(b, instr[2], instr[3])
        elseif instr[1] == "column"
            rotCol!(b, instr[2], instr[3])
        elseif instr[1] == "row"
            rotRow!(b, instr[2], instr[3])
        else
            error("Unknown instruction: ", instr)
        end
    end
    b
end
function parseInput(inp)
    i = split.(replace.(readlines(inp), r"rotate |(x|y)=| by ", " "))
    map(x -> length(x) == 2 ? (x[1], parse.(split(x[2], 'x'))...) : (x[1], parse(x[2])+1, parse(x[3])), i)
end

function drawRect!(buffer, width, height)
    setindex!(buffer, true, 1:height, 1:width)
end

function rotRow!(buffer, row, amount)
    buffer[row,:] = circshift(buffer[row,:], amount)
end

function rotCol!(buffer, col, amount)
    buffer[:,col] = circshift(buffer[:,col], amount)
end

followInstructions(instructions) = followInstructions(instructions, 50, 6)

function followInstructions(instructions, w, h)
    b = falses(h,w)
    for instr in instructions
        if instr[1] == "rect"
            drawRect!(b, instr[2], instr[3])
        elseif instr[1] == "column"
            rotCol!(b, instr[2], instr[3])
        elseif instr[1] == "row"
            rotRow!(b, instr[2], instr[3])
        else
            error("Unknown instruction: ", instr)
        end
    end
    b
end

function printScreen(buffer)
    s = size(buffer)
    for i in 1:s[1]
        for j in 1:s[2]
            print(buffer[i,j] ? '#' : ' ' )
        end
        print('\n')
    end
end
