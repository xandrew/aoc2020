maskRe = r"mask = ((0|1|X)+)$"
assRe = r"mem\[(\d+)] = (\d+)$"
andmask = parse(UInt, repeat("1", 36), base=2)
ormask = convert(UInt, 0)
values = Dict{UInt,UInt}()
open("/tmp/input14ex.txt") do file
  for l in eachline(file)
    maskm = match(maskRe, l)
    if maskm != nothing
      global andmask,ormask
      maskstring = maskm.captures[1]
      andmask = parse(UInt, replace(maskstring, "X" => "1"), base=2)
      ormask = parse(UInt, replace(maskstring, "X" => "0"), base=2)
      continue
    end
    assm = match(assRe, l)
    if assm != nothing
      idx = parse(UInt, assm.captures[1])
      v = parse(UInt, assm.captures[2])
      values[idx] = (v & andmask) | ormask
    end
  end
end

s = 0
for (_, v) in values
  global s
  s += v
end
println(s)

function variant(str, vid)
  res = collect(str)
  for i in 1:length(str)
    if res[i] == 'X'
      r = vid % 2
      vid = vid ÷ 2
      if r == 0
        res[i] = '0'
      else
        res[i] = '1'
      end
    end
  end
  if vid == 0
    return String(res)
  else
    return nothing
  end
end

values = Dict{UInt,UInt}()
mask = repeat('0', 36)

function domask(what)
  res = collect(what)
  for i in 1:(length(what))
    if mask[i] != '0'
      res[i] = mask[i]
    end
  end
  return String(res)
end

open("/tmp/input14.txt") do file
  for l in eachline(file)
    maskm = match(maskRe, l)
    if maskm != nothing
      global mask
      mask = maskm.captures[1]
      continue
    end
    assm = match(assRe, l)
    if assm != nothing
      idx = bitstring(parse(UInt, assm.captures[1]))[29:64]
      masked = domask(idx)
      val = parse(UInt, assm.captures[2])
      for vid in Iterators.countfrom(0)
        var = variant(masked, vid)
	(var == nothing) && break
	idv = parse(UInt, var, base=2)
	values[idv] = val
      end
    end
  end
end

s = 0
for (_, v) in values
  global s
  s += v
end
println(s)
