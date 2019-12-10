function condTrue(regVal, val, op)
    ret = false
    if op == "<"
        ret = regVal < val
    elseif op == ">"
        ret = regVal > val
    elseif op == ">="
        ret = regVal >= val
    elseif op == "<="
        ret = regVal <= val
    elseif op == "=="
        ret = regVal == val
    elseif op == "!="
        ret = regVal != val
    else
        error("Invalid operator -- $regVal - $op - $val ")
    end
    return ret
end

# f = readlines(open("test"))
f = readlines(open("input"))
regs = Dict{String, Int64}()

m = 0
for line in f
    line = split(line)
    reg = line[1]
    op = line[2]
    val = parse(line[3])
    regCond = line[5]
    opCond = line[6]
    valCond = parse(line[7])

    if !haskey(regs, reg)
        regs[reg] = 0
    end
    if !haskey(regs, regCond)
        regs[regCond] = 0
    end

    if condTrue(regs[regCond], valCond, opCond)
        if op == "inc"
            regs[reg] += val
        elseif op == "dec"
            regs[reg] -= val
        end
    end
    mt = maximum(values(regs))
    m = mt > m ? mt : m
end

println(maximum(values(regs)))
println(m)
