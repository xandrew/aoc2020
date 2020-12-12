module Day1 exposing (parse, solve1, solve2)

import Common exposing (..)

parse: String -> Maybe (List Int)
parse s = maybeList (List.map String.toInt (String.lines s))

solveOne l t =
    case l of
        e::r ->
            if List.member (t - e) r then Just (e * (t - e)) else solveOne r t
        [] -> Nothing

solve1 l = Maybe.withDefault -9999 (solveOne l 2020)

solve2 l =
    case l of
        e::r -> case solveOne r (2020 - e) of
                    Just rOne -> e * rOne
                    Nothing -> solve2 r
        [] -> -9999
