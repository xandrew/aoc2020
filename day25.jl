function solve(base, target, mod)
  act = 1
  for i in 1:(mod - 2)
    act = (act * base) % mod
    if act == target
      return i
    end
  end
end

function mexp(base, ex, mod)
  act = 1
  for i in 1:ex
    act = (act * base) % mod
  end
  return act
end

println(mexp(523731, solve(7, 1717001, 20201227), 20201227))
