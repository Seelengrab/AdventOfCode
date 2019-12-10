function parseInput(inp)
    map.(x -> (x[1], parse(Int, x[2:end])),  split.(readlines(inp), ','))
end

const right = [0,1]
const left = [0,-1]
const up = [-1,0]
const down = [1,0]

function runMap(inp, midPoint)
    map = spzeros(Int, midPoint*2 + 1, midPoint*2 + 1)
    id = 0

    for wire in inp
        pos = [midPoint, midPoint]
        id += 1
        totalPath = 0
        for (dir, len) in wire
            for i in 1:len
                if dir == 'R'
                    pos .+= right
                elseif dir == 'L'
                    pos .+= left
                elseif dir == 'U'
                    pos .+= up
                elseif dir == 'D'
                    pos .+= down
                else
                    error("Illegal direction: $dir")
                end

                # part 1
                if map[pos[1], pos[2]] != id && map[pos[1], pos[2]] > 0
                    map[pos[1], pos[2]] = -1
                else
                    map[pos[1], pos[2]] = id
                end
            end
        end
        # push!(maps, map)
    end

    # display(map)
    # part 1
    tmp = Tuple.(findall(<(0), map))
    m = typemax(Int)
    for i in eachindex(tmp)
        t = sum(abs.(tmp[i] .- midPoint))
        m = min(t, m)
    end
    return m

    # part2
    # @show any.(!=(0), maps)
    # r = []
    # for i in axes(maps[1], 1), j in axes(maps[1], 2)
    #     if maps[1][i,j] != 0 && maps[2][i,j] != 0
    #         push!(r, (i,j))
    #     end
    # end

    # mask = (maps[1] .!= 0) .& (maps[2] .!= 0)
    # # @show any(mask)
    # sort(sum.(r))
    # maps, sort(sum.(zip(maps[1][mask], maps[2][mask])))
end