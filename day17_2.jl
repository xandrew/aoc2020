nx = 8 + 2 * 7
ny = 8 + 2 * 7
nz = 1 + 2 * 7
nw = 1 + 2 * 7
pocket = zeros(Bool, nx, ny, nz, nw)

startMap0 = """
.#.
..#
###"""

startMap = """
#.#.#.##
.####..#
#####.#.
#####..#
#....###
###...##
...#.#.#
#.##..##"""

for (ridx, row) in enumerate(split(startMap, "\n"))
  for (cidx, chr) in enumerate(row)
    if chr == '#'
      pocket[ridx + 7, cidx + 7, 8, 8] = true
    end
  end
end

function ncount(pocket, x, y, z, w)
  sum = 0
  for dx in -1:1
    for dy in -1:1
      for dz in -1:1
        for dw in -1:1
          sum += pocket[x + dx, y + dy, z + dz, w + dw]
	end
      end
    end
  end
  return sum
end

function step(prev)
  res = zeros(Bool, nx, ny, nz, nw)
  for x in 2:(nx - 1)
    for y in 2:(ny - 1)
      for z in 2:(nz - 1)
        for w in 2:(nw - 1)
          nc = ncount(prev, x, y, z, w)
          if prev[x, y, z, w]
            if nc == 3 || nc == 4
	      res[x, y, z, w] = true
            end
          else
            if nc == 3
              res[x, y, z, w] = true
            end
	  end
	end
      end
    end
  end
  return res
end

nxt = pocket
for i in 1:6
  global nxt = step(nxt)
end
println(length(findall(nxt)))
