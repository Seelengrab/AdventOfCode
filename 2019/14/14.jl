function parseInput(inp)
    lines = split.(readlines(inp), " => ")
    res = Dict{String,Tuple{Int,Dict{String,Int}}}()
    for l in lines
        quant, name = split(l[2], ' ')
        req = split(l[1], ", ")
        reqs = Dict(map(x -> x[2] => parse(Int,x[1]), split.(req, ' ')))
        res[name] = (parse(Int,quant), reqs)
    end

    res
end

findNumOre(recs, numFuel=1) = findNumOre(Dict("FUEL" => numFuel), Dict{String, Int}(), recs)

function findNumOre(needed, have, recipe)
    if length(collect(keys(needed))) == 1 && haskey(needed, "ORE")
        return needed["ORE"]
    end

    # println("--------")
    # @show needed
    # @show have
    # println()
    for (chem, quant) in needed
        chem == "ORE" && continue
        # @show chem, quant
        delete!(needed, chem)

        q, ingredients = recipe[chem]
        if get!(have, chem, 0) < quant
            while have[chem] < quant
                have[chem] += q

                for (c,iq) in ingredients
                    needed[c] = get!(needed, c, 0) + iq - get!(have, c, 0)
                    have[c] = 0
                end
            end
        end

        have[chem] -= quant
    end

    return findNumOre(needed, have, recipe)
end

function findMaxFuel(recs, x1=10_000, x2=100_000, numOre=1_000_000_000_000)
    y1 = findNumOre(recs, x1)
    y2 = findNumOre(recs, x2) # this one takes a little while
    delta = (y2-y1)/(x2 - x1)
    x = y1 - delta*x1
    ceil((numOre - x) / delta) |> Int
end