module Intcode

export Intmachine, run!, reset!, parseInput, InfChannel

function parseInput(inp)
    return map(x -> parse.(BigInt, x), split.(readlines(inp), ","))
end

const add = Val(:add)
const mul = Val(:mul)
const input = Val(:input)
const output = Val(:output)
const jmpt = Val(:jmpt)
const jmpf = Val(:jmpf)
const lt = Val(:lt)
const eq = Val(:eq)
const rbo = Val(:rbo)

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
    9 => rbo
    99 => stop
])

struct InfChannel{T} <: AbstractChannel{T}
    data::T
end

InfChannel(d::T) where T = InfChannel{T}(d)

Base.put!(c::InfChannel, i) = throw(DomainError("Can't `put!` an Infinite providing channel."))
Base.take!(c::InfChannel) = c.data
Base.eltype(::Type{InfChannel{T}}) where T = T
function Base.iterate(c::InfChannel, state=nothing)
    return take!(c), nothing
end
Base.IteratorSize(::Type{<:InfChannel}) = Base.IsInfinite()

mutable struct Intmachine{T <: IO, U <: AbstractChannel, V <: AbstractChannel}
    id::Int
    prog::Array{BigInt,1}
    outStream::T
    shouldPrint::Bool
    inComm::U
    outComm::V

    ip::Int
    relBase::Int
    lastOp::Val
    maxMem::Int
end

Intmachine(id, 
           prog, 
           shouldPrint=true; 
           outStream=stdout, 
           inComm=Channel{Int}(Inf), 
           outComm=Channel{Int}(Inf), 
           ip=1, relBase=0, 
           lastOp=none, maxMem=Int(4e6)) = Intmachine{typeof(outStream), typeof(inComm), typeof(outComm)}(id, prog, outStream, shouldPrint, inComm, 
                                                                                                          outComm, ip, relBase, lastOp, maxMem)

function reset!(m::Intmachine, prog::Array{BigInt,1})
    m.ip = 1
    m.relBase = 1
    m.prog = prog
end

function Base.resize!(m::Intmachine, n::Integer)
    if n > length(m.prog)
        oldLen = length(m.prog)
        resize!(m.prog,n)
        m.prog[oldLen+1:end] .= 0
    end
end

function getOut(m, mode, var, write=false)
    if mode == 0
        return write ? var : m.prog[var+1]
    elseif mode == 1
        return var
    elseif mode == 2
        return write ? m.relBase + var : m.prog[m.relBase+1+var]
    end
end

function run!(m)
    run::Bool = true

    while run
        d = m.prog[m.ip]
        op = opsTable[d % 100]
        mode = div(d, 100)
        run = calc!(m, op, mode)
        m.lastOp = op
    end

    m.shouldPrint && println(m.outStream, "$(m.id)@$(m.ip) - goodbye!")
    nothing
end

function calc!(m, ::Val{:add}, mode)
    resize!(m, m.ip+3)
    a = m.prog[m.ip+1]
    b = m.prog[m.ip+2]
    c = m.prog[m.ip+3]

    maxAddr = min(m.maxMem, max(a+1,b+1,c+1,m.relBase+c+1,m.relBase+a+1,m.relBase+b+1))
    resize!(m, maxAddr)

    modeA = mode % 10
    modeB = div(mode, 10) % 10
    modeC = div(mode, 100) % 10

    a_out = getOut(m, modeA, a)
    b_out = getOut(m, modeB, b)
    c_out = getOut(m, modeC, c, true)

    m.prog[c_out+1] = a_out+b_out
    m.ip += 4

    return true
end

function calc!(m, ::Val{:mul}, mode)
    resize!(m, m.ip+3)
    a = m.prog[m.ip+1]
    b = m.prog[m.ip+2]
    c = m.prog[m.ip+3]

    maxAddr = min(m.maxMem, max(a+1,b+1,c+1,m.relBase+c+1,m.relBase+a+1,m.relBase+b+1))
    resize!(m, maxAddr)

    modeA = mode % 10
    modeB = div(mode, 10) % 10
    modeC = div(mode, 100) % 10

    a_out = getOut(m, modeA, a)
    b_out = getOut(m, modeB, b)
    c_out = getOut(m, modeC, c, true)

    m.prog[c_out+1] = a_out*b_out
    m.ip += 4
    return true
end

