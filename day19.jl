abstract type Parser
end

struct Lit <: Parser
  str::String
end

struct Ref <: Parser
  idx::Int
end

struct OrP <: Parser
  p1::Parser
  p2::Parser
end

struct ConP <: Parser
  p1::Parser
  p2::Parser
end

|(p1::Parser, p2::Parser) = OrP(p1, p2)

>>(p1::Parser, p2::Parser) = ConP(p1, p2)

ps = Vector{Parser}(undef, 200)
for i in 1:length(ps)
  ps[i] = Ref(i)
end

messages = Vector{String}()

open("/tmp/input19.txt") do file
  lit = eachline(file)
  (l, lits) = iterate(lit)
  while true
    (l == "") && break
    l = replace(l, r"(\d+)" => (x -> "ps[" * string(parse(Int, x) + 1) * "]"))
    l = replace(l, ": " => "=")
    l = replace(l, " | " => "|")
    l = replace(l, r"\"[^\"]+\"" => (x -> "Lit(" * x * ")"))
    l = replace(l, " " => ">>")
    eval(Meta.parse(l))
    (l, lits) = iterate(lit, lits)
  end
  next = iterate(lit, lits)
  while next !== nothing
    (l, lits) = next
    append!(messages, (l, ))
    next = iterate(lit, lits)
  end
end

println(ps)

options(p::Lit) = 1
options(p::Ref) = options(ps[p.idx])
options(p::ConP) = options(p.p1) * options(p.p2)
options(p::OrP) = options(p.p1) + options(p.p2)

strings(p::Lit) = Set([p.str])
strings(p::Ref) = strings(ps[p.idx])
strings(p::ConP) = Set([a * b for a in strings(p.p1) for b in strings(p.p2)])
strings(p::OrP) = union(strings(p.p1), strings(p.p2))

#goodones = strings(Ref(1))
#println(length([m for m in messages if in(m, goodones)]))

println(options(Ref(1)))
println(options(Ref(43)))
println(options(Ref(32)))

println(Set([length(s) for s in strings(Ref(43))]))
println(Set([length(s) for s in strings(Ref(32))]))

println(intersect(strings(Ref(43)), strings(Ref(32))))

count = 0
s42 = strings(Ref(43))
s31 = strings(Ref(32))
ps = 8
for p in union(s42, s31)
  if length(p) != ps
    println("NOOOOOOOOOOOOO $p")
  end
end

for m in messages
  if length(m) % ps != 0
    break
  end
  c42 = 0
  c31 = 0
  for c in eachcol(reshape(collect(m), ps, length(m) ÷ ps))
    ap = join(c)
    if in(ap, s42)
      if c31 > 0
        c42 = -1
        break
      end
      c42 += 1
    elseif in(ap, s31)
      c31 += 1
    else
      c42 = -1
      break
    end
  end
  if (c31 > 0) && (c42 > c31)
    global count += 1
  end
end

println(count)
