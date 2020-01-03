using SparseArrays, LinearAlgebra

function parseInput(inp)
    parse.(Int, split(readline(inp), ""))
end

function buildMat(input) # only suitable for part 1
    m = spzeros(Int8, size(input,1), size(input,1))
    j_max = size(m, 2)

    for i in axes(m, 1)
        for j in i:4*i:j_max
            j_tmp = j+i-1
            j_end = ifelse(j_tmp < j_max, j_tmp, j_max)
            @inbounds m[i,j:j_end] .= 1

            j_tmp += 2*i
            j_end = ifelse(j_tmp < j_max, j_tmp, j_max)
            @inbounds m[i,j+2*i:j_end] .= -1
        end
    end

    return m
end

function calcFFT(d) # only suitable for part 1
    d2 = similar(d)
    m = buildMat(d)

    for _ in 1:100
        mul!(d2, m, d)
        d .= abs.(d2) .% 0xA
    end

    for i in 1:8
        print(d[i])
    end
end

function part2(inp)
    d = repeat(parseInput(inp),outer=10_000)
    offset = foldl((x,y) -> x*10+y, d[1:7], init=0) % length(d)
    @show d[1:7]
    @show offset
    r = deepcopy(d[offset+1:end])
    r2 = similar(r)
    @show length(r)

    for _ in 1:100
        r2[end] = r[end]
        for i in 1:size(r,1)-1
            r2[end-i] = (r2[end-i+1] + r[end-i]) % 10
        end
        tmp = r2
        r2 = r
        r = tmp
    end

    for i in 1:8
        print(r[i])
    end
end