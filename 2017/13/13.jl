layers = map(x -> parse.(x), split.(readlines(open("input")), ": "))
ld = Dict{Int, Int}()

function moveScanners!(firewall)
    for i in 1:length(firewall)
        layer = firewall[i]
        pos = findfirst(layer)
        if pos == 0
            continue
        elseif pos == 1
            layer[pos] = abs(layer[pos])
        elseif pos == length(layer)
            layer[pos] *= -1
        end

        firewall[i] = circshift(layer, sign(layer[pos]))
    end
end

for layer in layers
    ld[layer[1]] = layer[2]
end

numLayers = maximum(keys(ld))
firewall = Array{Array{Int,1}}(numLayers+1)

for i in 0:numLayers
    if haskey(ld, i)
        nA = zeros(Int, ld[i])
        # nA[1] = i*ld[i]
        nA[1] = 1
        firewall[i+1] = nA
    else
        firewall[i+1] = [0]
    end
end


severity = -1
ps = 0
minsev = 9999999999999999999
maxsev = -1
while severity != 0
    fw = deepcopy(firewall)
    moveScanners!(firewall)
    println(ps)
    ps += 1
    severity = 0
    for i in 1:length(fw)
        if fw[i][1] != 0
            severity = -1
            break;
        end
        moveScanners!(fw)
    end
    if severity == 0
        println(fw)
    end
end

