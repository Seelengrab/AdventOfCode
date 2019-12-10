b = 0
c = 0
d = 0
e = 0
f = 0
g = 0
h = 0

# b = 67
# b *= 100
# b += 100000
b = 106700
c = 123700

function stuff(x)
    println(x)
    d = 2                           # 10
    while (d < x/2)                  # 24
        # e = 2                           # 11 -- from 24
        # while (e < x/2)
        #     if (d*e == x)
        #         return true                       # 16
        #     end
        #     e += 1
        # end
        if (x % d == 0)
            return true
        end
        d += 1                          # 21
    end
    return false
end

function runThis()
    for i in b:17:c
        if (stuff(i))                     # 25
            global h += 1                      # 26
        end
    end

    println("h = $h")
end
