if length(ARGS) != 1
    println("Need exactly one argument!")
    exit(1)
end

mutable struct Node
    numChilds::Int
    numMeta::Int
    childs::Array{Node,1}
    meta::Array{Int,1}

    Node(a, b) = Node(a, b, Node[], Int[])
    Node(a, b, c, d) = new(a,b,c,d)
end

Base.sum(n::Node) = sum(n.meta) + (isempty(n.childs) ? 0 : sum(sum, n.childs))
Base.length(n::Node) = 2 + n.numMeta + (isempty(n.childs) ? 0 : sum(length, n.childs))

function parseInput(file)
    return parse.(Int, split(readline(file)))
end

function buildTree(data)
    ret = Node(data[1], data[2])
    offset = 2

    for i in 1:ret.numChilds
        data = data[offset+1:end]
        if data[1] == 0 # no children! hurray!
            n = Node(data[1], data[2], Node[], data[3:2+data[2]])
            push!(ret.childs, n)
            offset = length(n)
        else
            n = Node(data[1], data[2])
            offset = calcLength(data)

            push!(ret.childs, buildTree(data[1:offset]))
        end
    end

    ret.meta = data[end-ret.numMeta+1:end]
    return ret
end

function calcLength(data)
    if isempty(data)
        return 0
    end

    offset = 2
    numChilds = data[1]
    numMeta = data[2]
    for i in 1:numChilds
        offset += calcLength(data[offset+1:end])
    end
    return offset + numMeta
end

function value(n::Node)
    if n.numChilds == 0
        return sum(n.meta)
    end

    entries = filter(x -> x > 0 && x <= n.numChilds, n.meta)
    if length(entries) > 0
        return sum(value, n.childs[entries])
    else
        return 0
    end
end

data = parseInput(ARGS[1])

tree = buildTree(data)
println(value(tree))
#println(sum(tree))