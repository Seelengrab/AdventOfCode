using Dates

if length(ARGS) != 1
    println("Need exactly one argument!")
    exit(1)
end

abstract type Event
end

struct shiftBegin <: Event
    date::DateTime
    id::Int
end

Base.show(io::IO, e::shiftBegin) = print(io, e.date, " : ", e.id)

@enum SLEEP ASLEEP WAKEUP

Base.show(io::IO, s::SLEEP) = print(io, s.date, " : " * (s == ASLEEP ? "asleep" : "wakeup"))

struct sleepEvent <: Event
    date::DateTime
    event::SLEEP
end

Base.show(io::IO, s::sleepEvent) = print(io, s.date, " : ", s.event)

function parseEvent(line)
    d = DateTime(line[2:17], "yyyy-mm-dd HH:MM")
    rest = line[20:end]
    if rest[1] == 'w'
        return sleepEvent(d, WAKEUP)
    elseif rest[1] == 'f'
        return sleepEvent(d, ASLEEP)
    else
        return shiftBegin(d, parse(Int, match(r"#\d+", rest).match[2:end]))
    end
end

function parseInput(file)
    return parseEvent.(readlines(file))
end

isShiftBegin(::shiftBegin) = true
isShiftBegin(::Any) = false

data = sort(parseInput(ARGS[1]), by = x -> x.date)

function getIds(file)
    d = eachmatch(r"#\d+", read(file, String))
    return Set(map(x -> parse(Int, x.match[2:end]), d))
end

ids = getIds(ARGS[1])
shifts = Dict{Int, Array{Int}}()
for id in ids
    shifts[id] = zeros(Int, 60)
end

lastId = -1
for d in data
    if typeof(d) == shiftBegin
        global lastId = d.id
    else
        if d.event == ASLEEP
            shifts[lastId][minute(d.date)+1:end] .+= 1
        else
            shifts[lastId][minute(d.date)+1:end] .-= 1
        end
    end
end

function getBestGuard()
    maxSoFar = -1
    bestId = -1
    bestMinute = 1
    for d in shifts
        if sum(d[2]) > maxSoFar
            bestId = d[1]
            maxSoFar = sum(d[2])
            bestMinute = 1
            minuteVal = 0
            for minute in 1:60
                if d[2][minute] > d[2][bestMinute]
                    bestMinute = minute
                    minuteVal = d[2][minute]
                end
            end
        end
    end

    return bestId * (bestMinute - 1)
end

function getSleepiestGuard(shifts)
    sleepSoFar = -1
    idSoFar = -1
    minuteSoFar = 1
    for d in shifts
        if findmax(d[2])[1] > sleepSoFar
            sleepSoFar, minuteSoFar = findmax(d[2])
            idSoFar = d[1]
        end
    end
    println(idSoFar * (minuteSoFar - 1))
end

getSleepiestGuard(shifts)