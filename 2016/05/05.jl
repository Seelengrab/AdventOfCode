using MD5

function findPassword(id)
    pw = [ '-' for _ in 1:8 ]
    index = 0
    i = 1
    while '-' in pw
        res = findHash(id, index)
        hash = res[1]
        # part 1
        # if "00000" == hash[1:5]
        #     pw[i] = hash[6]
        #     i = i + 1
        # end

        # part 2
        if isnumber(hash[6])
            ind = parse(Int, hash[6]) + 1 # AoC uses 0-based indexing
            if ind <= 8 && pw[ind] == '-'
                pw[ind] = hash[7]
            end
        end
        index = res[2] + 1
        print("\r$(String(pw))")
    end
end

function findHash(id, index)
    while true
        hash = bytes2hex(md5(id * string(index)))
        if "00000" == hash[1:5]
            return (hash, index)
        end
        index = index + 1
    end
end
