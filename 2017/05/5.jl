# f = open("short")
f = open("testinput")
instr = map(parse,readlines(f))
close(f)

index = 1
steps = 0
while (index > 0 && index <= length(instr))
    # println("$instr -- $(index-1)")
    old = instr[index]
    if old >= 3
        instr[index] -= 1
    else
        instr[index] += 1
    end
    index += old
    steps += 1
end
# println("$instr -- $(index-1)")

println("steps: $steps -- index: $index")
