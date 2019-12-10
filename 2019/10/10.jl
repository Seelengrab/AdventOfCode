function parseInput(inp)
    f = split.(readlines(inp), "")
    s = size(f[1])[1], size(f)[1]
    f |> Iterators.flatten |> collect |> x -> reshape(x, s...) |> x -> getindex.(x,1) |> transpose
end

Base.transpose(c::Char) = c

function visAsteroids(locs, a)
    dists = map(y -> y .- a, locs) |> x -> filter(!=((0,0)), x)
    return map(x -> div.(x, gcd(x...)), dists) |> unique |> length
end

getLocs(asts) = findall(==('#'), asts) |> x -> map(y -> (y.I[2]-1,y.I[1]-1), x)

function findLocation(asts)
    locs = getLocs(asts)
    maxAst = 0
    loc = (0,0)

    for a in locs
        n = visAsteroids(locs, a)
        if n > maxAst
            loc = a
            maxAst = n
        end
    end

    loc, maxAst
end

function cart2pol(c)
    len = sqrt(c.^2 |> sum)
    ang =  atan(c[2],c[1]) |> rad2deg
    if ang > 90
        ang = 450 - ang
    elseif ang > 0
        ang = 90 - ang
    else
        ang = 90 + abs(ang)
    end
    ang, len
end

function vaporize(asts, station)
    locs = getLocs(asts) |> x -> map(y -> (y .- station) .* (1,-1), x) |> x -> filter(!=((0,0)), x)
    display(locs)
    goal = min(299, length(locs))
    firings = 0
    oldAngle = -eps(Float64)

    while firings != goal
        if all(oldAngle .>= getindex.(cart2pol.(locs), 1))
            oldAngle = -eps(Float64)
        end
        sorted = sort(locs, by = cart2pol)
        s = filter(y -> cart2pol(y)[1] > oldAngle, sorted)
        firings += 1
        if firings in [1,2,3,10,20,50,100,199,200,201,299]
            t = (s[1] .* (1,-1)) .+ station
            @show firings, t, cart2pol(s[1])
        end
        oldAngle = cart2pol(s[1])[1]
        setdiff!(locs, [s[1]])
    end
end