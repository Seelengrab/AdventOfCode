input = 355
# input = 3
a = [0]
pos = 1
p = 0

for i in 1:2017
    # println(a)
    pos = ((pos + input) % length(a)) + 1
    insert!(a, pos+1, i)
end

println(a)
println(a[2])
