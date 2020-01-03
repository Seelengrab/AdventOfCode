using DataStructures, Memoize

const dirs = CartesianIndex.([(1,0),(0,1),(-1,0),(0,-1)])

function parseInput(inp)
    lines = readlines(inp)
    ret = fill('.', length(lines), length(lines[1]))
    start = CartesianIndex(1,1)
    for l in eachindex(lines)
        for l1 in eachindex(lines[1])
            c = lines[l][l1]
            if c == '@'
                start = CartesianIndex(l, l1)
            end
            ret[l,l1] = c
        end
    end
    ret, start
end

function printMap(maze, clear=false)
    io = IOBuffer()
    clear && print(io, "\u001B[2J")
    for x in axes(maze, 1)
        for y in axes(maze, 2)
            print(io,maze[x,y])
        end
        println(io)
    end
    print(String(take!(io)))
end

pos(maze,char) = findfirst(==(char), maze)

function BFS(maze, pos, goal)
    toVisit = BinaryMinHeap{Tuple{Int,Int32,Int32,CartesianIndex{2}}}()
    visited = Set{CartesianIndex{2}}()
    
    push!(toVisit, (0,0,0,pos))
    while !isempty(toVisit)
        ret = pop!(toVisit)
        cost, doors, keys, pos = ret
        block = maze[pos]
        
        if block == goal
            return cost, doors, keys, pos
        end
        
        push!(visited, pos)
        
        for d in dirs
            npos = pos + d
            maze[npos] == '#' && continue
            npos ∈ visited && continue
            
            block = maze[pos]
            if isuppercase(block)
                doors |= 1 << Int(block - 'A')
            end
            if islowercase(block)
                keys |= 1 << Int(block - 'a')
            end
            
            push!(toVisit, (cost+1, doors, keys, npos))
        end
    end
end

function reachable(curKey, key, gotKeys, cache)
    _, doors, _, _ = cache[curKey,key]
    doors ⊻ (doors & gotKeys) == 0 
end

function buildDistCache(maze, start)
    nkeys = count(islowercase, maze)
    keys = filter(islowercase, maze) |> sort
    allKeys = Int32[ 1 << i for i in 0:nkeys-1 ]

    dists = Dict{Tuple{Int,Int},Tuple{Int,Int32,Int32,CartesianIndex{2}}}()
    for i in eachindex(allKeys)
        for j in eachindex(allKeys)
            k1 = keys[i]
            k2 = keys[j]
            a = allKeys[i]
            b = allKeys[j]
            haskey(dists, (a,b)) && continue
            haskey(dists, (b,a)) && continue
            dists[a,b] = BFS(maze, pos(maze, k1), k2)
            dists[b,a] = BFS(maze, pos(maze, k2), k1)
        end
    end

    for (i,k) in enumerate(allKeys)
        dists[-1,k] = BFS(maze, start, keys[i])
    end

    dists
end

function solveMaze(inp, showProgress=true)
    maze, start = parseInput(inp)
    showProgress && printMap(maze, true)
    nkeys = count(islowercase, maze)
    allKeys = Int32[ 1 << i for i in 0:nkeys-1 ]
    
    toVisit = BinaryMinHeap{Tuple{Int,Int,Int32,CartesianIndex{2}}}()
    visited = Dict{Tuple{Int,CartesianIndex{2}},Int}()
    
    distCache = buildDistCache(maze, start)
    push!(toVisit, (0, 0, 0, start))

    while !isempty(toVisit)
        _, cost, gotKeys, pos = pop!(toVisit)
        if pos != start
            curKey = 1 << Int(maze[pos] - 'a')
        else
            curKey = -1
        end
        
        showProgress && print(rpad("\r$cost - $curKey:$(bitstring(gotKeys)):$gotKeys - $(length(toVisit)) ", 60))

        if count_ones(gotKeys) == nkeys
            showProgress && println()
            return cost
        end

        visited[gotKeys, pos] = cost

        for k in allKeys
            (k & gotKeys) > 0 && continue
            !reachable(curKey, k, gotKeys, distCache) && continue
            cost_to, _, wayKeys, npos = distCache[curKey,k]
            
            newKeys = gotKeys | wayKeys | k
            ncost = cost + cost_to
            
            heuristic = ncost # + heur(maze, newKeys, setdiff(allKeys, newKeys), npos)
            get!(visited, (newKeys, npos), typemax(Int)) <= ncost && continue
            push!(toVisit, (heuristic, ncost, newKeys, npos))
        end
    end
end
