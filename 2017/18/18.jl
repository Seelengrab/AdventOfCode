input = split.(readlines(open("test")))
regs = Dict{AbstractString, Integer}()
rems = Dict{AbstractString, Integer}()
pos = 1

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

    if com[1] == "snd"
        rems[reg] = regs[reg]
    elseif com[1] == "set"
        regs[reg] = b
    elseif com[1] == "add"
        regs[reg] += b
    elseif com[1] == "mul"
        regs[reg] *= b
    elseif com[1] == "mod"
        regs[reg] %= b
    elseif com[1] == "rcv"
        if haskey(rems, reg) && rems[reg] != 0
            println(rems[reg])
            break
        end
    elseif com[1] == "jgz"
        if a > 0
            pos += b
        else
            pos += 1
        end
    end

    if com[1] != "jgz"
        pos += 1
    end
end
