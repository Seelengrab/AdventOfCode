lines = readlines(open("input"))

lines = map(l -> replace(replace(l, r"!.", ""), r"<[^>.]*>", ""), lines)

for line in lines
    curScore = 0
    Score = 0
    for c in line
        if c == '{'
            curScore += 1
        elseif c == '}'
            Score += curScore
            curScore -= 1
        end
    end
    println("Score: $Score")
end

# for part 2:
# m = matchall(r"<[^>.]*>", replace(l, r"!.", ""))
# sum(length.(m))
