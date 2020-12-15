function next!(history)
  lng = length(history)
  last = history[lng]
  prev = findprev(x -> x==last, history, lng - 1)
  if prev == nothing
    append!(history, 0)
  else
    append!(history, lng - prev)
  end
end

ho = [18,8,0,5,4,1,20]
h = copy(ho)
target = 2020
for i in 1:(target - length(h))
  next!(h)
end
println(h[target])

function nextDict!(dict, lastidx, last)
  if haskey(dict, last)
    prev = dict[last]
    nxt = lastidx - prev
  else
    nxt = 0
  end
  dict[last] = lastidx
  return lastidx + 1, nxt
end

dict = Dict{Int,Int}()
lho = length(ho)
for (i, v) in enumerate(ho[1:(lho-1)])
  dict[v] = i
end

target = 30000000
idx = lho
last = ho[idx]

for i in 1:(target - length(ho))
  global idx, last
  idx, last = nextDict!(dict, idx, last)
end
println(last)
