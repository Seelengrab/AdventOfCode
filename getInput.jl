#! /usr/bin/env julia

using HTTP
using Dates


function saveFile()
    date = Dates.now()
    y = year(date)
    d = length(ARGS) > 0 ? parse(Int, ARGS[1]) : day(date)

    session = "session=" * readline("$y/session")
    @show session
    r = HTTP.request("GET", "https://adventofcode.com/$y/day/$d/input", ["cookie" => session])

    f = "$y/" * lpad(d, 2, '0') * "/input"
    @show f
    write(f, strip(String(r.body)))
end

saveFile()
