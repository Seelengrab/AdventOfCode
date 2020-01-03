using Combinatorics

function playGame(inp)
    d = parseInput(inp)
    m = Intmachine(0, deepcopy(d[1]), false)
    inC = m.inComm
    outC = m.outComm
    t = @async run!(m)

    texts = [ "asterisk"
              "antenna"
              "easter egg"
              "space heater"
              "jam"
              "tambourine"
              "festive hat"
              "fixed point" ]

    @async begin
        while !istaskdone(t)
            line = readline(stdin)
            while length(line) == 0
                line = readline(stdin)
            end
            if line == "solvePlease"
                for pos in combinations(texts)
                    text = ""
                    for c in pos
                        text *= "take $c\n"
                    end
                    text *= "west\n"
                    istaskdone(t) && return
                    for c in pos
                        text *= "drop $c\n"
                    end

                    for c in text
                        put!(inC, Int(c))
                    end
                end
            end
            for c in line
                put!(inC, Int(c))
            end
            put!(inC, 10)
        end
    end

    while !istaskdone(t) || isready(outC)
        c = Char(take!(outC))
        lastLine = ""
        while true
            lastLine *= c
            if c == '\n'
                print(lastLine)
                istaskdone(t) && !isready(outC) && return
                lastLine = ""
            end
            c = Char(take!(outC))
        end
    end
end