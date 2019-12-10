cases = readlines(open("input"))

for case in cases
    print("$case -- ")
    dist = 0
    x = 0
    y = 0
    z = 0
    mdist = 0
    case = split(case, ",")
    for step in case
        if step == "n"
            z -= 1
            y += 1
        elseif step == "ne"
            z -= 1
            x += 1
        elseif step == "se"
            x += 1
            y -= 1
        elseif step == "s"
            y -= 1
            z += 1
        elseif step == "sw"
            x -= 1
            z += 1
        elseif step == "nw"
            x -= 1
            y += 1
        else
            error("Unknown step: $step")
        end
        td = max(abs(x),abs(y),abs(z))
        mdist = td > mdist ? td : mdist
    end
    dist = max(abs(x),abs(y),abs(z))
    println("$dist -- $mdist")
end
