if length(ARGS) != 1
    println("Need exactly one argument!")
    exit(1)
end

function parseInput(file)
    data = readlines(open(file))
    return parse.(Int, data)
end

# part 1
#println(sum(parseInput(ARGS[1])))

function partTwo()
    counts = Dict{Int, Int}()
    cf = 0
    data = parseInput(ARGS[1])
    notFound = true

    while notFound
        for i in data
            # println(i)
            if haskey(counts, cf)
                println(cf)
                notFound = false
                break
            else
                counts[cf] = 1
                cf += i
            end
        end
    end
end

partTwo()
