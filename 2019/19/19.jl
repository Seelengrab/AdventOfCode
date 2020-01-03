using .Intcode

function part1(inp, minX=1,minY=1,sizeX=10,sizeY=10)
    cnt = 0
    for x in (minX-1):(minX+sizeX-1)
        for y in (minY-1):(minY+sizeY-1)
            m = Intmachine(0,deepcopy(inp),false)
            inC = m.inComm
            outC = m.outComm
            t = @async run!(m)
            put!(inC, x)
            put!(inC, y)
            res = take!(outC)
            print(res == 0 ? '.' : '#')
            cnt += res
        end
        println()
    end

    cnt
end

function checkCoords(inp,x,y)
    m = Intmachine(0, deepcopy(inp), false)
    @async run!(m)
    put!(m.inComm, x)
    put!(m.inComm, y)
    take!(m.outComm)
end

function part2(inp)
    minY = 1000
    for x in 1600:2000
        while checkCoords(inp, x, minY) == 0
            minY += 1
        end

        @show x,minY
        for y in minY:9999
            checkCoords(inp,x,y+99) == 0 && break
            if checkCoords(inp, x+99, y) == 1
                return x*10_000+y
            end
        end
    end
end