function calc!(m, ::Val{:input}, mode)
    resize!(m, m.ip+1)
    a = m.prog[m.ip+1]

    maxAddr = min(m.maxMem, max(a+1,m.relBase+a+1))
    resize!(m, maxAddr)

    modeA = mode % 10
    a_out = getOut(m, modeA, a, true)

    m.shouldPrint && println(m.outStream, "$(m.id)@$(m.ip) waiting...")
    m.prog[a_out+1] = take!(m.inComm)
    m.shouldPrint && println(m.outStream, "$(m.id)@$(m.ip) got: $(m.prog[a_out+1])@$(a_out+1)")

    m.ip += 2
    return true
end

function calc!(m, ::Val{:output}, mode)
    resize!(m, m.ip+1)
    a = m.prog[m.ip+1]

    maxAddr = min(m.maxMem, max(a+1,m.relBase+a+1))
    resize!(m, maxAddr)

    modeA = mode % 10

    a_out = getOut(m, modeA, a)

    m.shouldPrint && println(m.outStream, "$(m.id)@$(m.ip) lastOp: $(m.lastOp) $a_out ($(ndigits(a_out)))")
    put!(m.outComm, a_out)

    m.ip += 2
    return true
end

function calc!(m, ::Val{:jmpt}, mode)
    resize!(m, m.ip+2)
    a = m.prog[m.ip+1]
    b = m.prog[m.ip+2]

    maxAddr = min(m.maxMem, max(a+1,b+1,m.relBase+a+1,m.relBase+b+1))
    resize!(m, maxAddr)

    modeA = mode % 10
    modeB = div(mode, 10) % 10

    a_out = getOut(m, modeA, a)
    b_out = getOut(m, modeB, b)

    if a_out != 0
        m.ip = b_out+1
    else
        m.ip += 3
    end

    return true
end

function calc!(m, ::Val{:jmpf}, mode)
    resize!(m, m.ip+2)
    a = m.prog[m.ip+1]
    b = m.prog[m.ip+2]

    maxAddr = min(m.maxMem, max(a+1,b+1,m.relBase+a+1,m.relBase+b+1))
    resize!(m, maxAddr)

    modeA = mode % 10
    modeB = div(mode, 10) % 10

    a_out = getOut(m, modeA, a)
    b_out = getOut(m, modeB, b)

    if a_out == 0
        m.ip = b_out+1
    else
        m.ip += 3
    end

    return true
end

function calc!(m, ::Val{:lt}, mode)
    resize!(m, m.ip+3)
    a = m.prog[m.ip+1]
    b = m.prog[m.ip+2]
    c = m.prog[m.ip+3]

    maxAddr = min(m.maxMem, max(a+1,b+1,c+1,m.relBase+c+1,m.relBase+a+1,m.relBase+b+1))
    resize!(m, maxAddr)

    modeA = mode % 10
    modeB = div(mode, 10) % 10
    modeC = div(mode, 100) % 10

    a_out = getOut(m, modeA, a)
    b_out = getOut(m, modeB, b)
    c_out = getOut(m, modeC, c, true)

    m.prog[c_out+1] = Int(a_out < b_out)
    m.ip += 4
    return true
end

function calc!(m, ::Val{:eq}, mode)
    resize!(m, m.ip+3)
    a = m.prog[m.ip+1]
    b = m.prog[m.ip+2]
    c = m.prog[m.ip+3]

    maxAddr = min(m.maxMem, max(a+1,b+1,c+1,m.relBase+c+1,m.relBase+a+1,m.relBase+b+1))
    resize!(m, maxAddr)

    modeA = mode % 10
    modeB = div(mode, 10) % 10
    modeC = div(mode, 100) % 10

    a_out = getOut(m, modeA, a)
    b_out = getOut(m, modeB, b)
    c_out = getOut(m, modeC, c, true)

    m.prog[c_out+1] = Int(a_out == b_out)
    m.ip += 4
    return true
end

function calc!(m, ::Val{:rbo}, mode)
    resize!(m, m.ip+1)
    a = m.prog[m.ip + 1]

    maxAddr = min(m.maxMem, max(a+1,m.relBase+a+1))
    resize!(m, maxAddr)

    modeA = mode % 10

    a_out = getOut(m, modeA, a)

    m.relBase += a_out
    m.ip += 2
    return true
end

function calc!(m, ::Val{:stop}, mode)
    m.ip += 1
    return false
end

end # module
