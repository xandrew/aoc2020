⦿(x, y) = x + y
open("/tmp/input18.txt") do file
  repl = [replace(l, "+" => "⦿") for l in eachline(file)]
  println(reduce(+, [eval(Meta.parse(l)) for l in repl]))
end

⟰(x, y) = x + y
open("/tmp/input18.txt") do file
  repl = [replace(l, "+" => "⟰") for l in eachline(file)]
  println(reduce(+, [eval(Meta.parse(l)) for l in repl]))
end
