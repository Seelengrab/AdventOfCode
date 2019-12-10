if length(ARGS) != 1
    println("Need exactly one argument!")
    exit(1)
end

include("LList.jl")

function parseInput(file)
    d = readlines(file)
    ret = replace.(d, Ref(" points" => ""))
    ret = replace.(ret, Ref(" players; last marble is worth " => " "))
    println(ret)

    return map(x -> parse.(Int, split(x)), ret)
end

function findPos(curPos, boardLength)
    if curPos == boardLength
        return 2
    end
    nPos = curPos + 2

    if nPos > (boardLength + 1)
        return nPos - boardLength
    else
        return nPos
    end
end

function playGame(numPlayers, numMarbles)
    board = LList{Int}(0)
    scores = zeros(Int, numPlayers)
    curPos = 1
    curPlayer = 1
    bl = 1

    for marble in 1:numMarbles

        curPlayer += 1
        if curPlayer > numPlayers
            curPlayer = 1
        end

        if marble % 23 != 0
            curPos = findPos(curPos, bl)
            board = insert!(board, curPos, marble)
            bl += 1
        else
            print("\r$marble")
            scores[curPlayer] += marble
            curPos -= 7
            if curPos < 1
                curPos = bl + curPos
            end
            scores[curPlayer] += board[curPos]
            board = deleteat!(board, curPos)
            bl -= 1
        end
    end

    println("\rWinning score: $(maximum(scores))")
end

setups = parseInput(ARGS[1])
for game in setups
    playGame(game...)
end