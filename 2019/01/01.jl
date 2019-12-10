function parseInput(inp)
    return parse.(Int, readlines(inp))
end

function fuelReq(mass)
    return div(mass, 3) - 2
end

function fuelSum(mass) # saving the stack
    fuel = fuelReq(mass)
    nfuel = fuel
    while true
        nfuel = fuelReq(nfuel)
        nfuel <= 0 && break
        fuel += nfuel
    end
    return fuel
end

function fuelRek(fuel)
    f = fuelReq(fuel)
    f <= 0 && return fuel
    return fuel + fuelRek(f)
end