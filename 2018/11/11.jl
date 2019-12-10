if length(ARGS) != 1
    println("Need exactly one argument!")
    exit(1)
end

function parseInput(file)
    return parse(Int, readline(file))
end

function getPower(x, y, serial)
    rackId = x + 10
    power = rackId * y
    power += serial
    power *= rackId
    p = div((power % 1000), 100)
    return p - 5
end

function innerLoop(cellsize, bX, bY, bC, largestPower, grid)
    for y in 1:(300 - cellsize)
        for x in 1:(300 - cellsize)
            power = sum(grid[x:x+cellsize, y:y+cellsize])
            if power > largestPower
                largestPower = power
                bX = x
                bY = y
                bC = cellsize
            end
        end
    end
    return bX, bY, bC, largestPower
end

function doStuff(serial)
    grid = zeros(Int, 300, 300)

    for y in 1:300
        for x in 1:300
            grid[x,y] = getPower(x, y, serial)
        end
    end

    largestPower = -999
    bX = 0
    bY = 0
    bC = 0
    for cellsize in 0:299
        print("\rcellsize: $cellsize")
        for y in 1:(300 - cellsize)
            for x in 1:(300 - cellsize)
                power = sum(grid[x:x+cellsize, y:y+cellsize])
                if power > largestPower
                    largestPower = power
                    bX = x
                    bY = y
                    bC = cellsize + 1
                    println("\r$bX,$bY,$bC, Power: $largestPower")
                end
            end
        end
    end
end

doStuff(parseInput(ARGS[1]))