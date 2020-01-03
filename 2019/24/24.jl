function parseInput(inp)
    lines = readlines(inp)
    ret = fill('.', length(lines), length(lines[1]))

    for x in axes(ret, 1)
        for y in axes(ret,2)
            ret[x,y] = lines[x][y]
        end
    end

    ret
end

function updateBugs!(buffers, bugMaps)
    curKeys = keys(bugMaps) |> collect |> sort
    for bugIndex in curKeys
        bugMap = bugMaps[bugIndex]
        outerMap = get!(bugMaps, bugIndex-1, fill('.', size(bugMap)))
        innerMap = get!(bugMaps, bugIndex+1, fill('.', size(bugMap)))
        innerMap[3,3] = '?'
        outerMap[3,3] = '?'
        

        get!(buffers, bugIndex+1, fill('.', size(bugMap)))
        get!(buffers, bugIndex-1, fill('.', size(bugMap)))
        curBuffer = get!(buffers, bugIndex, fill('.', size(bugMap)))
        curBuffer[3,3] = '?'

        for x in axes(bugMap,1)
            for y in axes(bugMap, 2)
                x == y == 3 && continue

                count = 0

                if x == 1
                    count += outerMap[2,3] == '#'
                elseif x == 5
                    count += outerMap[4,3] == '#'
                end

                if y == 1
                    count += outerMap[3,2] == '#'
                elseif y == 5
                    count += outerMap[3,4] == '#'
                end

                if x > 1
                    count += bugMap[x-1,y] == '#'
                end
                if y > 1
                    count += bugMap[x,y-1] == '#'
                end

                if x == 2 && y == 3
                    count += sum(==('#'), innerMap[1,:])
                elseif x == 4 && y == 3
                    count += sum(==('#'), innerMap[5,:])
                elseif x == 3 && y == 2
                    count += sum(==('#'), innerMap[:,1])
                elseif x == 3 && y == 4 
                    count += sum(==('#'), innerMap[:,5])
                end

                if x < size(bugMap,1)
                    count += bugMap[x+1,y] == '#'
                end
                if y < size(bugMap,2)
                    count += bugMap[x,y+1] == '#'
                end
                
                if bugMap[x,y] == '#'
                    curBuffer[x,y] = count == 1 ? '#' : '.' 
                else
                    curBuffer[x,y] = count == 1 || count == 2 ? '#' : '.'
                end
            end
        end

        println("Depth: $bugIndex")
        printMap(bugMap)
        println()
        printMap(curBuffer)
        read(stdin, Char)
        println("-------")
    end
end

function biodiversity(chart)
    diversity = 0
    cnt = 0
    
    for x in axes(chart,1)
        for y in axes(chart,2)
            diversity += (chart[x,y] == '#') * 2^cnt
            cnt += 1
        end
    end

    diversity
end

function printMap(maze, io=stdout)
    for x in axes(maze,1)
        for y in axes(maze,2)
            print(io,maze[x,y])
        end
        println(io)
    end
end

function runSimul(inp)
    bugMaps = Dict{Int,Matrix{Char}}(0 => parseInput(inp))
    bufs = Dict{Int,Matrix{Char}}()
    # printMap(bugMaps[0])
    
    for _ in 1:10
        updateBugs!(bufs, bugMaps)
        
        for (idx, map) in bufs
            # println("\nDepth $idx:")
            # printMap(map)
            bugMaps[idx] = deepcopy(map)
        end
        
    end

    total = 0
    for (_,b) in bugMaps
        total += count(==('#'), b)
    end
    total
end