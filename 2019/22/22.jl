function parseInput(inp)
    lines = readlines(inp)
    actions = Tuple{Any,Int}[]

    for l in lines
        if l == "deal into new stack"
            push!(actions, (newStack, -1))
        elseif startswith(l, "deal with")
            push!(actions, (dealWith, parse(Int, l[findlast(' ', l)+1:end])))
        elseif startswith(l, "cut")
            push!(actions, (cut, parse(Int, l[findlast(' ', l)+1:end])))
        end
    end

    return actions
end

function printDeck(deck)
    print("Result:")
    for d in deck
        print(' ')
        print(d)
    end
    println()
end

# part 1

# function cut(deck, shift, buffer)
#     circshift!(buffer, deck, -shift)
# end

# function newStack(deck, shift, buffer)
#     buffer .= deck
#     reverse!(buffer)
# end

# function dealWith(deck, inc, buffer)
#     pos = 1
#     for i in eachindex(deck)
#         buffer[pos] = deck[i]
#         pos += inc
#         if pos > length(deck)
#             pos = pos % length(deck)
#         end
#     end
    
#     buffer
# end

# function shuffleDeck(inp, deckSize)
#     deck = 0:(deckSize-1) |> collect
#     actions = parseInput(inp)
#     buffer = similar(deck) 
#     deckCache = Dict{typeof(deck),typeof(deck)}()
    
#     for (action, shift) in actions
#         tmp = action(deck, shift, buffer)
#         buffer = deck
#         deck = tmp
#     end

#     findfirst(==(2019), deck) - 1 # part 1
# end


cut(off, inc, shift) = (off-inc, -inc)
newStack(off, inc, shift) = (off+inc*shift, inc)
dealWith(off, inc, shift) = (off, inc*powermod(shift,119315717514045,119315717514047))

function part2(inp)
    off = big"0"
    inc = big"1"
    off_diff = big"0"
    inc_mul = big"1"
    actions = parseInput(inp)

    for (action, shift) in actions
        off_diff, inc_mul = action(off_diff, inc_mul, shift)
    end

    modulus = big"119315717514047"
    n = big"101741582076661"

    increment = powermod(inc_mul, n, modulus)
    offset = off_diff * (1 - powermod(inc_mul, length(actions)*n, modulus) * powermod(1-inc_mul, modulus-2, modulus))
    (offset + increment*n) % modulus
end