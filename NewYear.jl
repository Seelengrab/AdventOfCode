if length(ARGS) != 1
    println("Need exactly one argument!")
    exit(1)
end

function genYear(year)
    textBase = """
    function parseInput()

    end
    """

    if isdir("$year")
        println("Year already exists!")
        exit(1)
    end

    mkdir(year)
    cd(year)
    for day in map(d -> lpad(d, 2, "0"), 1:25)
        mkdir(day)
        cd(day)
        open("$day.jl", "a") do f
            write(f, textBase)
        end
        touch.(["test","input"])
        cd("..")
    end
end

genYear(ARGS[1])
