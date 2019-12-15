function moveTo(inp, path)
    m = Intmachine(0, deepcopy(inp), false)
    ic = m.inComm
    oc = m.outComm
    @async run!(m)

    for p in path
        put!(ic, p)
        take!(oc)
    end

    m
end

function findOxy(inp)
    log = Set()
    toVis = [(0,[],(0,0))]

    while !isempty(toVis)
        dist, path, pos = popfirst!(toVis)
        push!(log, pos)
        for dir in [1,2,3,4]
            bot = moveTo(inp, path)
            put!(bot.inComm, dir)
            status = take!(bot.outComm)
            if status == 2
                return cat(path, [dir], dims=1)
            elseif status == 1
                if dir == 1
                    npos = pos .+ (0,-1)
                elseif dir == 2
                    npos = pos .+ (0,1)
                elseif dir == 3
                    npos = pos .+ (1,0)
                elseif dir == 4
                    npos = pos .+ (-1,0)
                end

                if npos ∉ log
                    push!(toVis, (dist+1, cat(path, [dir], dims=1),npos))
                end
            end

            sort!(toVis, by = x -> x[1])
        end
    end
end

function findLongestPath(inp, oxyLoc)
    log = Set()
    maxPath = 0
    m = moveTo(inp, oxyLoc)
    toVis = [(0, m, (0,0))]
    furthest = 0

    while !isempty(toVis)
        dist, mech, pos = popfirst!(toVis)
        furthest = max(dist, furthest)
        @show furthest
        push!(log, pos)
        for dir in [1,2,3,4]
            bot = deepcopy(mech)
            bot.id += 1
            bot.inComm = Channel{Int}(Inf)
            bot.outComm = Channel{Int}(Inf)
            @async run!(bot)
            put!(bot.inComm, dir)
            status = take!(bot.outComm)
            if status != 0
                if dir == 1
                    npos = pos .+ (0,-1)
                elseif dir == 2
                    npos = pos .+ (0,1)
                elseif dir == 3
                    npos = pos .+ (1,0)
                elseif dir == 4
                    npos = pos .+ (-1,0)
                end

                if npos ∉ log
                    push!(toVis, (dist+1, bot, npos))
                end
            end

            sort!(toVis, by = x -> x[1])
        end
    end

    furthest
end