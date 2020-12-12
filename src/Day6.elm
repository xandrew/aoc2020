module Day6 exposing (parse, solve1, solve2)

import Common exposing (..)
import Set exposing (Set)

parse content =
    content
        |> String.lines
        |> blocks
        |> Just

allLetters = List.range (Char.toCode 'a') (Char.toCode 'z')
    |> List.map Char.fromCode
    |> Set.fromList

unionAll = List.foldl Set.union Set.empty
intersectAll = List.foldl Set.intersect allLetters

groupNumYes aggr gr =
    gr
        |> String.trim
        |> String.split " "
        |> List.map (String.toList >> Set.fromList)
        |> aggr
        |> Set.size

solve1 inp =
    inp
        |> List.map (groupNumYes unionAll)
        |> List.sum

solve2 inp =
    inp
        |> List.map (groupNumYes intersectAll)
        |> List.sum

