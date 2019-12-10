using ClassicalCiphers.encrypt_caesar

function parseInput(file)
    lines = readlines(file)
    lines = map(x -> [ x[1:end-11], x[end-9:end]], lines)
    map(formatLine, lines)
end

function formatLine(line)
    p1 = *(line[1:end-1]...)
    rest = line[end]
    id = parse(rest[1:end-7])
    checksum = rest[end-5:end-1]

    return (p1, id, checksum)
end

function getRealRooms(file)
    filter(x -> checkSum(strip(x[1], ['-'])) == x[3], parseInput(file))
end

function checkSum(word)
    letters = unique(word)
    custlt(c) = count(x -> c == x, word)
    String(sort(letters, lt = (x,y) -> custlt(x) < custlt(y) ? true : custlt(x) == custlt(y) ? x > y : false , rev = true)[1:5])
end

function decrypt(text, id)
    text = encrypt_caesar(text, id)
    lowercase(replace(text, "-" => " "))
end

function findStorage(rooms)
    rooms = map(x -> (decrypt(x[1],x[2],x[2])), rooms)
    filter(x -> ismatch(r"north", x[1]), rooms)
end
