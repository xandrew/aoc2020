module Day12 exposing (parse, solve1, solve2)

parseNavInst: String -> Maybe (String, Int)
parseNavInst row =
    let
        fc = String.left 1 row
        par = String.dropLeft 1 row
    in
        Maybe.map (Tuple.pair fc) (String.toInt par)
             
parse12 content =
    content
        |> String.lines
        |> List.map parseNavInst
        |> maybeList

rotateRight times (dx, dy) =
    if times == 0 then (dx, dy)
    else if times > 0 then rotateRight (times - 1) (dy, -dx)
    else rotateRight (times + 1) (-dy, dx)

nextPos (inst, param) ((x, y), (dx, dy)) =
    case inst of
        "N" -> ((x, y + param), (dx, dy))
        "S" -> ((x, y - param), (dx, dy))
        "E" -> ((x + param, y), (dx, dy))
        "W" -> ((x - param, y), (dx, dy))
        "F" -> ((x + param * dx, y + param * dy), (dx, dy))
        "R" -> ((x, y), rotateRight (param // 90) (dx, dy))
        "L" -> ((x, y), rotateRight -(param // 90) (dx, dy))
        _ -> ((x, y), (dx, dy))

solve1 insts =
    let
        ((x, y), _) = List.foldl nextPos ((0, 0), (1, 0)) insts
    in (abs x) + (abs y)


nextPos2 (inst, param) ((x, y), (dx, dy)) =
    Debug.log "POS" (case inst of
        "N" -> ((x, y), (dx, dy + param))
        "S" -> ((x, y), (dx, dy - param))
        "E" -> ((x, y), (dx + param, dy))
        "W" -> ((x, y), (dx - param, dy))
        "F" -> ((x + param * dx, y + param * dy), (dx, dy))
        "R" -> ((x, y), rotateRight (param // 90) (dx, dy))
        "L" -> ((x, y), rotateRight -(param // 90) (dx, dy))
        _ -> ((x, y), (dx, dy)))

solve_2 insts =
    let
        ((x, y), _) = List.foldl nextPos2 ((0, 0), (10, 1)) insts
    in (abs x) + (abs y)

