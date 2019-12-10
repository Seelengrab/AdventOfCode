using Dates, HTTP

const date = now()
const YEAR = year(date)
const DAY = day(date)

const puzzle_URL = "https://adventofcode.com/$YEAR/day/$DAY/input"
session = readline(open("session"))

cd(lpad(DAY, 2, '0'))
run(`wget $puzzle_URL --no-cookies --header "Cookie: session=$session"`)