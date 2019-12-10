module mod18

export init

function init(pVal, input, sndChannel, rcvChannel)
    regs = Dict{AbstractString, Integer}()
    regs["p"] = pVal
    counter = 0
    pos = 1

    while pos <= length(input) && pos > 0
        com = input[pos]
        reg = com[2] # get the register

        # get the value of the register / the value of the first arg of jgz
        if all(isnumber, reg)
            regVal = parse(reg)
        else
            if !haskey(regs, reg)
                regs[reg] = 0
            end
            regVal = regs[reg]
        end

        # if it's a jgz, get the jump argument value
        if length(com) > 2
            if !all(isalpha, com[3])
                arg = parse(com[3])
            else
                arg = regs[com[3]]
            end
        end

        if com[1] == "snd"
            put!(sndChannel, regVal)
            println("$pos : => $regVal")
            counter += 1
        elseif com[1] == "set"
            regs[reg] = arg
            println("$pos : $reg = $arg")
        elseif com[1] == "add"
            regs[reg] += arg
            println("$pos : $arg + $reg")
        elseif com[1] == "mul"
            regs[reg] *= arg
            println("$pos : $reg * $arg")
        elseif com[1] == "mod"
            regs[reg] %= arg
            println("$pos : $reg % $arg")
        elseif com[1] == "rcv"
            sleepCnt = 0
            while !isready(rcvChannel)
                if sleepCnt == 10
                    println("$pVal: Timeout.")
                    println("I've ($pVal) sent stuff $counter times.")
                    return
                end
                sleep(0.1)
                sleepCnt += 1
            end

            regs[reg] = take!(rcvChannel)
            println("$pos : <= $(regs[reg])")
        elseif com[1] == "jgz"
            if regVal > 0
                pos += arg
            else
                pos += 1
            end
        end

        if com[1] != "jgz"
            pos += 1
        end
    end

    println("I've ($pVal) sent stuff $counter times.")
end
end
