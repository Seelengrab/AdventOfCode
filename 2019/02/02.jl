function parseInput(inp)
    return map(x -> parse.(Int, x), split.(readlines(inp), ","))
end

const add = Val(:add)
const mul = Val(:mul)
const stop = Val(:stop)

const opsTable = Dict([
    1 => add
    2 => mul
    99 => stop
])

function runProg(prog)
    ip = 1
    run = true
    while run
        # @show prog
        op = opsTable[prog[ip]]
        run, ip = calc!(prog, ip, op)
    end

    prog
end

function calc!(prog, ip, ::Val{:add})
    a = prog[ip+1]
    b = prog[ip+2]
    c = prog[ip+3]
    prog[c+1] = prog[a+1]+prog[b+1]
    return true, ip+4
end

function calc!(prog, ip, ::Val{:mul})
    a = prog[ip+1]
    b = prog[ip+2]
    c = prog[ip+3]
    prog[c+1] = prog[a+1]*prog[b+1]
    return true, ip+4
end

function calc!(prog, ip, ::Val{:stop})
    return false, ip+1
end

function preproc(inp)
    p = deepcopy(inp)
    for i in 0:99, j in 0:99
        p[2] = i
        p[3] = j
        if runProg(p)[1] == 19690720
            return 100*i+j
        end
        p .= inp
    end
end