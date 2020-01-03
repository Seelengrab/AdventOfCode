function jumper(inp)
    d = parseInput(inp)
    m = Intmachine(0,deepcopy(d[1]),false)
    inC = m.inComm
    outC = m.outComm
    t = @async run!(m)
    # part 1
    # program = """
    #           NOT A T
    #           NOT B J
    #           OR T J
    #           NOT C T
    #           OR T J
    #           AND D J
    #           WALK
    #           """

    #part 2
    program = """
              OR A J
              AND B J
              AND C J
              NOT J J
              AND D J
              OR E T
              OR H T
              AND T J
              RUN
              """

    for c in program
        put!(inC, Int(c))
    end
    while !istaskdone(t) || isready(outC)
        c = take!(outC)
        if c <= 256
            print(Char(c))
        else
            println(c)
        end
    end
end