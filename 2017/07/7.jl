struct Node
    name::AbstractString
    weight::Number
    children::Array{Node}
end

function treeFromRoot!(name, lines)
    str = filter(x -> startswith(x, name), lines)[1]
    splice!(lines, indexin([str], lines)[1])

    w = parse(Int64, str[findin(str, "(")[1]+1:findin(str, ")")[1]-1])
    childind = findin(str, ">")
    if length(childind) > 0
        cs = split(str[childind[end]+2:end], ", ")
        c = map(x -> treeFromRoot!(x, lines), cs)
    else
        c = Array{Node}()
    end

    return Node(name, w, c)
end

function calcWeight(head::Node, found::Bool)
    if isassigned(head.children)
        cweights = map(c -> calcWeight(c, found), head.children)
        if !found && length(unique(cweights)) > 1
            prnt = hcat(map(x -> x.name, head.children), cweights)
            println("wrong children: $(head.name) -- $prnt")
        end
        w = head.weight + sum(cweights)
    else
        w = head.weight
    end
    return w
end

# lines = readlines(open("testInput"))
lines = readlines(open("input"))

l = filter(x -> contains(x, "->"), lines)
pointedTo = map(line -> split(line[findin(line, '>')[end]+2:end],", "), l)
pointedNames = Set()
names = Set()
for line in pointedTo
    for word in line
        push!(pointedNames, word)
    end
end
for line in l
    push!(names, line[1:findin(line, ' ')[1]-1])
end

root = ""
for name in names
    if !in(name, pointedNames)
        root = name
        break
    end
end

# build the tree
head = treeFromRoot!(root, lines)
calcWeight(head, false)
