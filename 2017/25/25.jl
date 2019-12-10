TMTest = Dict([
    'A' => Dict([ 0 => (1,1,'B'),    1 => (0,-1,'B') ]),
    'B' => Dict([ 0 => (1,-1,'A'),   1 => (1,1,'A')  ])
])

TMInput = Dict([
    'A' => Dict([ 0 => (1,1,'B'), 1 => (0,1,'F')]),
    'B' => Dict([ 0 => (0,-1,'B'), 1 => (1,-1,'C')]),
    'C' => Dict([ 0 => (1,-1,'D'), 1 => (0,1,'C')]),
    'D' => Dict([ 0 => (1,-1,'E'), 1 => (1,1,'A')]),
    'E' => Dict([ 0 => (1,-1,'F'), 1 => (0,-1,'D')]),
    'F' => Dict([ 0 => (1,1,'A'), 1 => (0,-1,'E')])
])

function simulate(tm, steps)
    tape = Vector{UInt8}()
    state = 'A'
    pos = 1

    for i in 1:steps
        if (pos > length(tape))
            push!(tape, 0)
        elseif (pos < 1)
            unshift!(tape, 0)
            pos = 1
        end
        next = tm[state][tape[pos]]
        tape[pos] = next[1]
        pos += next[2]
        state = next[3]
    end
    return tape
end

# println(simulate(TMTest, 6))
println(sum(simulate(TMInput, 12964419)))
