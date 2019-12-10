if length(ARGS) != 1
    println("Need exactly one argument!")
    exit(1)
end

function parseInput(file)
    lines = readlines(file)
    data = split.(lines, " must be finished before step ")
    parsed = [ [x[1][end] x[2][1]] for x in data ]
    cleaned = reshape(collect(Iterators.flatten(parsed)), (2, length(parsed)))
    swapped = permutedims(cleaned, (2,1))
    posVals = length(unique(swapped))
    d = falses(posVals, posVals)
    for c in axes(swapped, 1)
        index = Int(swapped[c,1]) - Int('@')
        val = Int(swapped[c,2]) - Int('@')
        d[index, val] = true
    end
    @show d
    return d
end

function partOne(data)
    res = ""
    for _ in axes(data, 1)
        posNext = findall(.!reduce(|, data, dims=1))
        smallest = sort(posNext)[1].I[2]
        res *= '@' + smallest
        data[smallest,:] .= false
        data[smallest, smallest] = true
    end
    println(res)
end

function partTwo(data, timeOffset, numWorkers)
    time = 0
    done = Int[]
    curWork = Int[]
    times = [ timeOffset + c for c in axes(data, 1) ]
    println(times)
    while length(done) < size(data, 1)
        for c in curWork
            if times[c] == 0
                deleteat!(curWork, findall(x -> x == c, curWork))
                push!(done, c)
                data[c,:] .= false
                # data[smallest, smallest] = true
            end
        end

        if length(curWork) < numWorkers
            posNext = findall(.!reduce(|, data, dims=1))
            smallest = map(x -> x.I[2], posNext)
            filtered = sort(filter(x -> ! (x in done || x in curWork), smallest))
            while !isempty(filtered) && length(curWork) < numWorkers
                push!(curWork, popfirst!(filtered))
            end
        end

        # println(curWork)
        for c in curWork
            times[c] -= 1
        end

        time += 1
    end
    time -= 1
    println(time)
end

data = parseInput(ARGS[1])
# partOne(data)
partTwo(data, 60, 5)