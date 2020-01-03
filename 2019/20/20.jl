function parseInput(inp)
    lines = readlines(inp)
    ret = fill(' ', size(lines,1), maximum(length.(lines)))
    dirs = CartesianIndex.([(1,0),(0,1),(-1,0),(0,-1)])
    portals = Dict{String, Array{CartesianIndex{2},1}}()

    for l in axes(lines, 1)
        for c in 1:length(lines[l])
            if isuppercase(lines[l][c])
                (c == length(lines[l]) || l == size(lines, 1)) && continue
                if isuppercase(lines[l][c+1])
                    if c < length(lines[l])-1 && lines[l][c+2] == '.'
                        ret[l,c] = ' '
                        ret[l,c+1] = '*'
                        data = get!(portals, lines[l][c] * lines[l][c+1], Array{CartesianIndex{2},1}[])
                        push!(data, CartesianIndex(l,c+2))
                    elseif lines[l][c-1] == '.'
                        ret[l,c] = '*'
                        ret[l,c+1] = ' '
                        data = get!(portals, lines[l][c] * lines[l][c+1], Array{CartesianIndex{2},1}[])
                        push!(data, CartesianIndex(l,c-1))
                    end
                elseif isuppercase(lines[l+1][c])
                    if l < size(lines,1)-1 && lines[l+2][c] == '.'
                        ret[l,c] = ' '
                        ret[l+1,c] = '*'
                        data = get!(portals, lines[l][c] * lines[l+1][c], Array{CartesianIndex{2},1}[])
                        push!(data, CartesianIndex(l+2,c))
                    elseif lines[l-1][c] == '.'
                        ret[l,c] = '*'
                        ret[l+1,c] = ' '
                        data = get!(portals, lines[l][c] * lines[l+1][c], Array{CartesianIndex{2},1}[])
                        push!(data, CartesianIndex(l-1,c))
                    end
                end
            else
                ret[l,c] = lines[l][c]
            end
        end
    end
    # printMap(ret)
    portalMapping = Dict{CartesianIndex{2},CartesianIndex{2}}()
    for (_,v) in portals
        length(v) == 1 && continue
        portalMapping[v[1]] = v[2]
        portalMapping[v[2]] = v[1]
    end
    ret, portals["AA"][1], portals["ZZ"][1], portalMapping
end

function printMap(maze, io=stdout)
    for x in axes(maze,1)
        for y in axes(maze,2)
            print(io,maze[x,y])
        end
        println(io)
    end
end

function solveMaze(inp)
    maze, startPos, endPos, portals = parseInput(inp)
    dirs = CartesianIndex.([(1,0),(0,1),(-1,0),(0,-1)])
    visited = Set{Tuple{CartesianIndex{2},Int}}()
    toVisit = [(0,startPos,1)]

    while !isempty(toVisit)
        cost, pos, depth = popfirst!(toVisit)
        print("\rcost: $cost - depth; $depth - toCheck: $(length(toVisit))")

        if pos == endPos && depth == 1
            return cost
        end

        (pos, depth) ∈ visited && continue
        push!(visited, (pos, depth))
        for d in dirs
            npos = pos + d
            maze[npos] ∉ ['.','*'] && continue
            if maze[npos] == '*'
                if haskey(portals, pos)
                    portal = portals[pos]
                    ndepth = 1
                    
                    # part 2
                    tpos = Tuple(pos)
                    if any(==(3), tpos) || any(tpos .== size(maze).-2)
                        depth == 1 && continue
                        ndepth = depth - 1
                    else
                        ndepth = depth + 1
                    end
                    
                    push!(toVisit, (cost+1, portal, ndepth))
                end
            else
                push!(toVisit, (cost+1, npos, depth))
            end
        end

        sort!(toVisit, by = x -> (x[3],x[1]))
    end
end
