function parseInput(inp)
    map(x -> split(x, ['[',']']), readlines(inp))
end

## part 1

function isAbba(word)
    return  length(word) == 4 &&
            word[1] != word[2] &&
            word[1] == word[4] && word[2] == word[3]
end

function hasAbba(text)
    for pos in 1:length(text)-3
        isABBA(text[pos:pos+3]) ? (return true) : continue
    end
    return false
end

function supportsTLS(line)
    all(.!hasAbba.(line[2:2:end])) && any(hasAbba.(line[1:2:end]))
end

## part 2

function isAba(word)
    return  length(word) == 3 &&
            word[1] != word[2] &&
            word[1] == word[3]
end

function findAba(text)
    ret = String[]
    for pos in 1:length(text)-2
        w = text[pos:pos+2]
        isAba(w) ? push!(ret, w) : continue
    end
    return ret
end

function getBab(word)
    string(word[2], word[1], word[2])
end

function supportsSSL(line)
    aba = collect(Iterators.flatten(findAba.(line[1:2:end])))
    any(x -> any(contains.(line[2:2:end], x)), getBab.(aba))
end

println("TLS: ", count(supportsTLS.(parseInput("input"))))
println("SSL: ",count(supportsSSL.(parseInput("input"))))
