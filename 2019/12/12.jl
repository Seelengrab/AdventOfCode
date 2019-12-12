using StaticArrays, Combinatorics

function parseInput(inp)
    moon.(map(x -> parse.(Int, x), split.(map(x -> x[4:end-1], readlines(inp)), r", .=")))
end

struct moon
    pos::MVector{3,Int}
    vel::MVector{3,Int}

    moon(pos, vel=MVector{3}([0,0,0])) = new(MVector{3}(pos), vel)
end

Base.show(io::IO, m::moon) = begin
    print(io, "pos=" * string(m.pos) * ", vel=" * string(m.vel))
end

function energy(m::moon)
    pot = abs.(m.pos) |> sum
    kin = abs.(m.vel) |> sum
    pot*kin
end

function simulate!(moons, steps)
    caches = [ Dict([(map(x -> x.pos[i], moons),map(x -> x.vel[i], moons)) => 0]) for i in 1:3 ]
    cycles = [-1 -1 -1]

    # for s in 1:steps # part 1
    s = 0
    while any(==(-1), cycles)
        p = powerset(eachindex(moons),2,2)
        for (m1,m2) in p
            total = (moons[m1].pos .> moons[m2].pos) .- (moons[m1].pos .< moons[m2].pos)
            moons[m1].vel .-= total
            moons[m2].vel .+= total
        end

        for m in moons
            m.pos .+= m.vel
        end

        for i in 1:3
            if cycles[i] == -1
                p = map(x -> x.pos[i], moons)
                v = map(x -> x.vel[i], moons)
                if haskey(caches[i], (p,v))
                    cycles[i] = s - caches[i][(p,v)] + 1
                else
                    caches[i][(p,v)] = steps
                end
            end
        end

        s += 1
        @show s, cycles
    end

    # part 2
    println(lcm(big.(cycles)...))

    # part 1
    # println("After $steps steps:")
    # for m in moons
    #     display(m)
    # end
    # println()
    # println("Energy after $steps steps")
    # total = 0
    # for m in moons
    #     e = energy(m)
    #     display(e)
    #     total += e[3]
    # end
    # println("Sum total: $total")
end