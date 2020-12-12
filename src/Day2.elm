module Day2 exposing (parse, solve1, solve2)

import Common exposing (..)
import Set exposing (Set)
import Parser exposing (Parser, (|.), (|=), succeed, symbol, int, spaces, end)

type alias PasswordSpec =
    { min: Int
    , max: Int
    , char: String
    , pwd: String
    }

pSParser : Parser PasswordSpec
pSParser =
  succeed PasswordSpec
    |= int
    |. symbol "-"
    |= int
    |. spaces
    |= word
    |. symbol ":"
    |. spaces
    |= word
    |. end

validSpec1: PasswordSpec -> Bool
validSpec1 spec =
    let
        count = List.length (String.indices spec.char spec.pwd)
    in
        (count >= spec.min) && (count <= spec.max)

validSpec2: PasswordSpec -> Bool
validSpec2 spec =
    let
        s1 = String.slice (spec.min - 1) (spec.min) spec.pwd
        s2 = String.slice (spec.max - 1) (spec.max) spec.pwd
    in
        xor (s1 == spec.char) (s2 == spec.char)

validLine: (PasswordSpec -> Bool) -> String -> Bool
validLine validator line =
    case Parser.run pSParser line of
        Ok spec -> validator spec
        _ -> False

solved2 validator input = input
               |> String.lines
               |> List.map (validLine validator)
               |> List.filter identity
               |> List.length

parse = Just
solve1 = solved2 validSpec1
solve2 = solved2 validSpec2

