f = open("input")
lines = readlines(f)
close(f)
# lines = split("aa bb cc dd ee
# aa bb cc dd aa
# aa bb cc dd aaa", "\n")

num = 0
for line in lines
    temp = split(line, " ")
    num += 1
    for a in temp
        if count(i->(i == a), temp) > 1
            num -= 1
            break
        end
    end
end

println(num)
