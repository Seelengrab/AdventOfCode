input = 355
pos = 0
n = 0
size = 1

for i in 1:5e7
    pos = ((pos + input) % i) + 1
    # println("$pos : $i")
    if pos == 1
        n = i
        # println(n)
    end
end

println(n)
