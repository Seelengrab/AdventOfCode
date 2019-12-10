function parseInput(inp, y, x)
    s = readline(inp)
    ppl = x*y
    res = zeros(Int, x,y,div(length(s), ppl))
    ind = 1
    for i in 1:ppl:length(s)
        w = [ parse(Int, x) for x in s[i:i+ppl-1] ]
        res[:,:,ind] .= reshape(w, y, x)'
        ind += 1
    end
    return res
end

function findNum0(d)
    mapslices(x -> count.(==(0), x), d, dims=[3]) |> x -> sum(x,dims=[1,2]) |> findmin |> x -> d[:,:,x[2][3]] |> x -> count(==(1), x)*count(==(2), x)
end

function imgAgg(d)
    res = similar(d[:,:,1])
    for i in axes(d,1)
        for j in axes(d,2)
            fb = findfirst(==(0), d[i,j,:])
            fw = findfirst(==(1), d[i,j,:])
            ft = findfirst(==(2), d[i,j,:])

            if fb !== nothing && fw !== nothing
                if fb < fw
                    px = 0
                else
                    px = 1
                end
            elseif fb !== nothing
                px = 0
            elseif fw !== nothing
                px = 1
            else
                px = 2
            end

            res[i,j] = px
        end
    end

    res
end