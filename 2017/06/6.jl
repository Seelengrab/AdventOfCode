function balance(arr)
    narr = deepcopy(arr)
    m = maximum(narr)
    mi = indmax(narr)
    narr[mi] -= m
    while m > 0
        mi = mi == length(narr) ? 1 : mi+1
        narr[mi] += 1
        m -= 1
    end
    return narr
end

val = [10,3,15,10,5,15,5,15,9,2,5,8,5,2, 3, 6]
# val = [0,2,7,0]
cache = [val]
val = balance(val)

while !in(val, cache)
    push!(cache, val)
    val = balance(val)
end

# println(cache)
println("$(length(cache)) -- $(length(cache) - findfirst(cache, val))")
