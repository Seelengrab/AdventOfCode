if (length(ARGS) != 1)
    println("need exactly one argument!")
    exit(1)
end

struct Edge
    A::Integer
    B::Integer
    size::Integer
end

Edge(a, b) = Edge(a, b, a+b)

input = map(x -> Edge(x[1], x[2]), map.(parse, split.(readlines(open(ARGS[1])), '/')))
starts = filter(x -> x.A == 0 || x.B == 0, input)
noStart = setdiff(input, starts)

function filterEnd(list::Array{Edge,N}, portSize::Integer) where N
    filter(x -> x.A == portSize || x.B == portSize, list)
end

function bb(bridge, pool, port)
    global strength
    global best
    nexts = filterEnd(pool, port)
    if isempty(nexts)
        return bridge
    end

    for n in nexts
        path = bb(hcat(bridge, n), setdiff(pool, [n]), n.A == port ? n.B : n.A)
        sp = sum(x -> x.size, path)
        if (sp > strength)
            strength = sp
            best = path
        end
    end

    return best
end

sols = []

function runBB()
    for s in starts
        global best = Array{Edge}()
        global strength = 0
        res = bb([s], noStart, s.size)
        push!(sols, res)
    end
end

function printSols()
    for sol in sols
        println("$(sum(x -> x.size, sol)) - $(indexin(sol, sols))")
    end
end
