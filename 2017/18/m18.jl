using mod18

input = split.(readlines(open(ARGS[1])))
cA = RemoteChannel(() -> Channel{Int}(100), 1)
cB = RemoteChannel(() -> Channel{Int}(100), 1)

retA = @spawnat 2 mod18.init(0, input, cA, cB)
retB = @spawnat 3 mod18.init(1, input, cB, cA)
fetch(retA)
fetch(retB)
