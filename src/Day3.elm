module Day3 exposing (parse, solve1, solve2)

import Common exposing (..)

parse = Just

tree_at: String -> Int -> Int
tree_at line pos =
    let
        idx = modBy (String.length line) pos
    in
        if (String.slice idx (idx + 1) line) == "#" then 1 else 0

tree_in_row: Int -> Int -> Int -> String -> Int
tree_in_row rstep dstep ridx line =
    if (modBy dstep ridx) == 0 then        
        tree_at line (ridx // dstep * rstep)
    else 0


solve3: Int -> Int -> String -> Int
solve3 rstep dstep content =
    if not (String.isEmpty content)
    then content
        |> String.lines
        |> List.indexedMap (tree_in_row rstep dstep)
        |> List.sum
    else -1

solve1 c = solve3 3 1 c

solve2 c =
    (solve3 1 1 c) * (solve3 3 1 c) * (solve3 5 1 c) * (solve3 7 1 c) * (solve3 1 2 c)
