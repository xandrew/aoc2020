function blocks(lineit)
  next = iterate(lineit)
  res = Vector{String}[]
  current = String[]
  while next != nothing
    (l, lits) = next
    if l == ""
      push!(res, current)
      current = String[]
    else
      push!(current, l)
    end
    next = iterate(lineit, lits)
  end
  push!(res, current)
  return res
end

struct Tile
  id::Int
  flipped::Bool
  sides::Vector{String}
  img::Vector{String}
end

function rot(t::Tile)
  ll = length(t.img)
  mx = [l[i] for i in 1:ll, l in t.img]
  rot = [mx[end - r + 1, c] for c in 1:ll, r in 1:ll]
  rimg = [join(x) for x in eachcol(rot)]
  Tile(t.id, t.flipped, push!(t.sides[2:end], t.sides[1]), rimg)
end

function rotTo(t::Tile, side, dir)
  (t.sides[dir] == side) ? t : rotTo(rot(t), side, dir)
end

bySide = Dict{String, Vector{Tile}}()
tiles = Tile[]

function neighbor(t::Tile, dir)
  ns = filter(ot->ot.id != t.id, get(bySide, t.sides[dir], Tile[]))
  if ns == []
    return nothing
  elseif length(ns) == 1
    return ns[1]
  else
    println("Oh no, multiple match!")
    exit(-1)
  end
end
    
function iscorner(t::Tile)
  count(i -> neighbor(t, i) == nothing,1:4) == 2
end

function rottopleft(t::Tile)
  if (neighbor(t, 1) == nothing) && (neighbor(t, 4) == nothing)
    return t
  else
    return rottopleft(rot(t))
  end
end

function extfrom(t::Tile, dir::Int)
  next = t
  res = Tile[]
  while true
    push!(res, next)
    nn = neighbor(next, dir)
    (nn == nothing) && break
    next = rotTo(
        nn,
	reverse(next.sides[dir]),
	(dir + 1) % 4 + 1)
  end
  return res
end

function addTile(lines::Vector{String}, flipped::Bool)
  ll = length(lines[2])
  img = flipped ? lines[end:-1:2] : lines[2:end]
  mx = [l[i] for i in 1:ll, l in img]
  t = Tile(
      parse(Int, match(r"Tile (\d+):", lines[1]).captures[1]),
      flipped,
      join.([mx[:,1], mx[end,:], reverse(mx[:,end]), reverse(mx[1,:])]),
      img)
  push!(tiles, t)
  for s in t.sides
    push!(get!(bySide, reverse(s), Tile[]), t)
  end
end

open("/tmp/input20ex.txt") do file
  for b in blocks(eachline(file))
    addTile(b, true)
    addTile(b, false)
  end
end

res = 1

d = Dict{Int, Int}()
for t in tiles
  if !t.flipped && iscorner(t)
    if res == 1
      global tl = rottopleft(t)
    end
    global res *= t.id
    println(rottopleft(t))      
  end
end
println(res)

arranged = [extfrom(ch, 2) for ch in extfrom(tl, 3)]

ll = length(tl.img)

println(arranged)