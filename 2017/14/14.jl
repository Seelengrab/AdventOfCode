using knothash

function findRegions!(arr)
    count = 0
    marked = zeros(Bool, 128,128)

    for x in 1:128
        for y in 1:128
            if arr[x,y] == 1 && !marked[x,y]
                count += 1
                markRegion!(x, y, arr, marked, count)
            end
        end
    end

    return count
end

function markRegion!(x, y, arr, marked, reg)
    if arr[x, y] != 1 || marked[x, y]
        return
    end

    marked[x,y] = true
    arr[x,y] = reg
    x < 128 && markRegion!(x+1, y, arr, marked, reg)
    y < 128 && markRegion!(x, y+1, arr, marked, reg)
    x > 1 && markRegion!(x-1, y, arr, marked, reg)
    y > 1 && markRegion!(x, y-1, arr, marked, reg)
end

inp = readline(open("input"))
hashes = [ khash(inp * "-" * string(i)) for i in 0:127 ]
bitHashes = map(x ->  foldl(*, bits.(x)), hex2bytes.(hashes))
numOnes = sum(count.(x -> x == '1', bitHashes))

println(numOnes) # part one done

arr = zeros(Int, 128,128)

for x in 1:128
    for y in 1:128
        arr[x,y] = (bitHashes[x][y] == '1' ? 1 : 0)
    end
end

res = findRegions!(arr)
println(res)
