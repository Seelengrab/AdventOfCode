function parseInput(inp)
    parse.(Int, split(readline(inp), '-'))
end

twoAdjSame(ds::Int) = twoAdjSame(digits(ds))
function twoAdjSame(ds)
    for i in 1:length(ds)-1
        if ds[i] == ds[i+1]
            return true
        end
    end

    return false
end

twoAdjPart2(ds::Int) = twoAdjPart2(digits(ds))
function twoAdjPart2(ds)
    for i in ds
        if count(==(i), ds) == 2
            return true
        end
    end

    return false
end

neverDecrease(d::Int) = neverDecrease(digits(d))
function neverDecrease(ds)
    for i in length(ds):-1:2
        if ds[i] > ds[i-1]
            return false
        end
    end

    return true
end

fits(pw) = twoAdjPart2(pw) &&
            neverDecrease(pw) &&
            length(pw) == 6

function findNumPw(min, max)
    cntr = 0

    for pw in min:max
        ds = digits(pw)
        if fits(ds)
            cntr += 1
        end
    end

    return cntr
end