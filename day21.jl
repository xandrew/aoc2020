algtoing = Dict{String, Set{String}}()

ingsets = Set{String}[]

open("/tmp/input21.txt") do file
  lre = r"([^(]+) \(contains ([^)]+)\)"
  for b in eachline(file)
    m = match(lre, b)
    ings = Set(split(m.captures[1], " "))
    alls = split(m.captures[2], ", ")
    push!(ingsets, ings)
    for a in alls
      curr = get!(algtoing, a, ings)
      intersect!(curr, ings)
    end
  end
end

println(algtoing)

alging = reduce(union, values(algtoing))

sum = 0
for is in ingsets
  global sum += length(setdiff(is, alging))
end
println(sum)

pairs = Tuple{String, String}[]

while length(algtoing) > 0
  for (alg, ings) in algtoing
    if length(ings) == 1
      ing = pop!(ings)
      push!(pairs, (alg, ing))
      delete!(algtoing, alg)
      for oings in values(algtoing)
        setdiff!(oings, (ing, ))
      end
      break
    end
  end
end

println(pairs)

sort!(pairs)
println(join([i for (_, i) in pairs], ","))
