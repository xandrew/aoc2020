open("/tmp/input22.txt") do file
  lines = collect(eachline(file))
  half = length(lines) ÷ 2
  global s1 = parse.(Int, lines[2:half])
  global s2 = parse.(Int, lines[half + 3:end])
end

p1 = copy(s1)
p2 = copy(s2)
while !isempty(p1) && !isempty(p2)
  c1 = popfirst!(p1)
  c2 = popfirst!(p2)
  if c1 > c2
    append!(p1, [c1, c2])
  else
    append!(p2, [c2, c1])
  end
end

append!(p1, p2)

println(reduce(+, [a * b for (a,b) in enumerate(reverse(p1))]))

function recursivecombat(d1, d2)
  prevstates = Set{Tuple{Vector{Int}, Vector{Int}}}()
  while !isempty(d1) && !isempty(d2)
    #println("P1 $d1")
    #println("P2 $d2")
    if in((d1, d2), prevstates)
      #println("Early exit!!! $prevstates $d1 $d2")
      return 1
    end
    push!(prevstates, (copy(d1), copy(d2)))
    c1 = popfirst!(d1)
    c2 = popfirst!(d2)
    winner = 2
    if (length(d1) >= c1) && (length(d2) >= c2)
      winner = recursivecombat(d1[1:c1], d2[1:c2])
    elseif c1 > c2
      winner = 1
    end
    if winner == 1
      append!(d1, [c1, c2])
    else
      append!(d2, [c2, c1])
    end
  end
  return isempty(d2) ? 1 : 2
end

p1 = copy(s1)
p2 = copy(s2)
recursivecombat(p1, p2)
append!(p1, p2)
println(reduce(+, [a * b for (a,b) in enumerate(reverse(p1))]))
