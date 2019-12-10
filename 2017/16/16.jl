coms = split(readline(open("input")), ",")
progs = Char.(collect(Int('a'):Int('p')))
len = length(progs)
println(String(UInt8.(progs)))
def = deepcopy(progs)
count = 0
while true
for line in coms
    com = line[1]
    if com == 's'
        progs = circshift(progs, parse(line[2:end]))
    elseif com == 'x'
        l = parse.(split(line[2:end], "/"))
        a = l[1] + 1
        b = l[2] + 1
        perm = collect(1:len)
        perm[a] = b
        perm[b] = a
        permute!(progs, perm)
    elseif com == 'p'
        l = split(line[2:end], "/")
        a = findfirst(progs, l[1][1])
        b = findfirst(progs, l[2][1])
        perm = collect(1:len)
        perm[a] = b
        perm[b] = a
        permute!(progs, perm)
    end
end
count += 1
# progs == def && break # used to find an initial cycle for the given dance moves
count == 40 && break # used for breaking on 1e9 % 60 = 40 moves
end

print(String(UInt8.(progs)))
println(" $count")
