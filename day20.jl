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
  img::Matrix{Char}
end

function rotmx(mx::Matrix{Char})
  ll = size(mx, 1)
  [mx[end - r + 1, c] for c in 1:ll, r in 1:ll]
end

function rot(t::Tile)
  Tile(t.id, t.flipped, rotmx(t.img))
end

function sideof(t::Tile, dir::Int)
  [()->t.img[:,1],
   ()->t.img[end,:],
   ()->reverse(t.img[:,end]),
   ()->reverse(t.img[1,:])][dir]()
end

function rotTo(t::Tile, side, dir)
  (sideof(t,dir) == side) ? t : rotTo(rot(t), side, dir)
end

bySide = Dict{Vector{Char}, Vector{Tile}}()
tiles = Tile[]

function neighbor(t::Tile, dir)
  ns = filter(ot->ot.id != t.id, get(bySide, sideof(t, dir), Tile[]))
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
  count(i -> neighbor(t, i) == nothing, 1:4) == 2
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
	reverse(sideof(next, dir)),
	(dir + 1) % 4 + 1)
  end
  return res
end

function stringstomx(img::Vector{String})
  ll = length(img[1])
  return [l[i] for i in 1:ll, l in img]
end

function addTile(lines::Vector{String}, flipped::Bool)
  img = flipped ? lines[end:-1:2] : lines[2:end]
  t = Tile(
      parse(Int, match(r"Tile (\d+):", lines[1]).captures[1]),
      flipped,
      stringstomx(img))
  push!(tiles, t)
  for dir in 1:4
    push!(get!(bySide, reverse(sideof(t, dir)), Tile[]), t)
  end
end

open("/tmp/input20.txt") do file
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
  end
end
println(res)

grid = extfrom.(extfrom(tl, 3), 2)
tl = size(tl.img, 1) - 2
gl = size(grid, 1)

gc(i) = (i - 1) ÷ tl + 1
ic(i) = (i - 1) % tl + 2

picture = [grid[gc(r)][gc(c)].img[ic(c), ic(r)] for c in 1:(tl*gl), r in 1:(tl*gl)]

for lin in eachrow(picture)
  println(join(lin))
end

monster = [
    "                  # ",
    "#    ##    ##    ###",
    " #  #  #  #  #  #   "]

mmx = stringstomx(monster)

checkpairs = [(i,j) for i in 1:size(mmx,1) for j in 1:size(mmx,2) if mmx[i,j] == '#']

for r in 1:4
  global picture = rotmx(picture)
  monsters = 0
  for i in 1:size(picture, 1)
    for j in 1:size(picture, 2)
      found = true
      for (di, dj) in checkpairs
        if get(picture, (i + di - 1, j + dj - 1), '.') != '#'
	  found = false
	  break
	end
      end
      if found
	monsters += 1
      end
    end
  end
  if monsters > 0
    println("Final result!")
    println(length([c for c in picture if c == '#']) - monsters * length(checkpairs))
    monsters = 0
  end
end
