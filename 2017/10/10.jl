list = collect(0:255)
lengths = Array{UInt8}(readline(open("test")))
lengths = [lengths; [17, 31, 73, 47, 23]]

skip = 0
totalShift = 0
newshift = 0
rounds = 64

while rounds > 0
    l = deepcopy(lengths)
    while length(l) > 0
        revLeng = shift!(l)
        reverse!(list, 1, revLeng)
        newshift = revLeng + skip
        list = circshift(list, -newshift)
        totalShift += newshift
        skip += 1
    end
    rounds -= 1
end

list = circshift(list, totalShift)
d = []
for i in 0:15
    push!(d, hex(foldl(xor, list[1+i*16:16+i*16])))
end
res = ""
for a in d
    if length(a) == 1
        res *= "0" * a
    else
        res *= a
    end
end
println(res)
