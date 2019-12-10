import itertools

f = open("input", "r").readlines()
# f = ["abcde fghij", "abcde xyz ecdab", "a ab abc abd abf abj", "iiii oiii ooii oooi oooo ", "oiii ioii iioi iiio"]
result = 0
for line in f:
    x=["".join(sorted(i)) for i in line.split()]
    if len(x) == len(set(x)):
        result += 1

print(result)
