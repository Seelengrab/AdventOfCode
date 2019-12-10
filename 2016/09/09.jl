## part 1
function decompLength(inp)
    decL = 0
    file = open(inp, "r")
    while !eof(file)
        c = read(file, Char)
        if c in [' ', '\n']
            continue
        end
        if c != '('
            decL += 1
            continue
        end

        marker = readuntil(file, ')')
        parts = parse.(split(marker[1:end-1], 'x'))
        decL += parts[1] * parts[2]
        read(file, parts[1])
    end
    decL
end

## part2
function decomp(text)
    if '(' ∉ text
        return length(text)
    end
    nextPar = findfirst(text, '(')
    nextClos = findfirst(text, ')')
    parts = parse.(split(text[nextPar+1:nextClos-1], 'x'))
    return nextPar - 2 + parts[2] * decomp(text[nextClos + 1:nextClos + parts[1]]) + decomp(text[nextClos + parts[1]:end])
end