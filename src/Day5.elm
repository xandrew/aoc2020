module Day5 exposing (parse, solve1, solve2)

import Common exposing (..)
import Set exposing (Set)
import Parser exposing (Parser, (|.), (|=), succeed, symbol, int, spaces, end)

parse = Just

toBinId line =
    line
        |> String.replace "F" "0"
        |> String.replace "B" "1"
        |> String.replace "L" "0"
        |> String.replace "R" "1"

binParser = Parser.number
            { binary = Just identity
            , float = Nothing
            , hex = Nothing
            , int = Nothing
            , octal = Nothing
            }

toId: String -> Int
toId s =
    Result.withDefault -1 (Parser.run binParser ("0b" ++ (toBinId s)))

solve1 content =
    content
        |> String.lines
        |> List.map toId
        |> List.maximum
        |> Maybe.withDefault -1

firstMissing start set =
    if Set.member start set
    then firstMissing (start + 1) set
    else start

solve2 content =
    let
        ls = String.lines content
        ids = List.map toId ls
        mn = Maybe.withDefault -1 (List.minimum ids)
        idSet = Set.fromList ids                
    in
        firstMissing mn idSet
