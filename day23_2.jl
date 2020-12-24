#lst = parse.(Int, collect("389125467"))
lst = parse.(Int, collect("137826495"))
#lst = parse.(Int, collect("54321"))

idspace = 1000000
append!(lst, (length(lst) + 1):idspace)

nxts = Vector{Int}(undef, idspace)

for i in 1:(length(lst)-1)
  nxts[lst[i]] = lst[i+1]
end
nxts[lst[end]] = lst[1]

previd(id) = (id + idspace - 2) % idspace + 1

nextids = Vector{Int}(undef, 3)

function move(current)
  aside = nxts[current]
  afterc = aside
  lastaside = aside
  for i in 1:3
    nextids[i] = afterc
    lastaside = afterc
    afterc = nxts[afterc]
  end
  nxts[current] = afterc
  dest = previd(current)
  while in(dest, nextids)
    dest = previd(dest)
  end
  nxts[lastaside] = nxts[dest]
  nxts[dest] = aside
  return afterc
end

act = lst[1]
for i in 1:10000000
  if i % 10000 == 0
    println(i)
  end
  global act = move(act)
end

println(nxts[1] * nxts[nxts[1]])

