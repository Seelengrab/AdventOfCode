module Intcode

using StaticArrays

export parseInput, runProg!

function parseInput(inp)
    return map(x -> parse.(Int, x), split.(readlines(inp), ","))
end

struct InfIO end
Base.readline(::InfIO) = "1"

# const inStream = stdin
# const outStream = stdout
const inStream = InfIO()
const outStream = devnull

const add = Val(:add)
const mul = Val(:mul)
const input = Val(:input)
const output = Val(:output)
const jmpt = Val(:jmpt)
const jmpf = Val(:jmpf)
const lt = Val(:lt)
const eq = Val(:eq)

const stop = Val(:stop)
const none = Val(:none)

const opsTable = Dict{Int, Val}([
    1 => add
    2 => mul
    3 => input
    4 => output
    5 => jmpt
    6 => jmpf
    7 => lt
    8 => eq
    99 => stop
])

function runProg!(prog)
    ip::Int = 1
    run::Bool = true
    lastOp = none
    while run
        # @show prog[ip:min(ip+4, length(prog))]
        d = prog[ip]
        op = opsTable[d % 100]
        mode = div(d, 100)
        # @show mode
        run, ip = calc!(prog, ip, op, mode, lastOp)
        lastOp = op
        # println()
    end

    # prog
end

function calc!(prog, ip, ::Val{:add}, mode, last)
    a = prog[ip+1]
    b = prog[ip+2]
    c = prog[ip+3]
    modeA = mode % 10
    modeB = div(mode, 10) % 10
    a_out = modeA == 0 ? prog[a+1] : a
    b_out = modeB == 0 ? prog[b+1] : b
    prog[c+1] = a_out+b_out
    return true, ip+4
end

function calc!(prog, ip, ::Val{:mul}, mode, last)
    a = prog[ip+1]
    b = prog[ip+2]
    c = prog[ip+3]
    modeA = mode % 10
    modeB = div(mode, 10) % 10
    a_out = modeA == 0 ? prog[a+1] : a
    b_out = modeB == 0 ? prog[b+1] : b
    prog[c+1] = a_out*b_out
    return true, ip+4
end

function calc!(prog, ip, ::Val{:input}, mode, last)
    a = prog[ip+1]
    prog[a+1] = parse(Int, readline(inStream))
    return true, ip+2
end

function calc!(prog, ip, ::Val{:output}, mode, last)
    a = prog[ip+1]
    modeA = mode % 10
    a_out = modeA == 0 ? prog[a+1] : a
    print(outStream, "lastOp: ")
    print(outStream, last)
    print(outStream, " ")
    println(outStream, a_out)
    return true, ip+2
end

function calc!(prog, ip, ::Val{:jmpt}, mode, last)
    a = prog[ip+1]
    b = prog[ip+2]
    modeA = mode % 10
    modeB = div(mode, 10) % 10
    a_out = modeA == 0 ? prog[a+1] : a
    b_out = modeB == 0 ? prog[b+1] : b
    if a_out != 0
        return true, b_out+1
    else
        return true, ip + 3
    end
end

function calc!(prog, ip, ::Val{:jmpf}, mode, last)
    a = prog[ip+1]
    b = prog[ip+2]
    modeA = mode % 10
    modeB = div(mode, 10) % 10
    a_out = modeA == 0 ? prog[a+1] : a
    b_out = modeB == 0 ? prog[b+1] : b
    if a_out == 0
        return true, b_out+1
    else
        return true, ip + 3
    end
end

function calc!(prog, ip, ::Val{:lt}, mode, last)
    a = prog[ip+1]
    b = prog[ip+2]
    c = prog[ip+3]
    modeA = mode % 10
    modeB = div(mode, 10) % 10
    a_out = modeA == 0 ? prog[a+1] : a
    b_out = modeB == 0 ? prog[b+1] : b
    prog[c+1] = Int(a_out < b_out)

    return true, ip + 4
end

function calc!(prog, ip, ::Val{:eq}, mode, last)
    a = prog[ip+1]
    b = prog[ip+2]
    c = prog[ip+3]
    modeA = mode % 10
    modeB = div(mode, 10) % 10
    a_out = modeA == 0 ? prog[a+1] : a
    b_out = modeB == 0 ? prog[b+1] : b
    prog[c+1] = Int(a_out == b_out)

    return true, ip + 4
end

function calc!(prog, ip, ::Val{:stop}, mode, last)
    return false, ip+1
end

end # module