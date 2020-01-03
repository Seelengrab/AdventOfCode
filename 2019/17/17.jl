function getParam(inp)
    m = Intmachine(0, deepcopy(inp),false)
    out = m.outComm
    t = @async run!(m)
    x = 0
    y = 0
    mX = 53
    mY = 0
    cameraView = Dict{Tuple{Int, Int},Char}()
    while !istaskdone(t) || isready(out)
        c = Char(take!(out))
        print(c)
        if c == '\n'
            x = 0
            y += 1
        else
            cameraView[(x,y)] = c
            x += 1
        end
    end

    @show mX, y
    ret = fill('.',mX-1,y-1)

    for xp in 0:mX-2
        for yp in 0:y-2
            ret[xp+1,yp+1] = cameraView[(xp,yp)]
        end
    end

    # part 1

    sumParams = 0
    for xp in 2:size(ret,1)-1
        for yp in 2:size(ret,2)-1
            if ret[xp,yp] == '#' &&
               ret[xp-1,yp] == '#' &&
               ret[xp,yp-1] == '#' &&
               ret[xp+1,yp] == '#' &&
               ret[xp,yp+1] == '#'

               sumParams += (xp-1) * (yp-1)
            end
        end
    end
    sumParams
end

function part2(inp)
    d2 = deepcopy(inp)
    d2[1] = 2
    m = Intmachine(0, d2,false)
    inC = m.inComm
    outC = m.outComm
    t = @async run!(m)
    for c in """
             A,B,A,C,B,C,B,C,A,C
             R,12,L,10,R,12
             L,8,R,10,R,6
             R,12,L,10,R,10,L,8
             n
             """
        put!(inC, Int(c))
    end
    while isready(outC) || !istaskdone(t)
        @show take!(outC)
    end
end

# manual labor ftw

# R12,L10,R12,L8,R10,R6,R12,L10,R12,R12,L10,R10,L8,L8,R10,R6,R12,L10,R10,L8,L8,R10,R6,R12,L10,R10,L8,R12,L10,R12,R12,L10,R10,L8

# A,B,A,C,B,C,B,C,A,C
# A: R,12,L,10,R,12
# B: L,8,R,10,R,6
# C: R,12,L,10,R,10,L,8
