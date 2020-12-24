#lst = parse.(Int, collect("389125467"))
lst = parse.(Int, collect("137826495"))
rot(l) = push!(l[2:end], l[1])

rotAfter(l, t) = l[1] == t ? rot(l) : rotAfter(rot(l), t)

previd(id) = (id + 7) % 9 + 1
println([(i, previd(i)) for i in 1:9])
function move(l)
  curr = l[1]
  l = rot(l)
  (out, rest) = (l[1:3],l[4:end])
  dest = previd(curr)
  while in(dest, out)
    dest = previd(dest)
  end
  println("Dest $dest")
  afterDest = rotAfter(rest, dest)
  return rotAfter(append!(out, afterDest), curr)
end

for i in 1:100
  println(lst)
  global lst = move(lst)
end
println(join(string.(rotAfter(lst, 1)[1:end-1])))
