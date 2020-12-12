module Day9 exposing (parse, solve1, solve2)

import Common exposing (..)
import Set exposing (Set)

parse content =
    content
        |> String.lines
        |> List.map String.toInt
        |> maybeList

sums lst =
    case lst of
        [] -> []
        h :: t -> (List.map ((+) h) t) ++ (sums t)


prefSize = 25

findInvalid pre lst =
    let
        pref = Set.toList (Set.fromList (List.take prefSize pre))
        sms = sums pref
    in
        case lst of
            [] -> -99999
            h :: t ->
                if List.member h sms
                then findInvalid (List.drop 1 pre) t
                else h


solve1 nums = findInvalid nums (List.drop prefSize nums)


findPrefSum target soFar mi ma lst =
    case lst of
        [] -> Nothing
        h :: t ->
            let
                newSum = soFar + h
                newMi = Basics.min mi h
                newMa = Basics.max ma h
            in
                if newSum == target
                then Just (newMi, newMa)
                else if newSum > target
                     then Nothing
                     else findPrefSum target newSum newMi newMa t

findSum target lst =
    case lst of
        [] -> -9999
        h :: t ->
            case findPrefSum target h h h t of
                Nothing -> findSum target t
                Just (mi, ma) -> mi + ma
                             
solve2 lst = findSum (solve1 lst) lst

