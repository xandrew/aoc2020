rules = []
mynumbers = Vector{Int}()
othernumbers = Vector{Int}()

ruleRE = r"([^:]+): (\d+)-(\d+) or (\d+)-(\d+)$"

intparse(x) = parse(Int, x)

open("/tmp/input16.txt") do file
  lit = eachline(file)
  (l, lits) = iterate(lit)
  while true
    (l == "") && break
    c = match(ruleRE, l).captures
    append!(rules, ((c[1], intparse.((c[2], c[3])), intparse.((c[4],c[5]))),))
    (l, lits) = iterate(lit, lits)
  end
  (l, lits) = iterate(lit, lits)
  (l, lits) = iterate(lit, lits)
  append!(mynumbers, intparse.(split(l, ",")))

  (l, lits) = iterate(lit, lits)
  (l, lits) = iterate(lit, lits)
  next = iterate(lit, lits)
  while next !== nothing
    (l, lits) = next
    append!(othernumbers, intparse.(split(l, ",")))
    next = iterate(lit, lits)
  end
end

othermatrix = reshape(
    othernumbers,
    length(mynumbers),
    length(othernumbers) ÷ length(mynumbers))

function matchrule(rule, number)
  (_, (f1, t1), (f2, t2)) = rule
  return (f1 <= number && number <= t1) ||(f2 <= number && number <= t2)
end

sum = 0
for number in othernumbers
  if findfirst(rule -> matchrule(rule, number), rules) == nothing
    global sum += number
  end
end

println(sum)

ruleSets = Vector{Set{Int}}(undef, length(rules))
for i in 1:(length(rules))
  ruleSets[i] = Set(1:length(mynumbers))
end

lor(a,b) = a || b
land(a,b) = a && b

for other in eachcol(othermatrix)
#  println("Processing $other")
  mm = [matchrule(rule, number) for rule in rules, number in other]
#  println(mm)
  if !reduce(land, (col->reduce(lor, col)).(eachcol(mm)))
#    println("Fully invalid")
    continue
  end

  for (rid, matches) in enumerate(eachrow(mm))
#    println("Looking at rule $rid")
#    println(matches)
#    println("Before: $ruleSets[rid]")
    intersect!(ruleSets[rid], findall(matches))
#    println("After: $ruleSets[rid]")
  end
end

println(ruleSets)

assignments = Dict{String,Int}()
while !isempty(reduce(union, ruleSets))
  newly_used = Int[]
  for idx in findall(x->length(x) == 1, ruleSets)
    pos = first(ruleSets[idx])
    assignments[rules[idx][1]] = pos
    append!(newly_used, pos)
  end
  for set in ruleSets
    setdiff!(set, newly_used)
  end
  isempty(newly_used) && break
end

println(ruleSets)
println(assignments)
println(reduce(*, [mynumbers[assignments[r]] for (r, _, _) in rules if startswith(r, "departure")]))
