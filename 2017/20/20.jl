input = readlines(open(ARGS[1]))
matcher = r"(-?\d+,){2}-?\d+"

input = [ [ y.match for y in x ]  for x in eachmatch.(matcher, input) ]
input = [ split.(line, ",") for line in input ]
input = [ [ parse.(line[1]), parse.(line[2]), parse.(line[3]) ] for line in input ]

function doStuff()
    while true
        # for part 2
        println(length(input))
        filter!(it -> count(it2 -> it2[1] == it[1], input) == 1, input)

        for i in 1:length(input)
            input[i][2] = input[i][2] .+ input[i][3]
            input[i][1] = input[i][1] .+ input[i][2]
        end

        # for part 1
        # sort!(input, by = x -> sum(abs.(x[1])))
    end
end
