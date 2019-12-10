a = 1
b = 3
# i = 277678
i = 1024
cnt = 0

while true
    if (a^2 < i < b^2)
        break;
    end
    a += 2
    b += 2
    cnt += 1
end

println("$a -- $b -- $cnt")
