#if length(ARGS) != 1
#    println("Need exactly one argument!")
#    exit(1)
#end

function parseInput(file)
    return readline(file)
end

function react(polymer)
    println(length(polymer))
    for i in 1:length(polymer)-1
        if polymer[i] != polymer[i+1] && (polymer[i] == lowercase(polymer[i+1]) || lowercase(polymer[i]) == polymer[i+1])
            return react(polymer[1:i-1] * polymer[i+2:end])
        end
    end

    return polymer
end

input = parseInput("input.1")
#part 1
#res = react(input)
#println(length(res))
#exit(0)

#smallestVal = 999999999999
#for c in 'a':'z'
#    print("\rTrying $c...")
#    global smallestVal
#    temp = length(react(replace(input, Regex("$c|$(uppercase(c))") => "")))
#    if temp < smallestVal
#        smallestVal = temp
#    end
#end

#println()
#println(smallestVal)
