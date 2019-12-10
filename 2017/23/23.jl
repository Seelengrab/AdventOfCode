if (length(ARGS) != 1)
    println("Exactly one argument needed!")
    exit(1)
end

function resetInput()
    global input = split.(readlines(open(ARGS[1])))
    global regs = Dict{AbstractString, Integer}(zip([ "$(i + 'a')" for i in 0:7 ], [ 0 for i in 1:8 ]))
    regs["a"] = 1
    global pos = 1
    global mulCount = 0
end

function doStuff()
    global input
    global pos
    global mulCount
    global regs
    while pos <= length(input) && pos > 0
        com = input[pos]

        reg = com[2]

        if all(isnumber, reg)
            a = parse(reg)
        else
            if !haskey(regs, reg)
                regs[reg] = 0
            end
            a = regs[reg]
        end

        if length(com) > 2
            if !all(isalpha, com[3])
                b = parse(com[3])
            else
                b = regs[com[3]]
            end
        end

        if com[1] == "set"
            regs[reg] = b
        elseif com[1] == "sub"
            regs[reg] -= b
        elseif com[1] == "mul"
            regs[reg] *= b
            mulCount += 1
        elseif com[1] == "jnz"
            if a != 0
                pos += b
            else
                pos += 1
            end
        end

        if com[1] != "jnz"
            pos += 1
        end
        display(regs)
    end
    println(mulCount)
end

function start()
    resetInput()
    doStuff()
end
