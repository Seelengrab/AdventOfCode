using Combinatorics

include("../Intcode.jl")

function checkSettingPart1(prog)
    perms = permutations(0:4, 5)
    maxThrust = 0

    inComm = Channel{Int}(10)
    outComm = Channel{Int}(10)
    m = Intmachine(0, Int[], false, inComm=inComm, outComm=outComm)
    curProg = similar(prog)

    for p in perms
        put!(outComm, 0)
        for i in eachindex(p)
            curProg .= prog
            reset!(m, curProg)
            put!(inComm, p[i])
            put!(inComm, take!(outComm))
            run!(m)
        end
        maxThrust = max(maxThrust, take!(outComm))
    end
    maxThrust
end

function checkSetting(prog)
    perms = permutations(5:9, 5)
    maxThrust = 0
    progs = [ similar(prog) for _ in 1:5 ]

    for p in perms
        for i in eachindex(progs)
            progs[i] .= prog
        end
        c = Channel{Int}(Inf)
        comms = [ Channel{Int}(Inf) for _ in 1:5 ]

        for i in 1:4
            put!(comms[i], p[i])
            t = @task run!(Intmachine(i, progs[i], false, inComm=comms[i], outComm=comms[i+1]))
            schedule(t)
        end
        put!(comms[5], p[5])
        t = @task run!(Intmachine(5, progs[5], false, inComm=comms[5], outComm=c))
        schedule(t)

        lastOutput = 0
        while !istaskdone(t)
            put!(comms[1], lastOutput)
            lastOutput = take!(c)
            maxThrust = max(maxThrust, lastOutput)
        end
    end
    maxThrust
end
