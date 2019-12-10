mutable struct Bot
    id::Integer
    hold::Integer
end

struct nextLink
    next::String
    id::Integer
end

Bot(id, hold) = Bot(id, -1)
Bot(id) = Bot(id, -1)
Base.hash(b::Bot) = hash(b.id)
Base.:(==)(a::Bot, b::Bot) = a.hold == b.hold && a.id == b.id

function updateBot!(b::Bot, val::Int, botDict::Dict{Int, Dict}, bins)
    if (b.hold == 61 && val == 17) || (b.hold == 17 && val == 61)
        println("It's me - $(b.id)")
    end

    if b.hold == -1
        b.hold = val
        return
    end

    lower = min(b.hold, val)
    higher = max(b.hold, val)
    b.hold = -1

    next = botDict
    updateBot!()

end

function parseInput(inp::String)
    inpLines = readlines(inp)
    filteredVals = filter(x -> occursin(r"^value", x), inpLines)
    vals = map.(x -> Meta.parse.(x),
                split.(replace.(filteredVals, Ref(r"value | goes to bot " => " "))))::Array{Array{Int,1},1}

    filteredBots = filter(x -> occursin(r"^bot", x), inpLines)
    simplified = replace.(filteredBots, Ref(r"^bot | gives low to | and high to " => " "))
    splits = split.(simplified)
    bots = [ ( parse(Int, line[1]), nextLink(line[2], parse(Int, line[3])), nextLink(line[4], parse(Int, line[5])) ) for line in splits ]

    println(bots)
    botDict = Dict{Int, Tuple{Bot, Dict{Symbol, nextLink}}}()
    map(x -> botDict[x[1]] = (Bot(x[1]), Dict([ :low => x[2], :high => x[3] ])), bots)
    return (botDict, vals)
end

function processFile(file)
    bots, instrs = parseInput(file)

    for instr in instrs
        updateBot!(bots[instr[2]][1], instr[1], bots)
    end
end
