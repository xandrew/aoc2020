todelta = Dict(
    "e" => (1, 0),
    "w" => (-1, 0),
    "se" => (1, 1),
    "sw" => (0, 1),
    "ne" => (0, -1),
    "nw" => (-1, -1))


function todeltas(str::String)
  res = Tuple{Int, Int}[]
  while !isempty(str)
    for (k, v) in todelta
      if startswith(str, k)
        push!(res, v)
	str = str[length(k) + 1:end]
	break
      end
    end
  end
  return res
end

tiles = Dict{Tuple{Int, Int}, Int}()

open("/tmp/input24.txt") do file
  for line in eachline(file)
    crd = reduce((a,b) -> (+).(a, b), todeltas(line))
    tiles[crd] = xor(get(tiles, crd, 0), 1)
  end
end

println(reduce(+, values(tiles)))

nc(pos) = reduce(+, get(tiles, (+).(pos, v), 0) for (_, v) in todelta)

function next()
  should = Set{Tuple{Int, Int}}()
  for (t, c) in tiles
    if c == 1
      cnc = nc(t)
      if (cnc == 0) || (cnc > 2)
        push!(should, t)
      end
      for (_, v) in todelta
        p2 = (+).(t, v)
        if get(tiles, p2, 0) ==0 && nc(p2) == 2
	  push!(should, p2)
	end
      end
    end
  end
  for pos in should
    tiles[pos] = xor(get(tiles, pos, 0), 1)
  end
end

for i in 1:100
  next()
  println(reduce(+, values(tiles)))
end
