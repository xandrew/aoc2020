module Day10 exposing (parse, solve1, solve2)

import Common exposing (..)
import Dict exposing (Dict)

parse content =
    content
        |> String.lines
        |> List.map String.toInt
        |> maybeList

incDict key =
    Dict.update key (\old -> Just ((Maybe.withDefault 0 old) + 1))

countDiffs lst =
    case lst of
        [] -> Dict.empty
        [a] -> Dict.singleton 3 1
        a :: b :: rest -> incDict (b - a) (countDiffs (b :: rest))

solve1 lst =
    let
        diffs = countDiffs (0 :: (List.sort lst))
        maybeProduct = Maybe.map2 (*) (Dict.get 1 diffs) (Dict.get 3 diffs)
    in
        Maybe.withDefault -9999 maybeProduct

countWays w3 w2 w1 n lst =
    case lst of
        [] -> w1
        h :: t ->
            if (h == n)
            then countWays w2 w1 (w3 + w2 + w1) (n + 1) t
            else countWays w2 w1 0 (n + 1) lst

solve2 lst = countWays 0 0 1 1 (List.sort lst)

