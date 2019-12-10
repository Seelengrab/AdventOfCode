input = readlines(open("input"))
inDic = Dict{Int, Array{Int}}()

# input parsing
for line in input
    l = split(line, " <-> ")
    key = parse(l[1])
    val = map(parse, split(l[2], ", "))
    inDic[key] = val
end

# finds the group of the given node
function findGroup(node::Int)
    vis = [node]
    work = inDic[node]

    for node in work
        if !in(node, vis)
            push!(vis, node)
        end

        neighbours = inDic[node]
        for n in neighbours
            if !(in(n, work) || in(n, vis))
                push!(work, n)
            end
        end
    end
    return vis
end

function groups()
    groups = []
    vis = findGroup(0)
    push!(groups, vis)
    toCheck = setdiff(keys(inDic), vis)
    while length(toCheck) > 0
        g = findGroup(toCheck[1])
        vis = union(vis, g)
        push!(groups, g)
        toCheck = setdiff(keys(inDic), vis)
    end
    return groups
end

res = groups()
println(length(res))
